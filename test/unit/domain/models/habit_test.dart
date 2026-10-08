import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

Habit makeHabit() => Habit(
  id: 'b1',
  name: 'Read',
  icon: 'book',
  difficulty: Difficulty.media,
  frequency: Frequency.daily,
  hue: HabitHue.teal,
  streak: 0,
  bestStreak: 0,
  totalCompletions: 0,
  archived: false,
  createdAt: DateTime(2026, 5, 1),
);

void main() {
  group('Habit', () {
    test('has no last completion by default', () {
      expect(makeHabit().lastCompletedAt, isNull);
    });

    test('derives exp from its difficulty', () {
      final habit = makeHabit();

      expect(habit.copyWith(difficulty: Difficulty.facile).exp, 10);
      expect(habit.copyWith(difficulty: Difficulty.media).exp, 20);
      expect(habit.copyWith(difficulty: Difficulty.difficile).exp, 40);
    });

    test('copyWith replaces every field', () {
      final copy = makeHabit().copyWith(
        id: 'b2',
        name: 'Run',
        icon: 'shoe',
        difficulty: Difficulty.difficile,
        frequency: Frequency.x3,
        hue: HabitHue.gold,
        streak: 4,
        bestStreak: 9,
        totalCompletions: 20,
        lastCompletedAt: DateTime(2026, 5, 10, 8),
        archived: true,
        createdAt: DateTime(2026, 4, 1),
      );

      expect(
        copy,
        Habit(
          id: 'b2',
          name: 'Run',
          icon: 'shoe',
          difficulty: Difficulty.difficile,
          frequency: Frequency.x3,
          hue: HabitHue.gold,
          streak: 4,
          bestStreak: 9,
          totalCompletions: 20,
          lastCompletedAt: DateTime(2026, 5, 10, 8),
          archived: true,
          createdAt: DateTime(2026, 4, 1),
        ),
      );
    });

    test('copyWith cannot reset lastCompletedAt back to null', () {
      final habit = makeHabit().copyWith(lastCompletedAt: DateTime(2026, 5, 2));

      final copy = habit.copyWith(lastCompletedAt: null);

      expect(copy.lastCompletedAt, DateTime(2026, 5, 2));
    });

    test('has value equality and a matching hashCode', () {
      expect(makeHabit(), makeHabit());
      expect(makeHabit().hashCode, makeHabit().hashCode);
    });

    test('differs when any single field differs', () {
      final habit = makeHabit();
      final variants = <Habit>[
        habit.copyWith(id: 'x'),
        habit.copyWith(name: 'x'),
        habit.copyWith(icon: 'x'),
        habit.copyWith(difficulty: Difficulty.facile),
        habit.copyWith(frequency: Frequency.x2),
        habit.copyWith(hue: HabitHue.blue),
        habit.copyWith(streak: 1),
        habit.copyWith(bestStreak: 1),
        habit.copyWith(totalCompletions: 1),
        habit.copyWith(lastCompletedAt: DateTime(2026, 5, 2)),
        habit.copyWith(archived: true),
        habit.copyWith(createdAt: DateTime(2026, 5, 2)),
      ];

      for (final variant in variants) {
        expect(variant, isNot(habit));
      }
    });
  });
}
