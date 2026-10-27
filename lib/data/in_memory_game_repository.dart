import 'dart:async';

import 'package:levelup/data/game_repository.dart';
import 'package:levelup/data/instant.dart';
import 'package:levelup/data/new_entities.dart';
import 'package:levelup/domain/calendar.dart';
import 'package:levelup/domain/enums.dart';
import 'package:levelup/domain/game_rules.dart';
import 'package:levelup/domain/models.dart';
import 'package:levelup/domain/results.dart';
import 'package:uuid/uuid.dart';

typedef _StoredHero = ({GameHero hero, DateTime createdAt});
typedef _StoredHabit = ({Habit habit, String heroId});
typedef _StoredReward = ({Reward reward, String heroId, DateTime? redeemedAt});

/// A [GameRepository] that keeps everything in memory.
///
/// For tests and for running the app without a database. It follows the same
/// contract as the drift implementation (see the shared contract suite).
class InMemoryGameRepository implements GameRepository {
  InMemoryGameRepository({IdGenerator? newId})
    : _newId = newId ?? (() => const Uuid().v4());

  final IdGenerator _newId;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  List<_StoredHero> _heroes = const [];
  List<_StoredHabit> _habits = const [];
  List<_StoredReward> _rewards = const [];
  List<Completion> _completions = const [];

  /// Closes the change controller. Streams already open stop updating; the
  /// repository itself keeps working.
  Future<void> dispose() => _changes.close();

  /// Re-emits the value of [read] on listen and after every change.
  Stream<T> _watch<T>(T Function() read) {
    late final StreamController<T> controller;
    StreamSubscription<void>? subscription;
    controller = StreamController<T>(
      onListen: () {
        controller.add(read());
        subscription = _changes.stream.listen((_) => controller.add(read()));
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  void _notify() {
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  Stream<GameHero?> watchHero() => _watch(() {
    if (_heroes.isEmpty) return null;
    final sorted = List.of(_heroes)
      ..sort((a, b) {
        final byCreation = a.createdAt.compareTo(b.createdAt);
        return byCreation != 0 ? byCreation : a.hero.id.compareTo(b.hero.id);
      });
    return sorted.first.hero;
  });

  @override
  Stream<List<Habit>> watchHabits({bool includeArchived = false}) => _watch(() {
    final habits = [
      for (final stored in _habits)
        if (includeArchived || !stored.habit.archived) stored.habit,
    ];
    return habits..sort((a, b) {
      final byCreation = a.createdAt.compareTo(b.createdAt);
      return byCreation != 0 ? byCreation : a.id.compareTo(b.id);
    });
  });

  List<Completion> _completionsIn(
    DateTime from,
    DateTime to, [
    String? habitId,
  ]) {
    final start = from.millisecondsSinceEpoch;
    final end = to.millisecondsSinceEpoch;
    final found = [
      for (final c in _completions)
        if ((habitId == null || c.habitId == habitId) &&
            c.at.millisecondsSinceEpoch >= start &&
            c.at.millisecondsSinceEpoch < end)
          c,
    ];
    // Instant first, then id: a total order, so ties never depend on how the
    // sort treats equal elements.
    return found..sort((a, b) {
      final byInstant = a.at.compareTo(b.at);
      return byInstant != 0 ? byInstant : a.id.compareTo(b.id);
    });
  }

  @override
  Stream<List<Completion>> watchCompletionsBetween(
    DateTime from,
    DateTime to,
  ) => _watch(() => _completionsIn(from, to));

  @override
  Stream<List<Completion>> watchCompletionsOn(DateTime day) {
    final start = localDay(day);
    return watchCompletionsBetween(start, addLocalDays(start, 1));
  }

  @override
  Future<List<Completion>> completionsBetween(
    String habitId,
    DateTime from,
    DateTime to,
  ) async => _completionsIn(from, to, habitId);

  @override
  Future<GameHero> createHero({
    required AvatarMode avatarMode,
    required AccentKey accent,
    required ThemeKey theme,
    required DateTime now,
    String? userId,
    String? name,
    String? avatarIcon,
    HeroClass? heroClass,
  }) async {
    final hero = newHero(
      id: _newId(),
      userId: userId,
      name: name,
      avatarMode: avatarMode,
      avatarIcon: avatarIcon,
      accent: accent,
      heroClass: heroClass,
      theme: theme,
    );
    _heroes = [..._heroes, (hero: hero, createdAt: normalizeInstant(now))];
    _notify();
    return hero;
  }

  GameHero _requireHero(String heroId) => _heroes
      .firstWhere(
        (h) => h.hero.id == heroId,
        orElse: () => throw EntityNotFoundException('hero', heroId),
      )
      .hero;

  @override
  Future<Habit> createHabit({
    required String heroId,
    required String name,
    required String icon,
    required Difficulty difficulty,
    required Frequency frequency,
    required HabitHue hue,
    required DateTime now,
  }) async {
    _requireHero(heroId);
    final habit = newHabit(
      id: _newId(),
      name: name,
      icon: icon,
      difficulty: difficulty,
      frequency: frequency,
      hue: hue,
      now: now,
    );
    _habits = [..._habits, (habit: habit, heroId: heroId)];
    _notify();
    return habit;
  }

  @override
  Future<Reward> createReward({
    required String heroId,
    required String name,
    required RewardTier tier,
    required DateTime now,
    String? note,
  }) async {
    _requireHero(heroId);
    final reward = Reward(id: _newId(), name: name, note: note, tier: tier);
    _rewards = [
      ..._rewards,
      (reward: reward, heroId: heroId, redeemedAt: null),
    ];
    _notify();
    return reward;
  }

  _StoredHabit _requireHabit(String habitId) => _habits.firstWhere(
    (h) => h.habit.id == habitId,
    orElse: () => throw EntityNotFoundException('habit', habitId),
  );

  @override
  Future<void> archiveHabit(String habitId, DateTime now) async {
    final stored = _requireHabit(habitId);
    _replaceHabit(stored.habit.copyWith(archived: true), stored.heroId);
    _notify();
  }

  void _replaceHabit(Habit habit, String heroId) {
    _habits = [
      for (final stored in _habits)
        if (stored.habit.id == habit.id)
          (habit: habit, heroId: heroId)
        else
          stored,
    ];
  }

  void _replaceHero(GameHero hero) {
    _heroes = [
      for (final stored in _heroes)
        if (stored.hero.id == hero.id)
          (hero: hero, createdAt: stored.createdAt)
        else
          stored,
    ];
  }

  @override
  Future<void> refreshStreaks(DateTime now) async {
    final at = normalizeInstant(now);
    final window = _completionsIn(
      completionWindowStart(at),
      completionWindowEnd(at),
    );
    final refreshed = <_StoredHabit>[];
    var changed = false;
    for (final stored in _habits) {
      final streak = stored.habit.archived || stored.habit.streak == 0
          ? stored.habit.streak
          : refreshStreak(stored.habit, today: at, completions: window).streak;
      if (streak == stored.habit.streak) {
        refreshed.add(stored);
      } else {
        changed = true;
        refreshed.add((
          habit: stored.habit.copyWith(streak: streak),
          heroId: stored.heroId,
        ));
      }
    }
    _habits = refreshed;
    if (changed) _notify();
  }

  @override
  Future<CompletionResult> completeHabit(String habitId, DateTime now) async {
    final at = normalizeInstant(now);
    final stored = _requireHabit(habitId);
    final result = complete(
      hero: _requireHero(stored.heroId),
      habit: stored.habit,
      now: at,
      completionId: _newId(),
      weekCompletions: _completionsIn(
        completionWindowStart(at),
        completionWindowEnd(at),
        habitId,
      ),
    );
    if (result is! Completed) return result;

    _replaceHero(result.hero);
    _replaceHabit(result.habit, stored.heroId);
    _completions = [..._completions, result.completion];
    _notify();
    return result;
  }

  @override
  Future<RedeemResult> redeemReward(String rewardId, DateTime now) async {
    final stored = _rewards.firstWhere(
      (r) => r.reward.id == rewardId,
      orElse: () => throw EntityNotFoundException('reward', rewardId),
    );
    if (stored.redeemedAt != null) {
      throw RewardAlreadyRedeemedException(rewardId);
    }
    final at = normalizeInstant(now);
    final result = redeem(
      hero: _requireHero(stored.heroId),
      reward: stored.reward,
      redemptionId: _newId(),
      at: at,
    );
    if (result is! Redeemed) return result;

    _replaceHero(result.hero);
    _rewards = [
      for (final r in _rewards)
        if (r.reward.id == rewardId)
          (reward: r.reward, heroId: r.heroId, redeemedAt: at)
        else
          r,
    ];
    _notify();
    return result;
  }
}
