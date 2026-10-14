import 'package:levelup/domain/enums.dart';

/// A reward the user created and can redeem with reward points.
///
/// Immutable. [copyWith] uses `??`, so it can change [note] but never reset
/// it back to null.
class Reward {
  const Reward({
    required this.id,
    required this.name,
    required this.tier,
    this.note,
  });

  final String id;
  final String name;
  final String? note;
  final RewardTier tier;

  /// Reward points needed to redeem, derived from [tier].
  int get cost => tier.cost;

  Reward copyWith({String? id, String? name, String? note, RewardTier? tier}) =>
      Reward(
        id: id ?? this.id,
        name: name ?? this.name,
        note: note ?? this.note,
        tier: tier ?? this.tier,
      );

  @override
  bool operator ==(Object other) =>
      other is Reward &&
      other.id == id &&
      other.name == name &&
      other.note == note &&
      other.tier == tier;

  @override
  int get hashCode => Object.hash(id, name, note, tier);
}

/// A redeemed reward: a snapshot of what was paid and when.
class Redemption {
  const Redemption({
    required this.id,
    required this.rewardName,
    required this.cost,
    required this.levelAt,
    required this.at,
  });

  final String id;
  final String rewardName;
  final int cost;

  /// The hero level at the moment of redemption.
  final int levelAt;
  final DateTime at;

  Redemption copyWith({
    String? id,
    String? rewardName,
    int? cost,
    int? levelAt,
    DateTime? at,
  }) => Redemption(
    id: id ?? this.id,
    rewardName: rewardName ?? this.rewardName,
    cost: cost ?? this.cost,
    levelAt: levelAt ?? this.levelAt,
    at: at ?? this.at,
  );

  @override
  bool operator ==(Object other) =>
      other is Redemption &&
      other.id == id &&
      other.rewardName == rewardName &&
      other.cost == cost &&
      other.levelAt == levelAt &&
      other.at == at;

  @override
  int get hashCode => Object.hash(id, rewardName, cost, levelAt, at);
}
