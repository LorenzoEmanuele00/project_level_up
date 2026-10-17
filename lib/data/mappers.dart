import 'package:drift/drift.dart';
import 'package:levelup/data/database/app_database.dart';
import 'package:levelup/data/instant.dart';
import 'package:levelup/domain/models.dart';

// Mappers between database rows and domain models.
//
// Rows -> models: instants come back as UTC (see UtcMillisConverter).
// Models -> companions: instants are normalised with `normalizeInstant`,
// `createdAt` and `updatedAt` are supplied by the repository (the models do
// not carry them), and the owning hero id is supplied for the tables that
// have one.

GameHero heroFromRow(HeroRow row) => GameHero(
  id: row.id,
  userId: row.userId,
  name: row.name,
  avatarMode: row.avatarMode,
  avatarIcon: row.avatarIcon,
  accent: row.accent,
  heroClass: row.heroClass,
  level: row.level,
  exp: row.exp,
  rewardPoints: row.rewardPoints,
  theme: row.theme,
);

HeroesCompanion heroToCompanion(
  GameHero hero, {
  required DateTime createdAt,
  required DateTime updatedAt,
}) => HeroesCompanion.insert(
  id: hero.id,
  userId: Value(hero.userId),
  name: Value(hero.name),
  avatarMode: hero.avatarMode,
  avatarIcon: Value(hero.avatarIcon),
  accent: hero.accent,
  heroClass: Value(hero.heroClass),
  level: hero.level,
  exp: hero.exp,
  rewardPoints: hero.rewardPoints,
  theme: hero.theme,
  createdAt: normalizeInstant(createdAt),
  updatedAt: normalizeInstant(updatedAt),
);

/// The columns that change when the hero progresses (completing a habit,
/// paying a reward). It leaves `created_at` and the identity untouched.
HeroesCompanion heroProgressCompanion(
  GameHero hero, {
  required DateTime updatedAt,
}) => HeroesCompanion(
  level: Value(hero.level),
  exp: Value(hero.exp),
  rewardPoints: Value(hero.rewardPoints),
  updatedAt: Value(normalizeInstant(updatedAt)),
);

Habit habitFromRow(HabitRow row) => Habit(
  id: row.id,
  name: row.name,
  icon: row.icon,
  difficulty: row.difficulty,
  frequency: row.frequency,
  hue: row.hue,
  streak: row.streak,
  bestStreak: row.bestStreak,
  totalCompletions: row.totalCompletions,
  archived: row.archived,
  createdAt: row.createdAt,
);

HabitsCompanion habitToCompanion(
  Habit habit, {
  required String heroId,
  required DateTime updatedAt,
}) => HabitsCompanion.insert(
  id: habit.id,
  heroId: heroId,
  name: habit.name,
  icon: habit.icon,
  difficulty: habit.difficulty,
  frequency: habit.frequency,
  hue: habit.hue,
  streak: habit.streak,
  bestStreak: habit.bestStreak,
  totalCompletions: habit.totalCompletions,
  archived: habit.archived,
  createdAt: normalizeInstant(habit.createdAt),
  updatedAt: normalizeInstant(updatedAt),
);

Reward rewardFromRow(RewardRow row) =>
    Reward(id: row.id, name: row.name, note: row.note, tier: row.tier);

RewardsCompanion rewardToCompanion(
  Reward reward, {
  required String heroId,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => RewardsCompanion.insert(
  id: reward.id,
  heroId: heroId,
  name: reward.name,
  note: Value(reward.note),
  tier: reward.tier,
  createdAt: normalizeInstant(createdAt),
  updatedAt: normalizeInstant(updatedAt),
);

Redemption redemptionFromRow(RedemptionRow row) => Redemption(
  id: row.id,
  rewardName: row.rewardName,
  cost: row.cost,
  levelAt: row.levelAt,
  at: row.at,
);

RedemptionsCompanion redemptionToCompanion(
  Redemption redemption, {
  required String heroId,
  required DateTime createdAt,
  required DateTime updatedAt,
}) => RedemptionsCompanion.insert(
  id: redemption.id,
  heroId: heroId,
  rewardName: redemption.rewardName,
  cost: redemption.cost,
  levelAt: redemption.levelAt,
  at: normalizeInstant(redemption.at),
  createdAt: normalizeInstant(createdAt),
  updatedAt: normalizeInstant(updatedAt),
);

Completion completionFromRow(CompletionRow row) => Completion(
  id: row.id,
  habitId: row.habitId,
  at: row.at,
  exp: row.exp,
  frequency: row.frequency,
);

CompletionsCompanion completionToCompanion(
  Completion completion, {
  required DateTime updatedAt,
}) => CompletionsCompanion.insert(
  id: completion.id,
  habitId: completion.habitId,
  at: normalizeInstant(completion.at),
  exp: completion.exp,
  frequency: completion.frequency,
  updatedAt: normalizeInstant(updatedAt),
);
