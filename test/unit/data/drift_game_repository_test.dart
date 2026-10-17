import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/database/app_database.dart';
import 'package:levelup/data/drift_game_repository.dart';
import 'package:levelup/data/game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/results.dart';
import 'package:uuid/uuid.dart';

import 'game_repository_contract.dart';

final _monday = DateTime(2026, 3, 2, 10);

void main() {
  group('DriftGameRepository contract', () {
    runGameRepositoryContract(() async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      return DriftGameRepository(db);
    });
  });

  group('DriftGameRepository specifics', () {
    late AppDatabase db;
    late DriftGameRepository repo;
    late _SelectSpy spy;
    String? forcedId;

    setUp(() {
      forcedId = null;
      spy = _SelectSpy();
      db = AppDatabase(NativeDatabase.memory().interceptWith(spy));
      repo = DriftGameRepository(
        db,
        newId: () => forcedId ?? const Uuid().v4(),
      );
    });
    tearDown(() => db.close());

    Future<(GameHero, Habit)> heroWithHabit({
      Difficulty difficulty = Difficulty.medium,
    }) async {
      final hero = await repo.createHero(
        avatarMode: AvatarMode.initial,
        accent: AccentKey.sage,
        theme: ThemeKey.dark,
        now: _monday,
      );
      final habit = await repo.createHabit(
        heroId: hero.id,
        name: 'Run',
        icon: 'run',
        difficulty: difficulty,
        frequency: Frequency.daily,
        hue: HabitHue.green,
        now: _monday,
      );
      return (hero, habit);
    }

    Future<List<String>> planOf(String table) async {
      final query = spy.selects.lastWhere(
        (q) => q.sql.contains('FROM "$table"'),
      );
      final rows = await db
          .customSelect(
            'EXPLAIN QUERY PLAN ${query.sql}',
            variables: [for (final a in query.args) _variable(a)],
          )
          .get();
      return rows.map((r) => r.read<String>('detail')).toList();
    }

    test('writes created_at once and updated_at from the clock', () async {
      final (hero, habit) = await heroWithHabit();
      final later = _monday.add(const Duration(days: 1, minutes: 5));

      await repo.completeHabit(habit.id, later);

      final heroRow = await db.select(db.heroes).getSingle();
      final habitRow = await db.select(db.habits).getSingle();
      final completionRow = await db.select(db.completions).getSingle();
      expect(heroRow.createdAt, _monday.toUtc());
      expect(heroRow.updatedAt, later.toUtc());
      expect(habitRow.updatedAt, later.toUtc());
      expect(completionRow.updatedAt, later.toUtc());
      expect(heroRow.id, hero.id);
    });

    test(
      'completeHabit rolls back everything when the last write fails',
      () async {
        final (_, habit) = await heroWithHabit();
        final first = await repo.completeHabit(habit.id, _monday) as Completed;
        forcedId = first.completion.id;

        await expectLater(
          repo.completeHabit(habit.id, _monday.add(const Duration(days: 1))),
          throwsA(isA<SqliteException>()),
        );

        expect(await repo.watchHero().first, first.hero);
        expect(await repo.watchHabits().first, [first.habit]);
        final rows = await db.select(db.completions).get();
        expect(rows.map((r) => r.id), [first.completion.id]);
      },
    );

    Future<(GameHero, Reward)> richHeroWithReward(
      Habit habit,
      GameHero hero, {
      String name = 'Pizza',
    }) async {
      final reward = await repo.createReward(
        heroId: hero.id,
        name: name,
        tier: RewardTier.small,
        now: _monday,
      );
      return (hero, reward);
    }

    test('redeemReward keeps the reward, marks it and stores a copy', () async {
      final (hero, habit) = await heroWithHabit(difficulty: Difficulty.hard);
      final (_, reward) = await richHeroWithReward(habit, hero);
      for (var day = 0; day < 5; day++) {
        await repo.completeHabit(habit.id, _monday.add(Duration(days: day)));
      }
      final redeemAt = _monday.add(const Duration(days: 6));

      await repo.redeemReward(reward.id, redeemAt);

      final row = await db.select(db.rewards).getSingle();
      expect(row.id, reward.id);
      expect(row.redeemedAt, redeemAt.toUtc());
      expect(row.updatedAt, redeemAt.toUtc());
      final receipt = await db.select(db.redemptions).getSingle();
      expect(receipt.rewardName, 'Pizza');
      expect(receipt.cost, 10);
      expect(receipt.heroId, hero.id);
      expect(receipt.at, redeemAt.toUtc());
      expect(receipt.createdAt, redeemAt.toUtc());
    });

    test('redeeming a redeemed reward writes nothing', () async {
      final (hero, habit) = await heroWithHabit(difficulty: Difficulty.hard);
      final (_, reward) = await richHeroWithReward(habit, hero);
      for (var day = 0; day < 10; day++) {
        await repo.completeHabit(habit.id, _monday.add(Duration(days: day)));
      }
      await repo.redeemReward(reward.id, _monday.add(const Duration(days: 11)));
      final heroBefore = await repo.watchHero().first;

      await expectLater(
        repo.redeemReward(reward.id, _monday.add(const Duration(days: 12))),
        throwsA(isA<RewardAlreadyRedeemedException>()),
      );

      expect(await repo.watchHero().first, heroBefore);
      expect(await db.select(db.redemptions).get(), hasLength(1));
    });

    test('redeemReward rolls back when the receipt cannot be saved', () async {
      final (hero, habit) = await heroWithHabit(difficulty: Difficulty.hard);
      final (_, cheap) = await richHeroWithReward(habit, hero);
      final (_, other) = await richHeroWithReward(habit, hero, name: 'Tea');
      for (var day = 0; day < 10; day++) {
        await repo.completeHabit(habit.id, _monday.add(Duration(days: day)));
      }
      final first = await repo.redeemReward(cheap.id, _monday) as Redeemed;
      final heroBefore = await repo.watchHero().first;
      forcedId = first.redemption.id;

      await expectLater(
        repo.redeemReward(other.id, _monday.add(const Duration(days: 20))),
        throwsA(isA<SqliteException>()),
      );

      expect(await repo.watchHero().first, heroBefore);
      final untouched = await (db.select(
        db.rewards,
      )..where((r) => r.id.equals(other.id))).getSingle();
      expect(untouched.redeemedAt, isNull);
      expect(await db.select(db.redemptions).get(), hasLength(1));
    });

    group('query plans', () {
      test('the interval and today streams use the index on at', () async {
        await heroWithHabit();
        final day = DateTime(2026, 3, 2, 12);

        await repo.watchCompletionsBetween(_monday, day).first;
        expect(
          await planOf('completions'),
          contains(contains('completions_at')),
        );

        await repo.watchCompletionsOn(day).first;
        expect(
          await planOf('completions'),
          contains(contains('completions_at')),
        );
      });

      test('the per-habit window uses the (habit_id, at) index', () async {
        final (_, habit) = await heroWithHabit();

        await repo.completionsBetween(habit.id, _monday, _monday);

        expect(
          await planOf('completions'),
          contains(contains('completions_habit_at')),
        );
      });

      test('completeHabit loads its window through that same index', () async {
        final (_, habit) = await heroWithHabit();

        await repo.completeHabit(habit.id, _monday);

        expect(
          await planOf('completions'),
          contains(contains('completions_habit_at')),
        );
      });
    });

    test('reads the earliest created hero when several exist', () async {
      final late = await repo.createHero(
        name: 'Two',
        avatarMode: AvatarMode.initial,
        accent: AccentKey.rose,
        theme: ThemeKey.light,
        now: _monday.add(const Duration(days: 1)),
      );
      final early = await repo.createHero(
        name: 'One',
        avatarMode: AvatarMode.initial,
        accent: AccentKey.rose,
        theme: ThemeKey.light,
        now: _monday,
      );

      expect(await repo.watchHero().first, early);
      expect(await db.select(db.heroes).get(), hasLength(2));
      expect(late.name, 'Two');
    });
  });
}

/// Records every SELECT sent to the database, to inspect its plan.
class _SelectSpy extends QueryInterceptor {
  final selects = <({String sql, List<Object?> args})>[];

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor inner,
    String statement,
    List<Object?> args,
  ) {
    selects.add((sql: statement, args: args));
    return inner.runSelect(statement, args);
  }
}

Variable<Object> _variable(Object? value) => switch (value) {
  final int v => Variable<int>(v),
  final String v => Variable<String>(v),
  _ => throw ArgumentError('unsupported query argument: $value'),
};
