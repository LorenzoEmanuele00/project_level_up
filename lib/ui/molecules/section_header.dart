import 'package:flutter/widgets.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/motion/pressable.dart';

/// Largest share of the row the action may take before it shrinks.
const _actionMaxShare = .5;

/// Title size: [lg] for screen sections, [md] for sheets and sub sections.
enum SectionSize {
  lg(AppText.section),
  md(AppText.sheetTitle);

  const SectionSize(this.style);

  final TextStyle style;
}

/// Heading of a section with an optional action on the right ("see all").
/// The action is shown only with [actionLabel]; without [onAction] it is
/// inert. A long title takes one line and is cut with an ellipsis; a long
/// action shrinks to fit at most half of the row (keeping its 44 px tap area).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.size = SectionSize.lg,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final SectionSize size;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final actionLabel = this.actionLabel;
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: size.style.copyWith(color: colors.onCanvas),
              ),
            ),
          ),
          if (actionLabel != null)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * _actionMaxShare,
              ),
              child: Pressable(
                onTap: onAction,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: AppSizes.minTapTarget,
                    minHeight: AppSizes.minTapTarget,
                  ),
                  child: Center(
                    widthFactor: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        actionLabel,
                        maxLines: 1,
                        style: AppText.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.onCanvas2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
