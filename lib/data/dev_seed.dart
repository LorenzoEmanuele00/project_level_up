import 'package:levelup/data/game_repository.dart';
import 'package:levelup/domain/enums.dart';

// TEMPORARY development seed. PLU-22 (registration) replaces it: the first
// launch will create the hero from the onboarding flow, and this file goes
// away. The habit names are plain data here on purpose, so no user-facing
// string enters the widgets.

/// A starter habit created by the seed.
typedef _SeedHabit = ({
  String name,
  String icon,
  Difficulty difficulty,
  Frequency frequency,
  HabitHue hue,
});

const _seedHabits = <_SeedHabit>[
  (
    name: 'Bere acqua',
    icon: 'water',
    difficulty: Difficulty.easy,
    frequency: Frequency.daily,
    hue: HabitHue.blue,
  ),
  (
    name: 'Leggere 20 minuti',
    icon: 'book',
    difficulty: Difficulty.medium,
    frequency: Frequency.daily,
    hue: HabitHue.teal,
  ),
  (
    name: 'Allenamento',
    icon: 'gym',
    difficulty: Difficulty.hard,
    frequency: Frequency.x3,
    hue: HabitHue.red,
  ),
];

/// On the first launch (no hero stored) creates the default hero (level 1,
/// no EXP, no reward points, Terracotta accent, no account) in [theme] and
/// three starter habits. Does nothing if a hero already exists.
Future<void> seedDevelopmentData(
  GameRepository repository, {
  required DateTime now,
  required ThemeKey theme,
}) async {
  if (await repository.watchHero().first != null) return;

  final hero = await repository.createHero(
    avatarMode: AvatarMode.initial,
    accent: AccentKey.terracotta,
    theme: theme,
    now: now,
  );
  for (final seed in _seedHabits) {
    await repository.createHabit(
      heroId: hero.id,
      name: seed.name,
      icon: seed.icon,
      difficulty: seed.difficulty,
      frequency: seed.frequency,
      hue: seed.hue,
      now: now,
    );
  }
}
