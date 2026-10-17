import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/new_entities.dart';
import 'package:levelup/domain/enums.dart';

void main() {
  test('a new hero is level 1 with nothing earned', () {
    final hero = newHero(
      id: 'h',
      avatarMode: AvatarMode.icon,
      avatarIcon: 'crown',
      accent: AccentKey.rose,
      theme: ThemeKey.dark,
      name: 'Ada',
      heroClass: HeroClass.monk,
      userId: 'u',
    );

    expect((hero.level, hero.exp, hero.rewardPoints), (1, 0, 0));
    expect(hero.id, 'h');
    expect(hero.userId, 'u');
    expect(hero.name, 'Ada');
    expect(hero.avatarIcon, 'crown');
    expect(hero.heroClass, HeroClass.monk);
    expect((hero.accent, hero.theme), (AccentKey.rose, ThemeKey.dark));
  });

  test('a new hero has no account, name or class by default', () {
    final hero = newHero(
      id: 'h',
      avatarMode: AvatarMode.initial,
      accent: AccentKey.sage,
      theme: ThemeKey.light,
    );

    expect(hero.userId, isNull);
    expect(hero.name, isNull);
    expect(hero.heroClass, isNull);
  });

  test('a new habit has an empty history, is active and created in UTC', () {
    final habit = newHabit(
      id: 'x',
      name: 'Run',
      icon: 'run',
      difficulty: Difficulty.hard,
      frequency: Frequency.x3,
      hue: HabitHue.gold,
      now: DateTime(2026, 3, 2, 10, 0, 0, 5, 7),
    );

    expect((habit.streak, habit.bestStreak, habit.totalCompletions), (0, 0, 0));
    expect(habit.archived, isFalse);
    expect(habit.createdAt.isUtc, isTrue);
    expect(habit.createdAt.microsecond, 0);
    expect(habit.frequency, Frequency.x3);
  });
}
