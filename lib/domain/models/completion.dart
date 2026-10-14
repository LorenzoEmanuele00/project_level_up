/// One recorded completion of a habit, with the EXP it granted.
class Completion {
  const Completion({
    required this.id,
    required this.habitId,
    required this.at,
    required this.exp,
  });

  final String id;
  final String habitId;
  final DateTime at;
  final int exp;

  Completion copyWith({String? id, String? habitId, DateTime? at, int? exp}) =>
      Completion(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        at: at ?? this.at,
        exp: exp ?? this.exp,
      );

  @override
  bool operator ==(Object other) =>
      other is Completion &&
      other.id == id &&
      other.habitId == habitId &&
      other.at == at &&
      other.exp == exp;

  @override
  int get hashCode => Object.hash(id, habitId, at, exp);
}
