import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:levelup/data/database/tables.dart';
import 'package:levelup/data/database/utc_millis_converter.dart';
import 'package:levelup/domain/enums.dart';

export 'package:levelup/data/database/tables.dart';

part 'app_database.g.dart';

/// File name of the on-device SQLite database.
const _databaseName = 'levelup';

/// The local SQLite database (drift).
///
/// The generated `app_database.g.dart` is committed, like `lib/l10n`.
/// Regenerate it with `dart run build_runner build --delete-conflicting-outputs`
/// and, after any schema change, bump [schemaVersion] and export the schema
/// with `dart run drift_dev schema dump`.
@DriftDatabase(tables: [Heroes, Habits, Rewards, Redemptions, Completions])
class AppDatabase extends _$AppDatabase {
  /// Opens the real on-device database, or [executor] when given (tests).
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: _databaseName));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
