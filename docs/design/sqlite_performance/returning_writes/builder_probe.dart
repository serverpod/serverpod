// Exercise the production builder and encoder against a real SQLite schema.
import 'dart:convert';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/sqlite/value_encoder.dart';
import 'package:sqlite3/sqlite3.dart';

class DefaultTable extends Table<int?> {
  DefaultTable() : super(tableName: 'defaults');

  late final value = ColumnInt('value', this, hasDefault: true);

  @override
  List<Column> get columns => [id, value];
}

class DefaultRow implements TableRow<int?> {
  DefaultRow(this.table, this.id);

  @override
  final DefaultTable table;

  @override
  final int? id;

  @override
  Map<String, dynamic> toJson() => {'id': id, 'value': null};
}

void main() {
  ValueEncoder.set(const SqliteValueEncoder());
  final table = DefaultTable();
  final sql = InsertQueryBuilder(
    table: table,
    rows: [DefaultRow(table, 1)],
    conflictColumns: [table.id],
  ).build();
  final db = sqlite3.openInMemory();

  try {
    db.execute(
      'CREATE TABLE defaults(id INTEGER PRIMARY KEY, value INTEGER DEFAULT 10)',
    );
    SqliteException? rejected;

    try {
      db.select(sql);
    } on SqliteException catch (error) {
      rejected = error;
    }

    if (rejected == null || !rejected.message.contains('DEFAULT')) {
      throw StateError('Expected the current inline DEFAULT failure: $sql');
    }

    final omitted = db.select('''
INSERT INTO defaults(id) VALUES(1)
ON CONFLICT(id) DO UPDATE SET value=excluded.value
RETURNING *''').rows;

    if (jsonEncode(omitted) != '[[1,10]]') {
      throw StateError('Omitting the defaulted column failed: $omitted');
    }

    print(
      const JsonEncoder.withIndent('  ').convert({
        'sqlite_version': db
            .select('SELECT sqlite_version()')
            .rows
            .single
            .single,
        'production_builder_sql': sql,
        'production_builder_error': rejected.message,
        'omitted_column_upsert': omitted,
      }),
    );
  } finally {
    db.close();
  }
}
