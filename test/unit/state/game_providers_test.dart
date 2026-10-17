import 'dart:async';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/database/app_database.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/state/game_providers.dart';

final _now = DateTime(2026, 10, 17, 9);

/// Records when the database connection is closed.
class _CloseSpy extends QueryInterceptor {
  final closedSignal = Completer<void>();

  bool get closed => closedSignal.isCompleted;

  @override
  Future<void> close(QueryExecutor inner) {
    if (!closedSignal.isCompleted) closedSignal.complete();
    return inner.close();
  }
}

ProviderContainer _container(InMemoryGameRepository repo) {
  final container = ProviderContainer(
    overrides: [
      gameRepositoryProvider.overrideWithValue(repo),
      clockProvider.overrideWithValue(() => _now),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('database provider', () {
    test(
      'opens through the opener and closes the database on dispose',
      () async {
        final spy = _CloseSpy();
        final container = ProviderContainer(
          overrides: [
            appDatabaseOpenerProvider.overrideWithValue(
              () => AppDatabase(NativeDatabase.memory().interceptWith(spy)),
            ),
          ],
        );

        final db = container.read(appDatabaseProvider);
        expect(await db.select(db.heroes).get(), isEmpty);
        expect(spy.closed, isFalse);
        container.dispose();
        await spy.closedSignal.future.timeout(const Duration(seconds: 5));

        expect(spy.closed, isTrue);
      },
    );

    test('the repository is built on the database', () async {
      final container = ProviderContainer(
        overrides: [
          appDatabaseOpenerProvider.overrideWithValue(
            () => AppDatabase(NativeDatabase.memory()),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(gameRepositoryProvider);

      expect(await repo.watchHero().first, isNull);
    });
  });

  group('streams', () {
    test('heroProvider follows the repository', () async {
      final repo = InMemoryGameRepository();
      final container = _container(repo);
      final sub = container.listen(heroProvider, (_, _) {});
      addTearDown(sub.close);

      expect(await container.read(heroProvider.future), isNull);
      final hero = await repo.createHero(
        avatarMode: AvatarMode.initial,
        accent: AccentKey.rose,
        theme: ThemeKey.light,
        now: _now,
      );
      await Future<void>.delayed(Duration.zero);

      expect(container.read(heroProvider).value, hero);
    });

    test('activeHabitsProvider hides archived habits', () async {
      final repo = InMemoryGameRepository();
      final container = _container(repo);
      final hero = await repo.createHero(
        avatarMode: AvatarMode.initial,
        accent: AccentKey.rose,
        theme: ThemeKey.light,
        now: _now,
      );
      final keep = await repo.createHabit(
        heroId: hero.id,
        name: 'A',
        icon: 'book',
        difficulty: Difficulty.easy,
        frequency: Frequency.daily,
        hue: HabitHue.red,
        now: _now,
      );
      final drop = await repo.createHabit(
        heroId: hero.id,
        name: 'B',
        icon: 'book',
        difficulty: Difficulty.easy,
        frequency: Frequency.daily,
        hue: HabitHue.red,
        now: _now,
      );
      await repo.archiveHabit(drop.id, _now);

      // A listener keeps the stream provider active (Riverpod 3 pauses
      // providers nobody listens to).
      final sub = container.listen(activeHabitsProvider, (_, _) {});
      addTearDown(sub.close);

      expect(await container.read(activeHabitsProvider.future), [keep]);
    });
  });

  group('devSeedProvider', () {
    test('seeds an empty repository with the theme currently in use', () async {
      final repo = InMemoryGameRepository();
      final container = _container(repo);

      await container.read(devSeedProvider.future);

      final hero = await repo.watchHero().first;
      expect(hero?.theme, ThemeKey.light);
      expect(await repo.watchHabits().first, hasLength(3));
    });
  });
}
