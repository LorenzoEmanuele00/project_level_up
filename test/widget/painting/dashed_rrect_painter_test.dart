import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/ui/painting/dashed_rrect_painter.dart';

const _rrect = RRect.fromLTRBXY(0, 0, 200, 100, 22, 22);

DashedRRectPainter _painter({
  Color color = const Color(0xFF112233),
  double radius = 22,
  double strokeWidth = 1,
  double dash = 6,
  double gap = 4,
}) => DashedRRectPainter(
  color: color,
  radius: radius,
  strokeWidth: strokeWidth,
  dash: dash,
  gap: gap,
);

double _length(Path path) =>
    path.computeMetrics().fold(0.0, (sum, m) => sum + m.length);

void main() {
  group('dashedPath', () {
    test('splits the outline into dashes no longer than dash', () {
      final path = dashedPath(_rrect, dash: 6, gap: 4);

      final lengths = path.computeMetrics().map((m) => m.length).toList();

      expect(lengths.length, greaterThan(40));
      for (final length in lengths) {
        expect(length, lessThanOrEqualTo(6 * 1.05));
      }
    });

    test('covers dash over dash plus gap of the perimeter', () {
      final outline = Path()..addRRect(_rrect);
      final perimeter = _length(outline);

      final covered = _length(dashedPath(_rrect, dash: 6, gap: 4));

      expect(covered / perimeter, closeTo(.6, .02));
    });

    test('a degenerate rect gives an empty path without throwing', () {
      final path = dashedPath(RRect.zero, dash: 6, gap: 4);

      expect(_length(path), 0);
    });
  });

  group('DashedRRectPainter', () {
    test('repaints when colour, radius, width, dash or gap change', () {
      final base = _painter();

      expect(base.shouldRepaint(_painter()), isFalse);
      expect(base.shouldRepaint(_painter(color: Colors.red)), isTrue);
      expect(base.shouldRepaint(_painter(radius: 10)), isTrue);
      expect(base.shouldRepaint(_painter(strokeWidth: 2)), isTrue);
      expect(base.shouldRepaint(_painter(dash: 8)), isTrue);
      expect(base.shouldRepaint(_painter(gap: 6)), isTrue);
    });

    testWidgets('strokes one path in the given colour and width', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CustomPaint(
            key: const Key('dashed'),
            size: const Size(200, 100),
            painter: _painter(),
          ),
        ),
      );

      expect(
        tester.renderObject(find.byKey(const Key('dashed'))),
        paints..path(
          color: const Color(0xFF112233),
          strokeWidth: 1,
          style: PaintingStyle.stroke,
        ),
      );
    });
  });
}
