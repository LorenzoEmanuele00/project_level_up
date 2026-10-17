import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/game_config.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/results.dart';
import 'package:levelup/domain/schedule.dart';

/// Hero progression after adding EXP.
typedef ExpProgress = ({
  int level,
  int exp,
  int rp,
  int levelsGained,
  int rpGained,
});

/// Adds [gainedExp] to the hero's progression, levelling up as many times as
/// needed. Each level up pays [GameConfig.rpPerLevel] reward points.
ExpProgress applyExp({
  required int level,
  required int exp,
  required int rp,
  required int gainedExp,
  GameConfig config = GameConfig.standard,
}) {
  var newLevel = level;
  var newExp = exp + gainedExp;
  var newRp = rp;
  var levelsGained = 0;
  while (newExp >= config.expPerLevel) {
    newExp -= config.expPerLevel;
    newLevel++;
    newRp += config.rpPerLevel;
    levelsGained++;
  }
  return (
    level: newLevel,
    exp: newExp,
    rp: newRp,
    levelsGained: levelsGained,
    rpGained: levelsGained * config.rpPerLevel,
  );
}

/// Start (inclusive) of the window of completions that [complete] needs for
/// a completion at [now]: Monday 00:00, local, of the previous week.
DateTime completionWindowStart(DateTime now) =>
    addLocalDays(startOfWeek(now), -DateTime.daysPerWeek);

/// End (exclusive) of that window: the end of the local day of [now].
///
/// It runs past [now] on purpose: if the clock went back, a completion
/// already recorded later the same day must still be seen by [isDoneOn].
DateTime completionWindowEnd(DateTime now) => addLocalDays(localDay(now), 1);

/// Completes [habit] at [now] for [hero].
///
/// Pure: nothing is mutated and the clock and the new [completionId] come in
/// as parameters.
///
/// [weekCompletions] is the window of recorded completions of every habit
/// that this function relies on: from [completionWindowStart] (Monday 00:00,
/// local, of the week before [now]) to [completionWindowEnd] (the end of the
/// local day of [now]). It is used to tell whether the habit
/// was already done today and whether the streak survived (see
/// [refreshStreak]). A window that is too short makes a live streak look
/// broken, so the caller must not trim it.
///
/// The new [Completion] carries the habit's current frequency: the history
/// keeps the frequency each week was done with.
CompletionResult complete({
  required GameHero hero,
  required Habit habit,
  required DateTime now,
  required String completionId,
  required Iterable<Completion> weekCompletions,
  GameConfig config = GameConfig.standard,
}) {
  if (habit.archived) return const HabitArchived();
  if (isDoneOn(habit, now, weekCompletions)) return const AlreadyDoneToday();

  final fresh = refreshStreak(habit, today: now, completions: weekCompletions);
  final streak = fresh.streak + 1;
  final updatedHabit = fresh.copyWith(
    streak: streak,
    bestStreak: streak > fresh.bestStreak ? streak : fresh.bestStreak,
    totalCompletions: fresh.totalCompletions + 1,
  );

  final progress = applyExp(
    level: hero.level,
    exp: hero.exp,
    rp: hero.rewardPoints,
    gainedExp: habit.exp,
    config: config,
  );

  return Completed(
    hero: hero.copyWith(
      level: progress.level,
      exp: progress.exp,
      rewardPoints: progress.rp,
    ),
    habit: updatedHabit,
    completion: Completion(
      id: completionId,
      habitId: habit.id,
      at: now,
      exp: habit.exp,
      frequency: habit.frequency,
    ),
    feedback: progress.rpGained > 0
        ? LevelledUp(
            levelsGained: progress.levelsGained,
            rpGained: progress.rpGained,
            newLevel: progress.level,
          )
        : ExpGained(exp: habit.exp, habitName: habit.name),
  );
}

/// Lazily resets a streak that was broken, as of [today].
///
/// The last completion is the latest one of the habit in [completions]; its
/// frequency decides how the streak is judged, whatever the habit's current
/// frequency. Daily completions break the streak when a whole day is skipped.
/// xN completions are judged per calendar week: the streak survives the week
/// of the last completion, and the week after only if that week met its
/// [effectiveQuota] (computed with the frequency of the last completion, the
/// one in force when that week ended); any later it is broken. A week
/// without completions counts as failed.
///
/// [completions] must cover from the start of the week before [today] up to
/// [today] (see [complete]). Hence an empty window with a live streak means
/// the last completion is older than that: the streak is broken.
///
/// Idempotent, and never touches [Habit.bestStreak].
Habit refreshStreak(
  Habit habit, {
  required DateTime today,
  required Iterable<Completion> completions,
}) {
  if (habit.streak == 0) return habit;
  final last = _latestCompletion(habit, completions);
  if (last == null) return habit.copyWith(streak: 0);

  final broken = last.frequency == Frequency.daily
      ? localDaysBetween(last.at, today) > 1
      : _isXnStreakBroken(habit, last, today, completions);
  return broken ? habit.copyWith(streak: 0) : habit;
}

Completion? _latestCompletion(Habit habit, Iterable<Completion> completions) {
  Completion? latest;
  for (final c in completions) {
    if (c.habitId != habit.id) continue;
    if (latest == null || c.at.isAfter(latest.at)) latest = c;
  }
  return latest;
}

bool _isXnStreakBroken(
  Habit habit,
  Completion last,
  DateTime today,
  Iterable<Completion> completions,
) {
  final lastWeek = startOfWeek(last.at);
  final weeksApart =
      localDaysBetween(lastWeek, startOfWeek(today)) ~/ DateTime.daysPerWeek;
  if (weeksApart <= 0) return false;
  if (weeksApart > 1) return true;

  final nextWeek = addLocalDays(lastWeek, DateTime.daysPerWeek);
  final done = completions.where((c) {
    final at = c.at.toLocal();
    return c.habitId == habit.id &&
        !at.isBefore(lastWeek) &&
        at.isBefore(nextWeek);
  }).length;
  return done < effectiveQuota(habit, lastWeek, frequency: last.frequency);
}

/// Redeems [reward] for [hero] at [at].
///
/// Succeeds when the hero has at least the reward's cost in reward points.
/// [redemptionId] is supplied by the caller to keep this function pure.
RedeemResult redeem({
  required GameHero hero,
  required Reward reward,
  required String redemptionId,
  required DateTime at,
}) {
  final cost = reward.cost;
  final points = hero.rewardPoints;
  if (points < cost) return InsufficientPoints(missing: cost - points);

  return Redeemed(
    hero: hero.copyWith(rewardPoints: points - cost),
    redemption: Redemption(
      id: redemptionId,
      rewardName: reward.name,
      cost: cost,
      levelAt: hero.level,
      at: at,
    ),
  );
}

/// Share of today's due habits already done, from 0 to 1 (1 if none are due).
double questPct({required int done, required int due}) =>
    due == 0 ? 1.0 : done / due;
