import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

Reward makeReward() =>
    const Reward(id: 'r1', name: 'Gelato', tier: RewardTier.piccola);

Redemption makeRedemption() => Redemption(
  id: 'd1',
  rewardName: 'Gelato',
  cost: 10,
  levelAt: 3,
  at: DateTime(2026, 5, 10, 18),
);

void main() {
  group('Reward', () {
    test('has no note by default', () {
      expect(makeReward().note, isNull);
    });

    test('derives its cost from the tier', () {
      final reward = makeReward();

      expect(reward.copyWith(tier: RewardTier.piccola).cost, 10);
      expect(reward.copyWith(tier: RewardTier.media).cost, 25);
      expect(reward.copyWith(tier: RewardTier.grande).cost, 60);
    });

    test('copyWith replaces every field', () {
      final copy = makeReward().copyWith(
        id: 'r2',
        name: 'Cena',
        note: 'fuori',
        tier: RewardTier.grande,
      );

      expect(
        copy,
        const Reward(
          id: 'r2',
          name: 'Cena',
          note: 'fuori',
          tier: RewardTier.grande,
        ),
      );
    });

    test('copyWith cannot reset the note back to null', () {
      final reward = makeReward().copyWith(note: 'fuori');

      expect(reward.copyWith(note: null).note, 'fuori');
    });

    test('has value equality and a matching hashCode', () {
      expect(makeReward(), makeReward());
      expect(makeReward().hashCode, makeReward().hashCode);
    });

    test('differs when any single field differs', () {
      final reward = makeReward();
      final variants = <Reward>[
        reward.copyWith(id: 'x'),
        reward.copyWith(name: 'x'),
        reward.copyWith(note: 'x'),
        reward.copyWith(tier: RewardTier.media),
      ];

      for (final variant in variants) {
        expect(variant, isNot(reward));
      }
    });
  });

  group('Redemption', () {
    test('copyWith replaces every field', () {
      final copy = makeRedemption().copyWith(
        id: 'd2',
        rewardName: 'Cena',
        cost: 60,
        levelAt: 9,
        at: DateTime(2026, 6, 1),
      );

      expect(
        copy,
        Redemption(
          id: 'd2',
          rewardName: 'Cena',
          cost: 60,
          levelAt: 9,
          at: DateTime(2026, 6, 1),
        ),
      );
    });

    test('has value equality and a matching hashCode', () {
      expect(makeRedemption(), makeRedemption());
      expect(makeRedemption().hashCode, makeRedemption().hashCode);
    });

    test('differs when any single field differs', () {
      final redemption = makeRedemption();
      final variants = <Redemption>[
        redemption.copyWith(id: 'x'),
        redemption.copyWith(rewardName: 'x'),
        redemption.copyWith(cost: 1),
        redemption.copyWith(levelAt: 1),
        redemption.copyWith(at: DateTime(2026, 1, 1)),
      ];

      for (final variant in variants) {
        expect(variant, isNot(redemption));
      }
    });
  });
}
