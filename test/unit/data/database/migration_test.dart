import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/data/database/app_database.dart';

import '../../../generated_migrations/schema.dart';

/// Guards the exported schemas in `drift_schemas/`.
///
/// `SchemaVerifier.migrateAndValidate` cannot catch a table changed in code
/// but not re-exported (it only compares the exported schema with itself when
/// no migration runs), so the schema of the code is compared directly with the
/// database built from `drift_schemas/drift_schema_v1.json`: the normalised
/// `CREATE` statements (CHECKs, defaults, ON DELETE), columns, keys with their
/// actions, and indexes. After changing a
/// table: bump `schemaVersion`, run `dart run drift_dev schema dump ...` and
/// `dart run drift_dev schema generate ...` (see CLAUDE.md), then add a step
/// here that migrates from the previous version.
typedef _Query = Future<List<Map<String, Object?>>> Function(String sql);

const _tableNamesSql =
    "SELECT name FROM sqlite_master WHERE type = 'table' "
    "AND name NOT LIKE 'sqlite_%' ORDER BY name";

const _definitionsSql =
    'SELECT type, name, sql FROM sqlite_master '
    "WHERE name NOT LIKE 'sqlite_%' ORDER BY type, name";

/// The SQL of a definition without quoting, case or whitespace differences.
String _normalizeSql(Object? sql) => '$sql'
    .replaceAll(RegExp('["`]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .replaceAll(RegExp(r'\s*([(),])\s*'), r'$1')
    .toLowerCase()
    .trim();

/// A comparable text description of tables, keys and indexes.
Future<List<String>> _describeSchema(_Query query) async {
  final lines = <String>[];
  final definitions = await query(_definitionsSql);
  for (final d in definitions) {
    lines.add('${d['type']} ${d['name']}: ${_normalizeSql(d['sql'])}');
  }
  final tables = await query(_tableNamesSql);
  for (final table in tables.map((t) => t['name']! as String)) {
    for (final c in await query("PRAGMA table_info('$table')")) {
      lines.add(
        '$table.${c['name']} ${c['type']} '
        'notnull=${c['notnull']} pk=${c['pk']}',
      );
    }
    for (final fk in await query("PRAGMA foreign_key_list('$table')")) {
      lines.add(
        '$table.${fk['from']} -> ${fk['table']}.${fk['to']} '
        'on_update=${fk['on_update']} on_delete=${fk['on_delete']} '
        'match=${fk['match']}',
      );
    }
    for (final index in await query("PRAGMA index_list('$table')")) {
      final name = index['name']! as String;
      final columns = await query("PRAGMA index_info('$name')");
      final names = columns.map((c) => c['name']).join(',');
      lines.add('$table index $name($names) unique=${index['unique']}');
    }
  }
  return lines;
}

void main() {
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('the schema declared in code matches the exported v1 schema', () async {
    final exported = await verifier.schemaAt(1);
    addTearDown(exported.rawDatabase.close);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final fromCode = await _describeSchema(
      (sql) async =>
          (await db.customSelect(sql).get()).map((r) => r.data).toList(),
    );
    final fromExport = await _describeSchema(
      (sql) async => exported.rawDatabase
          .select(sql)
          .map((r) => Map<String, Object?>.from(r))
          .toList(),
    );

    expect(fromCode, isNotEmpty);
    expect(fromCode, fromExport);
  });
}
