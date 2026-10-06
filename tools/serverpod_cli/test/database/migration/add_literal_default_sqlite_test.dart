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

  group('Given an existing row and new columns with literal defaults, ', () {
    late List<ColumnDefinition> columns;

    setUp(() async {
      await session.db.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY) STRICT; '
        'INSERT INTO items VALUES (1);',
      );
      columns = [
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
    });

    group('when applying the generated SQLite migration, ', () {
      late String sql;
      late DatabaseResult rows;

      setUp(() async {
        sql = _addColumnsSql(columns);
        await session.db.unsafeExecute(sql);
        await session.db.unsafeExecute('INSERT INTO items(id) VALUES (2)');
        rows = await session.db.unsafeQuery('SELECT * FROM items ORDER BY id');
      });

      test('then the migration does not rebuild the table.', () {
        expect(sql, isNot(contains('DROP TABLE')));
      });

      test('then old and new rows receive the defaults.', () {
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
      });
    });
  });

  group(
    'Given an existing row and a new column with a current-time default, ',
    () {
      late List<ColumnDefinition> columns;

      setUp(() async {
        await session.db.unsafeExecute(
          'CREATE TABLE items (id INTEGER PRIMARY KEY) STRICT; '
          'INSERT INTO items VALUES (1);',
        );
        columns = [
          ColumnDefinition(
            name: 'created',
            columnType: ColumnType.timestampWithoutTimeZone,
            isNullable: false,
            columnDefault: defaultDateTimeValueNow,
          ),
        ];
      });

      group('when applying the generated SQLite migration, ', () {
        late String sql;
        late Map<String, dynamic> row;
        late int before;
        late int after;

        setUp(() async {
          sql = _addColumnsSql(columns);
          before = DateTime.now().millisecondsSinceEpoch;
          await session.db.unsafeExecute(sql);
          row = (await session.db.unsafeQuery(
            'SELECT * FROM items',
          )).single.toColumnMap();
          after = DateTime.now().millisecondsSinceEpoch;
        });

        test('then the migration rebuilds the table.', () {
          expect(sql, contains('DROP TABLE'));
        });

        test(
          'then the rebuild evaluates the expression for the existing row.',
          () {
            expect(row['id'], 1);
            expect(row['created'], inInclusiveRange(before, after));
          },
        );
      });
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
