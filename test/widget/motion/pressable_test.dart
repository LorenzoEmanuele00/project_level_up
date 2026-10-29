import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/motion/pressable.dart';

import '../../helpers/widget_host.dart';

const _box = SizedBox(key: Key('box'), width: 80, height: 80);

AnimatedScale _animatedScale(WidgetTester tester) => tester.widget(
  find.descendant(
    of: find.byType(Pressable),
    matching: find.byType(AnimatedScale),
  ),
);

double _scale(WidgetTester tester) => _animatedScale(tester).scale;

Future<TestGesture> _press(WidgetTester tester) async {
  final gesture = await tester.startGesture(
    tester.getCenter(find.byKey(const Key('box'))),
  );
  await tester.pump();
  return gesture;
}

void main() {
  group('Pressable', () {
    testWidgets('tap calls onTap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        widgetHost(Pressable(onTap: () => taps++, child: _box)),
      );

      await tester.tap(find.byType(Pressable));

      expect(taps, 1);
    });

    testWidgets('large scale shrinks to .965 while pressed and returns to 1', (
      tester,
    ) async {
      await tester.pumpWidget(widgetHost(Pressable(onTap: () {}, child: _box)));
      expect(_scale(tester), 1);

      final gesture = await _press(tester);
      expect(_scale(tester), Motion.pressScaleLarge);

      await gesture.up();
      await tester.pump();
      expect(_scale(tester), 1);
    });

    testWidgets('small scale shrinks to .88 while pressed', (tester) async {
      await tester.pumpWidget(
        widgetHost(
          Pressable(onTap: () {}, scale: PressScale.small, child: _box),
        ),
      );

      final gesture = await _press(tester);

      expect(_scale(tester), Motion.pressScaleSmall);
      await gesture.up();
    });

    testWidgets('scale animates over the spring duration with spring curve', (
      tester,
    ) async {
      await tester.pumpWidget(widgetHost(Pressable(onTap: () {}, child: _box)));

      final animated = _animatedScale(tester);

      expect(animated.duration, Motion.springShort);
      expect(animated.curve, Motion.spring);
    });

    testWidgets('cancelling the press returns the scale to 1', (tester) async {
      await tester.pumpWidget(widgetHost(Pressable(onTap: () {}, child: _box)));

      final gesture = await _press(tester);
      await gesture.moveBy(const Offset(0, 300));
      await gesture.up();
      await tester.pump();

      expect(_scale(tester), 1);
    });

    testWidgets('without onTap there is no scale', (tester) async {
      await tester.pumpWidget(widgetHost(const Pressable(child: _box)));

      final gesture = await _press(tester);

      expect(_scale(tester), 1);
      await gesture.up();
    });

    testWidgets('reduced motion: no scale but the tap still works', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        widgetHost(
          Pressable(onTap: () => taps++, child: _box),
          disableAnimations: true,
        ),
      );

      final gesture = await _press(tester);
      expect(_scale(tester), 1);
      await gesture.up();

      expect(taps, 1);
    });

    testWidgets('exposes a button with the label and enabled state', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(
          Pressable(onTap: () {}, semanticLabel: 'Complete', child: _box),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Complete')),
        matchesSemantics(
          label: 'Complete',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('without onTap the button is disabled for accessibility', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(const Pressable(semanticLabel: 'Done', child: _box)),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Done')),
        matchesSemantics(
          label: 'Done',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      handle.dispose();
    });
  });
}
