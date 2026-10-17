import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/dev_seed.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/theme/icons.dart';

final _now = DateTime(2026, 10, 17, 9);

void main() {
  test(
    'creates the default hero and three starter habits when empty',
    () async {
      final repo = InMemoryGameRepository();

      await seedDevelopmentData(repo, now: _now, theme: ThemeKey.dark);

      final hero = await repo.watchHero().first;
      expect(hero, isNotNull);
      expect((hero!.level, hero.exp, hero.rewardPoints), (1, 0, 0));
      expect(hero.accent, AccentKey.terracotta);
      expect(hero.theme, ThemeKey.dark);
      expect(hero.userId, isNull);
      final habits = await repo.watchHabits().first;
      expect(habits, hasLength(3));
      expect(habits.every((h) => h.name.trim().isNotEmpty), isTrue);
      expect(habits.every((h) => AppIcons.isKnown(h.icon)), isTrue);
      expect(habits.every((h) => h.createdAt == _now.toUtc()), isTrue);
    },
  );

  test('does nothing when a hero already exists', () async {
    final repo = InMemoryGameRepository();
    await seedDevelopmentData(repo, now: _now, theme: ThemeKey.light);

    await seedDevelopmentData(repo, now: _now, theme: ThemeKey.light);

    expect(await repo.watchHabits().first, hasLength(3));
  });
}
