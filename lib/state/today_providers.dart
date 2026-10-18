import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/game_rules.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/today.dart';
import 'package:levelup/state/game_providers.dart';

/// Shortest wait before the day change is checked again. A timer that fires
/// slightly early must not spin.
const _minimumTimerDelay = Duration(seconds: 1);

/// The current local day (at 00:00), kept up to date.
///
/// A timer moves it to the next day at local midnight. The wait is the real
/// time to the next local midnight, so days of 23 or 25 hours (daylight
/// saving) are right. [refresh] re-reads the clock, for when the app comes
/// back from the background and timers may have been suspended.
class TodayNotifier extends Notifier<DateTime> {
  Timer? _timer;

  @override
  DateTime build() {
    ref.onDispose(() => _timer?.cancel());
    final now = ref.read(clockProvider)();
    _scheduleNextMidnight(now);
    return localDay(now);
  }

  /// Re-reads the clock and moves to the day it shows, if it changed.
  void refresh() {
    final now = ref.read(clockProvider)();
    final day = localDay(now);
    if (day != state) state = day;
    _scheduleNextMidnight(now);
  }

  void _scheduleNextMidnight(DateTime now) {
    _timer?.cancel();
    final untilMidnight = addLocalDays(localDay(now), 1).difference(now);
    final wait = untilMidnight < _minimumTimerDelay
        ? _minimumTimerDelay
        : untilMidnight;
    _timer = Timer(wait, refresh);
  }
}

/// The current local day, see [TodayNotifier].
final todayProvider = NotifierProvider<TodayNotifier, DateTime>(
  TodayNotifier.new,
);

/// The completions the home needs: from the start of last week to the end of
/// today. It subscribes again with the new window when the day changes.
final completionWindowProvider = StreamProvider<List<Completion>>((ref) {
  final day = ref.watch(todayProvider);
  return ref
      .watch(gameRepositoryProvider)
      .watchCompletionsBetween(
        completionWindowStart(day),
        completionWindowEnd(day),
      );
});

/// Resets the streaks that expired, once per day (and on demand, by
/// invalidating it).
///
/// It deliberately does not watch the habits: its own writes would trigger
/// it again.
final streakRefreshProvider = FutureProvider<void>((ref) {
  ref.watch(todayProvider);
  return ref
      .watch(gameRepositoryProvider)
      .refreshStreaks(ref.read(clockProvider)());
});

/// What the home shows for today.
///
/// Synchronous on purpose: while the sources reload (for example at midnight)
/// the previous value stays, so the screen does not flash a loading state.
final todaySummaryProvider = Provider<AsyncValue<TodaySummary>>((ref) {
  final day = ref.watch(todayProvider);
  final habits = ref.watch(activeHabitsProvider);
  final completions = ref.watch(completionWindowProvider);

  final failure = habits.hasError ? habits : completions;
  if (failure.hasError) {
    return AsyncError(failure.error!, failure.stackTrace ?? StackTrace.empty);
  }
  final loadedHabits = habits.value;
  final loadedCompletions = completions.value;
  if (loadedHabits == null || loadedCompletions == null) {
    return const AsyncLoading();
  }
  return AsyncData(
    summarizeToday(
      habits: loadedHabits,
      completions: loadedCompletions,
      day: day,
    ),
  );
});
