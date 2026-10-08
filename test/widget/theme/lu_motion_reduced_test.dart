import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/lu_tokens.dart';

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
  group('LuMotion reduced animations', () {
    testWidgets('reduced is true when the platform disables animations', (
      tester,
    ) async {
      final context = await _pumpWithMedia(tester, disableAnimations: true);

      expect(LuMotion.reduced(context), isTrue);
    });

    testWidgets('reduced is false by default', (tester) async {
      final context = await _pumpWithMedia(tester, disableAnimations: false);

      expect(LuMotion.reduced(context), isFalse);
    });

    testWidgets('duration keeps the requested value when not reduced', (
      tester,
    ) async {
      final context = await _pumpWithMedia(tester, disableAnimations: false);

      expect(LuMotion.duration(context, LuMotion.popLong), LuMotion.popLong);
    });

    testWidgets('duration falls back to a 150 ms fade when reduced', (
      tester,
    ) async {
      final context = await _pumpWithMedia(tester, disableAnimations: true);

      expect(
        LuMotion.duration(context, LuMotion.popLong),
        const Duration(milliseconds: 150),
      );
      expect(LuMotion.reducedFade, const Duration(milliseconds: 150));
    });
  });
}
