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

/// Completes [habit] at [now] for [hero].
///
/// Pure: nothing is mutated and the clock and the new [completionId] come in
/// as parameters. [weekCompletions] are the recorded completions from the
/// start of the previous week up to [now]: the previous week is needed to
/// tell whether an xN streak survived it (see [refreshStreak]).
CompletionResult complete({
  required GameHero hero,
  required Habit habit,
  required DateTime now,
  required String completionId,
  required Iterable<Completion> weekCompletions,
  GameConfig config = GameConfig.standard,
}) {
  if (habit.archived) return const HabitArchived();
  if (isDoneOn(habit, now)) return const AlreadyDoneToday();

  final fresh = refreshStreak(habit, today: now, completions: weekCompletions);
  final streak = fresh.streak + 1;
  final updatedHabit = fresh.copyWith(
    streak: streak,
    bestStreak: streak > fresh.bestStreak ? streak : fresh.bestStreak,
    totalCompletions: fresh.totalCompletions + 1,
    lastCompletedAt: now,
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
/// Daily habits break when a whole day is skipped. xN habits are judged per
/// calendar week: the streak survives the week of the last completion, and
/// the week after only if that week met its [effectiveQuota]; any later it is
/// broken. [completions] must cover the week of the last completion.
///
/// Idempotent, and never touches [Habit.bestStreak].
Habit refreshStreak(
  Habit habit, {
  required DateTime today,
  required Iterable<Completion> completions,
}) {
  final last = habit.lastCompletedAt;
  if (last == null || habit.streak == 0) return habit;

  final broken = habit.frequency == Frequency.daily
      ? localDaysBetween(last, today) > 1
      : _isXnStreakBroken(habit, last, today, completions);
  return broken ? habit.copyWith(streak: 0) : habit;
}

bool _isXnStreakBroken(
  Habit habit,
  DateTime last,
  DateTime today,
  Iterable<Completion> completions,
) {
  final lastWeek = startOfWeek(last);
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
  return done < effectiveQuota(habit, lastWeek);
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

/// Levels the hero must gain to afford a reward of [cost] points.
int levelsNeededFor(int cost, {GameConfig config = GameConfig.standard}) =>
    (cost + config.rpPerLevel - 1) ~/ config.rpPerLevel;

/// Share of today's due habits already done, from 0 to 1 (1 if none are due).
double questPct({required int done, required int due}) =>
    due == 0 ? 1.0 : done / due;
