/// The five selectable accent palettes. Stored as a string (never as a
/// colour); the theme resolves it to a concrete colour.
enum AccentKey { terracotta, amber, sage, slate, rose }

/// Colour family of a habit. `red` follows the user's accent, the others are
/// fixed. Stored as a key; the theme resolves it to a tint/ink pair.
enum HabitHue { red, blue, teal, green, gold }

/// Medal levels, from lowest to highest.
enum MedalTier { bronze, silver, gold }

/// Reward rarity, with its fixed price in reward points.
enum RewardTier {
  small(10),
  medium(25),
  large(60);

  const RewardTier(this.cost);

  /// Reward points needed to redeem a reward of this tier.
  final int cost;
}

/// Habit difficulty. Fixes the EXP earned at each completion.
enum Difficulty {
  easy(10),
  medium(20),
  hard(40);

  const Difficulty(this.exp);

  /// EXP earned for one completion.
  final int exp;
}

/// How often a habit is due: every day or a number of days per week.
enum Frequency {
  daily(7),
  x5(5),
  x3(3),
  x2(2);

  const Frequency(this.weeklyQuota);

  /// Completions expected in a full week.
  final int weeklyQuota;
}

/// Optional hero archetype chosen at onboarding.
enum HeroClass { warrior, scholar, monk, creator, explorer }

/// What the avatar shows: the name initial or a chosen icon.
enum AvatarMode { initial, icon }

/// Light or dark appearance, as stored on the hero.
enum ThemeKey { light, dark }
