import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/atoms/app_icon.dart';
import 'package:levelup/ui/atoms/progress_ring.dart';
import 'package:levelup/ui/motion/pressable.dart';

const _size = 46.0;
const _ringWidth = 3.0;
const _discBorderWidth = 3.0;
const _iconRatio = .56;
const _gradientAngle = 155 * math.pi / 180;
const _fallbackInitial = 'E';

/// What the avatar disc shows: the user's initial or a picked icon.
enum AvatarMode { initial, icon }

/// Round profile picture (small, 46 px): gradient disc with the initial or an
/// icon, and an optional EXP ring around it. Taps are optional.
class Avatar extends StatelessWidget {
  const Avatar({
    required this.name,
    this.mode = AvatarMode.initial,
    this.icon,
    this.expProgress,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final String name;
  final AvatarMode mode;

  /// Icon key for [AvatarMode.icon]; without it the initial is shown.
  final String? icon;

  /// Progress (0 to 1) of the ring around the disc. No ring when null.
  final double? expProgress;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disc = _Disc(content: _content(colors.onAccent));
    final progress = expProgress;
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: progress == null
          ? SizedBox.square(
              dimension: _size,
              child: Center(child: disc),
            )
          : ProgressRing(
              value: progress,
              size: _size,
              strokeWidth: _ringWidth,
              color: colors.accent,
              trackColor: colors.elev,
              child: disc,
            ),
    );
  }

  Widget _content(Color color) {
    final iconKey = icon;
    if (mode == AvatarMode.icon && iconKey != null) {
      return AppIcon(iconKey, size: _discSide * _iconRatio, color: color);
    }
    return Text(_initial(name), style: AppText.label.copyWith(color: color));
  }
}

const _discSide = _size - 2 * _ringWidth;

String _initial(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return _fallbackInitial;
  return trimmed.characters.first.toUpperCase();
}

class _Disc extends StatelessWidget {
  const _Disc({required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: _discSide,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment(
              -math.sin(_gradientAngle),
              math.cos(_gradientAngle),
            ),
            end: Alignment(math.sin(_gradientAngle), -math.cos(_gradientAngle)),
            colors: [colors.accent, colors.accentDeep],
          ),
          border: Border.all(color: colors.surface, width: _discBorderWidth),
        ),
        child: Center(child: content),
      ),
    );
  }
}
