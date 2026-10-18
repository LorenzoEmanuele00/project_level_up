import 'package:drift/drift.dart';
import 'package:levelup/data/database/app_database.dart';
import 'package:levelup/data/game_repository.dart';
import 'package:levelup/data/instant.dart';
import 'package:levelup/data/mappers.dart';
import 'package:levelup/data/new_entities.dart';
import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/game_rules.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/results.dart';
import 'package:uuid/uuid.dart';

/// The [GameRepository] backed by the local SQLite database (drift).
///
/// Errors from the database propagate to the caller. Writes that touch more
/// than one table run in a single transaction.
class DriftGameRepository implements GameRepository {
  DriftGameRepository(this._db, {IdGenerator? newId})
    : _newId = newId ?? (() => const Uuid().v4());

  final AppDatabase _db;
  final IdGenerator _newId;

  @override
  Stream<GameHero?> watchHero() =>
      (_db.select(_db.heroes)
            ..orderBy([
              (h) => OrderingTerm.asc(h.createdAt),
              (h) => OrderingTerm.asc(h.id),
            ])
            ..limit(1))
          .watchSingleOrNull()
          .map((row) => row == null ? null : heroFromRow(row));

  @override
  Stream<List<Habit>> watchHabits({bool includeArchived = false}) {
    final query = _db.select(_db.habits)
      ..orderBy([
        (h) => OrderingTerm.asc(h.createdAt),
        (h) => OrderingTerm.asc(h.id),
      ]);
    if (!includeArchived) query.where((h) => h.archived.equals(false));
    return query.watch().map((rows) => rows.map(habitFromRow).toList());
  }

  SimpleSelectStatement<$CompletionsTable, CompletionRow> _completionsIn(
    DateTime from,
    DateTime to,
  ) => _db.select(_db.completions)
    ..where(
      (c) =>
          c.at.isBiggerOrEqualValue(from.millisecondsSinceEpoch) &
          c.at.isSmallerThanValue(to.millisecondsSinceEpoch),
    )
    ..orderBy([(c) => OrderingTerm.asc(c.at), (c) => OrderingTerm.asc(c.id)]);

  @override
  Stream<List<Completion>> watchCompletionsBetween(
    DateTime from,
    DateTime to,
  ) => _completionsIn(
    from,
    to,
  ).watch().map((rows) => rows.map(completionFromRow).toList());

  @override
  Stream<List<Completion>> watchCompletionsOn(DateTime day) {
    final start = localDay(day);
    return watchCompletionsBetween(start, addLocalDays(start, 1));
  }

  @override
  Future<List<Completion>> completionsBetween(
    String habitId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await (_completionsIn(
      from,
      to,
    )..where((c) => c.habitId.equals(habitId))).get();
    return rows.map(completionFromRow).toList();
  }

  @override
  Future<GameHero> createHero({
    required AvatarMode avatarMode,
    required AccentKey accent,
    required ThemeKey theme,
    required DateTime now,
    String? userId,
    String? name,
    String? avatarIcon,
    HeroClass? heroClass,
  }) async {
    final hero = newHero(
      id: _newId(),
      userId: userId,
      name: name,
      avatarMode: avatarMode,
      avatarIcon: avatarIcon,
      accent: accent,
      heroClass: heroClass,
      theme: theme,
    );
    await _db
        .into(_db.heroes)
        .insert(heroToCompanion(hero, createdAt: now, updatedAt: now));
    return hero;
  }

  @override
  Future<Habit> createHabit({
    required String heroId,
    required String name,
    required String icon,
    required Difficulty difficulty,
    required Frequency frequency,
    required HabitHue hue,
    required DateTime now,
  }) => _db.transaction(() async {
    await _heroRow(heroId);
    final habit = newHabit(
      id: _newId(),
      name: name,
      icon: icon,
      difficulty: difficulty,
      frequency: frequency,
      hue: hue,
      now: now,
    );
    await _db
        .into(_db.habits)
        .insert(habitToCompanion(habit, heroId: heroId, updatedAt: now));
    return habit;
  });

  @override
  Future<Reward> createReward({
    required String heroId,
    required String name,
    required RewardTier tier,
    required DateTime now,
    String? note,
  }) => _db.transaction(() async {
    await _heroRow(heroId);
    final reward = Reward(id: _newId(), name: name, note: note, tier: tier);
    await _db
        .into(_db.rewards)
        .insert(
          rewardToCompanion(
            reward,
            heroId: heroId,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return reward;
  });

  @override
  Future<void> archiveHabit(String habitId, DateTime now) async {
    final updated =
        await (_db.update(
          _db.habits,
        )..where((h) => h.id.equals(habitId))).write(
          HabitsCompanion(
            archived: const Value(true),
            updatedAt: Value(normalizeInstant(now)),
          ),
        );
    if (updated == 0) throw EntityNotFoundException('habit', habitId);
  }

  @override
  Future<void> refreshStreaks(DateTime now) => _db.transaction(() async {
    final at = normalizeInstant(now);
    final rows =
        await (_db.select(_db.habits)..where(
              (h) => h.archived.equals(false) & h.streak.isBiggerThanValue(0),
            ))
            .get();
    if (rows.isEmpty) return;

    final window = [
      for (final row in await _completionsIn(
        completionWindowStart(at),
        completionWindowEnd(at),
      ).get())
        completionFromRow(row),
    ];
    for (final row in rows) {
      final fresh = refreshStreak(
        habitFromRow(row),
        today: at,
        completions: window,
      );
      if (fresh.streak == row.streak) continue;
      await (_db.update(_db.habits)..where((h) => h.id.equals(row.id))).write(
        HabitsCompanion(streak: Value(fresh.streak), updatedAt: Value(at)),
      );
    }
  });

  @override
  Future<CompletionResult> completeHabit(String habitId, DateTime now) =>
      _db.transaction(() async {
        final at = normalizeInstant(now);
        final habitRow = await _habitRow(habitId);
        final heroRow = await _heroRow(habitRow.heroId);
        final window = await completionsBetween(
          habitId,
          completionWindowStart(at),
          completionWindowEnd(at),
        );

        final result = complete(
          hero: heroFromRow(heroRow),
          habit: habitFromRow(habitRow),
          now: at,
          completionId: _newId(),
          weekCompletions: window,
        );
        if (result is Completed) await _saveCompleted(result, heroRow.id, at);
        return result;
      });

  Future<void> _saveCompleted(
    Completed done,
    String heroId,
    DateTime at,
  ) async {
    await _updateHero(done.hero, at);
    await _updateHabit(done.habit, heroId, at);
    await _db
        .into(_db.completions)
        .insert(completionToCompanion(done.completion, updatedAt: at));
  }

  Future<HabitRow> _habitRow(String habitId) async {
    final row = await (_db.select(
      _db.habits,
    )..where((h) => h.id.equals(habitId))).getSingleOrNull();
    return row ?? (throw EntityNotFoundException('habit', habitId));
  }

  Future<HeroRow> _heroRow(String heroId) async {
    final row = await (_db.select(
      _db.heroes,
    )..where((h) => h.id.equals(heroId))).getSingleOrNull();
    return row ?? (throw EntityNotFoundException('hero', heroId));
  }

  Future<void> _updateHero(GameHero hero, DateTime at) =>
      (_db.update(_db.heroes)..where((h) => h.id.equals(hero.id))).write(
        heroProgressCompanion(hero, updatedAt: at),
      );

  Future<void> _updateHabit(Habit habit, String heroId, DateTime at) =>
      (_db.update(_db.habits)..where((h) => h.id.equals(habit.id))).write(
        habitToCompanion(habit, heroId: heroId, updatedAt: at),
      );

  @override
  Future<RedeemResult> redeemReward(String rewardId, DateTime now) =>
      _db.transaction(() async {
        final at = normalizeInstant(now);
        final rewardRow =
            await (_db.select(
              _db.rewards,
            )..where((r) => r.id.equals(rewardId))).getSingleOrNull() ??
            (throw EntityNotFoundException('reward', rewardId));
        if (rewardRow.redeemedAt != null) {
          throw RewardAlreadyRedeemedException(rewardId);
        }
        final heroRow = await _heroRow(rewardRow.heroId);

        final result = redeem(
          hero: heroFromRow(heroRow),
          reward: rewardFromRow(rewardRow),
          redemptionId: _newId(),
          at: at,
        );
        if (result is Redeemed) {
          await _saveRedeemed(result, heroRow.id, rewardId, at);
        }
        return result;
      });

  Future<void> _saveRedeemed(
    Redeemed done,
    String heroId,
    String rewardId,
    DateTime at,
  ) async {
    await _updateHero(done.hero, at);
    await _db
        .into(_db.redemptions)
        .insert(
          redemptionToCompanion(
            done.redemption,
            heroId: heroId,
            createdAt: at,
            updatedAt: at,
          ),
        );
    await (_db.update(_db.rewards)..where((r) => r.id.equals(rewardId))).write(
      RewardsCompanion(redeemedAt: Value(at), updatedAt: Value(at)),
    );
  }
}
