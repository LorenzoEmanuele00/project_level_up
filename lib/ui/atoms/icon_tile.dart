import 'package:flutter/widgets.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/ui/atoms/app_icon.dart';

const _paddingRatio = 0.23;
const _radiusRatio = 0.29;

/// Rounded square with the hue tint as background and the icon in the hue ink.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {required this.size, required this.hue, super.key});

  final String icon;
  final double size;
  final HabitHue hue;

  @override
  Widget build(BuildContext context) {
    final tone = context.colors.hue(hue);
    final padding = size * _paddingRatio;
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tone.tint,
          borderRadius: BorderRadius.circular(size * _radiusRatio),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: AppIcon(icon, size: size - 2 * padding, color: tone.ink),
        ),
      ),
    );
  }
}
