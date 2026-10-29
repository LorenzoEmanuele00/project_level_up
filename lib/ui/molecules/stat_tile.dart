import 'package:flutter/widgets.dart';
import 'package:levelup/theme/palettes.dart';
import 'package:levelup/theme/text.dart';
import 'package:levelup/theme/tokens.dart';

const _verticalPadding = 11.0;
const _horizontalPadding = 8.0;
const _valueGap = 3.0;

/// Pastel tile with a small upper-case [label] over a big [value] and an
/// optional "/[total]" in the label colour. Colours are the same in both
/// themes. Text shrinks to fit on one line.
class StatTile extends StatelessWidget {
  const StatTile({
    required this.kind,
    required this.label,
    required this.value,
    this.total,
    super.key,
  });

  final StatKind kind;
  final String label;
  final String value;
  final String? total;

  @override
  Widget build(BuildContext context) {
    final tone = Palettes.stat(kind);
    final total = this.total;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.fill,
        borderRadius: BorderRadius.circular(AppRadius.field),
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
            _OneLine(
              child: Text(
                AppText.upper(label),
                maxLines: 1,
                style: AppText.statLabel.copyWith(color: tone.label),
              ),
            ),
            const SizedBox(height: _valueGap),
            _OneLine(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: AppText.statValue.copyWith(color: tone.value),
                    ),
                    if (total != null)
                      TextSpan(
                        text: '/$total',
                        style: AppText.tag.copyWith(color: tone.label),
                      ),
                  ],
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OneLine extends StatelessWidget {
  const _OneLine({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      FittedBox(fit: BoxFit.scaleDown, child: child);
}
