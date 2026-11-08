// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
    return 'Complete $name';
  }

  @override
  String habitCheckDone(String name) {
    return '$name completed';
  }

  @override
  String homeGreetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get heroFallbackName => 'Hero';

  @override
  String heroMissionProgress(int done, int due, int exp) {
    final intl.NumberFormat expNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String expString = expNumberFormat.format(exp);

    return '$done/$due completed · +$expString EXP left';
  }

  @override
  String get statDone => 'Done';

  @override
  String get statExp => 'EXP';

  @override
  String get statStreak => 'Streak';

  @override
  String get statLevel => 'Level';

  @override
  String get homeTodayTitle => 'Today';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeAllDone => 'All done for today';

  @override
  String get homeLoadError => 'Couldn\'t load your habits';

  @override
  String get homeOpenProfile => 'Open profile';

  @override
  String homeOpenRewards(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return 'Reward points: $pointsString. Open the reward shop';
  }

  @override
  String get homeOpenMission => 'Open today\'s mission';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonBody => 'This section is coming soon.';

  @override
  String get comingSoonClose => 'Close';

  @override
  String get comingSoonProfile => 'Profile';

  @override
  String get comingSoonRewards => 'Reward shop';

  @override
  String get comingSoonMission => 'Today\'s mission';

  @override
  String get comingSoonHabits => 'All habits';
}
