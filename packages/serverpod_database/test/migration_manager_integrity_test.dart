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

class _TestSerializationManager extends DatabaseSerializationManager {
  final tables = <TableDefinition>[];

  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => tables;
}
