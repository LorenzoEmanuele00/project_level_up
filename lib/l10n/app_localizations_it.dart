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

  @override
  String homeGreetingMorning(String name) {
    return 'Buongiorno, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Buon pomeriggio, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Buonasera, $name';
  }

  @override
  String get heroFallbackName => 'Eroe';

  @override
  String heroMissionProgress(int done, int due, int exp) {
    final intl.NumberFormat expNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String expString = expNumberFormat.format(exp);

    return '$done/$due completate · +$expString EXP rimasti';
  }

  @override
  String get statDone => 'Fatte';

  @override
  String get statExp => 'EXP';

  @override
  String get statStreak => 'Streak';

  @override
  String get statLevel => 'Livello';

  @override
  String get homeTodayTitle => 'Oggi';

  @override
  String get homeSeeAll => 'Vedi tutte';

  @override
  String get homeAllDone => 'Tutto fatto per oggi';

  @override
  String get homeLoadError => 'Impossibile caricare le habit';

  @override
  String get homeOpenProfile => 'Apri il profilo';

  @override
  String homeOpenRewards(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return 'Reward points: $pointsString. Apri il Reward Shop';
  }

  @override
  String get homeOpenMission => 'Apri la missione di oggi';

  @override
  String get comingSoonTitle => 'Prossimamente';

  @override
  String get comingSoonBody => 'Questa sezione arriva presto.';

  @override
  String get comingSoonClose => 'Chiudi';

  @override
  String get comingSoonProfile => 'Profilo';

  @override
  String get comingSoonRewards => 'Reward Shop';

  @override
  String get comingSoonMission => 'Missione di oggi';

  @override
  String get comingSoonHabits => 'Tutte le habit';
}
