import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/app/day_refresher.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/state/game_providers.dart';
import 'package:levelup/state/today_providers.dart';

class _SpyRepository extends InMemoryGameRepository {
  final refreshedAt = <DateTime>[];
  Object? refreshError;

  @override
  Future<void> refreshStreaks(DateTime now) async {
    refreshedAt.add(now);
    final error = refreshError;
    if (error != null) throw error;
    return super.refreshStreaks(now);
  }
}

const _childKey = Key('child');

class _Setup {
  _Setup(this.tester, this.now, this.repo);

  final WidgetTester tester;
  final _SpyRepository repo;
  DateTime now;

  ProviderContainer get container =>
      ProviderScope.containerOf(tester.element(find.byKey(_childKey)));

  Future<Habit> streakingHabit() async => (await tester.runAsync(() async {
    final hero = await repo.createHero(
      avatarMode: AvatarMode.initial,
      accent: AccentKey.sage,
      theme: ThemeKey.light,
      now: DateTime(2026, 3, 1),
    );
    final habit = await repo.createHabit(
      heroId: hero.id,
      name: 'Read',
      icon: 'book',
      difficulty: Difficulty.easy,
      frequency: Frequency.daily,
      hue: HabitHue.teal,
      now: DateTime(2026, 3, 1),
    );
    await repo.completeHabit(habit.id, DateTime(2026, 3, 2, 10));
    await repo.completeHabit(habit.id, DateTime(2026, 3, 3, 10));
    return habit;
  }))!;

  Future<int> streakInRepository() async =>
      (await tester.runAsync(() => repo.watchHabits().first))!.single.streak;

  Future<void> pumpApp() async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameRepositoryProvider.overrideWithValue(repo),
          clockProvider.overrideWithValue(() => now),
        ],
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: DayRefresher(child: SizedBox(key: _childKey)),
        ),
      ),
    );
    await _settle(tester);
  }

  /// Sends the app to the background and brings it back.
  Future<void> backgroundAndResume() async {
    await goToBackground();
    // The framework only allows paused -> hidden -> inactive -> resumed.
    for (final state in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await _settle(tester);
  }

  /// Sends the app to the background.
  Future<void> goToBackground() async {
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await _settle(tester);
  }
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 1));
  }
}

void main() {
  testWidgets('shows its child', (tester) async {
    await _Setup(tester, DateTime(2026, 3, 4, 9), _SpyRepository()).pumpApp();

    expect(find.byKey(_childKey), findsOneWidget);
  });

  testWidgets('refreshes the streaks when the app starts', (tester) async {
    final setup = _Setup(tester, DateTime(2026, 3, 5, 9), _SpyRepository());
    await setup.streakingHabit();

    await setup.pumpApp();

    expect(await setup.streakInRepository(), 0);
  });

  testWidgets('on resume it updates the day and resets the expired streaks', (
    tester,
  ) async {
    final setup = _Setup(tester, DateTime(2026, 3, 4, 9), _SpyRepository());
    await setup.streakingHabit();
    await setup.pumpApp();
    expect(await setup.streakInRepository(), 2, reason: 'done yesterday');
    expect(setup.container.read(todayProvider), DateTime(2026, 3, 4));

    // The app sleeps, the timers with it: two days later it wakes up.
    setup.now = DateTime(2026, 3, 6, 8);
    await setup.backgroundAndResume();

    expect(setup.container.read(todayProvider), DateTime(2026, 3, 6));
    expect(await setup.streakInRepository(), 0);
    expect(setup.repo.refreshedAt, [
      DateTime(2026, 3, 4, 9),
      DateTime(2026, 3, 6, 8),
    ]);
  });

  testWidgets('on resume within the same day it refreshes once', (
    tester,
  ) async {
    final setup = _Setup(tester, DateTime(2026, 3, 4, 9), _SpyRepository());
    await setup.pumpApp();

    setup.now = DateTime(2026, 3, 4, 18);
    await setup.backgroundAndResume();

    expect(setup.container.read(todayProvider), DateTime(2026, 3, 4));
    expect(setup.repo.refreshedAt, [
      DateTime(2026, 3, 4, 9),
      DateTime(2026, 3, 4, 18),
    ]);
  });

  testWidgets('going to the background alone changes nothing', (tester) async {
    final setup = _Setup(tester, DateTime(2026, 3, 4, 9), _SpyRepository());
    await setup.pumpApp();

    await setup.goToBackground();

    expect(setup.repo.refreshedAt, hasLength(1));
  });

  testWidgets('a failing refresh is reported and the child stays up', (
    tester,
  ) async {
    final reported = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = reported.add;
    try {
      final setup = _Setup(tester, DateTime(2026, 3, 4, 9), _SpyRepository());
      await setup.pumpApp();
      expect(reported, isEmpty);

      setup.repo.refreshError = StateError('disk failure');
      await setup.backgroundAndResume();

      expect(reported, hasLength(1));
      expect(reported.single.exception, isA<StateError>());
      expect(find.byKey(_childKey), findsOneWidget);
    } finally {
      FlutterError.onError = previous;
    }
  });

  testWidgets('two failing refreshes in a row are reported once each', (
    tester,
  ) async {
    final reported = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = reported.add;
    try {
      final setup = _Setup(tester, DateTime(2026, 3, 4, 9), _SpyRepository());
      await setup.pumpApp();
      setup.repo.refreshError = StateError('disk failure');

      await setup.backgroundAndResume();
      await setup.backgroundAndResume();

      expect(reported, hasLength(2));
    } finally {
      FlutterError.onError = previous;
    }
  });
}
