import 'package:levelup/data/instant.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';

// Pure factories for brand new entities, shared by every repository so that
// they start from the same state.

/// A level 1 hero with no EXP and no reward points.
GameHero newHero({
  required String id,
  required AvatarMode avatarMode,
  required AccentKey accent,
  required ThemeKey theme,
  String? userId,
  String? name,
  String? avatarIcon,
  HeroClass? heroClass,
}) => GameHero(
  id: id,
  userId: userId,
  name: name,
  avatarMode: avatarMode,
  avatarIcon: avatarIcon,
  accent: accent,
  heroClass: heroClass,
  level: 1,
  exp: 0,
  rewardPoints: 0,
  theme: theme,
);

/// An active habit with an empty history, created at [now] (normalised to
/// UTC milliseconds).
Habit newHabit({
  required String id,
  required String name,
  required String icon,
  required Difficulty difficulty,
  required Frequency frequency,
  required HabitHue hue,
  required DateTime now,
}) => Habit(
  id: id,
  name: name,
  icon: icon,
  difficulty: difficulty,
  frequency: frequency,
  hue: hue,
  streak: 0,
  bestStreak: 0,
  totalCompletions: 0,
  archived: false,
  createdAt: normalizeInstant(now),
);
