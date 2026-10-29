import 'package:flutter/widgets.dart';
import 'package:levelup/theme/theme.dart';
import 'package:levelup/theme/tokens.dart';
import 'package:levelup/ui/atoms/progress_semantics.dart';

const _questHeight = 10.0;
const _expHeight = 8.0;
const _expRadius = 5.0;

enum _BarKind { quest, exp }

/// Horizontal progress bar (0 to 1) that animates value changes.
///
/// [ProgressBar.quest] is the thick bar of a quest (elev track, flat accent
/// fill); [ProgressBar.exp] is the thin EXP bar (line track, accent to accent2
/// gradient).
///
/// With a [semanticLabel] the bar is announced as that label plus its rounded
/// percentage; without it the bar is silent, so a caller that already
/// announces the value is not duplicated.
class ProgressBar extends StatelessWidget {
  const ProgressBar.quest({required this.value, this.semanticLabel, super.key})
    : _kind = _BarKind.quest;

  const ProgressBar.exp({required this.value, this.semanticLabel, super.key})
    : _kind = _BarKind.exp;

  /// Progress from 0 to 1. Out of range values are clamped, NaN counts as 0.
  final double value;

  /// What the bar measures, for accessibility. Null keeps the bar silent.
  final String? semanticLabel;
  final _BarKind _kind;

  double get _clamped => value.isNaN ? 0 : value.clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isQuest = _kind == _BarKind.quest;
    final radius = BorderRadius.circular(isQuest ? AppRadius.bar : _expRadius);
    return progressSemantics(
      context,
      value: _clamped,
      label: semanticLabel,
      child: SizedBox(
        height: isQuest ? _questHeight : _expHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isQuest ? colors.elev : colors.line,
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: _clamped),
              duration: Motion.duration(context, Motion.outLong),
              curve: Motion.out,
              builder: (context, factor, _) => Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: factor,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      color: isQuest ? colors.accent : null,
                      gradient: isQuest
                          ? null
                          : LinearGradient(
                              colors: [colors.accent, colors.accent2],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
