import 'dart:ui';

import 'package:intl/intl.dart';

const _italian = 'it';

/// The date under the Home greeting: "Giovedì 29 ott" in Italian (weekday
/// capitalised, as the locale writes it in lower case) and "Thursday, Oct 29"
/// in English. [locale] is explicit, never the device default.
String formatHomeDate(DateTime instant, Locale locale) {
  final date = instant.toLocal();
  final tag = locale.toString();
  if (locale.languageCode != _italian) {
    return DateFormat('EEEE, MMM d', tag).format(date);
  }
  final text = DateFormat('EEEE d MMM', tag).format(date);
  return text[0].toUpperCase() + text.substring(1);
}
