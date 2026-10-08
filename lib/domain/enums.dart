/// The five selectable accent palettes. Stored as a string (never as a
/// colour); the theme resolves it to a concrete colour.
enum AccentKey { terra, ambra, salvia, ardesia, rosa }

/// Colour family of a habit. `red` follows the user's accent, the others are
/// fixed. Stored as a key; the theme resolves it to a tint/ink pair.
enum HabitHue { red, blue, teal, green, gold }

/// Medal levels, from lowest to highest.
enum MedalTier { bronzo, argento, oro }

/// Reward rarity. The cost in reward points is defined by the game rules.
enum RewardTier { piccola, media, grande }
