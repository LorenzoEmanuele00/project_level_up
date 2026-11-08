import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/today.dart';
import 'package:levelup/theme/palettes.dart';
import 'package:levelup/ui/atoms/avatar.dart';
import 'package:levelup/ui/atoms/points_pill.dart';
import 'package:levelup/ui/atoms/progress_bar.dart';
import 'package:levelup/ui/molecules/stat_tile.dart';
import 'package:levelup/ui/organisms/hero_block.dart';

import '../../helpers/widget_host.dart';
import '../../unit/domain/support/fixtures.dart';

final _morning = DateTime(2026, 10, 29, 9);

TodaySummary _summary({
  int done = 2,
  int due = 5,
  int expToday = 30,
  int expLeft = 70,
  int maxStreak = 12,
}) => TodaySummary(
  dueHabits: const [],
  doneCount: done,
  dueCount: due,
  expToday: expToday,
  expLeft: expLeft,
  maxStreak: maxStreak,
  questPct: due == 0 ? 1 : done / due,
  allDone: done == due,
);

GameHero _hero({String? name = 'Lorenzo', int exp = 40, int points = 1280}) =>
    heroFixture(level: 3, exp: exp, rewardPoints: points).copyWith(name: name);

Widget _block({
  GameHero? hero,
  TodaySummary? summary,
  DateTime? now,
  VoidCallback? onProfile,
  VoidCallback? onRewards,
  VoidCallback? onMission,
}) => SingleChildScrollView(
  child: HeroBlock(
    hero: hero ?? _hero(),
    summary: summary ?? _summary(),
    now: now ?? _morning,
    onProfile: onProfile,
    onRewards: onRewards,
    onMission: onMission,
  ),
);

void main() {
  setUpAll(() => initializeDateFormatting());

  group('HeroBlock greeting', () {
    testWidgets('greets by the part of the day', (tester) async {
      await tester.pumpWidget(
        widgetHost(_block(now: DateTime(2026, 10, 29, 9))),
      );
      expect(find.text('Buongiorno, Lorenzo'), findsOneWidget);

      await tester.pumpWidget(
        widgetHost(_block(now: DateTime(2026, 10, 29, 15))),
      );
      expect(find.text('Buon pomeriggio, Lorenzo'), findsOneWidget);

      await tester.pumpWidget(
        widgetHost(_block(now: DateTime(2026, 10, 29, 21))),
      );
      expect(find.text('Buonasera, Lorenzo'), findsOneWidget);
    });

    testWidgets('greets in English', (tester) async {
      await tester.pumpWidget(widgetHost(_block(), locale: const Locale('en')));
      expect(find.text('Good morning, Lorenzo'), findsOneWidget);
    });

    testWidgets('falls back to the localized hero name', (tester) async {
      await tester.pumpWidget(widgetHost(_block(hero: _hero(name: null))));
      expect(find.text('Buongiorno, Eroe'), findsOneWidget);

      await tester.pumpWidget(widgetHost(_block(hero: _hero(name: '  '))));
      expect(find.text('Buongiorno, Eroe'), findsOneWidget);

      await tester.pumpWidget(
        widgetHost(_block(hero: _hero(name: null)), locale: const Locale('en')),
      );
      expect(find.text('Good morning, Hero'), findsOneWidget);
    });

    testWidgets('shows the formatted date', (tester) async {
      await tester.pumpWidget(widgetHost(_block()));
      expect(find.text('Giovedì 29 ott'), findsOneWidget);
    });
  });

  group('HeroBlock stats', () {
    testWidgets('shows four stat tiles with the day numbers', (tester) async {
      await tester.pumpWidget(widgetHost(_block()));

      final tiles = tester
          .widgetList<StatTile>(find.byType(StatTile))
          .map((t) => (t.kind, t.label, t.value, t.total))
          .toList();
      expect(tiles, [
        (StatKind.peach, 'Fatte', '2', '5'),
        (StatKind.mint, 'EXP', '30', null),
        (StatKind.sky, 'Streak', '12', null),
        (StatKind.butter, 'Livello', '3', null),
      ]);
    });

    testWidgets('shows the mission bar and its line', (tester) async {
      await tester.pumpWidget(widgetHost(_block()));

      final bar = tester.widget<ProgressBar>(find.byType(ProgressBar));
      expect(bar.value, .4);
      expect(find.text('2/5 completate · +70 EXP rimasti'), findsOneWidget);
    });

    testWidgets('a day with nothing due shows a full bar', (tester) async {
      final summary = _summary(done: 0, due: 0, expLeft: 0, expToday: 0);
      await tester.pumpWidget(widgetHost(_block(summary: summary)));

      expect(tester.widget<ProgressBar>(find.byType(ProgressBar)).value, 1);
      expect(find.text('0/0 completate · +0 EXP rimasti'), findsOneWidget);
    });
  });

  group('HeroBlock header', () {
    testWidgets('the avatar ring shows the progress to the next level', (
      tester,
    ) async {
      await tester.pumpWidget(widgetHost(_block(hero: _hero(exp: 40))));

      expect(tester.widget<Avatar>(find.byType(Avatar)).expProgress, .4);
    });

    testWidgets('shows the reward points', (tester) async {
      await tester.pumpWidget(widgetHost(_block()));

      expect(tester.widget<PointsPill>(find.byType(PointsPill)).value, 1280);
    });
  });

  group('HeroBlock taps', () {
    testWidgets('avatar, pill and stats area call their callbacks', (
      tester,
    ) async {
      final taps = <String>[];
      await tester.pumpWidget(
        widgetHost(
          _block(
            onProfile: () => taps.add('profile'),
            onRewards: () => taps.add('rewards'),
            onMission: () => taps.add('mission'),
          ),
        ),
      );

      await tester.tap(find.byType(Avatar));
      await tester.tap(find.byType(PointsPill));
      await tester.tap(find.byType(ProgressBar));
      await tester.tap(find.byType(StatTile).first);

      expect(taps, ['profile', 'rewards', 'mission', 'mission']);
    });

    testWidgets('without callbacks the taps do nothing', (tester) async {
      await tester.pumpWidget(widgetHost(_block()));

      await tester.tap(find.byType(Avatar));
      await tester.tap(find.byType(PointsPill));
      await tester.tap(find.byType(StatTile).first);
      expect(tester.takeException(), isNull);
    });
  });

  group('HeroBlock layout', () {
    forBothThemes('renders without overflow', (tester, brightness) async {
      await tester.pumpWidget(widgetHost(_block(), brightness: brightness));
      expect(tester.takeException(), isNull);
    });

    testWidgets('survives a large text scale and long numbers', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final summary = _summary(
        done: 12,
        due: 30,
        expToday: 1200,
        maxStreak: 1234,
      );
      await tester.pumpWidget(
        widgetHost(
          _block(
            hero: _hero(name: 'Un nome molto molto lungo da troncare'),
            summary: summary,
          ),
          textScale: 2,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
