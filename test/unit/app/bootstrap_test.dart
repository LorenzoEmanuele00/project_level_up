import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/app/bootstrap.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/state/game_providers.dart';

class _BrokenRepository extends InMemoryGameRepository {
  @override
  Stream<GameHero?> watchHero() => Stream.error(StateError('disk failure'));
}

void main() {
  test('startup seeds the data and hands back a live container', () async {
    final repo = InMemoryGameRepository();
    var disposed = false;

    final container = await createAppContainer(
      overrides: [
        gameRepositoryProvider.overrideWith((ref) {
          ref.onDispose(() => disposed = true);
          return repo;
        }),
      ],
    );
    addTearDown(container.dispose);

    expect(await repo.watchHero().first, isNotNull);
    expect(await repo.watchHabits().first, hasLength(3));
    expect(disposed, isFalse, reason: 'the app still needs the container');
    expect(container.read(gameRepositoryProvider), same(repo));
  });

  test('a seeding failure is surfaced and the container disposed', () async {
    var disposed = false;

    await expectLater(
      createAppContainer(
        overrides: [
          gameRepositoryProvider.overrideWith((ref) {
            ref.onDispose(() => disposed = true);
            return _BrokenRepository();
          }),
        ],
      ),
      throwsA(isA<StateError>()),
    );

    expect(disposed, isTrue);
  });
}
