import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';

void main() {
  group('Difficulty', () {
    test('lists easy, medium, hard in order', () {
      expect(Difficulty.values, [
        Difficulty.facile,
        Difficulty.media,
        Difficulty.difficile,
      ]);
    });

    test('gives a fixed exp per completion', () {
      expect(Difficulty.facile.exp, 10);
      expect(Difficulty.media.exp, 20);
      expect(Difficulty.difficile.exp, 40);
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
      expect(RewardTier.piccola.cost, 10);
      expect(RewardTier.media.cost, 25);
      expect(RewardTier.grande.cost, 60);
    });
  });

  group('plain enums', () {
    test('HeroClass lists the five classes', () {
      expect(HeroClass.values, [
        HeroClass.guerriero,
        HeroClass.studioso,
        HeroClass.monaco,
        HeroClass.creatore,
        HeroClass.esploratore,
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
