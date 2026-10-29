import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/l10n/app_localizations.dart';

void main() {
  final it = lookupAppLocalizations(const Locale('it'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('habitExpGain prefixes the EXP amount', () {
    expect(it.habitExpGain(20), '+20 EXP');
    expect(en.habitExpGain(20), '+20 EXP');
  });

  test('habitExpGain groups thousands per locale', () {
    expect(it.habitExpGain(1200), '+1.200 EXP');
    expect(en.habitExpGain(1200), '+1,200 EXP');
  });

  test('check labels name the habit in both languages', () {
    expect(it.habitCheckComplete('Leggere'), 'Completa Leggere');
    expect(en.habitCheckComplete('Read'), 'Complete Read');
    expect(it.habitCheckDone('Leggere'), 'Leggere completata');
    expect(en.habitCheckDone('Read'), 'Read completed');
  });
}
