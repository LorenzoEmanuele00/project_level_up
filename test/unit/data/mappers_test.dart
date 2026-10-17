import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/database/app_database.dart';
import 'package:levelup/data/instant.dart';
import 'package:levelup/data/mappers.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

/// Distinctive instants: milliseconds set, local zone vs UTC.
final _utcWithMillis = DateTime.utc(2026, 10, 17, 8, 30, 15, 123);
final _localSameInstant = _utcWithMillis.toLocal();
final _createdAt = DateTime.utc(2026, 10, 16, 7, 0, 0, 9);
final _updatedAt = DateTime.utc(2026, 10, 18, 9, 0, 0, 7);

const _fullHero = GameHero(
  id: 'hero-1',
  userId: 'user-1',
  name: 'Ada',
  avatarMode: AvatarMode.icon,
  avatarIcon: 'sword',
  accent: AccentKey.slate,
  heroClass: HeroClass.scholar,
  level: 7,
  exp: 55,
  rewardPoints: 31,
  theme: ThemeKey.dark,
);

const _bareHero = GameHero(
  id: 'hero-2',
  avatarMode: AvatarMode.initial,
  accent: AccentKey.terracotta,
  level: 1,
  exp: 0,
  rewardPoints: 0,
  theme: ThemeKey.light,
);

Habit _habit({DateTime? createdAt}) => Habit(
  id: 'habit-1',
  name: 'Read',
  icon: 'book',
  difficulty: Difficulty.hard,
  frequency: Frequency.x3,
  hue: HabitHue.gold,
  streak: 4,
  bestStreak: 9,
  totalCompletions: 21,
  archived: true,
  createdAt: createdAt ?? _utcWithMillis,
);

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db
        .into(db.heroes)
        .insert(
          heroToCompanion(
            _bareHero,
            createdAt: _createdAt,
            updatedAt: _updatedAt,
          ),
        );
  });
  tearDown(() => db.close());

  group('hero', () {
    test('round-trips a hero with every field set', () async {
      await db
          .into(db.heroes)
          .insert(
            heroToCompanion(
              _fullHero,
              createdAt: _createdAt,
              updatedAt: _updatedAt,
            ),
          );

      final row = await (db.select(
        db.heroes,
      )..where((h) => h.id.equals('hero-1'))).getSingle();

      expect(heroFromRow(row), _fullHero);
      expect(row.updatedAt, _updatedAt);
    });

    test('round-trips a hero with every nullable field empty', () async {
      final row = await (db.select(
        db.heroes,
      )..where((h) => h.id.equals('hero-2'))).getSingle();

      final hero = heroFromRow(row);

      expect(hero, _bareHero);
      expect(hero.userId, isNull);
      expect(hero.heroClass, isNull);
    });
  });

  test('a hero progress update leaves created_at and identity alone', () async {
    final hero = _bareHero.copyWith(level: 3, exp: 40, rewardPoints: 5);

    await (db.update(db.heroes)..where((h) => h.id.equals('hero-2'))).write(
      heroProgressCompanion(hero, updatedAt: _updatedAt),
    );

    final row = await db.select(db.heroes).getSingle();
    expect(heroFromRow(row), hero);
    expect(row.createdAt, _createdAt);
    expect(
      heroProgressCompanion(hero, updatedAt: _updatedAt).id.present,
      isFalse,
    );
  });

  group('habit', () {
    test('round-trips with millisecond precision and a hero id', () async {
      await db
          .into(db.habits)
          .insert(
            habitToCompanion(_habit(), heroId: 'hero-2', updatedAt: _updatedAt),
          );

      final row = await db.select(db.habits).getSingle();

      expect(habitFromRow(row), _habit());
      expect(row.heroId, 'hero-2');
      expect(habitFromRow(row).createdAt.millisecond, 123);
    });

    test('reads a local createdAt back as the same UTC instant', () async {
      await db
          .into(db.habits)
          .insert(
            habitToCompanion(
              _habit(createdAt: _localSameInstant),
              heroId: 'hero-2',
              updatedAt: _updatedAt,
            ),
          );

      final createdAt = habitFromRow(await db.select(db.habits).getSingle())
          .createdAt;

      expect(createdAt, _utcWithMillis);
      expect(createdAt.isUtc, isTrue);
    });
  });

  group('reward', () {
    test('round-trips with a note', () async {
      const reward = Reward(
        id: 'r1',
        name: 'Cinema',
        note: 'Friday',
        tier: RewardTier.large,
      );
      await db
          .into(db.rewards)
          .insert(
            rewardToCompanion(
              reward,
              heroId: 'hero-2',
              createdAt: _createdAt,
              updatedAt: _updatedAt,
            ),
          );

      final row = await db.select(db.rewards).getSingle();

      expect(rewardFromRow(row), reward);
      expect(row.heroId, 'hero-2');
    });

    test('round-trips without a note', () async {
      const reward = Reward(id: 'r2', name: 'Pizza', tier: RewardTier.small);
      await db
          .into(db.rewards)
          .insert(
            rewardToCompanion(
              reward,
              heroId: 'hero-2',
              createdAt: _createdAt,
              updatedAt: _updatedAt,
            ),
          );

      final row = await db.select(db.rewards).getSingle();

      expect(rewardFromRow(row).note, isNull);
      expect(rewardFromRow(row), reward);
    });
  });

  group('redemption', () {
    test('round-trips as a copy of name and cost', () async {
      final redemption = Redemption(
        id: 'x1',
        rewardName: 'Cinema',
        cost: 60,
        levelAt: 12,
        at: _utcWithMillis,
      );
      await db
          .into(db.redemptions)
          .insert(
            redemptionToCompanion(
              redemption,
              heroId: 'hero-2',
              createdAt: _createdAt,
              updatedAt: _updatedAt,
            ),
          );

      final row = await db.select(db.redemptions).getSingle();

      expect(redemptionFromRow(row), redemption);
      expect(row.heroId, 'hero-2');
    });
  });

  group('completion', () {
    test('round-trips with frequency and milliseconds', () async {
      await db
          .into(db.habits)
          .insert(
            habitToCompanion(_habit(), heroId: 'hero-2', updatedAt: _updatedAt),
          );
      final completion = Completion(
        id: 'c1',
        habitId: 'habit-1',
        at: _localSameInstant,
        exp: 40,
        frequency: Frequency.x2,
      );
      await db
          .into(db.completions)
          .insert(completionToCompanion(completion, updatedAt: _updatedAt));

      final restored = completionFromRow(
        await db.select(db.completions).getSingle(),
      );

      expect(restored, completion.copyWith(at: _utcWithMillis));
      expect(restored.at.isUtc, isTrue);
      expect(restored.frequency, Frequency.x2);
    });
  });

  group('normalizeInstant', () {
    test('returns UTC and drops sub-millisecond precision', () {
      final raw = DateTime(2026, 10, 17, 8, 30, 15, 123, 456);

      final normalized = normalizeInstant(raw);

      expect(normalized.isUtc, isTrue);
      expect(normalized.microsecond, 0);
      expect(normalized.millisecondsSinceEpoch, raw.millisecondsSinceEpoch);
    });

    test('keeps an already normalised instant equal', () {
      expect(normalizeInstant(_utcWithMillis), _utcWithMillis);
    });
  });
}
