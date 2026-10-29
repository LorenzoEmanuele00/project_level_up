import 'package:flutter/widgets.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/painting/dashed_rrect_painter.dart';

const _verticalPadding = 30.0;
const _horizontalPadding = 16.0;
const _subtitleGap = 4.0;
const _leadingGap = Spacing.sm;
const _borderWidth = 1.0;
const _dashLength = 6.0;
const _dashGap = 4.0;

/// Placeholder for an empty list: surface card with a dashed border, a
/// centred [title], an optional [subtitle] and an optional [leading] widget
/// (icon, illustration) above them.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.subtitle,
    this.leading,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = this.subtitle;
    final leading = this.leading;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: CustomPaint(
        foregroundPainter: DashedRRectPainter(
          color: colors.line,
          radius: AppRadius.tile,
          strokeWidth: _borderWidth,
          dash: _dashLength,
          gap: _dashGap,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: _verticalPadding,
            horizontal: _horizontalPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leading != null) ...[
                Center(child: leading),
                const SizedBox(height: _leadingGap),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppText.emphasis.copyWith(color: colors.text),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: _subtitleGap),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppText.caption.copyWith(color: colors.text2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
