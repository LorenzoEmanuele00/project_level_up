import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/calendar.dart';

void main() {
  group('localDay', () {
    test('drops the time of day', () {
      final day = localDay(DateTime(2026, 5, 13, 23, 59, 59, 999));

      expect(day, DateTime(2026, 5, 13));
    });

    test('returns a local (non UTC) date', () {
      expect(localDay(DateTime(2026, 5, 13, 8)).isUtc, isFalse);
    });

    test('converts a UTC instant to its local calendar day', () {
      final instant = DateTime.utc(2026, 5, 13, 22, 30);
      final local = instant.toLocal();

      final day = localDay(instant);

      expect(day, DateTime(local.year, local.month, local.day));
      expect(day.isUtc, isFalse);
    });
  });

  group('isSameLocalDay', () {
    test('is true at 00:00 and 23:59 of the same day', () {
      expect(
        isSameLocalDay(DateTime(2026, 5, 13), DateTime(2026, 5, 13, 23, 59)),
        isTrue,
      );
    });

    test('is false across midnight', () {
      expect(
        isSameLocalDay(
          DateTime(2026, 5, 13, 23, 59),
          DateTime(2026, 5, 14, 0, 1),
        ),
        isFalse,
      );
    });

    test('is false for the same date in another month or year', () {
      expect(
        isSameLocalDay(DateTime(2026, 5, 13), DateTime(2026, 6, 13)),
        isFalse,
      );
      expect(
        isSameLocalDay(DateTime(2026, 5, 13), DateTime(2027, 5, 13)),
        isFalse,
      );
    });
  });

  group('addLocalDays', () {
    test('adds days within a month', () {
      expect(addLocalDays(DateTime(2026, 5, 13, 17), 2), DateTime(2026, 5, 15));
    });

    test('subtracts days with a negative amount', () {
      expect(addLocalDays(DateTime(2026, 5, 13), -13), DateTime(2026, 4, 30));
    });

    test('rolls over month and year boundaries', () {
      expect(addLocalDays(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 1));
      expect(addLocalDays(DateTime(2026, 12, 31), 1), DateTime(2027, 1, 1));
    });

    test('handles leap day', () {
      expect(addLocalDays(DateTime(2028, 2, 28), 1), DateTime(2028, 2, 29));
      expect(addLocalDays(DateTime(2026, 2, 28), 1), DateTime(2026, 3, 1));
    });

    test('adds zero days as the plain day', () {
      expect(addLocalDays(DateTime(2026, 5, 13, 9), 0), DateTime(2026, 5, 13));
    });

    test('moves one calendar day across the spring DST change', () {
      // Europe/Rome springs forward on 2026-03-29 (a 23 hour day).
      expect(addLocalDays(DateTime(2026, 3, 28), 1), DateTime(2026, 3, 29));
      expect(addLocalDays(DateTime(2026, 3, 29), 1), DateTime(2026, 3, 30));
    });

    test('moves one calendar day across the autumn DST change', () {
      // Europe/Rome falls back on 2026-10-25 (a 25 hour day).
      expect(addLocalDays(DateTime(2026, 10, 24), 1), DateTime(2026, 10, 25));
      expect(addLocalDays(DateTime(2026, 10, 25), 1), DateTime(2026, 10, 26));
    });
  });

  group('startOfWeek', () {
    test('returns the same day on a Monday', () {
      // 2026-05-11 is a Monday.
      expect(startOfWeek(DateTime(2026, 5, 11, 15)), DateTime(2026, 5, 11));
    });

    test('returns the previous Monday in mid week', () {
      expect(startOfWeek(DateTime(2026, 5, 14)), DateTime(2026, 5, 11));
    });

    test('keeps Sunday in the week that started on Monday', () {
      expect(startOfWeek(DateTime(2026, 5, 17, 23, 59)), DateTime(2026, 5, 11));
    });

    test('starts a new week on the Monday after Sunday', () {
      expect(startOfWeek(DateTime(2026, 5, 18)), DateTime(2026, 5, 18));
    });

    test('crosses month and year boundaries', () {
      // 2026-01-01 is a Thursday.
      expect(startOfWeek(DateTime(2026, 1, 1)), DateTime(2025, 12, 29));
    });

    test('is stable across the DST weekends', () {
      expect(startOfWeek(DateTime(2026, 3, 29)), DateTime(2026, 3, 23));
      expect(startOfWeek(DateTime(2026, 10, 25)), DateTime(2026, 10, 19));
    });
  });

  group('localDaysBetween', () {
    test('is zero for the same day at different times', () {
      expect(
        localDaysBetween(DateTime(2026, 5, 13), DateTime(2026, 5, 13, 23, 59)),
        0,
      );
    });

    test('is one between 23:59 and 00:01 of the next day', () {
      expect(
        localDaysBetween(
          DateTime(2026, 5, 13, 23, 59),
          DateTime(2026, 5, 14, 0, 1),
        ),
        1,
      );
    });

    test('is negative when the second day is earlier', () {
      expect(
        localDaysBetween(DateTime(2026, 5, 15), DateTime(2026, 5, 13)),
        -2,
      );
    });

    test('counts across month and year boundaries', () {
      expect(localDaysBetween(DateTime(2026, 12, 30), DateTime(2027, 1, 2)), 3);
    });

    test('counts whole days over the spring DST change', () {
      expect(localDaysBetween(DateTime(2026, 3, 28), DateTime(2026, 3, 30)), 2);
      expect(
        localDaysBetween(
          DateTime(2026, 3, 28, 23, 30),
          DateTime(2026, 3, 29, 0, 30),
        ),
        1,
      );
    });

    test('counts whole days over the autumn DST change', () {
      expect(
        localDaysBetween(DateTime(2026, 10, 24), DateTime(2026, 10, 26)),
        2,
      );
      expect(
        localDaysBetween(
          DateTime(2026, 10, 25, 23, 30),
          DateTime(2026, 10, 26, 0, 30),
        ),
        1,
      );
    });
  });
}
