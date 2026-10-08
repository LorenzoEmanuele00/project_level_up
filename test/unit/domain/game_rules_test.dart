import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/game_config.dart';
import 'package:levelup/domain/game_rules.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/results.dart';
import 'package:levelup/domain/schedule.dart';

import 'support/fixtures.dart';

// A Wednesday.
final _now = DateTime(2026, 5, 13, 10);

Completed _complete({
  GameHero? hero,
  Habit? habit,
  DateTime? now,
  Iterable<Completion> weekCompletions = const [],
  GameConfig config = GameConfig.standard,
}) {
  final result = complete(
    hero: hero ?? heroFixture(),
    habit: habit ?? habitFixture(),
    now: now ?? _now,
    completionId: 'new-completion',
    weekCompletions: weekCompletions,
    config: config,
  );
  expect(result, isA<Completed>());
  return result as Completed;
}

void main() {
  group('applyExp', () {
    test('adds exp without levelling below the threshold', () {
      final r = applyExp(level: 1, exp: 50, rp: 0, gainedExp: 20);

      expect(r.level, 1);
      expect(r.exp, 70);
      expect(r.rp, 0);
      expect(r.levelsGained, 0);
      expect(r.rpGained, 0);
    });

    test('levels up on exactly expPerLevel and leaves 0 exp', () {
      final r = applyExp(level: 1, exp: 60, rp: 2, gainedExp: 40);

      expect(r.level, 2);
      expect(r.exp, 0);
      expect(r.rp, 7);
      expect(r.levelsGained, 1);
      expect(r.rpGained, 5);
    });

    test('keeps the remainder after a level up', () {
      final r = applyExp(level: 3, exp: 90, rp: 0, gainedExp: 40);

      expect(r.level, 4);
      expect(r.exp, 30);
    });

    test('levels up several times in one go', () {
      final r = applyExp(level: 1, exp: 0, rp: 0, gainedExp: 250);

      expect(r.level, 3);
      expect(r.exp, 50);
      expect(r.levelsGained, 2);
      expect(r.rpGained, 10);
      expect(r.rp, 10);
    });

    test('uses the custom rpPerLevel and expPerLevel', () {
      const config = GameConfig(expPerLevel: 50, rpPerLevel: 3);

      final r = applyExp(
        level: 1,
        exp: 0,
        rp: 0,
        gainedExp: 120,
        config: config,
      );

      expect(r.level, 3);
      expect(r.exp, 20);
      expect(r.rpGained, 6);
    });
  });

  group('complete', () {
    test('grants exp by difficulty', () {
      for (final (difficulty, exp) in [
        (Difficulty.facile, 10),
        (Difficulty.media, 20),
        (Difficulty.difficile, 40),
      ]) {
        final done = _complete(habit: habitFixture(difficulty: difficulty));

        expect(done.hero.exp, exp, reason: '$difficulty');
        expect(done.completion.exp, exp, reason: '$difficulty');
      }
    });

    test('levels up when exp reaches exactly expPerLevel', () {
      final done = _complete(
        hero: heroFixture(exp: 60),
        habit: habitFixture(difficulty: Difficulty.difficile),
      );

      expect(done.hero.level, 2);
      expect(done.hero.exp, 0);
      expect(done.hero.rewardPoints, 5);
    });

    test('levels up several times when the hero starts far above', () {
      const config = GameConfig(expPerLevel: 20);
      final done = _complete(
        hero: heroFixture(exp: 14),
        habit: habitFixture(difficulty: Difficulty.difficile),
        config: config,
      );

      expect(done.hero.level, 3);
      expect(done.hero.exp, 14);
      expect(done.hero.rewardPoints, 10);
      expect(done.feedback, isA<LevelledUp>());
      expect((done.feedback as LevelledUp).levelsGained, 2);
    });

    test('pays the custom rpPerLevel on level up', () {
      final done = _complete(
        hero: heroFixture(exp: 90),
        config: const GameConfig(rpPerLevel: 8),
      );

      expect(done.hero.rewardPoints, 8);
      expect((done.feedback as LevelledUp).rpGained, 8);
    });

    test('feedback is ExpGained without a level up', () {
      final done = _complete(hero: heroFixture(exp: 10));

      expect(done.feedback, isA<ExpGained>());
      final feedback = done.feedback as ExpGained;
      expect(feedback.exp, 20);
      expect(feedback.habitName, 'Read');
    });

    test('feedback is LevelledUp exactly when reward points are gained', () {
      final done = _complete(hero: heroFixture(level: 4, exp: 95));

      final feedback = done.feedback;
      expect(feedback, isA<LevelledUp>());
      expect((feedback as LevelledUp).newLevel, 5);
      expect(feedback.levelsGained, 1);
      expect(feedback.rpGained, 5);
    });

    test('increments streak and total completions and stamps the time', () {
      final yesterday = DateTime(2026, 5, 12, 9);
      final done = _complete(
        habit: habitFixture(
          streak: 3,
          bestStreak: 3,
          totalCompletions: 7,
          lastCompletedAt: yesterday,
        ),
      );

      expect(done.habit.streak, 4);
      expect(done.habit.totalCompletions, 8);
      expect(done.habit.lastCompletedAt, _now);
    });

    test('raises bestStreak when the streak passes it', () {
      final done = _complete(
        habit: habitFixture(
          streak: 3,
          bestStreak: 3,
          lastCompletedAt: DateTime(2026, 5, 12),
        ),
      );

      expect(done.habit.bestStreak, 4);
    });

    test('keeps bestStreak when it is already higher', () {
      final done = _complete(
        habit: habitFixture(
          streak: 3,
          bestStreak: 10,
          lastCompletedAt: DateTime(2026, 5, 12),
        ),
      );

      expect(done.habit.streak, 4);
      expect(done.habit.bestStreak, 10);
    });

    test('records a completion with id, habit, time and exp', () {
      final done = _complete(
        habit: habitFixture(id: 'h-9', difficulty: Difficulty.facile),
      );

      expect(
        done.completion,
        Completion(id: 'new-completion', habitId: 'h-9', at: _now, exp: 10),
      );
    });

    test('does nothing when already done earlier today', () {
      final habit = habitFixture(lastCompletedAt: DateTime(2026, 5, 13, 0, 5));

      final result = complete(
        hero: heroFixture(),
        habit: habit,
        now: _now,
        completionId: 'x',
        weekCompletions: const [],
      );

      expect(result, isA<AlreadyDoneToday>());
    });

    test('does nothing for an archived habit', () {
      final result = complete(
        hero: heroFixture(),
        habit: habitFixture(archived: true),
        now: _now,
        completionId: 'x',
        weekCompletions: const [],
      );

      expect(result, isA<HabitArchived>());
    });

    test('reports archived before already done', () {
      final result = complete(
        hero: heroFixture(),
        habit: habitFixture(archived: true, lastCompletedAt: _now),
        now: _now,
        completionId: 'x',
        weekCompletions: const [],
      );

      expect(result, isA<HabitArchived>());
    });

    test('allows 23:59 and then 00:01 of the next day', () {
      final late = DateTime(2026, 5, 13, 23, 59);
      final first = _complete(now: late);

      final second = complete(
        hero: first.hero,
        habit: first.habit,
        now: DateTime(2026, 5, 14, 0, 1),
        completionId: 'second',
        weekCompletions: [first.completion],
      );

      expect(second, isA<Completed>());
      expect((second as Completed).habit.streak, 2);
    });

    test('leaves the inputs untouched', () {
      final hero = heroFixture(exp: 95);
      final habit = habitFixture(streak: 2, bestStreak: 2);
      final week = [completionFixture(DateTime(2026, 5, 11))];

      _complete(hero: hero, habit: habit, weekCompletions: week);

      expect(hero, heroFixture(exp: 95));
      expect(habit, habitFixture(streak: 2, bestStreak: 2));
      expect(week, [completionFixture(DateTime(2026, 5, 11))]);
    });
  });

  group('refreshStreak', () {
    Habit streaking({
      Frequency frequency = Frequency.daily,
      required DateTime last,
      int streak = 5,
      int bestStreak = 9,
      DateTime? createdAt,
    }) => habitFixture(
      frequency: frequency,
      streak: streak,
      bestStreak: bestStreak,
      lastCompletedAt: last,
      createdAt: createdAt,
    );

    test('leaves a habit that was never completed untouched', () {
      final habit = habitFixture();

      expect(refreshStreak(habit, today: _now, completions: const []), habit);
    });

    test('daily keeps the streak when completed yesterday', () {
      final habit = streaking(last: DateTime(2026, 5, 12, 0, 5));

      final result = refreshStreak(habit, today: _now, completions: const []);

      expect(result, habit);
    });

    test('daily keeps the streak when completed today', () {
      final habit = streaking(last: DateTime(2026, 5, 13, 8));

      expect(refreshStreak(habit, today: _now, completions: const []), habit);
    });

    test('daily resets after skipping a whole day', () {
      final habit = streaking(last: DateTime(2026, 5, 11, 23, 59));

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 5, 13, 0, 1),
        completions: const [],
      );

      expect(result.streak, 0);
    });

    test('never touches bestStreak or the other fields', () {
      final habit = streaking(last: DateTime(2026, 5, 1));

      final result = refreshStreak(habit, today: _now, completions: const []);

      expect(result, habit.copyWith(streak: 0));
      expect(result.bestStreak, 9);
      expect(result.lastCompletedAt, DateTime(2026, 5, 1));
    });

    test('is idempotent', () {
      final habit = streaking(last: DateTime(2026, 5, 1));

      final once = refreshStreak(habit, today: _now, completions: const []);
      final twice = refreshStreak(once, today: _now, completions: const []);

      expect(twice, once);
    });

    test('daily across the spring DST change keeps a consecutive streak', () {
      final habit = streaking(last: DateTime(2026, 3, 28, 23, 30));

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 3, 29, 0, 30),
        completions: const [],
      );

      expect(result.streak, 5);
    });

    test('daily across the DST changes resets only after a skipped day', () {
      final spring = streaking(last: DateTime(2026, 3, 28, 23, 30));
      final autumn = streaking(last: DateTime(2026, 10, 24, 23, 30));

      expect(
        refreshStreak(
          spring,
          today: DateTime(2026, 3, 30, 0, 30),
          completions: const [],
        ).streak,
        0,
      );
      expect(
        refreshStreak(
          autumn,
          today: DateTime(2026, 10, 25, 23, 30),
          completions: const [],
        ).streak,
        5,
      );
      expect(
        refreshStreak(
          autumn,
          today: DateTime(2026, 10, 26, 0, 30),
          completions: const [],
        ).streak,
        0,
      );
    });

    test('xN keeps the streak while still in the same week', () {
      final habit = streaking(
        frequency: Frequency.x3,
        last: DateTime(2026, 5, 11, 9),
      );

      expect(
        refreshStreak(
          habit,
          today: DateTime(2026, 5, 17, 22),
          completions: const [],
        ),
        habit,
      );
    });

    test('xN keeps the streak if last week met the quota', () {
      final habit = streaking(
        frequency: Frequency.x2,
        last: DateTime(2026, 5, 7, 9),
      );
      final lastWeek = [
        completionFixture(DateTime(2026, 5, 5, 9)),
        completionFixture(DateTime(2026, 5, 7, 9)),
      ];

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 5, 13),
        completions: lastWeek,
      );

      expect(result, habit);
    });

    test('xN resets if last week fell short of the quota', () {
      final habit = streaking(
        frequency: Frequency.x3,
        last: DateTime(2026, 5, 7, 9),
      );
      final lastWeek = [
        completionFixture(DateTime(2026, 5, 5, 9)),
        completionFixture(DateTime(2026, 5, 7, 9)),
      ];

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 5, 13),
        completions: lastWeek,
      );

      expect(result.streak, 0);
    });

    test('xN keeps the streak when today is before the last completion', () {
      // Clock or time-zone change: "today" falls in the week before `last`.
      final habit = streaking(
        frequency: Frequency.x3,
        last: DateTime(2026, 5, 13, 9),
      );

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 5, 6),
        completions: const [],
      );

      expect(result, habit);
    });

    test('xN counts only completions of the same habit', () {
      final habit = streaking(
        frequency: Frequency.x2,
        last: DateTime(2026, 5, 7, 9),
      );
      final lastWeek = [
        completionFixture(DateTime(2026, 5, 7, 9)),
        completionFixture(DateTime(2026, 5, 6, 9), habitId: 'other'),
      ];

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 5, 13),
        completions: lastWeek,
      );

      expect(result.streak, 0);
    });

    test('xN resets when the last completion is older than last week', () {
      final habit = streaking(
        frequency: Frequency.x2,
        last: DateTime(2026, 4, 30, 9),
      );
      final old = [
        completionFixture(DateTime(2026, 4, 28, 9)),
        completionFixture(DateTime(2026, 4, 30, 9)),
      ];

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 5, 13),
        completions: old,
      );

      expect(result.streak, 0);
    });

    test('xN does not penalise a partial first week', () {
      final habit = streaking(
        frequency: Frequency.x5,
        last: DateTime(2026, 5, 16, 9),
        createdAt: DateTime(2026, 5, 14),
      );
      final firstWeek = [
        for (final day in [14, 15, 16, 17])
          completionFixture(DateTime(2026, 5, day, 9)),
      ];

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 5, 20),
        completions: firstWeek,
      );

      expect(result, habit);
    });

    test('xN across the week of a DST change is judged by calendar week', () {
      final habit = streaking(
        frequency: Frequency.x2,
        last: DateTime(2026, 3, 29, 12),
      );
      final week = [
        completionFixture(DateTime(2026, 3, 23, 9)),
        completionFixture(DateTime(2026, 3, 29, 12)),
      ];

      final result = refreshStreak(
        habit,
        today: DateTime(2026, 3, 30, 0, 10),
        completions: week,
      );

      expect(result, habit);
    });
  });

  group('complete with a stale streak', () {
    test('daily restarts at 1 instead of old + 1', () {
      final done = _complete(
        habit: habitFixture(
          streak: 7,
          bestStreak: 7,
          lastCompletedAt: DateTime(2026, 5, 10, 9),
        ),
      );

      expect(done.habit.streak, 1);
      expect(done.habit.bestStreak, 7);
    });

    test('xN restarts at 1 after a week below quota', () {
      final done = _complete(
        habit: habitFixture(
          frequency: Frequency.x3,
          streak: 4,
          bestStreak: 4,
          lastCompletedAt: DateTime(2026, 5, 6, 9),
        ),
        weekCompletions: [completionFixture(DateTime(2026, 5, 6, 9))],
      );

      expect(done.habit.streak, 1);
    });

    test('xN continues when the previous week met its quota', () {
      final done = _complete(
        habit: habitFixture(
          frequency: Frequency.x2,
          streak: 4,
          bestStreak: 4,
          lastCompletedAt: DateTime(2026, 5, 7, 9),
        ),
        weekCompletions: [
          completionFixture(DateTime(2026, 5, 5, 9)),
          completionFixture(DateTime(2026, 5, 7, 9)),
        ],
      );

      expect(done.habit.streak, 5);
    });

    test('xN may be completed beyond the weekly quota', () {
      final week = [
        for (final day in [11, 12])
          completionFixture(DateTime(2026, 5, day, 9)),
      ];

      final done = _complete(
        habit: habitFixture(
          frequency: Frequency.x2,
          streak: 2,
          bestStreak: 2,
          lastCompletedAt: DateTime(2026, 5, 12, 9),
        ),
        weekCompletions: week,
      );

      expect(done.habit.streak, 3);
      expect(done.hero.exp, 20);
    });
  });

  group('redeem', () {
    final at = DateTime(2026, 5, 13, 18);

    RedeemResult redeemWith(int rp, RewardTier tier, {int level = 4}) => redeem(
      hero: heroFixture(level: level, rewardPoints: rp),
      reward: Reward(id: 'r1', name: 'Gelato', tier: tier),
      redemptionId: 'red-1',
      at: at,
    );

    test('pays exactly the cost and leaves 0 points', () {
      final result = redeemWith(25, RewardTier.media);

      expect(result, isA<Redeemed>());
      expect((result as Redeemed).hero.rewardPoints, 0);
    });

    test('keeps the excess points', () {
      final result = redeemWith(70, RewardTier.grande) as Redeemed;

      expect(result.hero.rewardPoints, 10);
    });

    test('records a redemption snapshot with the hero level', () {
      final result = redeemWith(12, RewardTier.piccola, level: 7) as Redeemed;

      expect(
        result.redemption,
        Redemption(
          id: 'red-1',
          rewardName: 'Gelato',
          cost: 10,
          levelAt: 7,
          at: at,
        ),
      );
    });

    test('changes only the reward points of the hero', () {
      final hero = heroFixture(level: 3, exp: 40, rewardPoints: 30);

      final result = redeem(
        hero: hero,
        reward: const Reward(id: 'r', name: 'n', tier: RewardTier.media),
        redemptionId: 'x',
        at: at,
      );

      expect((result as Redeemed).hero, hero.copyWith(rewardPoints: 5));
    });

    test('reports the missing points when short', () {
      final result = redeemWith(4, RewardTier.piccola);

      expect(result, isA<InsufficientPoints>());
      expect((result as InsufficientPoints).missing, 6);
    });

    test('reports the full cost when the hero has no points', () {
      final result = redeemWith(0, RewardTier.grande) as InsufficientPoints;

      expect(result.missing, 60);
    });

    test('reports a single missing point', () {
      final result = redeemWith(59, RewardTier.grande) as InsufficientPoints;

      expect(result.missing, 1);
    });
  });

  group('levelsNeededFor', () {
    test('divides the cost by 5 rp per level, rounding up', () {
      expect(levelsNeededFor(10), 2);
      expect(levelsNeededFor(25), 5);
      expect(levelsNeededFor(60), 12);
    });

    test('rounds up with 3 rp per level', () {
      const config = GameConfig(rpPerLevel: 3);

      expect(levelsNeededFor(10, config: config), 4);
      expect(levelsNeededFor(25, config: config), 9);
      expect(levelsNeededFor(60, config: config), 20);
    });

    test('is 0 for a free reward', () {
      expect(levelsNeededFor(0), 0);
    });
  });

  group('questPct', () {
    test('is 1 when nothing is due', () {
      expect(questPct(done: 0, due: 0), 1.0);
    });

    test('is the fraction of due habits done', () {
      expect(questPct(done: 1, due: 4), 0.25);
      expect(questPct(done: 3, due: 3), 1.0);
      expect(questPct(done: 0, due: 5), 0.0);
    });

    test('counts a habit done today that is still due', () {
      // x3 habit: Mon and Tue done, completed again on Wed (still due).
      final habit = habitFixture(frequency: Frequency.x3);
      final week = [
        completionFixture(DateTime(2026, 5, 11, 9)),
        completionFixture(DateTime(2026, 5, 12, 9)),
        completionFixture(DateTime(2026, 5, 13, 9)),
      ];
      final doneToday = habit.copyWith(
        lastCompletedAt: DateTime(2026, 5, 13, 9),
      );
      final due = isDueOn(doneToday, DateTime(2026, 5, 13), week) ? 1 : 0;
      final done = isDoneOn(doneToday, DateTime(2026, 5, 13)) ? 1 : 0;

      expect(questPct(done: done, due: due), 1.0);
    });
  });
}
