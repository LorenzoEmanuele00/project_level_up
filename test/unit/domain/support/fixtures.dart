import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

/// A fresh level 1 hero with nothing earned yet.
GameHero heroFixture({int level = 1, int exp = 0, int rewardPoints = 0}) =>
    GameHero(
      id: 'hero-1',
      avatarMode: AvatarMode.initial,
      accent: AccentKey.terra,
      level: level,
      exp: exp,
      rewardPoints: rewardPoints,
      theme: ThemeKey.light,
    );

/// A daily, medium habit created long before the dates used in tests.
Habit habitFixture({
  String id = 'habit-1',
  Difficulty difficulty = Difficulty.media,
  Frequency frequency = Frequency.daily,
  int streak = 0,
  int bestStreak = 0,
  int totalCompletions = 0,
  DateTime? lastCompletedAt,
  bool archived = false,
  DateTime? createdAt,
}) => Habit(
  id: id,
  name: 'Read',
  icon: 'book',
  difficulty: difficulty,
  frequency: frequency,
  hue: HabitHue.teal,
  streak: streak,
  bestStreak: bestStreak,
  totalCompletions: totalCompletions,
  lastCompletedAt: lastCompletedAt,
  archived: archived,
  createdAt: createdAt ?? DateTime(2026, 1, 1),
);

/// A completion of [habitId] at [at].
Completion completionFixture(
  DateTime at, {
  String habitId = 'habit-1',
  String? id,
  int exp = 20,
}) =>
    Completion(id: id ?? 'c-$habitId-$at', habitId: habitId, at: at, exp: exp);
