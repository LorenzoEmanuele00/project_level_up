import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/in_memory_game_repository.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/state/game_providers.dart';
import 'package:levelup/state/today_providers.dart';

/// Whether the machine zone has daylight saving in 2026 (Europe/Rome: run
/// with `TZ=Europe/Rome`). The DST tests are skipped otherwise.
final _hasDst =
    DateTime(2026, 3, 30).difference(DateTime(2026, 3, 29)).inHours == 23;
const _needsDst = 'needs a zone with daylight saving: run TZ=Europe/Rome';

/// `testWidgets` can only skip with a flag, so the reason goes in the name.
final _skipNote = _hasDst ? '' : ' [skipped: $_needsDst]';

/// An in-memory repository that counts the streak refreshes and can fail.
class _SpyRepository extends InMemoryGameRepository {
  final refreshedAt = <DateTime>[];
  Object? refreshError;
  Object? habitsError;

  @override
  Future<void> refreshStreaks(DateTime now) async {
    refreshedAt.add(now);
    final error = refreshError;
    if (error != null) throw error;
    return super.refreshStreaks(now);
  }

  @override
  Stream<List<Habit>> watchHabits({bool includeArchived = false}) {
    final error = habitsError;
    return error == null
        ? super.watchHabits(includeArchived: includeArchived)
        : Stream.error(error);
  }
}

/// A container whose clock is [now]: tests move it together with the fake
/// time they pump.
class _Harness {
  _Harness(this.now) {
    container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(repo),
        clockProvider.overrideWithValue(() => now),
      ],
    );
  }

  DateTime now;
  final repo = _SpyRepository();
  late final ProviderContainer container;

  /// Moves the clock and the fake time by [elapsed].
  Future<void> elapse(WidgetTester tester, Duration elapsed) async {
    now = now.add(elapsed);
    await tester.pump(elapsed);
  }

  DateTime get today => container.read(todayProvider);

  /// Collects every change of [todayProvider].
  List<DateTime> trackDays() {
    final days = <DateTime>[];
    final sub = container.listen(todayProvider, (_, next) => days.add(next));
    addTearDown(sub.close);
    return days;
  }
}

/// A widget test with a [_Harness] whose clock starts at [start].
///
/// The container is disposed inside the test body: `testWidgets` checks for
/// pending timers before the tear-downs run.
void _scenario(
  String description,
  DateTime start,
  Future<void> Function(WidgetTester tester, _Harness harness) body, {
  bool skip = false,
}) {
  testWidgets(description, (tester) async {
    final harness = _Harness(start);
    try {
      await body(tester, harness);
    } finally {
      harness.container.dispose();
    }
  }, skip: skip);
}

/// Lets chained streams and provider rebuilds settle. Riverpod and the
/// streams schedule each link of the chain on its own turn, so a single
/// zero-length pump is not enough.
Future<void> _flush(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 1));
  }
}

Future<Habit> _seedHabit(WidgetTester tester, _Harness h) async {
  return (await tester.runAsync(() async {
    final hero = await h.repo.createHero(
      avatarMode: AvatarMode.initial,
      accent: AccentKey.sage,
      theme: ThemeKey.light,
      now: DateTime(2026, 1, 1),
    );
    return h.repo.createHabit(
      heroId: hero.id,
      name: 'Read',
      icon: 'book',
      difficulty: Difficulty.medium,
      frequency: Frequency.daily,
      hue: HabitHue.teal,
      now: DateTime(2026, 1, 1),
    );
  }))!;
}

void main() {
  group('todayProvider', () {
    _scenario(
      'starts on the local day of the clock',
      DateTime(2026, 3, 4, 15, 30),
      (tester, h) async {
        expect(h.today, DateTime(2026, 3, 4));
      },
    );

    _scenario(
      'moves to the next day at local midnight, not before',
      DateTime(2026, 3, 4, 23, 59),
      (tester, h) async {
        final days = h.trackDays();
        expect(h.today, DateTime(2026, 3, 4));

        await h.elapse(tester, const Duration(seconds: 59));
        expect(days, isEmpty);

        await h.elapse(tester, const Duration(seconds: 1));
        expect(days, [DateTime(2026, 3, 5)]);
      },
    );

    _scenario(
      'keeps ticking: every midnight is followed by the next',
      DateTime(2026, 3, 4, 23, 59),
      (tester, h) async {
        final days = h.trackDays();
        h.today; // build

        await h.elapse(tester, const Duration(minutes: 1));
        await h.elapse(tester, const Duration(days: 1));

        expect(days, [DateTime(2026, 3, 5), DateTime(2026, 3, 6)]);
      },
    );

    _scenario(
      'the night of 28 to 29 March lasts a 23-hour day$_skipNote',
      DateTime(2026, 3, 28, 23),
      (tester, h) async {
        final days = h.trackDays();
        h.today;

        await h.elapse(tester, const Duration(hours: 1));
        expect(days, [DateTime(2026, 3, 29)]);

        await h.elapse(tester, const Duration(hours: 22, minutes: 59));
        expect(days, hasLength(1), reason: 'one minute still to go');
        await h.elapse(tester, const Duration(minutes: 1));
        expect(days, [DateTime(2026, 3, 29), DateTime(2026, 3, 30)]);
      },
      skip: !_hasDst,
    );

    _scenario(
      '25 October lasts 25 hours$_skipNote',
      DateTime(2026, 10, 24, 23),
      (tester, h) async {
        final days = h.trackDays();
        h.today;

        await h.elapse(tester, const Duration(hours: 1));
        expect(days, [DateTime(2026, 10, 25)]);

        await h.elapse(tester, const Duration(hours: 24, minutes: 59));
        expect(days, hasLength(1), reason: 'one minute still to go');
        await h.elapse(tester, const Duration(minutes: 1));
        expect(days, [DateTime(2026, 10, 25), DateTime(2026, 10, 26)]);
      },
      skip: !_hasDst,
    );

    _scenario(
      'a timer that fires early waits again, at least one second',
      DateTime(2026, 3, 4, 23, 59),
      (tester, h) async {
        final days = h.trackDays();
        h.today;

        // The timer fires, but the clock is half a second short of midnight.
        h.now = DateTime(2026, 3, 4, 23, 59, 59, 500);
        await tester.pump(const Duration(minutes: 1));
        expect(days, isEmpty);

        // Midnight passes at once: only the one-second floor holds it back.
        h.now = DateTime(2026, 3, 5, 0, 0, 0, 200);
        await tester.pump(const Duration(milliseconds: 900));
        expect(days, isEmpty);
        await tester.pump(const Duration(milliseconds: 100));
        expect(days, [DateTime(2026, 3, 5)]);
      },
    );

    _scenario(
      'refresh picks up a clock that jumped, and only then',
      DateTime(2026, 3, 4, 10),
      (tester, h) async {
        final days = h.trackDays();
        final notifier = h.container.read(todayProvider.notifier);

        notifier.refresh();
        expect(days, isEmpty, reason: 'same day: no change');

        h.now = DateTime(2026, 3, 6, 9);
        notifier.refresh();
        expect(days, [DateTime(2026, 3, 6)]);
      },
    );

    _scenario(
      'refresh reschedules: one change per midnight, not two',
      DateTime(2026, 3, 4, 23, 59),
      (tester, h) async {
        final days = h.trackDays();
        final notifier = h.container.read(todayProvider.notifier);

        notifier.refresh();
        notifier.refresh();
        await h.elapse(tester, const Duration(minutes: 1));
        await h.elapse(tester, const Duration(hours: 23, minutes: 59));

        expect(days, [DateTime(2026, 3, 5)]);
      },
    );

    testWidgets('disposing the container cancels the timer', (tester) async {
      final h = _Harness(DateTime(2026, 3, 4, 23, 59));
      h.today;

      h.container.dispose();

      // testWidgets fails on a Timer left pending; nothing may fire either.
      await tester.pump(const Duration(days: 2));
    });
  });

  group('completionWindowProvider', () {
    _scenario(
      'holds the completions from last week to the end of today',
      DateTime(2026, 3, 4, 12),
      (tester, h) async {
        final habit = await _seedHabit(tester, h);
        await tester.runAsync(() async {
          await h.repo.completeHabit(habit.id, DateTime(2026, 2, 22, 10));
          await h.repo.completeHabit(habit.id, DateTime(2026, 2, 23, 10));
          await h.repo.completeHabit(habit.id, DateTime(2026, 3, 4, 20));
          await h.repo.completeHabit(habit.id, DateTime(2026, 3, 5, 10));
        });
        final sub = h.container.listen(completionWindowProvider, (_, _) {});
        addTearDown(sub.close);
        await _flush(tester);

        final days = h.container
            .read(completionWindowProvider)
            .requireValue
            .map((c) => c.at.toLocal().day);
        expect(days, [23, 4]);
      },
    );

    _scenario(
      'subscribes again with the new window when the day changes',
      DateTime(2026, 3, 8, 23, 59),
      (tester, h) async {
        // Sunday: the window starts 23 February. On Monday it starts 2 March.
        final habit = await _seedHabit(tester, h);
        await tester.runAsync(() async {
          await h.repo.completeHabit(habit.id, DateTime(2026, 2, 23, 10));
          await h.repo.completeHabit(habit.id, DateTime(2026, 3, 3, 10));
        });
        final sub = h.container.listen(completionWindowProvider, (_, _) {});
        addTearDown(sub.close);
        await _flush(tester);
        expect(
          h.container.read(completionWindowProvider).requireValue,
          hasLength(2),
        );

        await h.elapse(tester, const Duration(minutes: 1));
        await _flush(tester);

        final window = h.container.read(completionWindowProvider).requireValue;
        expect(window.map((c) => c.at.toLocal().day), [3]);
      },
    );
  });

  group('streakRefreshProvider', () {
    _scenario(
      'resets the expired streaks of the repository',
      DateTime(2026, 3, 5, 9),
      (tester, h) async {
        final habit = await _seedHabit(tester, h);
        await tester.runAsync(() async {
          await h.repo.completeHabit(habit.id, DateTime(2026, 3, 2, 10));
          await h.repo.completeHabit(habit.id, DateTime(2026, 3, 3, 10));
        });
        final sub = h.container.listen(streakRefreshProvider, (_, _) {});
        addTearDown(sub.close);

        await _flush(tester);

        final habits = await tester.runAsync(() => h.repo.watchHabits().first);
        expect(habits?.single.streak, 0);
        expect(h.repo.refreshedAt, [DateTime(2026, 3, 5, 9)]);
      },
    );

    _scenario('runs again on the new day', DateTime(2026, 3, 4, 23, 59), (
      tester,
      h,
    ) async {
      final sub = h.container.listen(streakRefreshProvider, (_, _) {});
      addTearDown(sub.close);
      await _flush(tester);
      expect(h.repo.refreshedAt, hasLength(1));

      await h.elapse(tester, const Duration(minutes: 1));
      await _flush(tester);

      expect(h.repo.refreshedAt, [
        DateTime(2026, 3, 4, 23, 59),
        DateTime(2026, 3, 5),
      ]);
    });

    _scenario(
      'does not run again when the habits change',
      DateTime(2026, 3, 4, 9),
      (tester, h) async {
        final habit = await _seedHabit(tester, h);
        final sub = h.container.listen(streakRefreshProvider, (_, _) {});
        addTearDown(sub.close);
        final habitsSub = h.container.listen(activeHabitsProvider, (_, _) {});
        addTearDown(habitsSub.close);
        await _flush(tester);

        await tester.runAsync(() => h.repo.archiveHabit(habit.id, h.now));
        await _flush(tester);

        expect(h.repo.refreshedAt, hasLength(1));
      },
    );

    _scenario('invalidating it refreshes again', DateTime(2026, 3, 4, 9), (
      tester,
      h,
    ) async {
      final sub = h.container.listen(streakRefreshProvider, (_, _) {});
      addTearDown(sub.close);
      await _flush(tester);

      h.container.invalidate(streakRefreshProvider);
      await _flush(tester);

      expect(h.repo.refreshedAt, hasLength(2));
    });

    _scenario(
      'a failure ends up in the provider state',
      DateTime(2026, 3, 4, 9),
      (tester, h) async {
        h.repo.refreshError = StateError('disk failure');
        final sub = h.container.listen(streakRefreshProvider, (_, _) {});
        addTearDown(sub.close);

        await _flush(tester);

        expect(h.container.read(streakRefreshProvider).hasError, isTrue);
      },
    );
  });

  group('todaySummaryProvider', () {
    _scenario(
      'is loading until the habits and completions arrive',
      DateTime(2026, 3, 4, 9),
      (tester, h) async {
        final sub = h.container.listen(todaySummaryProvider, (_, _) {});
        addTearDown(sub.close);

        expect(h.container.read(todaySummaryProvider).isLoading, isTrue);
        await _flush(tester);

        expect(h.container.read(todaySummaryProvider).hasValue, isTrue);
      },
    );

    _scenario(
      'summarises the due habits and what was done today',
      DateTime(2026, 3, 4, 12),
      (tester, h) async {
        final habit = await _seedHabit(tester, h);
        await tester.runAsync(
          () => h.repo.completeHabit(habit.id, DateTime(2026, 3, 4, 8)),
        );
        final sub = h.container.listen(todaySummaryProvider, (_, _) {});
        addTearDown(sub.close);

        await _flush(tester);

        final summary = h.container.read(todaySummaryProvider).requireValue;
        expect(summary.dueCount, 1);
        expect(summary.doneCount, 1);
        expect(summary.expToday, 20);
        expect(summary.allDone, isTrue);
      },
    );

    _scenario('follows a completion made later', DateTime(2026, 3, 4, 12), (
      tester,
      h,
    ) async {
      final habit = await _seedHabit(tester, h);
      final sub = h.container.listen(todaySummaryProvider, (_, _) {});
      addTearDown(sub.close);
      await _flush(tester);
      expect(
        h.container.read(todaySummaryProvider).requireValue.allDone,
        isFalse,
      );

      await tester.runAsync(() => h.repo.completeHabit(habit.id, h.now));
      await _flush(tester);

      final summary = h.container.read(todaySummaryProvider).requireValue;
      expect(summary.doneCount, 1);
      expect(summary.expToday, 20);
    });

    _scenario(
      'never goes back to loading when the day changes',
      DateTime(2026, 3, 4, 23, 59),
      (tester, h) async {
        await _seedHabit(tester, h);
        final states = <bool>[];
        final sub = h.container.listen(
          todaySummaryProvider,
          (_, next) => states.add(next.hasValue),
        );
        addTearDown(sub.close);
        await _flush(tester);

        await h.elapse(tester, const Duration(minutes: 1));
        await _flush(tester);

        expect(states, isNotEmpty);
        expect(states, everyElement(isTrue));
        expect(
          h.container.read(todaySummaryProvider).requireValue.dueHabits,
          hasLength(1),
        );
      },
    );

    _scenario(
      'a failing source turns into an error',
      DateTime(2026, 3, 4, 12),
      (tester, h) async {
        h.repo.habitsError = StateError('disk failure');
        final sub = h.container.listen(todaySummaryProvider, (_, _) {});
        addTearDown(sub.close);

        await _flush(tester);

        expect(h.container.read(todaySummaryProvider).hasError, isTrue);
      },
    );
  });
}
