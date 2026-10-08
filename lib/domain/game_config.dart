/// Tunable constants of the game rules.
class GameConfig {
  const GameConfig({this.expPerLevel = 100, this.rpPerLevel = 5})
    : assert(expPerLevel > 0, 'expPerLevel must be positive'),
      assert(
        rpPerLevel >= minRpPerLevel && rpPerLevel <= maxRpPerLevel,
        'rpPerLevel must be between 3 and 10',
      );

  /// The configuration the app ships with.
  static const standard = GameConfig();

  static const minRpPerLevel = 3;
  static const maxRpPerLevel = 10;

  /// EXP needed to go up one level.
  final int expPerLevel;

  /// Reward points granted at every level up.
  final int rpPerLevel;
}
