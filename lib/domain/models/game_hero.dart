import 'package:levelup/domain/enums.dart';

/// Name shown when the hero has none (or a blank one).
const _defaultHeroName = 'Eroe';

/// The player's character: identity, look and progression.
///
/// Immutable. [copyWith] uses `??`, so it can change a nullable field but
/// never reset it back to null.
class GameHero {
  const GameHero({
    required this.id,
    required this.avatarMode,
    required this.accent,
    required this.level,
    required this.exp,
    required this.rewardPoints,
    required this.theme,
    this.userId,
    this.name,
    this.avatarIcon,
    this.heroClass,
  });

  final String id;
  final String? userId;
  final String? name;
  final AvatarMode avatarMode;
  final String? avatarIcon;
  final AccentKey accent;
  final HeroClass? heroClass;
  final int level;
  final int exp;
  final int rewardPoints;
  final ThemeKey theme;

  /// The name to show, falling back to "Eroe" when missing or blank.
  String get displayName {
    final trimmed = name?.trim() ?? '';
    return trimmed.isEmpty ? _defaultHeroName : trimmed;
  }

  GameHero copyWith({
    String? id,
    String? userId,
    String? name,
    AvatarMode? avatarMode,
    String? avatarIcon,
    AccentKey? accent,
    HeroClass? heroClass,
    int? level,
    int? exp,
    int? rewardPoints,
    ThemeKey? theme,
  }) => GameHero(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    avatarMode: avatarMode ?? this.avatarMode,
    avatarIcon: avatarIcon ?? this.avatarIcon,
    accent: accent ?? this.accent,
    heroClass: heroClass ?? this.heroClass,
    level: level ?? this.level,
    exp: exp ?? this.exp,
    rewardPoints: rewardPoints ?? this.rewardPoints,
    theme: theme ?? this.theme,
  );

  @override
  bool operator ==(Object other) =>
      other is GameHero &&
      other.id == id &&
      other.userId == userId &&
      other.name == name &&
      other.avatarMode == avatarMode &&
      other.avatarIcon == avatarIcon &&
      other.accent == accent &&
      other.heroClass == heroClass &&
      other.level == level &&
      other.exp == exp &&
      other.rewardPoints == rewardPoints &&
      other.theme == theme;

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    avatarMode,
    avatarIcon,
    accent,
    heroClass,
    level,
    exp,
    rewardPoints,
    theme,
  );
}
