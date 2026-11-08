import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Wraps a progress indicator with its accessibility description.
///
/// With a [label] the indicator becomes one node: label plus the rounded
/// percentage of [value] (already clamped to 0..1), formatted for the locale.
/// Anything below it (e.g. the text inside a ring) is excluded, so the same
/// number is not read twice. Without a [label] the [child] is returned as is:
/// the indicator announces nothing and the caller, which knows what it
/// measures, is responsible for the announcement.
Widget progressSemantics(
  BuildContext context, {
  required double value,
  required String? label,
  required Widget child,
}) {
  if (label == null) return child;
  final locale = Localizations.localeOf(context).toString();
  return Semantics(
    label: label,
    value: NumberFormat.percentPattern(locale).format(value),
    excludeSemantics: true,
    child: child,
  );
}
