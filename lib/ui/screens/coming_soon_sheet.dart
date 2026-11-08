import 'package:flutter/material.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/app_icon.dart';
import 'package:levelup/ui/l10n/l10n.dart';
import 'package:levelup/ui/motion/pressable.dart';

const _closeIcon = 'chevron-down';
const _closeIconSize = 24.0;
const _bodyGap = Spacing.sm;

/// Full-height placeholder of a section that is not built yet (profile,
/// rewards, mission, all habits): a header with the close chevron and the
/// "coming soon" message. Removed route by route as the real sheets arrive.
///
/// [section] gives the localized name of the section shown in the header.
class ComingSoonSheet extends StatelessWidget {
  const ComingSoonSheet({
    required this.section,
    required this.onClose,
    super.key,
  });

  final String Function(BuildContext context) section;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.lg,
                vertical: Spacing.sm,
              ),
              child: Row(
                children: [
                  Pressable(
                    onTap: onClose,
                    semanticLabel: l10n.comingSoonClose,
                    child: SizedBox.square(
                      dimension: AppSizes.minTapTarget,
                      child: Center(
                        child: AppIcon(
                          _closeIcon,
                          size: _closeIconSize,
                          color: colors.onCanvas,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      section(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sheetTitle.copyWith(
                        color: colors.onCanvas,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.x2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.comingSoonTitle,
                        textAlign: TextAlign.center,
                        style: AppText.title.copyWith(color: colors.onCanvas),
                      ),
                      const SizedBox(height: _bodyGap),
                      Text(
                        l10n.comingSoonBody,
                        textAlign: TextAlign.center,
                        style: AppText.body.copyWith(color: colors.onCanvas2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
