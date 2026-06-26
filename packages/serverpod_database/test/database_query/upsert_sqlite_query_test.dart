import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/sqlite/value_encoder.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class UuidRowTable extends Table<int?> {
  late final ColumnUuid rowUuid;

  UuidRowTable() : super(tableName: 'uuid_row') {
    rowUuid = ColumnUuid('rowUuid', this);
  }

  @override
  List<Column> get columns => [id, rowUuid];
}

class UuidRow implements TableRow<int?> {
  UuidRow({this.id, required this.rowUuid});

  @override
  int? id;

  final UuidValue rowUuid;

  @override
  Table<int?> get table => UuidRowTable();

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'rowUuid': rowUuid.toJson(),
    };
  }
}

void main() {
  ValueEncoder.set(const SqliteValueEncoder());

  test(
    'Given a model with a UUID column, '
    'when building an upsert query for SQLite, '
    'then UUID values are encoded as BLOB literals.',
    () {
      var table = UuidRowTable();
      var uuidString = '550e8400-e29b-41d4-a716-446655440000';
      var uuidHex = uuidString.replaceAll('-', '').toLowerCase();

      var query = InsertQueryBuilder(
        table: table,
        rows: [
          UuidRow(
            id: 1,
            rowUuid: UuidValue.fromString(uuidString),
          ),
        ],
        conflictColumns: [table.id],
      ).build();

      expect(query, contains("X'$uuidHex'"));
      expect(query, isNot(contains("'$uuidString'")));
    },
  );
}
