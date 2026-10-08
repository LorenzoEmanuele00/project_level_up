import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

/// Whether [habit] was already completed on the local day of [day].
///
/// Only valid for today: [Habit.lastCompletedAt] remembers just the latest
/// completion, so a past day cannot be answered from it.
bool isDoneOn(Habit habit, DateTime day) {
  final last = habit.lastCompletedAt;
  return last != null && isSameLocalDay(last, day);
}

/// Completions expected for [habit] in the week containing [weekStart].
///
/// In the week the habit was created, an xN habit cannot ask for more days
/// than are left from the creation day to Sunday (inclusive).
int effectiveQuota(Habit habit, DateTime weekStart) {
  final week = startOfWeek(weekStart);
  final quota = habit.frequency.weeklyQuota;
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
