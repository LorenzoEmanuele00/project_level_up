import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/database/app_database.dart';
import 'package:levelup/domain/enums.dart';

final _stamp = DateTime.utc(2026, 10, 17, 8, 30, 15, 123);

HeroesCompanion _hero(
  String id, {
  String? userId,
  AccentKey accent = AccentKey.sage,
  int level = 1,
  int exp = 0,
  int rewardPoints = 0,
}) => HeroesCompanion.insert(
  id: id,
  userId: Value(userId),
  avatarMode: AvatarMode.initial,
  accent: accent,
  level: level,
  exp: exp,
  rewardPoints: rewardPoints,
  theme: ThemeKey.light,
  createdAt: _stamp,
  updatedAt: _stamp,
);

HabitsCompanion _habit(
  String id,
  String heroId, {
  int streak = 0,
  int bestStreak = 0,
  int totalCompletions = 0,
}) => HabitsCompanion.insert(
  id: id,
  heroId: heroId,
  name: 'Read',
  icon: 'book',
  difficulty: Difficulty.medium,
  frequency: Frequency.daily,
  hue: HabitHue.teal,
  streak: streak,
  bestStreak: bestStreak,
  totalCompletions: totalCompletions,
  archived: false,
  createdAt: _stamp,
  updatedAt: _stamp,
);

RewardsCompanion _reward(String id, String heroId) => RewardsCompanion.insert(
  id: id,
  heroId: heroId,
  name: 'Tea',
  tier: RewardTier.small,
  createdAt: _stamp,
  updatedAt: _stamp,
);

RedemptionsCompanion _redemption(
  String id,
  String heroId, {
  int cost = 10,
  int levelAt = 1,
}) => RedemptionsCompanion.insert(
  id: id,
  heroId: heroId,
  rewardName: 'Tea',
  cost: cost,
  levelAt: levelAt,
  at: _stamp,
  createdAt: _stamp,
  updatedAt: _stamp,
);

CompletionsCompanion _completion(String id, String habitId, {int exp = 20}) =>
    CompletionsCompanion.insert(
      id: id,
      habitId: habitId,
      at: _stamp,
      exp: exp,
      frequency: Frequency.daily,
      updatedAt: _stamp,
    );

Matcher get _sqliteError => throwsA(isA<SqliteException>());

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> seedFamily() async {
    await db.into(db.heroes).insert(_hero('hero-1'));
    await db.into(db.habits).insert(_habit('h1', 'hero-1'));
    await db.into(db.rewards).insert(_reward('r1', 'hero-1'));
    await db.into(db.redemptions).insert(_redemption('x1', 'hero-1'));
    await db.into(db.completions).insert(_completion('c1', 'h1'));
  }

  test('starts at schema version 1', () {
    expect(db.schemaVersion, 1);
  });

  group('storage format', () {
    test('stores enums by name, as text', () async {
      await db.into(db.heroes).insert(_hero('hero-1', accent: AccentKey.slate));

      final raw = await db
          .customSelect('SELECT accent, theme, avatar_mode FROM heroes')
          .getSingle();

      expect(raw.read<String>('accent'), 'slate');
      expect(raw.read<String>('theme'), 'light');
      expect(raw.read<String>('avatar_mode'), 'initial');
    });

    test('keeps user_id nullable', () async {
      await db.into(db.heroes).insert(_hero('hero-1'));
      await db.into(db.heroes).insert(_hero('hero-2', userId: 'user-9'));

      final rows = await (db.select(
        db.heroes,
      )..orderBy([(h) => OrderingTerm.asc(h.id)])).get();

      expect(rows.map((r) => r.userId), [null, 'user-9']);
    });

    test('stores instants as epoch milliseconds, read back in UTC', () async {
      await seedFamily();

      for (final table in ['heroes', 'rewards', 'redemptions']) {
        final raw = await db
            .customSelect('SELECT created_at, updated_at FROM $table')
            .getSingle();
        expect(
          raw.read<int>('created_at'),
          _stamp.millisecondsSinceEpoch,
          reason: table,
        );
        expect(raw.read<int>('updated_at'), _stamp.millisecondsSinceEpoch);
      }
      final row = await db.select(db.heroes).getSingle();
      expect(row.createdAt, _stamp);
      expect(row.createdAt.isUtc, isTrue);
    });

    test(
      'a reward starts not redeemed and keeps redeemed_at nullable',
      () async {
        await db.into(db.heroes).insert(_hero('hero-1'));
        await db.into(db.rewards).insert(_reward('r1', 'hero-1'));

        final fresh = await db.select(db.rewards).getSingle();
        expect(fresh.redeemedAt, isNull);

        await (db.update(db.rewards)..where((r) => r.id.equals('r1'))).write(
          RewardsCompanion(redeemedAt: Value(_stamp)),
        );
        final redeemed = await db.select(db.rewards).getSingle();
        expect(redeemed.redeemedAt, _stamp);
        expect(redeemed.redeemedAt!.isUtc, isTrue);
      },
    );

    test('fails loudly on an unknown enum value', () async {
      await db.into(db.heroes).insert(_hero('hero-1'));
      await db.customStatement("UPDATE heroes SET accent = 'neon'");

      await expectLater(db.select(db.heroes).get(), throwsA(anything));
    });
  });

  group('foreign keys', () {
    test('are switched on', () async {
      final pragma = await db.customSelect('PRAGMA foreign_keys').getSingle();

      expect(pragma.read<int>('foreign_keys'), 1);
    });

    test('a habit needs an existing hero', () async {
      await expectLater(
        db.into(db.habits).insert(_habit('h1', 'missing-hero')),
        _sqliteError,
      );
    });

    test('a completion needs an existing habit', () async {
      await expectLater(
        db.into(db.completions).insert(_completion('c1', 'missing')),
        _sqliteError,
      );
    });

    test('every key declares ON DELETE RESTRICT', () async {
      final tables = ['habits', 'rewards', 'redemptions', 'completions'];
      for (final table in tables) {
        final keys = await db
            .customSelect("PRAGMA foreign_key_list('$table')")
            .get();
        expect(keys, hasLength(1), reason: table);
        expect(
          keys.single.read<String>('on_delete'),
          'RESTRICT',
          reason: table,
        );
      }
    });

    test(
      'deleting a hero that has habits, rewards or redemptions fails',
      () async {
        await seedFamily();
        await db.customStatement('DELETE FROM completions');
        await db.customStatement('DELETE FROM habits');
        await expectLater(
          db.customStatement("DELETE FROM heroes WHERE id = 'hero-1'"),
          _sqliteError,
        );
        await db.customStatement('DELETE FROM rewards');
        await expectLater(
          db.customStatement("DELETE FROM heroes WHERE id = 'hero-1'"),
          _sqliteError,
        );
        await db.customStatement('DELETE FROM redemptions');
        await db.customStatement("DELETE FROM heroes WHERE id = 'hero-1'");
        expect(await db.select(db.heroes).get(), isEmpty);
      },
    );

    test('deleting a habit that has completions fails', () async {
      await seedFamily();

      await expectLater(
        db.customStatement("DELETE FROM habits WHERE id = 'h1'"),
        _sqliteError,
      );
      expect(await db.select(db.habits).get(), hasLength(1));
    });
  });

  group('indexes', () {
    Future<Map<String, List<String>>> indexesOf(String table) async {
      final list = await db.customSelect("PRAGMA index_list('$table')").get();
      final result = <String, List<String>>{};
      for (final index in list) {
        final name = index.read<String>('name');
        if (name.startsWith('sqlite_autoindex')) continue;
        final cols = await db.customSelect("PRAGMA index_info('$name')").get();
        result[name] = cols.map((c) => c.read<String>('name')).toList();
      }
      return result;
    }

    test('completions: (habit_id, at) and (at)', () async {
      expect(await indexesOf('completions'), {
        'completions_habit_at': ['habit_id', 'at'],
        'completions_at': ['at'],
      });
    });

    test('habits: (hero_id, archived)', () async {
      expect(await indexesOf('habits'), {
        'habits_hero_archived': ['hero_id', 'archived'],
      });
    });

    test('rewards: (hero_id)', () async {
      expect(await indexesOf('rewards'), {
        'rewards_hero': ['hero_id'],
      });
    });

    test('redemptions: (hero_id, at)', () async {
      expect(await indexesOf('redemptions'), {
        'redemptions_hero_at': ['hero_id', 'at'],
      });
    });

    test('heroes: (user_id)', () async {
      expect(await indexesOf('heroes'), {
        'heroes_user': ['user_id'],
      });
    });
  });

  group('numeric CHECK constraints', () {
    setUp(() => db.into(db.heroes).insert(_hero('hero-1')));

    test('heroes: level >= 1, exp >= 0, reward_points >= 0', () async {
      await expectLater(
        db.into(db.heroes).insert(_hero('a', level: 0)),
        _sqliteError,
      );
      await expectLater(
        db.into(db.heroes).insert(_hero('b', exp: -1)),
        _sqliteError,
      );
      await expectLater(
        db.into(db.heroes).insert(_hero('c', rewardPoints: -1)),
        _sqliteError,
      );
    });

    test('habits: streak, best_streak and total_completions', () async {
      await expectLater(
        db.into(db.habits).insert(_habit('a', 'hero-1', streak: -1)),
        _sqliteError,
      );
      await expectLater(
        db.into(db.habits).insert(_habit('b', 'hero-1', totalCompletions: -1)),
        _sqliteError,
      );
      await expectLater(
        db
            .into(db.habits)
            .insert(_habit('c', 'hero-1', streak: 3, bestStreak: 2)),
        _sqliteError,
      );
      await db
          .into(db.habits)
          .insert(_habit('ok', 'hero-1', streak: 3, bestStreak: 3));
    });

    test('redemptions: cost >= 0 and level_at >= 1', () async {
      await expectLater(
        db.into(db.redemptions).insert(_redemption('a', 'hero-1', cost: -1)),
        _sqliteError,
      );
      await expectLater(
        db.into(db.redemptions).insert(_redemption('b', 'hero-1', levelAt: 0)),
        _sqliteError,
      );
    });

    test('completions: exp >= 0', () async {
      await db.into(db.habits).insert(_habit('h1', 'hero-1'));

      await expectLater(
        db.into(db.completions).insert(_completion('a', 'h1', exp: -1)),
        _sqliteError,
      );
    });
  });
}
