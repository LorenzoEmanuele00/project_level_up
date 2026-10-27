import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/game_rules.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/schedule.dart';

/// A habit due today and whether it was already completed today.
typedef DueHabit = ({Habit habit, bool done});

/// What the home screen shows about one local day.
///
/// Immutable: [dueHabits] cannot be modified.
class TodaySummary {
  const TodaySummary({
    required this.dueHabits,
    required this.doneCount,
    required this.dueCount,
    required this.expToday,
    required this.expLeft,
    required this.maxStreak,
    required this.questPct,
    required this.allDone,
  });

  /// Habits due today, in the order they were given, with their done flag.
  final List<DueHabit> dueHabits;

  /// Due habits already completed today.
  final int doneCount;

  /// Habits due today (done or not).
  final int dueCount;

  /// EXP earned today: the sum over the completions of the day.
  final int expToday;

  /// EXP still to earn today: the sum over the due habits not done yet.
  final int expLeft;

  /// The highest live streak among the active habits.
  final int maxStreak;

  /// Share of due habits done, from 0 to 1 (1 if none are due).
  final double questPct;

  /// Whether every due habit is done (also true if none is due).
  final bool allDone;
}

/// Summarises the local day of [day] for the active [habits].
///
/// [completions] must cover the window of [completionWindowStart] to
/// [completionWindowEnd] for [day]: the weekly quotas and the streaks need
/// the previous week too. Archived habits are ignored. The streaks are
/// refreshed in memory only (see [refreshStreak]): nothing is written.
TodaySummary summarizeToday({
  required List<Habit> habits,
  required Iterable<Completion> completions,
  required DateTime day,
}) {
  final today = localDay(day);
  final window = completions.toList(growable: false);
  final active = habits.where((h) => !h.archived);

  final due = <DueHabit>[
    for (final habit in active)
      if (isDueOn(habit, today, window))
        (habit: habit, done: isDoneOn(habit, today, window)),
  ];
  final doneCount = due.where((d) => d.done).length;
  final expLeft = due.where((d) => !d.done).fold(0, (s, d) => s + d.habit.exp);
  final expToday = window
      .where((c) => isSameLocalDay(c.at, today))
      .fold(0, (sum, c) => sum + c.exp);
  final maxStreak = active
      .map((h) => refreshStreak(h, today: today, completions: window).streak)
      .fold(0, (best, streak) => streak > best ? streak : best);

  return TodaySummary(
    dueHabits: List.unmodifiable(due),
    doneCount: doneCount,
    dueCount: due.length,
    expToday: expToday,
    expLeft: expLeft,
    maxStreak: maxStreak,
    questPct: questPct(done: doneCount, due: due.length),
    allDone: doneCount == due.length,
  );
}
