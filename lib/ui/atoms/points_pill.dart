import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/app_icon.dart';
import 'package:levelup/ui/motion/pressable.dart';

const _radius = 14.0;
const _verticalPadding = 9.0;
const _horizontalPadding = 14.0;
const _gap = 7.0;
const _gemSize = 18.0;
const _gemIcon = 'gem';

/// Reward points balance: gem and value in gold on an elevated pill. The pill
/// is at least 44 px tall to be tappable; without [onTap] it is inert.
class PointsPill extends StatelessWidget {
  const PointsPill({
    required this.value,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final int value;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toString();
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.elev,
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: _verticalPadding,
                horizontal: _horizontalPadding,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(_gemIcon, size: _gemSize, color: colors.gold),
                  const SizedBox(width: _gap),
                  Flexible(
                    child: Text(
                      NumberFormat.decimalPattern(locale).format(value),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.emphasis.copyWith(color: colors.gold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
