import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  late ClientDatabaseSession session;
  late _TestSerializationManager serializationManager;

  setUp(() async {
    final directory = await Directory.systemTemp.createTemp('sqlite_bulk_');
    addTearDown(() => directory.delete(recursive: true));

    serializationManager = _TestSerializationManager();
    session = await ClientDatabaseSession.open(
      p.join(directory.path, 'test.db'),
      serializationManager,
      runMigrations: false,
    );
    addTearDown(session.close);

    await session.db.unsafeExecute('''
      CREATE TABLE serverpod_sqlite_schema (
        table_name TEXT NOT NULL,
        column_name TEXT NOT NULL,
        column_type TEXT NOT NULL,
        column_vector_dimension INTEGER
      );
    ''');
  });

  test(
    'Given a table missing a declared column, '
    'when exporting its data, '
    'then a BulkDataException reports the missing column.',
    () async {
      serializationManager.tables.add(
        _table(
          extraColumns: [
            ColumnDefinition(
              name: 'age',
              columnType: ColumnType.bigint,
              isNullable: false,
            ),
          ],
        ),
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
      );

      await expectLater(
        DatabaseBulkData.exportTableData(
          database: session.db,
          table: 'example',
        ),
        throwsA(
          isA<BulkDataException>().having(
            (e) => e.message,
            'message',
            contains('Column "age"'),
          ),
        ),
      );
    },
  );

  test(
    'Given a table matching its declaration, '
    'when exporting its data, '
    'then the rows are returned.',
    () async {
      serializationManager.tables.add(_table());
      await session.db.unsafeExecute(
        'CREATE TABLE example (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
      );
      await session.db.unsafeExecute(
        "INSERT INTO example (id, name) VALUES (1, 'first');",
      );

      final bulkData = await DatabaseBulkData.exportTableData(
        database: session.db,
        table: 'example',
        lastId: 0,
      );

      expect(bulkData.data, contains('first'));
    },
  );
}

TableDefinition _table({List<ColumnDefinition> extraColumns = const []}) =>
    TableDefinition(
      name: 'example',
      schema: 'public',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
          columnDefault: 'serial',
        ),
        ColumnDefinition(
          name: 'name',
          columnType: ColumnType.text,
          isNullable: false,
        ),
        ...extraColumns,
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    );

class _TestSerializationManager extends DatabaseSerializationManager {
  final tables = <TableDefinition>[];

  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => tables;
}
