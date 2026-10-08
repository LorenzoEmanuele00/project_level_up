import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

GameHero makeHero() => const GameHero(
  id: 'h1',
  avatarMode: AvatarMode.initial,
  accent: AccentKey.terra,
  level: 1,
  exp: 0,
  rewardPoints: 0,
  theme: ThemeKey.light,
);

void main() {
  group('GameHero', () {
    test('has no user, name, icon or class by default', () {
      final hero = makeHero();

      expect(hero.userId, isNull);
      expect(hero.name, isNull);
      expect(hero.avatarIcon, isNull);
      expect(hero.heroClass, isNull);
    });

    test('displayName falls back to "Eroe" without a name', () {
      expect(makeHero().displayName, 'Eroe');
    });

    test('displayName falls back to "Eroe" for a blank name', () {
      expect(makeHero().copyWith(name: '   ').displayName, 'Eroe');
    });

    test('displayName returns the name when set', () {
      expect(makeHero().copyWith(name: 'Lorenzo').displayName, 'Lorenzo');
    });

    test('copyWith replaces every field', () {
      final copy = makeHero().copyWith(
        id: 'h2',
        userId: 'u1',
        name: 'Ada',
        avatarMode: AvatarMode.icon,
        avatarIcon: 'star',
        accent: AccentKey.rosa,
        heroClass: HeroClass.monaco,
        level: 4,
        exp: 30,
        rewardPoints: 15,
        theme: ThemeKey.dark,
      );

      expect(
        copy,
        const GameHero(
          id: 'h2',
          userId: 'u1',
          name: 'Ada',
          avatarMode: AvatarMode.icon,
          avatarIcon: 'star',
          accent: AccentKey.rosa,
          heroClass: HeroClass.monaco,
          level: 4,
          exp: 30,
          rewardPoints: 15,
          theme: ThemeKey.dark,
        ),
      );
    });

    test('copyWith without arguments keeps every field', () {
      final hero = makeHero().copyWith(
        name: 'Ada',
        heroClass: HeroClass.monaco,
      );

      expect(hero.copyWith(), hero);
    });

    test('copyWith cannot reset a nullable field back to null', () {
      final hero = makeHero().copyWith(
        name: 'Ada',
        heroClass: HeroClass.monaco,
      );

      final copy = hero.copyWith(name: null, heroClass: null);

      expect(copy.name, 'Ada');
      expect(copy.heroClass, HeroClass.monaco);
    });

    test('has value equality and a matching hashCode', () {
      expect(makeHero(), makeHero());
      expect(makeHero().hashCode, makeHero().hashCode);
    });

    test('differs when any single field differs', () {
      final hero = makeHero();
      final variants = <GameHero>[
        hero.copyWith(id: 'x'),
        hero.copyWith(userId: 'x'),
        hero.copyWith(name: 'x'),
        hero.copyWith(avatarMode: AvatarMode.icon),
        hero.copyWith(avatarIcon: 'x'),
        hero.copyWith(accent: AccentKey.rosa),
        hero.copyWith(heroClass: HeroClass.monaco),
        hero.copyWith(level: 2),
        hero.copyWith(exp: 1),
        hero.copyWith(rewardPoints: 1),
        hero.copyWith(theme: ThemeKey.dark),
      ];

      for (final variant in variants) {
        expect(variant, isNot(hero));
      }
    });
  });
}
