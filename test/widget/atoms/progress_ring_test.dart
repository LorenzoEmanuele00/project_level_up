import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/atoms/progress_ring.dart';

import '../../helpers/widget_host.dart';

Widget _ring({
  double value = .5,
  double size = 100,
  double? strokeWidth,
  Color? color,
  Color? trackColor,
  Widget? child,
  Brightness brightness = Brightness.light,
}) => widgetHost(
  ProgressRing(
    value: value,
    size: size,
    strokeWidth: strokeWidth,
    color: color,
    trackColor: trackColor,
    child: child,
  ),
  brightness: brightness,
);

Finder get _paint => find.descendant(
  of: find.byType(ProgressRing),
  matching: find.byType(CustomPaint),
);

CustomPainter _painter(WidgetTester tester) =>
    tester.widget<CustomPaint>(_paint).painter!;

void main() {
  group('ProgressRing arc', () {
    testWidgets('starts at 12 o clock and sweeps clockwise by value', (
      tester,
    ) async {
      await tester.pumpWidget(_ring(value: .25));

      expect(
        _paint,
        paints..arc(startAngle: -math.pi / 2, sweepAngle: math.pi / 2),
      );
    });

    testWidgets('clamps values above 1 to a full turn', (tester) async {
      await tester.pumpWidget(_ring(value: 3));

      expect(_paint, paints..arc(sweepAngle: 2 * math.pi));
    });

    testWidgets('treats negative and NaN values as empty', (tester) async {
      await tester.pumpWidget(_ring(value: -1));
      expect(_paint, isNot(paints..arc()));

      await tester.pumpWidget(_ring(value: double.nan));
      expect(_paint, isNot(paints..arc()));
      expect(tester.takeException(), isNull);
    });

    testWidgets('value 0 draws only the track', (tester) async {
      await tester.pumpWidget(_ring(value: 0));

      expect(_paint, paints..circle());
      expect(_paint, isNot(paints..arc()));
    });

    testWidgets('value 1 draws track and a complete arc without errors', (
      tester,
    ) async {
      await tester.pumpWidget(_ring(value: 1));

      expect(
        _paint,
        paints
          ..circle()
          ..arc(sweepAngle: 2 * math.pi),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('ProgressRing stroke', () {
    testWidgets('defaults to 5% of the diameter with butt caps', (
      tester,
    ) async {
      await tester.pumpWidget(_ring(size: 120));

      expect(
        _paint,
        paints
          ..circle(strokeWidth: 6)
          ..arc(strokeWidth: 6, strokeCap: StrokeCap.butt),
      );
    });

    testWidgets('can be overridden', (tester) async {
      await tester.pumpWidget(_ring(strokeWidth: 3));

      expect(
        _paint,
        paints
          ..circle(strokeWidth: 3)
          ..arc(strokeWidth: 3),
      );
    });

    testWidgets('keeps the stroke inside the given size', (tester) async {
      await tester.pumpWidget(_ring(size: 100, strokeWidth: 10));

      expect(tester.getSize(find.byType(ProgressRing)), const Size(100, 100));
      expect(_paint, paints..circle(x: 50, y: 50, radius: 45));
    });
  });

  group('ProgressRing colours', () {
    testWidgets('use the line track and the accent arc by default', (
      tester,
    ) async {
      await tester.pumpWidget(_ring());
      final colors = tester.element(find.byType(ProgressRing)).colors;

      expect(
        _paint,
        paints
          ..circle(color: colors.line)
          ..arc(color: colors.accent),
      );
    });

    testWidgets('can be overridden', (tester) async {
      const arc = Color(0xFF111111);
      const track = Color(0xFF222222);
      await tester.pumpWidget(_ring(color: arc, trackColor: track));

      expect(
        _paint,
        paints
          ..circle(color: track)
          ..arc(color: arc),
      );
    });

    testWidgets('follow the dark theme', (tester) async {
      await tester.pumpWidget(_ring(brightness: Brightness.dark));
      final colors = tester.element(find.byType(ProgressRing)).colors;

      expect(
        _paint,
        paints
          ..circle(color: colors.line)
          ..arc(color: colors.accent),
      );
    });
  });

  group('ProgressRing content', () {
    testWidgets('centres the child in the ring', (tester) async {
      await tester.pumpWidget(
        _ring(child: const SizedBox(key: Key('inner'), width: 20, height: 20)),
      );

      expect(
        tester.getCenter(find.byKey(const Key('inner'))),
        tester.getCenter(find.byType(ProgressRing)),
      );
    });

    testWidgets('works without a child', (tester) async {
      await tester.pumpWidget(_ring());

      expect(tester.takeException(), isNull);
    });
  });

  group('ProgressRing repaint', () {
    Future<CustomPainter> painterFor(
      WidgetTester tester, {
      double value = .5,
      Color? color,
      double? strokeWidth,
    }) async {
      await tester.pumpWidget(
        _ring(value: value, color: color, strokeWidth: strokeWidth),
      );
      return _painter(tester);
    }

    testWidgets('repaints when value, colour or stroke change', (tester) async {
      final base = await painterFor(tester);
      final otherValue = await painterFor(tester, value: .7);
      final otherColor = await painterFor(tester, color: Colors.red);
      final otherStroke = await painterFor(tester, strokeWidth: 9);

      expect(otherValue.shouldRepaint(base), isTrue);
      expect(otherColor.shouldRepaint(base), isTrue);
      expect(otherStroke.shouldRepaint(base), isTrue);
    });

    testWidgets('does not repaint when nothing changed', (tester) async {
      final first = await painterFor(tester);
      final second = await painterFor(tester);

      expect(second.shouldRepaint(first), isFalse);
    });
  });

  group('ProgressRing semantics', () {
    testWidgets('with a label exposes it and the percentage, not the child', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(
          const ProgressRing(
            value: .5,
            size: 100,
            semanticLabel: 'Livello',
            child: Text('50'),
          ),
        ),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Livello'));

      expect(node.label, 'Livello');
      expect(node.value, '50%');
      expect(find.bySemanticsLabel('50'), findsNothing);
      handle.dispose();
    });

    testWidgets('without a label it leaves the child announced as is', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        widgetHost(const ProgressRing(value: .5, size: 100, child: Text('50'))),
      );

      final node = tester.getSemantics(find.text('50'));

      expect(node.label, '50');
      expect(node.value, isEmpty);
      handle.dispose();
    });
  });
}
