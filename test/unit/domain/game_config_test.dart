import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/game_config.dart';

void main() {
  group('GameConfig', () {
    test('standard uses 100 exp per level and 5 rp per level', () {
      expect(GameConfig.standard.expPerLevel, 100);
      expect(GameConfig.standard.rpPerLevel, 5);
    });

    test('defaults to the standard values', () {
      const config = GameConfig();

      expect(config.expPerLevel, 100);
      expect(config.rpPerLevel, 5);
    });

    test('accepts rpPerLevel at both ends of the 3 to 10 range', () {
      expect(const GameConfig(rpPerLevel: 3).rpPerLevel, 3);
      expect(const GameConfig(rpPerLevel: 10).rpPerLevel, 10);
    });

    test('rejects rpPerLevel outside the 3 to 10 range', () {
      final tooLow = 2;
      final tooHigh = 11;

      expect(
        () => GameConfig(rpPerLevel: tooLow),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => GameConfig(rpPerLevel: tooHigh),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects a non positive expPerLevel', () {
      final zero = 0;

      expect(
        () => GameConfig(expPerLevel: zero),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
