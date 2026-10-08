import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/tokens.dart';

Future<BuildContext> _pumpWithMedia(
  WidgetTester tester, {
  required bool disableAnimations,
}) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Builder(
        builder: (context) {
          captured = context;
          return const SizedBox();
        },
      ),
    ),
  );
  return captured;
}

void main() {
  group('Motion reduced animations', () {
    testWidgets('reduced is true when the platform disables animations', (
      tester,
    ) async {
      final context = await _pumpWithMedia(tester, disableAnimations: true);

      expect(Motion.reduced(context), isTrue);
    });

    testWidgets('reduced is false by default', (tester) async {
      final context = await _pumpWithMedia(tester, disableAnimations: false);

      expect(Motion.reduced(context), isFalse);
    });

    testWidgets('duration keeps the requested value when not reduced', (
      tester,
    ) async {
      final context = await _pumpWithMedia(tester, disableAnimations: false);

      expect(Motion.duration(context, Motion.popLong), Motion.popLong);
    });

    testWidgets('duration falls back to a 150 ms fade when reduced', (
      tester,
    ) async {
      final context = await _pumpWithMedia(tester, disableAnimations: true);

      expect(
        Motion.duration(context, Motion.popLong),
        const Duration(milliseconds: 150),
      );
      expect(Motion.reducedFade, const Duration(milliseconds: 150));
    });
  });
}
