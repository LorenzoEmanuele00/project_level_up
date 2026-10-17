import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';

import 'game_repository_contract.dart';

void main() {
  runGameRepositoryContract(() async {
    final repo = InMemoryGameRepository();
    addTearDown(repo.dispose);
    return repo;
  });

  test('dispose silences open streams but writes keep working', () async {
    final repo = InMemoryGameRepository();
    final seen = <bool>[];
    final subscription = repo.watchHero().listen((h) => seen.add(h != null));
    await Future<void>.delayed(Duration.zero);

    await repo.dispose();
    final hero = await repo.createHero(
      avatarMode: AvatarMode.initial,
      accent: AccentKey.sage,
      theme: ThemeKey.light,
      now: DateTime(2026, 3, 2),
    );
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(seen, [false]);
    expect(hero.level, 1);
  });
}
