import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/app/bootstrap.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/state/game_providers.dart';

class _BrokenRepository extends InMemoryGameRepository {
  @override
  Stream<GameHero?> watchHero() => Stream.error(StateError('disk failure'));
}

class _RefreshFailsRepository extends InMemoryGameRepository {
  @override
  Future<void> refreshStreaks(DateTime now) =>
      Future.error(StateError('refresh failure'));
}

/// Two days of a daily habit, then a day skipped: its streak has expired.
Future<Habit> _habitWithExpiredStreak(InMemoryGameRepository repo) async {
  final hero = await repo.createHero(
    avatarMode: AvatarMode.initial,
    accent: AccentKey.sage,
    theme: ThemeKey.light,
    now: DateTime(2026, 3, 2),
  );
  final habit = await repo.createHabit(
    heroId: hero.id,
    name: 'Read',
    icon: 'book',
    difficulty: Difficulty.easy,
    frequency: Frequency.daily,
    hue: HabitHue.teal,
    now: DateTime(2026, 3, 2),
  );
  await repo.completeHabit(habit.id, DateTime(2026, 3, 2, 10));
  await repo.completeHabit(habit.id, DateTime(2026, 3, 3, 10));
  return habit;
}

void main() {
  test('startup seeds the data and hands back a live container', () async {
    final repo = InMemoryGameRepository();
    var disposed = false;

    final container = await createAppContainer(
      overrides: [
        gameRepositoryProvider.overrideWith((ref) {
          ref.onDispose(() => disposed = true);
          return repo;
        }),
      ],
    );
    addTearDown(container.dispose);

    expect(await repo.watchHero().first, isNotNull);
    expect(await repo.watchHabits().first, hasLength(3));
    expect(disposed, isFalse, reason: 'the app still needs the container');
    expect(container.read(gameRepositoryProvider), same(repo));
  });

  test('a seeding failure is surfaced and the container disposed', () async {
    var disposed = false;

    await expectLater(
      createAppContainer(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) {
            ref.onDispose(() => disposed = true);
            return _BrokenRepository();
          }),
        ],
      ),
      throwsA(isA<StateError>()),
    );

    expect(disposed, isTrue);
  });

  test(
    'startup resets the streaks that expired while the app was off',
    () async {
      final repo = InMemoryGameRepository();
      await _habitWithExpiredStreak(repo);

      final container = await createAppContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(repo),
          clockProvider.overrideWithValue(() => DateTime(2026, 3, 5, 9)),
        ],
      );
      addTearDown(container.dispose);

      final habit = (await repo.watchHabits().first).single;
      expect((habit.streak, habit.bestStreak), (0, 2));
    },
  );

  test('a streak refresh failure is reported and does not block', () async {
    final reported = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = reported.add;
    addTearDown(() => FlutterError.onError = previous);
    final repo = _RefreshFailsRepository();

    final container = await createAppContainer(
      overrides: [gameRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    expect(await repo.watchHabits().first, hasLength(3), reason: 'seeded');
    expect(reported, hasLength(1));
    expect(reported.single.exception, isA<StateError>());
  });
}
