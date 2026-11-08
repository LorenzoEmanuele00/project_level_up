import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:levelup/ui/l10n/home_date.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  final thursday = DateTime(2026, 10, 29);

  test('Italian: weekday with a capital, day and short month', () {
    expect(formatHomeDate(thursday, const Locale('it')), 'Giovedì 29 ott');
  });

  test('English: weekday, month then day', () {
    expect(formatHomeDate(thursday, const Locale('en')), 'Thursday, Oct 29');
  });

  test('ignores the time of day', () {
    final late = DateTime(2026, 10, 29, 23, 59);
    expect(formatHomeDate(late, const Locale('it')), 'Giovedì 29 ott');
  });

  test('reads the local day of a UTC instant', () {
    final utc = DateTime.utc(2026, 10, 29, 12);
    expect(
      formatHomeDate(utc, const Locale('it')),
      formatHomeDate(utc.toLocal(), const Locale('it')),
    );
  });
}
