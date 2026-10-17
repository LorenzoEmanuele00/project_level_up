// drift's documented way to write a column CHECK refers to the column's own
// getter; the analyzer reads that as recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:levelup/data/database/utc_millis_converter.dart';
import 'package:levelup/domain/enums.dart';

// Every table has a text UUID primary key and an `updated_at` instant that
// the future cloud sync (PLU-24) will use. There are no tombstones yet.
// Enums are stored by name as text: renaming one needs a migration.
// Foreign keys are ON DELETE RESTRICT: nothing is deleted behind the back of
// its children. Numeric CHECKs mirror what the game rules can produce.

@DataClassName('HeroRow')
@TableIndex(name: 'heroes_user', columns: {#userId})
class Heroes extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get avatarMode => textEnum<AvatarMode>()();
  TextColumn get avatarIcon => text().nullable()();
  TextColumn get accent => textEnum<AccentKey>()();
  TextColumn get heroClass => textEnum<HeroClass>().nullable()();
  IntColumn get level => integer().check(level.isBiggerOrEqualValue(1))();
  IntColumn get exp => integer().check(exp.isBiggerOrEqualValue(0))();
  IntColumn get rewardPoints =>
      integer().check(rewardPoints.isBiggerOrEqualValue(0))();
  TextColumn get theme => textEnum<ThemeKey>()();
  IntColumn get createdAt => integer().map(const UtcMillisConverter())();
  IntColumn get updatedAt => integer().map(const UtcMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HabitRow')
@TableIndex(name: 'habits_hero_archived', columns: {#heroId, #archived})
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get heroId =>
      text().references(Heroes, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get difficulty => textEnum<Difficulty>()();
  TextColumn get frequency => textEnum<Frequency>()();
  TextColumn get hue => textEnum<HabitHue>()();
  IntColumn get streak => integer().check(streak.isBiggerOrEqualValue(0))();
  IntColumn get bestStreak =>
      integer().check(bestStreak.isBiggerOrEqual(streak))();
  IntColumn get totalCompletions =>
      integer().check(totalCompletions.isBiggerOrEqualValue(0))();
  BoolColumn get archived => boolean()();
  IntColumn get createdAt => integer().map(const UtcMillisConverter())();
  IntColumn get updatedAt => integer().map(const UtcMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// A reward is never deleted: redeeming it sets `redeemed_at`. The available
/// ones are those with `redeemed_at IS NULL`.
@DataClassName('RewardRow')
@TableIndex(name: 'rewards_hero', columns: {#heroId})
class Rewards extends Table {
  TextColumn get id => text()();
  TextColumn get heroId =>
      text().references(Heroes, #id, onDelete: KeyAction.restrict)();
  TextColumn get name => text()();
  TextColumn get note => text().nullable()();
  TextColumn get tier => textEnum<RewardTier>()();
  IntColumn get redeemedAt =>
      integer().nullable().map(const UtcMillisConverter())();
  IntColumn get createdAt => integer().map(const UtcMillisConverter())();
  IntColumn get updatedAt => integer().map(const UtcMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// A redeemed reward. `reward_name` and `cost` are a copy of the reward at
/// that moment.
@DataClassName('RedemptionRow')
@TableIndex(name: 'redemptions_hero_at', columns: {#heroId, #at})
class Redemptions extends Table {
  TextColumn get id => text()();
  TextColumn get heroId =>
      text().references(Heroes, #id, onDelete: KeyAction.restrict)();
  TextColumn get rewardName => text()();
  IntColumn get cost => integer().check(cost.isBiggerOrEqualValue(0))();
  IntColumn get levelAt => integer().check(levelAt.isBiggerOrEqualValue(1))();
  IntColumn get at => integer().map(const UtcMillisConverter())();
  IntColumn get createdAt => integer().map(const UtcMillisConverter())();
  IntColumn get updatedAt => integer().map(const UtcMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// The full history of completions. The calendar day is never stored: it is
/// computed from `at` in local time.
@DataClassName('CompletionRow')
@TableIndex(name: 'completions_habit_at', columns: {#habitId, #at})
@TableIndex(name: 'completions_at', columns: {#at})
class Completions extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.restrict)();
  IntColumn get at => integer().map(const UtcMillisConverter())();
  IntColumn get exp => integer().check(exp.isBiggerOrEqualValue(0))();
  TextColumn get frequency => textEnum<Frequency>()();
  IntColumn get updatedAt => integer().map(const UtcMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
