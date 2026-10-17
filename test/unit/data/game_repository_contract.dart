import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/results.dart';

/// Behaviour every [GameRepository] must have, whatever stores the data.
///
/// [create] must return a fresh, empty repository on every call and register
/// its own cleanup (for example with `addTearDown`).
///
/// Dates are built in the local zone on purpose: the game rules work on local
/// calendar days. 2026-03-02 is a Monday; the dates stay clear of daylight
/// saving changes.
void runGameRepositoryContract(Future<GameRepository> Function() create) {
  late GameRepository repo;

  setUp(() async => repo = await create());

  Future<T> next<T>(Stream<T> stream, bool Function(T) when) =>
      stream.firstWhere(when).timeout(const Duration(seconds: 5));

  Future<GameHero> newHero({DateTime? now}) => repo.createHero(
    avatarMode: AvatarMode.initial,
    accent: AccentKey.terracotta,
    theme: ThemeKey.light,
    now: now ?? _monday,
  );

  Future<Habit> newHabit(
    GameHero hero, {
    Difficulty difficulty = Difficulty.medium,
    Frequency frequency = Frequency.daily,
    DateTime? now,
  }) => repo.createHabit(
    heroId: hero.id,
    name: 'Read',
    icon: 'book',
    difficulty: difficulty,
    frequency: frequency,
    hue: HabitHue.teal,
    now: now ?? _monday,
  );

  Future<Completed> complete(Habit habit, DateTime now) async {
    final result = await repo.completeHabit(habit.id, now);
    expect(result, isA<Completed>(), reason: 'completing on $now');
    return result as Completed;
  }

  group('hero', () {
    test('streams null while no hero exists', () async {
      expect(await repo.watchHero().first, isNull);
    });

    test('createHero stores a level 1 hero and streams it', () async {
      final hero = await repo.createHero(
        name: 'Ada',
        avatarMode: AvatarMode.icon,
        avatarIcon: 'sword',
        accent: AccentKey.sage,
        heroClass: HeroClass.monk,
        theme: ThemeKey.dark,
        now: _monday,
      );

      expect(hero.id, isNotEmpty);
      expect(hero.userId, isNull);
      expect((hero.level, hero.exp, hero.rewardPoints), (1, 0, 0));
      expect(hero.name, 'Ada');
      expect(hero.heroClass, HeroClass.monk);
      expect(await repo.watchHero().first, hero);
    });

    test('the stream follows later changes', () async {
      final hero = await newHero();
      final habit = await newHabit(hero);
      final updated = next(repo.watchHero(), (h) => h?.exp == 20);

      await complete(habit, _monday);

      expect((await updated)?.exp, 20);
    });
  });

  group('habits', () {
    test('createHabit starts clean and streams the new habit', () async {
      final hero = await newHero();

      final habit = await newHabit(hero, now: _monday);

      expect(
        (habit.streak, habit.bestStreak, habit.totalCompletions),
        (0, 0, 0),
      );
      expect(habit.archived, isFalse);
      expect(habit.createdAt, _monday.toUtc());
      expect(habit.createdAt.isUtc, isTrue);
      expect(await repo.watchHabits().first, [habit]);
    });

    test('habits stream by creation instant, then by id', () async {
      final hero = await newHero();
      final later = await newHabit(
        hero,
        now: _monday.add(const Duration(minutes: 5)),
      );
      final earlier = await newHabit(
        hero,
        now: _monday.subtract(const Duration(minutes: 5)),
      );
      final tieA = await newHabit(hero, now: _monday);
      final tieB = await newHabit(hero, now: _monday);

      final ties = [tieA, tieB]..sort((a, b) => a.id.compareTo(b.id));

      expect(await repo.watchHabits().first, [earlier, ...ties, later]);
    });

    test('the hero is the earliest created, then by id', () async {
      await newHero(now: _monday.add(const Duration(days: 1)));
      final early = await newHero(now: _monday);

      expect(await repo.watchHero().first, early);
    });

    test('createHabit fails for an unknown hero', () async {
      await expectLater(
        repo.createHabit(
          heroId: 'nobody',
          name: 'x',
          icon: 'book',
          difficulty: Difficulty.easy,
          frequency: Frequency.daily,
          hue: HabitHue.red,
          now: _monday,
        ),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('archived habits only show when asked for', () async {
      final hero = await newHero();
      final kept = await newHabit(hero);
      final gone = await newHabit(
        hero,
        now: _monday.add(const Duration(minutes: 1)),
      );

      await repo.archiveHabit(gone.id, _monday);

      expect(await repo.watchHabits().first, [kept]);
      final all = await repo.watchHabits(includeArchived: true).first;
      expect(all.map((h) => h.id), [kept.id, gone.id]);
      expect(all.last.archived, isTrue);
    });

    test('archiveHabit fails for an unknown habit', () async {
      await expectLater(
        repo.archiveHabit('nope', _monday),
        throwsA(isA<EntityNotFoundException>()),
      );
    });
  });

  group('completeHabit', () {
    test('rewards EXP and records the completion', () async {
      final hero = await newHero();
      final habit = await newHabit(hero, difficulty: Difficulty.hard);

      final done = await complete(habit, _monday);

      expect(done.hero.exp, 40);
      expect(done.habit.streak, 1);
      expect(done.habit.totalCompletions, 1);
      expect(done.completion.at, _monday.toUtc());
      expect(done.completion.at.isUtc, isTrue);
      expect(done.completion.frequency, Frequency.daily);
      expect(await repo.watchHero().first, done.hero);
      expect(await repo.watchHabits().first, [done.habit]);
      final stored = await repo.completionsBetween(
        habit.id,
        _monday.subtract(const Duration(days: 1)),
        _monday.add(const Duration(days: 1)),
      );
      expect(stored, [done.completion]);
    });

    test('a second completion on the same day changes nothing', () async {
      final hero = await newHero();
      final habit = await newHabit(hero);
      await complete(habit, _monday);

      final again = await repo.completeHabit(
        habit.id,
        _monday.add(const Duration(hours: 5)),
      );

      expect(again, isA<AlreadyDoneToday>());
      expect((await repo.watchHero().first)?.exp, 20);
      expect((await repo.watchHabits().first).single.totalCompletions, 1);
      expect(await repo.watchCompletionsOn(_monday).first, hasLength(1));
    });

    test(
      'an earlier clock reading the same day sees the later completion',
      () async {
        final hero = await newHero();
        final habit = await newHabit(hero);
        await complete(habit, DateTime(2026, 3, 2, 18));

        final again = await repo.completeHabit(
          habit.id,
          DateTime(2026, 3, 2, 17),
        );

        expect(again, isA<AlreadyDoneToday>());
        expect((await repo.watchHero().first)?.exp, 20);
        expect(await repo.watchCompletionsOn(_monday).first, hasLength(1));
      },
    );

    test(
      'an archived habit cannot be completed and nothing is written',
      () async {
        final hero = await newHero();
        final habit = await newHabit(hero);
        await repo.archiveHabit(habit.id, _monday);

        final result = await repo.completeHabit(habit.id, _monday);

        expect(result, isA<HabitArchived>());
        expect((await repo.watchHero().first)?.exp, 0);
        expect(await repo.watchCompletionsOn(_monday).first, isEmpty);
      },
    );

    test('fails for an unknown habit', () async {
      await expectLater(
        repo.completeHabit('nope', _monday),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('levels up as many times as needed', () async {
      final hero = await newHero();
      final habit = await newHabit(hero, difficulty: Difficulty.hard);

      for (var day = 0; day < 3; day++) {
        await complete(habit, _monday.add(Duration(days: day)));
      }

      final after = await repo.watchHero().first;
      expect((after?.level, after?.exp, after?.rewardPoints), (2, 20, 5));
    });

    test(
      'keeps a daily streak across many days, then resets after a gap',
      () async {
        final hero = await newHero();
        final habit = await newHabit(hero);

        Completed? last;
        for (var day = 0; day < 10; day++) {
          last = await complete(habit, _monday.add(Duration(days: day)));
        }
        expect(last?.habit.streak, 10);

        final afterGap = await complete(
          habit,
          _monday.add(const Duration(days: 12)),
        );

        expect(afterGap.habit.streak, 1);
        expect(afterGap.habit.bestStreak, 10);
        expect(afterGap.habit.totalCompletions, 11);
      },
    );

    test('judges an xN streak week by week from the history', () async {
      final hero = await newHero();
      final habit = await newHabit(hero, frequency: Frequency.x3);
      for (final day in [0, 2, 4]) {
        await complete(habit, _monday.add(Duration(days: day)));
      }

      final nextWeek = await complete(
        habit,
        _monday.add(const Duration(days: 8)),
      );
      expect(nextWeek.habit.streak, 4);

      final afterSkippedWeek = await complete(
        habit,
        _monday.add(const Duration(days: 23)),
      );
      expect(afterSkippedWeek.habit.streak, 1);
      expect(afterSkippedWeek.habit.bestStreak, 4);
    });

    test('stores the habit frequency on the completion', () async {
      final hero = await newHero();
      final habit = await newHabit(hero, frequency: Frequency.x2);

      final done = await complete(habit, _monday);

      expect(done.completion.frequency, Frequency.x2);
    });
  });

  group('completion queries', () {
    test(
      'watchCompletionsOn holds only the local day, edges included',
      () async {
        final hero = await newHero();
        final a = await newHabit(hero);
        final b = await newHabit(hero);
        final lateYesterday = DateTime(2026, 3, 1, 23, 59, 59, 999);
        final midnight = DateTime(2026, 3, 2);
        final lateToday = DateTime(2026, 3, 2, 23, 59, 59, 999);
        final tomorrow = DateTime(2026, 3, 3);
        await complete(a, lateYesterday);
        final first = await complete(a, midnight);
        final second = await complete(b, lateToday);
        await complete(b, tomorrow);

        final today = await repo
            .watchCompletionsOn(DateTime(2026, 3, 2, 12))
            .first;

        expect(today, [first.completion, second.completion]);
      },
    );

    test('watchCompletionsBetween is from-inclusive, to-exclusive', () async {
      final hero = await newHero();
      final habit = await newHabit(hero);
      final d0 = await complete(habit, _monday);
      final d1 = await complete(habit, _monday.add(const Duration(days: 1)));
      await complete(habit, _monday.add(const Duration(days: 2)));

      final range = await repo
          .watchCompletionsBetween(
            _monday,
            _monday.add(const Duration(days: 2)),
          )
          .first;

      expect(range, [d0.completion, d1.completion]);
    });

    test('completionsBetween only returns the given habit', () async {
      final hero = await newHero();
      final a = await newHabit(hero);
      final b = await newHabit(hero);
      final doneA = await complete(a, _monday);
      await complete(b, _monday);

      final found = await repo.completionsBetween(
        a.id,
        _monday.subtract(const Duration(hours: 1)),
        _monday.add(const Duration(days: 1)),
      );

      expect(found, [doneA.completion]);
    });

    test('many completions at one instant keep a stable order by id', () async {
      final hero = await newHero();
      final done = <Completion>[];
      for (var i = 0; i < 40; i++) {
        final habit = await newHabit(hero);
        done.add((await complete(habit, _monday)).completion);
      }
      done.sort((a, b) => a.id.compareTo(b.id));

      final today = await repo.watchCompletionsOn(_monday).first;

      expect(today, done);
    });

    test('a daily streak survives the spring DST change', () async {
      final hero = await newHero();
      final habit = await newHabit(hero, now: DateTime(2026, 3, 27, 9));

      Completed? last;
      for (final day in [27, 28, 29, 30]) {
        last = await complete(habit, DateTime(2026, 3, day, 20));
      }

      expect(last?.habit.streak, 4);
    }, skip: _hasDst ? false : _needsDst);

    test('the today stream updates when a habit is completed', () async {
      final hero = await newHero();
      final habit = await newHabit(hero);
      final seen = next(repo.watchCompletionsOn(_monday), (l) => l.isNotEmpty);

      final done = await complete(habit, _monday);

      expect(await seen, [done.completion]);
    });
  });

  group('rewards', () {
    test('createReward returns the stored reward', () async {
      final hero = await newHero();

      final reward = await repo.createReward(
        heroId: hero.id,
        name: 'Cinema',
        note: 'Friday',
        tier: RewardTier.large,
        now: _monday,
      );

      expect(reward.id, isNotEmpty);
      expect(
        (reward.name, reward.note, reward.tier),
        ('Cinema', 'Friday', RewardTier.large),
      );
    });

    test('createReward fails for an unknown hero', () async {
      await expectLater(
        repo.createReward(
          heroId: 'nobody',
          name: 'x',
          tier: RewardTier.small,
          now: _monday,
        ),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('redeemReward fails for an unknown reward', () async {
      await expectLater(
        repo.redeemReward('nope', _monday),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test(
      'without enough points nothing changes and the reward stays',
      () async {
        final hero = await newHero();
        final reward = await repo.createReward(
          heroId: hero.id,
          name: 'Pizza',
          tier: RewardTier.small,
          now: _monday,
        );

        final result = await repo.redeemReward(reward.id, _monday);

        expect(result, isA<InsufficientPoints>());
        expect((result as InsufficientPoints).missing, RewardTier.small.cost);
        expect((await repo.watchHero().first)?.rewardPoints, 0);
        final retry = await repo.redeemReward(reward.id, _monday);
        expect(retry, isA<InsufficientPoints>(), reason: 'reward still exists');
      },
    );

    test(
      'redeeming pays, returns a receipt and marks the reward redeemed',
      () async {
        final hero = await newHero();
        final habit = await newHabit(hero, difficulty: Difficulty.hard);
        final reward = await repo.createReward(
          heroId: hero.id,
          name: 'Pizza',
          tier: RewardTier.small,
          now: _monday,
        );
        for (var day = 0; day < 5; day++) {
          await complete(habit, _monday.add(Duration(days: day)));
        }
        final before = await repo.watchHero().first;
        expect(before?.rewardPoints, 10);
        final redeemAt = _monday.add(const Duration(days: 5, hours: 3));

        final result = await repo.redeemReward(reward.id, redeemAt);

        expect(result, isA<Redeemed>());
        final redeemed = result as Redeemed;
        expect(redeemed.hero.rewardPoints, 0);
        expect(redeemed.redemption.rewardName, 'Pizza');
        expect(redeemed.redemption.cost, 10);
        expect(redeemed.redemption.levelAt, before?.level);
        expect(redeemed.redemption.at, redeemAt.toUtc());
        expect(await repo.watchHero().first, redeemed.hero);
        await expectLater(
          repo.redeemReward(reward.id, redeemAt),
          throwsA(isA<RewardAlreadyRedeemedException>()),
        );
        expect((await repo.watchHero().first)?.rewardPoints, 0);
      },
    );
  });
}

/// Whether the machine zone changes its clock in spring 2026 (run with
/// `TZ=Europe/Rome`). The DST test is skipped otherwise, visibly.
final _hasDst =
    DateTime(2026, 3, 30).difference(DateTime(2026, 3, 29)).inHours == 23;
const _needsDst = 'needs a zone with daylight saving: run TZ=Europe/Rome';

/// A Monday at 10:00, local time.
final _monday = DateTime(2026, 3, 2, 10);
