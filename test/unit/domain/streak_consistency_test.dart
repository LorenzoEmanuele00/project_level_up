import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/game_rules.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/results.dart';

import 'support/fixtures.dart';

// Coherence between what complete() and refreshStreak() store on the habit
// (streak, bestStreak) and what the full completion history says. The
// reference below recomputes everything from the history alone, with its own
// day and week arithmetic (epoch day numbers), not the calendar helpers.

/// One day of a scripted run: an optional frequency change, then (maybe) a
/// completion at [hour] o'clock.
typedef _Step = ({DateTime day, bool completes, Frequency? changeTo, int hour});

_Step _step(
  DateTime day, {
  bool completes = true,
  Frequency? changeTo,
  int hour = 9,
}) => (day: day, completes: completes, changeTo: changeTo, hour: hour);

typedef _Run = ({Habit habit, List<Completion> history});

/// Plays [steps] through complete(), feeding it the window the contract
/// promises: from the start of the previous week up to the completion time.
_Run _play(
  Habit start,
  Iterable<_Step> steps, {
  void Function(Habit habit, List<Completion> history)? afterCompletion,
}) {
  var habit = start;
  final history = <Completion>[];
  for (final step in steps) {
    final changeTo = step.changeTo;
    if (changeTo != null) habit = habit.copyWith(frequency: changeTo);
    if (!step.completes) continue;

    final now = DateTime(
      step.day.year,
      step.day.month,
      step.day.day,
      step.hour,
    );
    final result = complete(
      hero: heroFixture(),
      habit: habit,
      now: now,
      completionId: 'c${history.length}',
      weekCompletions: _window(history, now),
    );
    expect(result, isA<Completed>(), reason: 'completing on $now');
    final done = result as Completed;
    habit = done.habit;
    history.add(done.completion);
    afterCompletion?.call(habit, List.unmodifiable(history));
  }
  return (habit: habit, history: history);
}

/// The completions of [history] that `complete()` is given for [now].
List<Completion> _window(List<Completion> history, DateTime now) {
  final from = completionWindowStart(now);
  final to = completionWindowEnd(now);
  return [
    for (final c in history)
      if (!c.at.isBefore(from) && c.at.isBefore(to)) c,
  ];
}

// --- Independent reference -------------------------------------------------

int _epochDay(DateTime t) =>
    DateTime.utc(t.year, t.month, t.day).millisecondsSinceEpoch ~/ 86400000;

// 1970-01-01 was a Thursday, so Monday-based weeks shift by 3 days.
int _weekOf(int epochDay) => (epochDay + 3) ~/ 7;

int _quota(Frequency frequency, DateTime createdAt, int week) {
  final createdDay = _epochDay(createdAt);
  if (_weekOf(createdDay) != week) return frequency.weeklyQuota;
  final sunday = week * 7 + 3;
  final daysLeft = sunday - createdDay + 1;
  return min(frequency.weeklyQuota, daysLeft);
}

/// Whether the chain ending at [previous] is over by [nextDay].
bool _chainBroken(
  List<Completion> history,
  Completion previous,
  DateTime nextDay,
  DateTime createdAt,
) {
  final previousDay = _epochDay(previous.at);
  final nextEpochDay = _epochDay(nextDay);
  if (previous.frequency == Frequency.daily) {
    return nextEpochDay - previousDay > 1;
  }
  final previousWeek = _weekOf(previousDay);
  final weeksApart = _weekOf(nextEpochDay) - previousWeek;
  if (weeksApart <= 0) return false;
  if (weeksApart > 1) return true;
  final inWeek = history.where((c) => _weekOf(_epochDay(c.at)) == previousWeek);
  return inWeek.length < _quota(previous.frequency, createdAt, previousWeek);
}

typedef _Reference = ({int streak, int best});

/// Streak and best streak the history implies right after its last item.
_Reference _reference(List<Completion> history, DateTime createdAt) {
  var chain = 0;
  var best = 0;
  for (var i = 0; i < history.length; i++) {
    final broken =
        i == 0 ||
        _chainBroken(history, history[i - 1], history[i].at, createdAt);
    chain = broken ? 1 : chain + 1;
    best = max(best, chain);
  }
  return (streak: chain, best: best);
}

/// Streak the history implies when looked at on [today], without completing.
int _referenceStreakOn(
  List<Completion> history,
  DateTime createdAt,
  DateTime today,
) {
  if (history.isEmpty) return 0;
  final streak = _reference(history, createdAt).streak;
  final last = history.last;
  return _chainBroken(history, last, today, createdAt) ? 0 : streak;
}

/// Plays [steps], comparing the stored streaks with the reference after every
/// completion; then looks at the habit on the following days, checking the
/// lazy reset.
void _expectCoherent(Habit start, List<_Step> steps) {
  final createdAt = start.createdAt;
  final run = _play(
    start,
    steps,
    afterCompletion: (habit, history) {
      final expected = _reference(history, createdAt);
      final when = history.last.at;
      expect(habit.streak, expected.streak, reason: 'streak at $when');
      expect(habit.bestStreak, expected.best, reason: 'bestStreak at $when');
      expect(habit.totalCompletions, history.length);
    },
  );
  if (run.history.isEmpty) return;

  final last = run.history.last.at;
  for (var offset = 0; offset <= 21; offset++) {
    final day = addLocalDays(last, offset);
    // Late in the day, so that a completion made earlier that day is in the
    // window (the window ends at the moment of the call).
    final today = DateTime(day.year, day.month, day.day, 23, 59);
    final refreshed = refreshStreak(
      run.habit,
      today: today,
      completions: _window(run.history, today),
    );
    expect(
      refreshed.streak,
      _referenceStreakOn(run.history, createdAt, today),
      reason: 'refreshed on $today',
    );
    expect(refreshed.bestStreak, run.habit.bestStreak);
  }
}

List<_Step> _randomSteps({
  required int seed,
  required DateTime from,
  required int days,
  required double pComplete,
  required double pChange,
}) {
  final random = Random(seed);
  return [
    for (var i = 0; i < days; i++)
      _step(
        addLocalDays(from, i),
        completes: random.nextDouble() < pComplete,
        changeTo: random.nextDouble() < pChange
            ? Frequency.values[random.nextInt(Frequency.values.length)]
            : null,
        hour: 6 + random.nextInt(17),
      ),
  ];
}

/// Whether the machine zone changes its clock in spring 2026 (run with
/// `TZ=Europe/Rome`). The DST tests are skipped otherwise, visibly.
final _hasDst =
    DateTime(2026, 3, 30).difference(DateTime(2026, 3, 29)).inHours == 23;
const _needsDst = 'needs a zone with daylight saving: run TZ=Europe/Rome';

void main() {
  group('hand-checked histories', () {
    test('daily: a skipped day restarts the streak, best is kept', () {
      final may = DateTime(2026, 5);
      final run = _play(habitFixture(createdAt: DateTime(2026, 5, 4)), [
        for (final d in [4, 5, 6]) _step(addLocalDays(may, d - 1)),
        _step(addLocalDays(may, 6), completes: false),
        for (final d in [8, 9, 10]) _step(addLocalDays(may, d - 1)),
      ]);

      expect(run.habit.streak, 3);
      expect(run.habit.bestStreak, 3);
      expect(run.habit.totalCompletions, 6);
    });

    test('x3 then x2: quota judged with the frequency of each week', () {
      Habit habit() => habitFixture(
        frequency: Frequency.x3,
        createdAt: DateTime(2026, 5, 4),
      );
      final run = _play(habit(), [
        for (final d in [4, 6, 8]) _step(DateTime(2026, 5, d)),
        for (final d in [11, 12]) _step(DateTime(2026, 5, d)),
        // Week of the 11th fell short (2 of 3): the streak restarts.
        _step(DateTime(2026, 5, 18)),
        // Switch to x2: the week of the 18th is judged as x2 (3 done >= 2).
        _step(DateTime(2026, 5, 19), changeTo: Frequency.x2),
        _step(DateTime(2026, 5, 20)),
        _step(DateTime(2026, 5, 25)),
      ]);

      expect(run.habit.bestStreak, 5);
      expect(run.habit.streak, 4);
      expect(run.history.last.frequency, Frequency.x2);
    });

    test('x3 switched to x5 on Sunday: the week stays valid', () {
      final run = _play(
        habitFixture(frequency: Frequency.x3, createdAt: DateTime(2026, 5, 4)),
        [
          for (final d in [4, 5, 6]) _step(DateTime(2026, 5, d)),
          _step(
            DateTime(2026, 5, 10),
            completes: false,
            changeTo: Frequency.x5,
          ),
          _step(DateTime(2026, 5, 11)),
        ],
      );

      expect(run.habit.streak, 4);
    });

    test('x3 switched to x5 on Tuesday: 3 completions Wed-Fri fail', () {
      final run = _play(
        habitFixture(frequency: Frequency.x3, createdAt: DateTime(2026, 5, 4)),
        [
          _step(DateTime(2026, 5, 5), completes: false, changeTo: Frequency.x5),
          for (final d in [6, 7, 8]) _step(DateTime(2026, 5, d)),
          _step(DateTime(2026, 5, 11)),
        ],
      );

      expect(run.habit.streak, 1);
      expect(run.habit.bestStreak, 3);
    });
  });

  group('against the reference computed from the history', () {
    test('the spring DST day is 23 hours long (guard)', () {
      expect(
        DateTime(2026, 3, 30).difference(DateTime(2026, 3, 29)).inHours,
        23,
        reason: 'run with TZ=Europe/Rome',
      );
    }, skip: _hasDst ? false : _needsDst);

    test('daily with gaps across the spring DST change', () {
      _expectCoherent(
        habitFixture(createdAt: DateTime(2026, 3, 2)),
        _randomSteps(
          seed: 1,
          from: DateTime(2026, 3, 2),
          days: 60,
          pComplete: 0.85,
          pChange: 0,
        ),
      );
    }, skip: _hasDst ? false : _needsDst);

    test('x3 over several weeks with skipped weeks', () {
      _expectCoherent(
        habitFixture(frequency: Frequency.x3, createdAt: DateTime(2026, 5, 6)),
        _randomSteps(
          seed: 2,
          from: DateTime(2026, 5, 6),
          days: 90,
          pComplete: 0.4,
          pChange: 0,
        ),
      );
    });

    test('frequency changes across the autumn DST change', () {
      for (final seed in [3, 4, 5, 6, 7]) {
        _expectCoherent(
          habitFixture(
            frequency: Frequency.x5,
            createdAt: DateTime(2026, 10, 7),
          ),
          _randomSteps(
            seed: seed,
            from: DateTime(2026, 10, 7),
            days: 75,
            pComplete: 0.6,
            pChange: 0.08,
          ),
        );
      }
    }, skip: _hasDst ? false : _needsDst);

    test('many random histories, mixed frequencies', () {
      for (var seed = 100; seed < 130; seed++) {
        final random = Random(seed);
        final start = DateTime(
          2026,
          1 + random.nextInt(10),
          1 + random.nextInt(28),
        );
        _expectCoherent(
          habitFixture(
            frequency: Frequency.values[random.nextInt(4)],
            createdAt: start,
          ),
          _randomSteps(
            seed: seed,
            from: start,
            days: 80,
            pComplete: 0.3 + random.nextDouble() * 0.6,
            pChange: 0.05,
          ),
        );
      }
    });
  });
}
