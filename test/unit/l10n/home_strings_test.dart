import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/l10n/app_localizations.dart';

void main() {
  final it = lookupAppLocalizations(const Locale('it'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('greetings name the hero in both languages', () {
    expect(it.homeGreetingMorning('Lorenzo'), 'Buongiorno, Lorenzo');
    expect(it.homeGreetingAfternoon('Lorenzo'), 'Buon pomeriggio, Lorenzo');
    expect(it.homeGreetingEvening('Lorenzo'), 'Buonasera, Lorenzo');
    expect(en.homeGreetingMorning('Lorenzo'), 'Good morning, Lorenzo');
    expect(en.homeGreetingAfternoon('Lorenzo'), 'Good afternoon, Lorenzo');
    expect(en.homeGreetingEvening('Lorenzo'), 'Good evening, Lorenzo');
  });

  test('the fallback name is the hero in each language', () {
    expect(it.heroFallbackName, 'Eroe');
    expect(en.heroFallbackName, 'Hero');
  });

  test('mission progress counts done, due and EXP left', () {
    expect(
      it.heroMissionProgress(2, 5, 70),
      '2/5 completate · +70 EXP rimasti',
    );
    expect(en.heroMissionProgress(2, 5, 70), '2/5 completed · +70 EXP left');
  });

  test('mission progress groups thousands per locale', () {
    expect(it.heroMissionProgress(0, 3, 1200), contains('+1.200 EXP'));
    expect(en.heroMissionProgress(0, 3, 1200), contains('+1,200 EXP'));
  });

  test('stat labels exist in both languages', () {
    expect(it.statDone, 'Fatte');
    expect(en.statDone, 'Done');
    expect(it.statLevel, 'Livello');
    expect(en.statLevel, 'Level');
    expect(it.statStreak, 'Streak');
    expect(en.statExp, 'EXP');
  });

  test('coming soon sheets are named per section', () {
    expect(it.comingSoonProfile, 'Profilo');
    expect(en.comingSoonRewards, 'Reward shop');
    expect(it.comingSoonMission, 'Missione di oggi');
    expect(en.comingSoonHabits, 'All habits');
    expect(it.comingSoonTitle, 'Prossimamente');
    expect(en.comingSoonClose, 'Close');
  });

  test('accessibility labels name their target', () {
    expect(it.homeOpenProfile, isNotEmpty);
    expect(en.homeOpenMission, isNotEmpty);
    expect(it.homeOpenRewards(1280), contains('1.280'));
    expect(en.homeOpenRewards(1280), contains('1,280'));
  });
}
