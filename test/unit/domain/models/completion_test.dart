import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/models.dart';

Completion makeCompletion() =>
    Completion(id: 'c1', habitId: 'b1', at: DateTime(2026, 5, 10, 8), exp: 20);

void main() {
  group('Completion', () {
    test('copyWith replaces every field', () {
      final copy = makeCompletion().copyWith(
        id: 'c2',
        habitId: 'b2',
        at: DateTime(2026, 5, 11),
        exp: 40,
      );

      expect(
        copy,
        Completion(id: 'c2', habitId: 'b2', at: DateTime(2026, 5, 11), exp: 40),
      );
    });

    test('has value equality and a matching hashCode', () {
      expect(makeCompletion(), makeCompletion());
      expect(makeCompletion().hashCode, makeCompletion().hashCode);
    });

    test('differs when any single field differs', () {
      final completion = makeCompletion();
      final variants = <Completion>[
        completion.copyWith(id: 'x'),
        completion.copyWith(habitId: 'x'),
        completion.copyWith(at: DateTime(2026, 1, 1)),
        completion.copyWith(exp: 1),
      ];

      for (final variant in variants) {
        expect(variant, isNot(completion));
      }
    });
  });
}
