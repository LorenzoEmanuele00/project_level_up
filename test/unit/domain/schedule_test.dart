import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/schedule.dart';

import 'support/fixtures.dart';

// Week of Monday 2026-05-11 to Sunday 2026-05-17.
final _monday = DateTime(2026, 5, 11);
final _tuesday = DateTime(2026, 5, 12);
final _wednesday = DateTime(2026, 5, 13);
final _thursday = DateTime(2026, 5, 14);
final _sunday = DateTime(2026, 5, 17);
final _nextMonday = DateTime(2026, 5, 18);

List<Completion> _doneOn(List<DateTime> days, {String habitId = 'habit-1'}) => [
  for (final d in days)
    completionFixture(d.add(const Duration(hours: 9)), habitId: habitId),
];

void main() {
  group('isDoneOn', () {
    test('is false without any completion', () {
      expect(isDoneOn(habitFixture(), _wednesday), isFalse);
    });

    test('is true when last completed earlier the same local day', () {
      final habit = habitFixture(lastCompletedAt: DateTime(2026, 5, 13, 0, 1));

      expect(isDoneOn(habit, DateTime(2026, 5, 13, 23, 59)), isTrue);
    });

    test('is false when last completed the previous day at 23:59', () {
      final habit = habitFixture(
        lastCompletedAt: DateTime(2026, 5, 12, 23, 59),
      );

      expect(isDoneOn(habit, DateTime(2026, 5, 13, 0, 1)), isFalse);
    });
  });

  group('effectiveQuota', () {
    test('is the plain weekly quota for a habit created earlier', () {
      for (final frequency in Frequency.values) {
        final habit = habitFixture(frequency: frequency);

        expect(effectiveQuota(habit, _monday), frequency.weeklyQuota);
      }
    });

    test('is capped by the days left in the first week', () {
      final habit = habitFixture(
        frequency: Frequency.x5,
        createdAt: DateTime(2026, 5, 14, 18),
      );

      expect(effectiveQuota(habit, _monday), 4);
    });

    test('keeps the plain quota when the first week has enough days', () {
      final habit = habitFixture(
        frequency: Frequency.x3,
        createdAt: DateTime(2026, 5, 14),
      );

      expect(effectiveQuota(habit, _monday), 3);
    });

    test('is 1 for an x2 habit created on Sunday', () {
      final habit = habitFixture(
        frequency: Frequency.x2,
        createdAt: DateTime(2026, 5, 17, 20),
      );

      expect(effectiveQuota(habit, _monday), 1);
    });

    test('is back to the plain quota from the following week', () {
      final habit = habitFixture(
        frequency: Frequency.x2,
        createdAt: DateTime(2026, 5, 17),
      );

      expect(effectiveQuota(habit, _nextMonday), 2);
    });

    test('accepts any day of the week as the week reference', () {
      final habit = habitFixture(
        frequency: Frequency.x5,
        createdAt: DateTime(2026, 5, 14),
      );

      expect(effectiveQuota(habit, _sunday), 4);
    });

    test('daily habit created on Thursday has 4 days that week', () {
      final habit = habitFixture(createdAt: DateTime(2026, 5, 14));

      expect(effectiveQuota(habit, _monday), 4);
    });
  });

  group('isDueOn', () {
    test('a daily habit is due every day of the week', () {
      final habit = habitFixture();

      for (var i = 0; i < 7; i++) {
        final day = DateTime(2026, 5, 11 + i);
        expect(isDueOn(habit, day, const []), isTrue, reason: '$day');
      }
    });

    test('an xN habit is due at the start of the week', () {
      for (final f in [Frequency.x5, Frequency.x3, Frequency.x2]) {
        expect(isDueOn(habitFixture(frequency: f), _monday, const []), isTrue);
      }
    });

    test('x3 is due mid week with two completions before', () {
      final habit = habitFixture(frequency: Frequency.x3);

      expect(isDueOn(habit, _wednesday, _doneOn([_monday, _tuesday])), isTrue);
    });

    test('x3 stays due today after completing it today', () {
      final habit = habitFixture(frequency: Frequency.x3);
      final done = _doneOn([_monday, _tuesday, _wednesday]);

      expect(isDueOn(habit, _wednesday, done), isTrue);
    });

    test('x3 is not due after the quota was met on earlier days', () {
      final habit = habitFixture(frequency: Frequency.x3);
      final done = _doneOn([_monday, _tuesday, _wednesday]);

      expect(isDueOn(habit, _thursday, done), isFalse);
      expect(isDueOn(habit, _sunday, done), isFalse);
    });

    test('x3 is due again on the next Monday', () {
      final habit = habitFixture(frequency: Frequency.x3);
      final done = _doneOn([_monday, _tuesday, _wednesday]);

      expect(isDueOn(habit, _nextMonday, done), isTrue);
    });

    test('x2 is due on Sunday with one completion, not with two', () {
      final habit = habitFixture(frequency: Frequency.x2);

      expect(isDueOn(habit, _sunday, _doneOn([_monday])), isTrue);
      expect(isDueOn(habit, _sunday, _doneOn([_monday, _tuesday])), isFalse);
    });

    test('x5 is due until five days were completed', () {
      final habit = habitFixture(frequency: Frequency.x5);
      final four = _doneOn([_monday, _tuesday, _wednesday, _thursday]);
      final five = _doneOn([
        _monday,
        _tuesday,
        _wednesday,
        _thursday,
        DateTime(2026, 5, 15),
      ]);

      expect(isDueOn(habit, DateTime(2026, 5, 15), four), isTrue);
      expect(isDueOn(habit, _sunday, five), isFalse);
    });

    test('ignores completions of other habits', () {
      final habit = habitFixture(frequency: Frequency.x2);
      final others = _doneOn([_monday, _tuesday], habitId: 'other');

      expect(isDueOn(habit, _thursday, others), isTrue);
    });

    test('ignores completions from previous weeks', () {
      final habit = habitFixture(frequency: Frequency.x2);
      final lastWeek = _doneOn([DateTime(2026, 5, 9), DateTime(2026, 5, 10)]);

      expect(isDueOn(habit, _monday, lastWeek), isTrue);
    });

    test('ignores completions on or after the day itself', () {
      final habit = habitFixture(frequency: Frequency.x2);
      final later = _doneOn([_wednesday, _thursday]);

      expect(isDueOn(habit, _tuesday, later), isTrue);
    });

    test('an archived habit is never due', () {
      expect(isDueOn(habitFixture(archived: true), _monday, const []), isFalse);
    });

    test('is not due before the day it was created', () {
      final habit = habitFixture(createdAt: DateTime(2026, 5, 14, 18));

      expect(isDueOn(habit, _wednesday, const []), isFalse);
      expect(isDueOn(habit, DateTime(2026, 5, 14, 6), const []), isTrue);
    });

    test('x5 created on Thursday is still due on Sunday after 3 days', () {
      final habit = habitFixture(
        frequency: Frequency.x5,
        createdAt: DateTime(2026, 5, 14),
      );
      final three = _doneOn([
        _thursday,
        DateTime(2026, 5, 15),
        DateTime(2026, 5, 16),
      ]);

      expect(isDueOn(habit, _sunday, three), isTrue);
    });

    test('x5 created on Thursday is due again on the next Monday', () {
      final habit = habitFixture(
        frequency: Frequency.x5,
        createdAt: DateTime(2026, 5, 14),
      );
      final all = _doneOn([
        _thursday,
        DateTime(2026, 5, 15),
        DateTime(2026, 5, 16),
        _sunday,
      ]);

      expect(isDueOn(habit, _nextMonday, all), isTrue);
    });

    test('x2 created on Sunday stays due on that Sunday even once done', () {
      final habit = habitFixture(
        frequency: Frequency.x2,
        createdAt: DateTime(2026, 5, 17),
      );

      expect(isDueOn(habit, _sunday, const []), isTrue);
      expect(isDueOn(habit, _sunday, _doneOn([_sunday])), isTrue);
    });

    test('x2 created on Wednesday is not due on Friday after two days', () {
      final habit = habitFixture(
        frequency: Frequency.x2,
        createdAt: _wednesday,
      );
      final done = _doneOn([_wednesday, _thursday]);

      expect(isDueOn(habit, DateTime(2026, 5, 15), done), isFalse);
    });
  });
}
