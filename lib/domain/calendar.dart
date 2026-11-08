// Calendar helpers on the user's local days.
//
// A "day" is the local calendar date, never a block of 24 hours: daylight
// saving makes some days 23 or 25 hours long. All arithmetic goes through
// the `DateTime(y, m, d)` constructor, which normalises overflowing fields.

import 'package:levelup/domain/enums.dart';

/// The local calendar day of [t] at 00:00 (UTC instants are converted first).
DateTime localDay(DateTime t) {
  final local = t.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// Whether [a] and [b] fall on the same local calendar day.
bool isSameLocalDay(DateTime a, DateTime b) => localDay(a) == localDay(b);

/// The local day [n] calendar days after [day] (before, if [n] is negative).
DateTime addLocalDays(DateTime day, int n) {
  final start = localDay(day);
  return DateTime(start.year, start.month, start.day + n);
}

/// The Monday at 00:00 of the week containing [day].
DateTime startOfWeek(DateTime day) {
  final start = localDay(day);
  return addLocalDays(start, -(start.weekday - DateTime.monday));
}

/// Whole calendar days from [from] to [to] (negative if [to] is earlier).
int localDaysBetween(DateTime from, DateTime to) {
  final a = localDay(from);
  final b = localDay(to);
  return DateTime.utc(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
}

const _morningStartHour = 5;
const _afternoonStartHour = 12;
const _eveningStartHour = 18;

/// The part of the day of [t] in local time: morning from 05:00, afternoon
/// from 12:00, evening from 18:00 until 04:59 (the night counts as evening).
GreetingPeriod greetingPeriodAt(DateTime t) {
  final hour = t.toLocal().hour;
  if (hour >= _eveningStartHour || hour < _morningStartHour) {
    return GreetingPeriod.evening;
  }
  return hour >= _afternoonStartHour
      ? GreetingPeriod.afternoon
      : GreetingPeriod.morning;
}

const _hoursOfChange = [
  _morningStartHour,
  _afternoonStartHour,
  _eveningStartHour,
];

/// The next instant after [t] at which the Home greeting or its date changes:
/// 05:00, 12:00, 18:00, or midnight (new date).
DateTime nextGreetingChange(DateTime t) {
  final local = t.toLocal();
  for (final hour in _hoursOfChange) {
    if (local.hour < hour) {
      return DateTime(local.year, local.month, local.day, hour);
    }
  }
  return DateTime(local.year, local.month, local.day + 1);
}
