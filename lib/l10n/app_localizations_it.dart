// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'LevelUp';

  @override
  String habitExpGain(int exp) {
    final intl.NumberFormat expNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String expString = expNumberFormat.format(exp);

    return '+$expString EXP';
  }

  @override
  String habitCheckComplete(String name) {
    return 'Completa $name';
  }

  @override
  String habitCheckDone(String name) {
    return '$name completata';
  }
}
