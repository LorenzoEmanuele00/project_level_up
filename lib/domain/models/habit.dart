import 'package:levelup/domain/enums.dart';

/// A habit the user wants to repeat.
///
/// Immutable. When it was last completed is not stored here: it comes from
/// the recorded completions.
class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.difficulty,
    required this.frequency,
    required this.hue,
    required this.streak,
    required this.bestStreak,
    required this.totalCompletions,
    required this.archived,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String icon;
  final Difficulty difficulty;
  final Frequency frequency;
  final HabitHue hue;
  final int streak;
  final int bestStreak;
  final int totalCompletions;
  final bool archived;

  /// When the habit was created. Drives the partial first week quota.
  final DateTime createdAt;

  /// EXP earned per completion, derived from [difficulty].
  int get exp => difficulty.exp;

  Habit copyWith({
    String? id,
    String? name,
    String? icon,
    Difficulty? difficulty,
    Frequency? frequency,
    HabitHue? hue,
    int? streak,
    int? bestStreak,
    int? totalCompletions,
    bool? archived,
    DateTime? createdAt,
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    difficulty: difficulty ?? this.difficulty,
    frequency: frequency ?? this.frequency,
    hue: hue ?? this.hue,
    streak: streak ?? this.streak,
    bestStreak: bestStreak ?? this.bestStreak,
    totalCompletions: totalCompletions ?? this.totalCompletions,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  bool operator ==(Object other) =>
      other is Habit &&
      other.id == id &&
      other.name == name &&
      other.icon == icon &&
      other.difficulty == difficulty &&
      other.frequency == frequency &&
      other.hue == hue &&
      other.streak == streak &&
      other.bestStreak == bestStreak &&
      other.totalCompletions == totalCompletions &&
      other.archived == archived &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icon,
    difficulty,
    frequency,
    hue,
    streak,
    bestStreak,
    totalCompletions,
    archived,
    createdAt,
  );
}
