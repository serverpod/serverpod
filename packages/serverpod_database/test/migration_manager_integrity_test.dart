import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/log.dart' as shared;
import 'package:test/test.dart';

void main() {
  late ClientDatabaseSession session;
  late _TestSerializationManager serializationManager;
  late shared.TestLogWriter logWriter;

  setUp(() async {
    final directory = await Directory.systemTemp.createTemp(
      'sqlite_integrity_',
    );
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
    await session.db.unsafeExecute('''
      CREATE TABLE serverpod_migrations (
        module TEXT PRIMARY KEY,
        version TEXT NOT NULL,
        timestamp INTEGER
      );
    ''');

    logWriter = shared.TestLogWriter();
    shared.logWriter.add(logWriter);
    addTearDown(() => shared.logWriter.remove(logWriter));
  });

  group('Given an unmanaged SQLite table with custom schema objects,', () {
    setUp(() async {
      serializationManager.tables.add(_table(managed: false));
      await session.db.unsafeExecute('''
        CREATE TABLE example (
          name TEXT NOT NULL UNIQUE DEFAULT 'custom',
          parent TEXT REFERENCES example(name),
          extra INTEGER CHECK (extra > 0)
        );
      ''');
      await session.db.unsafeExecute(
        'CREATE INDEX example_lower_name_idx ON example (LOWER(name)) '
        'WHERE parent IS NOT NULL;',
      );
    });

    test(
      'when verifying database integrity, '
      'then verification succeeds without warnings.',
      () async {
        final matches = await MigrationManager.verifyDatabaseIntegrity(session);
        await shared.log.flush();

        expect(matches, isTrue);
        expect(logWriter.entries, isEmpty);
      },
    );
  });

  test(
    'Given an unmanaged SQLite table missing a declared column, '
    'when verifying database integrity, '
    'then verification fails and reports the missing column.',
    () async {
      serializationManager.tables.add(_table(managed: false));
      await session.db.unsafeExecute('CREATE TABLE example (extra INTEGER);');

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Missing Column "name".'),
      );
    },
  );

  test(
    'Given an unmanaged SQLite table with an incompatible column type, '
    'when verifying database integrity, '
    'then verification fails and reports the type mismatch.',
    () async {
      serializationManager.tables.add(_table(managed: false));
      await session.db.unsafeExecute(
        'CREATE TABLE example (name INTEGER NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('expected type "text", found "integer".'),
      );
    },
  );

  test(
    'Given an unmanaged SQLite table with an incompatible nullable column, '
    'when verifying database integrity, '
    'then verification fails and reports the nullability mismatch.',
    () async {
      serializationManager.tables.add(_table(managed: false));
      await session.db.unsafeExecute('CREATE TABLE example (name TEXT);');

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('expected isNullable "false", found "true".'),
      );
    },
  );

  test(
    'Given a managed SQLite table with an additional column, '
    'when verifying database integrity, '
    'then verification fails and reports the schema mismatch.',
    () async {
      serializationManager.tables.add(_table(managed: true));
      await session.db.unsafeExecute(
        'CREATE TABLE example (name TEXT NOT NULL, extra INTEGER);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(logWriter.entries.single.message, contains('extra'));
    },
  );

  test(
    'Given a managed SQLite table missing a declared column, '
    'when verifying database integrity, '
    'then verification fails and reports the missing column.',
    () async {
      final table = _table(managed: true);
      serializationManager.tables.add(
        table.copyWith(
          columns: [
            ...table.columns,
            ColumnDefinition(
              name: 'age',
              columnType: ColumnType.bigint,
              isNullable: false,
            ),
          ],
        ),
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (name TEXT NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Column "age"'),
      );
    },
  );

  test(
    'Given a managed SQLite table missing a declared index, '
    'when verifying database integrity, '
    'then verification fails and reports the missing index.',
    () async {
      serializationManager.tables.add(
        _table(managed: true).copyWith(indexes: [_nameIndex()]),
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (name TEXT NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Index "example_name_idx"'),
      );
    },
  );

  test(
    'Given a managed SQLite table with its declared index, '
    'when verifying database integrity, '
    'then verification succeeds without warnings.',
    () async {
      serializationManager.tables.add(
        _table(managed: true).copyWith(indexes: [_nameIndex()]),
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (name TEXT NOT NULL);',
      );
      await session.db.unsafeExecute(
        'CREATE INDEX example_name_idx ON example (name);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isTrue);
      expect(logWriter.entries, isEmpty);
    },
  );

  test(
    'Given a managed SQLite table missing a declared foreign key, '
    'when verifying database integrity, '
    'then verification fails and reports the missing foreign key.',
    () async {
      serializationManager.tables.add(_tableWithForeignKey());
      await session.db.unsafeExecute(
        'CREATE TABLE managed (id INTEGER PRIMARY KEY);',
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (name TEXT NOT NULL, managedId INTEGER NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Foreign key "example_fk_0"'),
      );
    },
  );

  test(
    'Given a managed SQLite table with its declared foreign key, '
    'when verifying database integrity, '
    'then verification succeeds without warnings.',
    () async {
      serializationManager.tables.add(_tableWithForeignKey());
      await session.db.unsafeExecute(
        'CREATE TABLE managed (id INTEGER PRIMARY KEY);',
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (name TEXT NOT NULL, managedId INTEGER NOT NULL, '
        'CONSTRAINT example_fk_0 FOREIGN KEY (managedId) '
        'REFERENCES managed (id));',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isTrue);
      expect(logWriter.entries, isEmpty);
    },
  );

  group(
    'Given an unmanaged SQLite timestamp column with a custom default,',
    () {
      setUp(() async {
        serializationManager.tables.add(
          _table(
            managed: false,
            columnType: ColumnType.timestampWithoutTimeZone,
          ),
        );
        await session.db.unsafeExecute('''
        INSERT INTO serverpod_sqlite_schema
          (table_name, column_name, column_type)
        VALUES ('example', 'name', 'timestampWithoutTimeZone');
      ''');
        await session.db.unsafeExecute(
          'CREATE TABLE example '
          "(name INTEGER NOT NULL DEFAULT (unixepoch('now') * 1000));",
        );
      });

      test(
        'when verifying database integrity, '
        'then verification succeeds without warnings.',
        () async {
          final matches = await MigrationManager.verifyDatabaseIntegrity(
            session,
          );
          await shared.log.flush();

          expect(matches, isTrue);
          expect(logWriter.entries, isEmpty);
        },
      );
    },
  );
}

TableDefinition _table({
  required bool managed,
  ColumnType columnType = ColumnType.text,
}) => TableDefinition(
  name: 'example',
  schema: 'public',
  columns: [
    ColumnDefinition(
      name: 'name',
      columnType: columnType,
      isNullable: false,
    ),
  ],
  foreignKeys: [],
  indexes: [],
  managed: managed,
);

IndexDefinition _nameIndex() => IndexDefinition(
  indexName: 'example_name_idx',
  elements: [
    IndexElementDefinition(
      type: IndexElementDefinitionType.column,
      definition: 'name',
    ),
  ],
  type: 'btree',
  isUnique: false,
  isPrimary: false,
);

TableDefinition _tableWithForeignKey() {
  final table = _table(managed: true);
  return table.copyWith(
    columns: [
      ...table.columns,
      ColumnDefinition(
        name: 'managedId',
        columnType: ColumnType.bigint,
        isNullable: false,
      ),
    ],
    foreignKeys: [
      ForeignKeyDefinition(
        constraintName: 'example_fk_0',
        columns: ['managedId'],
        referenceTable: 'managed',
        referenceTableSchema: 'public',
        referenceColumns: ['id'],
        onUpdate: ForeignKeyAction.noAction,
        onDelete: ForeignKeyAction.noAction,
        matchType: null,
      ),
    ],
  );
}

class _TestSerializationManager extends DatabaseSerializationManager {
  final tables = <TableDefinition>[];

  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => tables;
}
