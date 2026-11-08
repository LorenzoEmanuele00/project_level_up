import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/atoms/progress_semantics.dart';

const _strokeRatio = .05;
const _startAngle = -math.pi / 2;

/// Circular progress (0 to 1) drawn clockwise from 12 o clock, with an
/// optional [child] centred inside.
///
/// With a [semanticLabel] the ring is announced as that label plus its rounded
/// percentage and its [child] is excluded from semantics (it usually shows the
/// same number). Without it the ring adds nothing and the [child] keeps its
/// own semantics.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.value,
    required this.size,
    this.strokeWidth,
    this.color,
    this.trackColor,
    this.child,
    this.semanticLabel,
    super.key,
  });

  /// Progress from 0 to 1. Out of range values are clamped, NaN counts as 0.
  final double value;

  /// Outer diameter.
  final double size;

  /// Defaults to 5% of [size].
  final double? strokeWidth;

  /// Arc colour. Defaults to the accent.
  final Color? color;

  /// Track colour. Defaults to the line token.
  final Color? trackColor;
  final Widget? child;

  /// What the ring measures, for accessibility. Null keeps the ring silent.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final clamped = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);
    return progressSemantics(
      context,
      value: clamped,
      label: semanticLabel,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _RingPainter(
            value: clamped,
            strokeWidth: strokeWidth ?? size * _strokeRatio,
            color: color ?? colors.accent,
            trackColor: trackColor ?? colors.line,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  final double value;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawCircle(
      rect.center,
      rect.shortestSide / 2,
      paint..color = trackColor,
    );
    if (value <= 0) return;
    canvas.drawArc(
      rect,
      _startAngle,
      2 * math.pi * value,
      false,
      paint..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.strokeWidth != strokeWidth ||
      old.color != color ||
      old.trackColor != trackColor;
}
