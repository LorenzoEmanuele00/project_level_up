import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Outline of [rrect] cut into dashes of length [dash] separated by [gap].
Path dashedPath(RRect rrect, {required double dash, required double gap}) {
  final result = Path();
  final outline = Path()..addRRect(rrect);
  for (final metric in outline.computeMetrics()) {
    for (var start = 0.0; start < metric.length; start += dash + gap) {
      final end = math.min(start + dash, metric.length);
      result.addPath(metric.extractPath(start, end), Offset.zero);
    }
  }
  return result;
}

/// Paints a dashed rounded rectangle along the edge of its box. The stroke is
/// drawn inside the box, so it never gets cut at the edges.
class DashedRRectPainter extends CustomPainter {
  const DashedRRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawPath(
      dashedPath(rrect, dash: dash, gap: gap),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(DashedRRectPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth ||
      old.dash != dash ||
      old.gap != gap;
}
