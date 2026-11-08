import 'package:flutter/widgets.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/app_icon.dart';
import 'package:levelup/ui/motion/pressable.dart';

const _diameter = 34.0;
const _borderWidth = 2.0;
const _tickSize = 18.0;
const _tickIcon = 'check';

/// Round check of a habit: 34 px drawn inside a 44 px touch area.
///
/// Todo is a light fill with a line border and a tick in the hue ink; done is
/// filled with the hue ink and has a white tick. A done check, or one without
/// [onTap], is inert; it also reports a checked state to accessibility.
class HabitCheck extends StatelessWidget {
  const HabitCheck({
    required this.hue,
    required this.done,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final HabitHue hue;
  final bool done;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ink = colors.hue(hue).ink;
    return Pressable(
      onTap: done ? null : onTap,
      scale: PressScale.small,
      semanticLabel: semanticLabel,
      checked: done,
      child: SizedBox.square(
        dimension: AppSizes.minTapTarget,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? ink : colors.onTintFill,
              border: Border.all(
                color: done ? ink : colors.line,
                width: _borderWidth,
              ),
            ),
            child: SizedBox.square(
              dimension: _diameter,
              child: Center(
                child: AppIcon(
                  _tickIcon,
                  size: _tickSize,
                  color: done ? colors.onAccent : ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
