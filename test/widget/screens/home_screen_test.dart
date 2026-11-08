import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/app/app.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/state/game_providers.dart';
import 'package:levelup/ui/atoms/avatar.dart' show Avatar;
import 'package:levelup/ui/atoms/habit_check.dart';
import 'package:levelup/ui/atoms/points_pill.dart';
import 'package:levelup/ui/molecules/empty_state.dart';
import 'package:levelup/ui/molecules/habit_tile.dart';
import 'package:levelup/ui/molecules/stat_tile.dart';
import 'package:levelup/ui/motion/entrance.dart';
import 'package:levelup/ui/screens/coming_soon_sheet.dart';
import 'package:levelup/ui/screens/home_screen.dart';

final _now = DateTime(2026, 10, 29, 9);
DateTime _clock = _now;

class _FailingRepository extends InMemoryGameRepository {
  @override
  Stream<List<Habit>> watchHabits({bool includeArchived = false}) =>
      Stream.error(StateError('boom'));
}

class _Fixture {
  _Fixture(this.tester, this.repo);

  final WidgetTester tester;
  final InMemoryGameRepository repo;
  late final GameHero hero;

  Future<void> seedHero({String? name = 'Lorenzo'}) async {
    hero = (await tester.runAsync(
      () => repo.createHero(
        avatarMode: AvatarMode.initial,
        accent: AccentKey.terracotta,
        theme: ThemeKey.light,
        now: _now,
        name: name,
      ),
    ))!;
  }

  Future<Habit> addHabit(
    String name, {
    Difficulty difficulty = Difficulty.medium,
  }) async => (await tester.runAsync(
    () => repo.createHabit(
      heroId: hero.id,
      name: name,
      icon: 'book',
      difficulty: difficulty,
      frequency: Frequency.daily,
      hue: HabitHue.teal,
      now: DateTime(2026, 10, 1),
    ),
  ))!;

  Future<void> complete(Habit habit) async {
    await tester.runAsync(() => repo.completeHabit(habit.id, _now));
  }

  Future<void> pump({
    List<Locale> locales = const [Locale('it')],
    bool disableAnimations = false,
  }) async {
    tester.platformDispatcher.localesTestValue = locales;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures(disableAnimations: disableAnimations);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWithValue(repo),
          clockProvider.overrideWithValue(() => _clock),
        ],
        child: const LevelUpApp(),
      ),
    );
    await tester.pumpAndSettle();
  }
}

_Fixture _fixture(WidgetTester tester, [InMemoryGameRepository? repo]) =>
    _Fixture(tester, repo ?? InMemoryGameRepository());

void main() {
  setUp(() => _clock = _now);

  testWidgets('opens on route / with the greeting and the day stats', (
    tester,
  ) async {
    final f = _fixture(tester);
    await f.seedHero();
    await f.addHabit('Leggere');
    await f.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Buongiorno, Lorenzo'), findsOneWidget);
    expect(find.byType(StatTile), findsNWidgets(4));
    expect(find.byType(Avatar), findsOneWidget);
    expect(find.byType(PointsPill), findsOneWidget);
  });

  testWidgets('greets in English on an English device', (tester) async {
    final f = _fixture(tester);
    await f.seedHero();
    await f.pump(locales: const [Locale('en')]);

    expect(find.text('Good morning, Lorenzo'), findsOneWidget);
  });

  testWidgets('shows a tile for each due habit and hides the archived', (
    tester,
  ) async {
    final f = _fixture(tester);
    await f.seedHero();
    await f.addHabit('Leggere');
    final archived = await f.addHabit('Vecchia');
    await tester.runAsync(() => f.repo.archiveHabit(archived.id, _now));
    await f.pump();

    expect(find.byType(HabitTile), findsOneWidget);
    expect(find.text('Leggere'), findsOneWidget);
    expect(find.text('Vecchia'), findsNothing);
  });

  testWidgets('marks completed habits as done', (tester) async {
    final f = _fixture(tester);
    await f.seedHero();
    final read = await f.addHabit('Leggere');
    await f.addHabit('Correre');
    await f.complete(read);
    await f.pump();

    final tiles = tester.widgetList<HabitTile>(find.byType(HabitTile));
    expect(
      tiles.map((t) => t.done).toList()..sort((a, b) => '$a'.compareTo('$b')),
      [false, true],
    );
    expect(find.byType(EmptyState), findsNothing);
  });

  testWidgets('shows the all done message when every habit is done', (
    tester,
  ) async {
    final f = _fixture(tester);
    await f.seedHero();
    await f.complete(await f.addHabit('Leggere'));
    await f.pump();

    expect(find.text('Tutto fatto per oggi'), findsOneWidget);
    expect(find.byType(HabitTile), findsOneWidget);
  });

  testWidgets('shows the all done message when no habit exists', (
    tester,
  ) async {
    final f = _fixture(tester);
    await f.seedHero();
    await f.pump();

    expect(find.text('Tutto fatto per oggi'), findsOneWidget);
    expect(find.byType(HabitTile), findsNothing);
  });

  testWidgets('lays tiles out two per row with an odd last row', (
    tester,
  ) async {
    final f = _fixture(tester);
    await f.seedHero();
    await f.addHabit('Uno');
    await f.addHabit('Due con un nome parecchio lungo che va a capo');
    await f.addHabit('Tre');
    await f.pump();

    final rects = [
      for (final e in tester.elementList(find.byType(HabitTile)))
        tester.getRect(find.byWidget(e.widget)),
    ];
    expect(rects, hasLength(3));
    expect(rects[0].top, rects[1].top);
    expect(rects[0].width, rects[1].width);
    expect(rects[0].height, rects[1].height);
    expect(rects[2].top, greaterThan(rects[0].bottom));
    expect(rects[2].width, rects[0].width);
    expect(rects[2].left, rects[0].left);
  });

  testWidgets('tapping a check or a tile does not complete the habit yet', (
    tester,
  ) async {
    final f = _fixture(tester);
    await f.seedHero();
    final habit = await f.addHabit('Leggere');
    await f.pump();

    await tester.tap(find.byType(HabitCheck));
    await tester.tap(find.text('Leggere'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    final done = await tester.runAsync(
      () => f.repo.completionsBetween(
        habit.id,
        DateTime(2026, 10, 29),
        DateTime(2026, 10, 30),
      ),
    );
    expect(done, isEmpty);
  });

  group('navigation to placeholder sheets', () {
    Future<void> openAndExpect(
      WidgetTester tester,
      Finder trigger,
      String section,
    ) async {
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(find.byType(ComingSoonSheet), findsOneWidget);
      expect(find.text(section), findsOneWidget);
    }

    testWidgets('avatar opens the profile', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();
      await openAndExpect(tester, find.byType(Avatar), 'Profilo');
    });

    testWidgets('points pill opens the reward shop', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();
      await openAndExpect(tester, find.byType(PointsPill), 'Reward Shop');
    });

    testWidgets('stats area opens the mission', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();
      await openAndExpect(
        tester,
        find.byType(StatTile).first,
        'Missione di oggi',
      );
    });

    testWidgets('see all opens the habit list', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();
      await openAndExpect(tester, find.text('Vedi tutte'), 'Tutte le habit');
    });

    testWidgets('a double tap opens the sheet only once', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();

      await tester.tap(find.byType(Avatar));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(Avatar), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(ComingSoonSheet), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Chiudi'));
      await tester.pumpAndSettle();
      expect(find.byType(ComingSoonSheet), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('the stats area reads as one button with its summary', (
      tester,
    ) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.addHabit('Leggere');
      await f.pump();

      final handle = tester.ensureSemantics();
      expect(
        find.bySemanticsLabel(
          RegExp(r'Apri la missione di oggi.*0/1 completate'),
        ),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Fatte'), findsNothing);
      handle.dispose();
    });

    testWidgets('closing a sheet returns to the home', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();
      await openAndExpect(tester, find.byType(Avatar), 'Profilo');

      await tester.tap(find.bySemanticsLabel('Chiudi'));
      await tester.pumpAndSettle();

      expect(find.byType(ComingSoonSheet), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('the sheet is reachable with reduced motion', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump(disableAnimations: true);
      await openAndExpect(tester, find.byType(Avatar), 'Profilo');
    });
  });

  group('time of day', () {
    testWidgets('the greeting changes when the day crosses 12:00', (
      tester,
    ) async {
      _clock = DateTime(2026, 10, 29, 11, 59, 50);
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();
      expect(find.text('Buongiorno, Lorenzo'), findsOneWidget);

      _clock = DateTime(2026, 10, 29, 12, 0, 1);
      await tester.pump(const Duration(seconds: 11));
      await tester.pumpAndSettle();

      expect(find.text('Buon pomeriggio, Lorenzo'), findsOneWidget);
      expect(find.text('Buongiorno, Lorenzo'), findsNothing);
    });

    testWidgets('the greeting is refreshed when the app resumes', (
      tester,
    ) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.pump();
      expect(find.text('Buongiorno, Lorenzo'), findsOneWidget);

      _clock = DateTime(2026, 10, 29, 19);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(find.text('Buonasera, Lorenzo'), findsOneWidget);
    });
  });

  group('entrances', () {
    testWidgets('hero and header are blocks, tiles are staggered items', (
      tester,
    ) async {
      final f = _fixture(tester);
      await f.seedHero();
      await f.addHabit('Uno');
      await f.addHabit('Due');
      await f.pump();

      final entrances = tester
          .widgetList<Entrance>(find.byType(Entrance))
          .toList();
      final blocks = entrances.where((e) => e.kind == EntranceKind.blockUp);
      final items = entrances.where((e) => e.kind == EntranceKind.itemIn);
      expect(blocks.map((e) => e.index), [0, 1]);
      expect(items, hasLength(2));
      expect(items.map((e) => e.index).toSet(), hasLength(2));
    });

    testWidgets('a rebuild does not replay the tile entrance', (tester) async {
      final f = _fixture(tester);
      await f.seedHero();
      final read = await f.addHabit('Leggere');
      await f.pump();
      final before = tester.state(find.byType(Entrance).last);

      await f.complete(read);
      await tester.pumpAndSettle();

      expect(tester.state(find.byType(Entrance).last), same(before));
    });
  });

  group('loading and errors', () {
    testWidgets('shows the error message when the data fails', (tester) async {
      final f = _fixture(tester, _FailingRepository());
      await f.seedHero();
      await f.pump();

      expect(find.text('Impossibile caricare le habit'), findsOneWidget);
      expect(find.byType(HabitTile), findsNothing);
    });

    testWidgets('shows nothing but the background while the hero is missing', (
      tester,
    ) async {
      final f = _fixture(tester);
      await f.pump();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(StatTile), findsNothing);
    });
  });
}
