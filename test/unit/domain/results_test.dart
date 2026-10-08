import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/results.dart';

void main() {
  group('result types', () {
    test('CompletionResult switches exhaustively', () {
      final CompletionResult result = const AlreadyDoneToday();

      final label = switch (result) {
        Completed() => 'completed',
        AlreadyDoneToday() => 'already',
        HabitArchived() => 'archived',
      };

      expect(label, 'already');
    });

    test('CompletionFeedback switches exhaustively', () {
      const CompletionFeedback feedback = LevelledUp(
        levelsGained: 1,
        rpGained: 5,
        newLevel: 2,
      );

      final label = switch (feedback) {
        ExpGained() => 'exp',
        LevelledUp(:final newLevel) => 'level $newLevel',
      };

      expect(label, 'level 2');
    });

    test('RedeemResult switches exhaustively', () {
      final RedeemResult result = const InsufficientPoints(missing: 4);

      final label = switch (result) {
        Redeemed() => 'ok',
        InsufficientPoints(:final missing) => 'missing $missing',
      };

      expect(label, 'missing 4');
    });
  });
}
