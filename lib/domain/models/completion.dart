import 'package:levelup/domain/enums.dart';

/// One recorded completion of a habit, with the EXP it granted.
///
/// [frequency] is the habit's frequency at the moment of completion: the
/// history keeps it so that a week can be judged with the frequency that was
/// in force then, even if the habit has changed since.
class Completion {
  const Completion({
    required this.id,
    required this.habitId,
    required this.at,
    required this.exp,
    required this.frequency,
  });

  final String id;
  final String habitId;
  final DateTime at;
  final int exp;
  final Frequency frequency;

  Completion copyWith({
    String? id,
    String? habitId,
    DateTime? at,
    int? exp,
    Frequency? frequency,
  }) => Completion(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    at: at ?? this.at,
    exp: exp ?? this.exp,
    frequency: frequency ?? this.frequency,
  );

  @override
  bool operator ==(Object other) =>
      other is Completion &&
      other.id == id &&
      other.habitId == habitId &&
      other.at == at &&
      other.exp == exp &&
      other.frequency == frequency;

  @override
  int get hashCode => Object.hash(id, habitId, at, exp, frequency);
}
