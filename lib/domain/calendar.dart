// Calendar helpers on the user's local days.
//
// A "day" is the local calendar date, never a block of 24 hours: daylight
// saving makes some days 23 or 25 hours long. All arithmetic goes through
// the `DateTime(y, m, d)` constructor, which normalises overflowing fields.

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
