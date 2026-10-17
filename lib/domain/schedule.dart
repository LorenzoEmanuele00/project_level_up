import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

/// Whether [habit] has a completion on the local day of [day].
///
/// Valid for any day, as long as [completions] include that day.
bool isDoneOn(Habit habit, DateTime day, Iterable<Completion> completions) =>
    completions.any((c) => c.habitId == habit.id && isSameLocalDay(c.at, day));

/// Completions expected for [habit] in the week containing [weekStart].
///
/// The quota follows [frequency], which defaults to the habit's current one.
/// A week that is already closed must be judged with the frequency its
/// completions were made with, so callers pass that one.
///
/// In the week the habit was created, an xN habit cannot ask for more days
/// than are left from the creation day to Sunday (inclusive).
int effectiveQuota(Habit habit, DateTime weekStart, {Frequency? frequency}) {
  final week = startOfWeek(weekStart);
  final quota = (frequency ?? habit.frequency).weeklyQuota;
  if (startOfWeek(habit.createdAt) != week) return quota;

  final sunday = addLocalDays(week, DateTime.daysPerWeek - 1);
  final daysLeft = localDaysBetween(habit.createdAt, sunday) + 1;
  return quota < daysLeft ? quota : daysLeft;
}

/// Whether [habit] is due on [day], given the recorded [completions].
///
/// Only completions strictly before [day] (within its week) count, so a habit
/// completed today stays due today.
bool isDueOn(Habit habit, DateTime day, Iterable<Completion> completions) {
  if (habit.archived) return false;
  final today = localDay(day);
  if (today.isBefore(localDay(habit.createdAt))) return false;
  if (habit.frequency == Frequency.daily) return true;

  final weekStart = startOfWeek(today);
  final doneBefore = completions.where((c) {
    if (c.habitId != habit.id) return false;
    final at = c.at.toLocal();
    return !at.isBefore(weekStart) && at.isBefore(today);
  }).length;
  return doneBefore < effectiveQuota(habit, weekStart);
}
