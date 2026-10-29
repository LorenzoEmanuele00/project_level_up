import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:levelup/domain/models/habit.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/app_icon.dart';
import 'package:levelup/ui/atoms/habit_check.dart';
import 'package:levelup/ui/atoms/icon_tile.dart';
import 'package:levelup/ui/l10n/l10n.dart';
import 'package:levelup/ui/motion/pressable.dart';

const _padding = 15.0;
const _minHeight = 134.0;
const _iconSize = 44.0;
const _nameLines = 2;
const _nameHeight = 1.2;
const _flameSize = 12.0;
const _flameIcon = 'flame';
const _streakOpacity = .7;
const _doneOpacity = .72;
const _iconNameGap = Spacing.sm;
const _nameInfoGap = 3.0;
const _infoSpacing = Spacing.sm;
const _flameGap = 3.0;

/// The check sits so that its 34 px circle is [_padding] from the corner.
const _checkOffset = _padding - (AppSizes.minTapTarget - 34) / 2;

/// Habit card of the Home grid: icon, name, EXP reward and streak on the hue
/// tint, with the completion check in the top right corner.
///
/// Tapping the card calls [onOpen]; tapping the check calls [onComplete] only.
/// The check is a sibling of the card press target (not inside it) so that
/// pressing the check does not also shrink the card. A done habit fades and
/// its check is inert.
///
/// The card gets no explicit semantic label: the name, EXP and streak texts
/// merge into the button node, so the name is read once.
class HabitTile extends StatelessWidget {
  const HabitTile({
    required this.habit,
    required this.done,
    this.onComplete,
    this.onOpen,
    super.key,
  });

  final Habit habit;
  final bool done;
  final VoidCallback? onComplete;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AnimatedOpacity(
      opacity: done ? _doneOpacity : 1,
      duration: Motion.outShort,
      child: Stack(
        children: [
          Pressable(
            onTap: onOpen,
            child: _TileBody(habit: habit),
          ),
          Positioned(
            top: _checkOffset,
            right: _checkOffset,
            child: HabitCheck(
              hue: habit.hue,
              done: done,
              onTap: onComplete,
              semanticLabel: done
                  ? l10n.habitCheckDone(habit.name)
                  : l10n.habitCheckComplete(habit.name),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileBody extends StatelessWidget {
  const _TileBody({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = colors.hue(habit.hue);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tone.tint,
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          // IntrinsicHeight: the column is as tall as its content, or the
          // minimum height, and spreads icon and info over that height.
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconTile(
                  habit.icon,
                  size: _iconSize,
                  hue: habit.hue,
                  background: colors.onTintFill,
                ),
                const SizedBox(height: _iconNameGap),
                Text(
                  habit.name,
                  maxLines: _nameLines,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(
                    color: tone.ink,
                    height: _nameHeight,
                  ),
                ),
                const SizedBox(height: _nameInfoGap),
                _Info(habit: habit, ink: tone.ink),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.habit, required this.ink});

  final Habit habit;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Wrap(
      spacing: _infoSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          context.l10n.habitExpGain(habit.exp),
          style: AppText.tag.copyWith(color: ink),
        ),
        Opacity(
          opacity: _streakOpacity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(_flameIcon, size: _flameSize, color: ink),
              const SizedBox(width: _flameGap),
              Text(
                NumberFormat.decimalPattern(locale).format(habit.streak),
                style: AppText.small.copyWith(color: ink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
