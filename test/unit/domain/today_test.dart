import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/today.dart';

import 'support/fixtures.dart';

/// Whether the machine zone has daylight saving in 2026 (Europe/Rome: run
/// with `TZ=Europe/Rome`). The DST tests are skipped otherwise.
final _hasDst =
    DateTime(2026, 3, 30).difference(DateTime(2026, 3, 29)).inHours == 23;
const _needsDst = 'needs a zone with daylight saving: run TZ=Europe/Rome';

/// Wednesday 2026-03-04.
final _wednesday = DateTime(2026, 3, 4, 12);

void main() {
  group('summarizeToday', () {
    test('no habits at all: nothing due, all done, quest complete', () {
      final summary = summarizeToday(
        habits: const [],
        completions: const [],
        day: _wednesday,
      );

      expect(summary.dueHabits, isEmpty);
      expect((summary.doneCount, summary.dueCount), (0, 0));
      expect((summary.expToday, summary.expLeft, summary.maxStreak), (0, 0, 0));
      expect(summary.questPct, 1.0);
      expect(summary.allDone, isTrue);
    });

    test('keeps the order of the habits and marks the ones done today', () {
      final a = habitFixture(id: 'a');
      final b = habitFixture(id: 'b', difficulty: Difficulty.hard);
      final doneB = completionFixture(
        DateTime(2026, 3, 4, 8),
        habitId: 'b',
        exp: 40,
      );

      final summary = summarizeToday(
        habits: [a, b],
        completions: [doneB],
        day: _wednesday,
      );

      expect(summary.dueHabits, [
        (habit: a, done: false),
        (habit: b, done: true),
      ]);
      expect((summary.doneCount, summary.dueCount), (1, 2));
      expect(summary.questPct, 0.5);
      expect(summary.allDone, isFalse);
    });

    test('expToday sums the EXP of the completions of the day only', () {
      final a = habitFixture(id: 'a');
      final b = habitFixture(id: 'b');
      final completions = [
        completionFixture(DateTime(2026, 3, 3, 23, 59), habitId: 'a', exp: 10),
        completionFixture(DateTime(2026, 3, 4, 0, 1), habitId: 'a', exp: 20),
        completionFixture(DateTime(2026, 3, 4, 23, 59), habitId: 'b', exp: 40),
        completionFixture(DateTime(2026, 3, 5), habitId: 'b', exp: 99),
      ];

      final summary = summarizeToday(
        habits: [a, b],
        completions: completions,
        day: _wednesday,
      );

      expect(summary.expToday, 60);
    });

    test('expLeft sums the EXP of the due habits not done yet', () {
      final easy = habitFixture(id: 'e', difficulty: Difficulty.easy);
      final medium = habitFixture(id: 'm');
      final hard = habitFixture(id: 'h', difficulty: Difficulty.hard);

      final summary = summarizeToday(
        habits: [easy, medium, hard],
        completions: [
          completionFixture(DateTime(2026, 3, 4, 9), habitId: 'm', exp: 20),
        ],
        day: _wednesday,
      );

      expect(summary.expLeft, 50);
    });

    test('all due habits done: allDone, questPct 1 and nothing left', () {
      final summary = summarizeToday(
        habits: [habitFixture()],
        completions: [completionFixture(DateTime(2026, 3, 4, 9))],
        day: _wednesday,
      );

      expect(summary.allDone, isTrue);
      expect(summary.questPct, 1.0);
      expect(summary.expLeft, 0);
    });

    test('archived habits are left out of everything', () {
      final active = habitFixture(id: 'a', streak: 2);
      final archived = habitFixture(
        id: 'z',
        archived: true,
        streak: 9,
        difficulty: Difficulty.hard,
      );

      final summary = summarizeToday(
        habits: [active, archived],
        completions: [
          completionFixture(DateTime(2026, 3, 3, 9), habitId: 'a'),
          completionFixture(DateTime(2026, 3, 3, 9), habitId: 'z'),
        ],
        day: _wednesday,
      );

      expect(summary.dueHabits.map((d) => d.habit.id), ['a']);
      expect(summary.expLeft, 20);
      expect(summary.maxStreak, 2);
    });

    test(
      'an xN habit that met its quota this week is not due, not counted',
      () {
        // Monday 2026-03-02 and Tuesday: two of two done; Wednesday is free.
        final x2 = habitFixture(id: 'x', frequency: Frequency.x2, streak: 1);
        final daily = habitFixture(id: 'd');
        final completions = [
          completionFixture(
            DateTime(2026, 3, 2, 9),
            habitId: 'x',
            frequency: Frequency.x2,
          ),
          completionFixture(
            DateTime(2026, 3, 3, 9),
            habitId: 'x',
            frequency: Frequency.x2,
          ),
        ];

        final summary = summarizeToday(
          habits: [x2, daily],
          completions: completions,
          day: _wednesday,
        );

        expect(summary.dueHabits.map((d) => d.habit.id), ['d']);
        expect((summary.doneCount, summary.dueCount), (0, 1));
        expect(summary.expLeft, 20);
      },
    );

    test('an xN habit completed today stays due and counts as done', () {
      final x3 = habitFixture(id: 'x', frequency: Frequency.x3, streak: 1);

      final summary = summarizeToday(
        habits: [x3],
        completions: [
          completionFixture(
            DateTime(2026, 3, 4, 9),
            habitId: 'x',
            frequency: Frequency.x3,
          ),
        ],
        day: _wednesday,
      );

      expect(summary.dueHabits, [(habit: x3, done: true)]);
      expect(summary.allDone, isTrue);
    });

    test('maxStreak is the highest streak among the active habits', () {
      final summary = summarizeToday(
        habits: [
          habitFixture(id: 'a', streak: 3),
          habitFixture(id: 'b', streak: 7),
        ],
        completions: [
          completionFixture(DateTime(2026, 3, 3, 9), habitId: 'a'),
          completionFixture(DateTime(2026, 3, 4, 9), habitId: 'b'),
        ],
        day: _wednesday,
      );

      expect(summary.maxStreak, 7);
    });

    test('maxStreak ignores a streak that already expired', () {
      final summary = summarizeToday(
        habits: [
          habitFixture(id: 'old', streak: 9),
          habitFixture(id: 'live', streak: 2),
        ],
        completions: [
          // Two days ago: a skipped day in between, the streak is broken.
          completionFixture(DateTime(2026, 3, 2, 9), habitId: 'old'),
          completionFixture(DateTime(2026, 3, 3, 9), habitId: 'live'),
        ],
        day: _wednesday,
      );

      expect(summary.maxStreak, 2);
    });

    test('a live streak with no completions in the window counts as 0', () {
      final summary = summarizeToday(
        habits: [habitFixture(streak: 5)],
        completions: const [],
        day: _wednesday,
      );

      expect(summary.maxStreak, 0);
    });

    test('reads the day as a local day whatever time of day is passed', () {
      final a = habitFixture();
      final done = completionFixture(DateTime(2026, 3, 4, 0, 5));

      final late = summarizeToday(
        habits: [a],
        completions: [done],
        day: DateTime(2026, 3, 4, 23, 59),
      );

      expect(late.doneCount, 1);
    });

    test('the due list cannot be modified from outside', () {
      final summary = summarizeToday(
        habits: [habitFixture()],
        completions: const [],
        day: _wednesday,
      );

      expect(
        () => summary.dueHabits.add((habit: habitFixture(id: 'x'), done: true)),
        throwsUnsupportedError,
      );
    });

    test('does not change the habits it was given', () {
      final habits = [habitFixture(streak: 4)];

      summarizeToday(habits: habits, completions: const [], day: _wednesday);

      expect(habits.single.streak, 4);
    });

    test('handles a large number of habits', () {
      final habits = [
        for (var i = 0; i < 10000; i++) habitFixture(id: 'h$i', streak: i % 5),
      ];

      final summary = summarizeToday(
        habits: habits,
        completions: const [],
        day: _wednesday,
      );

      expect(summary.dueCount, 10000);
    });

    group('daylight saving', () {
      // 2026-03-29 has 23 hours, 2026-10-25 has 25 (Europe/Rome).
      for (final (label, year, month, day) in [
        ('23-hour day', 2026, 3, 29),
        ('25-hour day', 2026, 10, 25),
      ]) {
        test('$label: completions at 00:30 and 23:30 belong to the day', () {
          final a = habitFixture(id: 'a', createdAt: DateTime(2026, 1, 1));
          final b = habitFixture(id: 'b', createdAt: DateTime(2026, 1, 1));
          final completions = [
            completionFixture(
              DateTime(year, month, day - 1, 23, 30),
              habitId: 'a',
              exp: 5,
            ),
            completionFixture(
              DateTime(year, month, day, 0, 30),
              habitId: 'a',
              exp: 20,
            ),
            completionFixture(
              DateTime(year, month, day, 23, 30),
              habitId: 'b',
              exp: 40,
            ),
            completionFixture(
              DateTime(year, month, day + 1, 0, 30),
              habitId: 'b',
              exp: 99,
            ),
          ];

          final summary = summarizeToday(
            habits: [a, b],
            completions: completions,
            day: DateTime(year, month, day, 12),
          );

          expect(summary.doneCount, 2);
          expect(summary.expToday, 60);
          expect(summary.allDone, isTrue);
        }, skip: _hasDst ? false : _needsDst);
      }
    });
  });
}
