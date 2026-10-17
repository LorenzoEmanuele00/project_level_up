import 'package:drift/drift.dart';

/// Stores an instant as epoch milliseconds (an integer) and always reads it
/// back as a UTC [DateTime].
///
/// drift's own `DateTime` column keeps whole seconds only (or ISO text whose
/// ordering breaks when microseconds appear). Integer milliseconds round-trip
/// exactly, sort numerically for range queries, and `DateTime ==` compares
/// `isUtc` too, so normalising on read keeps equality stable.
class UtcMillisConverter extends TypeConverter<DateTime, int> {
  const UtcMillisConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMillisecondsSinceEpoch(fromDb, isUtc: true);

  @override
  int toSql(DateTime value) => value.millisecondsSinceEpoch;
}
