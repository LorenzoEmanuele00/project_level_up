import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';

void main() {
  group('Difficulty', () {
    test('lists easy, medium, hard in order', () {
      expect(Difficulty.values, [
        Difficulty.easy,
        Difficulty.medium,
        Difficulty.hard,
      ]);
    });

    test('gives a fixed exp per completion', () {
      expect(Difficulty.easy.exp, 10);
      expect(Difficulty.medium.exp, 20);
      expect(Difficulty.hard.exp, 40);
    });
  });

  group('Frequency', () {
    test('lists daily and the three weekly quotas', () {
      expect(Frequency.values, [
        Frequency.daily,
        Frequency.x5,
        Frequency.x3,
        Frequency.x2,
      ]);
    });

    test('exposes the weekly quota', () {
      expect(Frequency.daily.weeklyQuota, 7);
      expect(Frequency.x5.weeklyQuota, 5);
      expect(Frequency.x3.weeklyQuota, 3);
      expect(Frequency.x2.weeklyQuota, 2);
    });
  });

  group('RewardTier', () {
    test('costs 10, 25 and 60 reward points', () {
      expect(RewardTier.small.cost, 10);
      expect(RewardTier.medium.cost, 25);
      expect(RewardTier.large.cost, 60);
    });
  });

  group('plain enums', () {
    test('HeroClass lists the five classes', () {
      expect(HeroClass.values, [
        HeroClass.warrior,
        HeroClass.scholar,
        HeroClass.monk,
        HeroClass.creator,
        HeroClass.explorer,
      ]);
    });

    test('AvatarMode is initial or icon', () {
      expect(AvatarMode.values, [AvatarMode.initial, AvatarMode.icon]);
    });

    test('ThemeKey is light or dark', () {
      expect(ThemeKey.values, [ThemeKey.light, ThemeKey.dark]);
    });
  });
}
