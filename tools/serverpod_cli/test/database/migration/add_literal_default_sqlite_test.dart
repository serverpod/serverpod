import 'dart:io';

import 'package:serverpod_cli/src/database/dialects/sqlite.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late ClientDatabaseSession session;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('sqlite_add_default_');
    session = await ClientDatabaseSession.open(
      '${directory.path}/test.db',
      _SerializationManager(),
      runMigrations: false,
    );
  });

  tearDown(() async {
    await session.close();
    await directory.delete(recursive: true);
  });

  test(
    'Given an existing row and new columns with literal defaults, '
    'when applying the generated SQLite migration, '
    'then old and new rows receive the defaults without a table rebuild.',
    () async {
      await session.db.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY) STRICT; '
        'INSERT INTO items VALUES (1);',
      );
      final columns = [
        ColumnDefinition(
          name: 'enabled',
          columnType: ColumnType.boolean,
          isNullable: false,
          columnDefault: defaultBooleanFalse,
        ),
        ColumnDefinition(
          name: 'amount',
          columnType: ColumnType.doublePrecision,
          isNullable: false,
          columnDefault: '-1.25e2',
        ),
        ColumnDefinition(
          name: 'label',
          columnType: ColumnType.text,
          isNullable: false,
          columnDefault: "'it''s; literal SQL'",
        ),
        ColumnDefinition(
          name: 'data',
          columnType: ColumnType.bytea,
          isNullable: false,
          columnDefault: "X'00ff'",
        ),
        ColumnDefinition(
          name: 'optional',
          columnType: ColumnType.text,
          isNullable: true,
          columnDefault: 'NULL',
        ),
      ];
      final sql = _addColumnsSql(columns);

      await session.db.unsafeExecute(sql);
      await session.db.unsafeExecute('INSERT INTO items(id) VALUES (2)');
      final rows = await session.db.unsafeQuery(
        'SELECT * FROM items ORDER BY id',
      );

      expect(sql, isNot(contains('DROP TABLE')));
      expect(rows.map((row) => row.toColumnMap()), [
        {
          'id': 1,
          'enabled': 0,
          'amount': -125.0,
          'label': "it's; literal SQL",
          'data': [0, 255],
          'optional': null,
        },
        {
          'id': 2,
          'enabled': 0,
          'amount': -125.0,
          'label': "it's; literal SQL",
          'data': [0, 255],
          'optional': null,
        },
      ]);
    },
  );

  test(
    'Given an existing row and a new column with a current-time default, '
    'when applying the generated SQLite migration, '
    'then the rebuild evaluates the expression for the existing row.',
    () async {
      await session.db.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY) STRICT; '
        'INSERT INTO items VALUES (1);',
      );
      final sql = _addColumnsSql([
        ColumnDefinition(
          name: 'created',
          columnType: ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          columnDefault: defaultDateTimeValueNow,
        ),
      ]);
      final before = DateTime.now().millisecondsSinceEpoch;

      await session.db.unsafeExecute(sql);
      final row = (await session.db.unsafeQuery('SELECT * FROM items')).single;

      expect(sql, contains('DROP TABLE'));
      expect(row.toColumnMap()['id'], 1);
      expect(
        row.toColumnMap()['created'],
        inInclusiveRange(before, DateTime.now().millisecondsSinceEpoch),
      );
    },
  );
}

String _addColumnsSql(List<ColumnDefinition> columns) {
  final table = TableDefinition(
    name: 'items',
    schema: 'main',
    columns: [
      ColumnDefinition(
        name: 'id',
        columnType: ColumnType.integer,
        isNullable: false,
        columnDefault: defaultIntSerial,
      ),
      ...columns,
    ],
    foreignKeys: [],
    indexes: [],
  );
  return TableMigration(
    name: 'items',
    schema: 'main',
    addColumns: columns,
    deleteColumns: [],
    modifyColumns: [],
    addIndexes: [],
    deleteIndexes: [],
    addForeignKeys: [],
    deleteForeignKeys: [],
    warnings: [],
  ).toSql(
    DatabaseDefinition(
      moduleName: 'test',
      tables: [table],
      installedModules: [],
      migrationApiVersion: 1,
    ),
  );
}

class _SerializationManager extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];
}
