@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/log.dart' as shared;
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late DatabasePoolManager poolManager;
  late _TestSerializationManager serializationManager;
  late DatabaseSession session;
  // The analyzer does not recognize test_integration as a test directory.
  // ignore: invalid_use_of_visible_for_testing_member
  late shared.TestLogWriter logWriter;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('migration_integrity_');
    addTearDown(() => tempDir.delete(recursive: true));

    serializationManager = _TestSerializationManager();
    poolManager = DatabaseProvider.forDialect(DatabaseDialect.postgres)
        .createPoolManager(
          serializationManager,
          null,
          PostgresDatabaseConfig.embedded(
            dataPath: p.join(tempDir.path, 'pgdata'),
            name: 'integrity_test',
          ),
        );
    addTearDown(poolManager.stop);
    await poolManager.started;

    late Database database;
    session = _TestSession(() => database);
    database = DatabaseConstructor.create(
      session: session,
      poolManager: poolManager,
    );

    await session.db.unsafeExecute('''
      CREATE TABLE serverpod_migrations (
        module text PRIMARY KEY,
        version text NOT NULL,
        timestamp timestamp without time zone
      );
    ''');
  });

  setUp(() {
    serializationManager.tables.clear();
    logWriter = shared.TestLogWriter();
    shared.logWriter.add(logWriter);
  });

  tearDown(() async {
    shared.logWriter.remove(logWriter);
    await session.db.unsafeExecute('DROP TABLE IF EXISTS example, managed;');
  });

  test(
    'Given a missing unmanaged table, '
    'when verifying database integrity, '
    'then verification fails and reports the missing table.',
    () async {
      serializationManager.tables.add(_table('example', managed: false));

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Table "example" is missing.'),
      );
    },
  );

  group('Given an unmanaged table with a manual expression index,', () {
    setUp(() async {
      serializationManager.tables.add(_table('example', managed: false));
      await session.db.unsafeExecute(
        'CREATE TABLE example (name text NOT NULL);',
      );
      await session.db.unsafeExecute(
        'CREATE INDEX example_lower_name_idx ON example (LOWER(name));',
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

  group(
    'Given an unmanaged table with additional columns and manual constraints,',
    () {
      setUp(() async {
        serializationManager.tables.add(_table('example', managed: false));
        await session.db.unsafeExecute('''
          CREATE TABLE example (
            name text PRIMARY KEY CHECK (name <> ''),
            parent text REFERENCES example(name),
            amount numeric NOT NULL DEFAULT 0,
            created_at timestamp NOT NULL DEFAULT (now() AT TIME ZONE 'utc')
          );
        ''');
        await session.db.unsafeExecute(
          'CREATE INDEX example_parent_idx ON example (parent) '
          'WHERE parent IS NOT NULL;',
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

  test(
    'Given an unmanaged table missing a declared column, '
    'when verifying database integrity, '
    'then verification fails and reports the missing column.',
    () async {
      serializationManager.tables.add(_table('example', managed: false));
      await session.db.unsafeExecute('CREATE TABLE example (extra integer);');

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Missing Column "name".'),
      );
      expect(logWriter.entries.single.message, isNot(contains('extra')));
    },
  );

  test(
    'Given an unmanaged table with an incompatible declared column type, '
    'when verifying database integrity, '
    'then verification fails and reports the expected and actual types.',
    () async {
      serializationManager.tables.add(_table('example', managed: false));
      await session.db.unsafeExecute(
        'CREATE TABLE example (name integer NOT NULL);',
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
    'Given an unmanaged table allowing null in a non-nullable model column, '
    'when verifying database integrity, '
    'then verification fails and reports the nullability mismatch.',
    () async {
      serializationManager.tables.add(_table('example', managed: false));
      await session.db.unsafeExecute('CREATE TABLE example (name text);');

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
    'Given an unmanaged table rejecting null in a nullable model column, '
    'when verifying database integrity, '
    'then verification fails and reports the nullability mismatch.',
    () async {
      serializationManager.tables.add(
        _table('example', managed: false, isNullable: true),
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (name text NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('expected isNullable "true", found "false".'),
      );
    },
  );

  test(
    'Given an unmanaged table with a matching nullable column, '
    'when verifying database integrity, '
    'then verification succeeds without warnings.',
    () async {
      serializationManager.tables.add(
        _table('example', managed: false, isNullable: true),
      );
      await session.db.unsafeExecute('CREATE TABLE example (name text);');

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isTrue);
      expect(logWriter.entries, isEmpty);
    },
  );

  test(
    'Given an unmanaged table storing a model integer in a bigint column, '
    'when verifying database integrity, '
    'then verification succeeds without warnings.',
    () async {
      serializationManager.tables.add(
        _table('example', managed: false, columnType: ColumnType.integer),
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example (name bigint NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isTrue);
      expect(logWriter.entries, isEmpty);
    },
  );

  test(
    'Given an unmanaged table with a different column default, '
    'when verifying database integrity, '
    'then verification succeeds without warnings.',
    () async {
      serializationManager.tables.add(
        _table('example', managed: false, columnDefault: "'model'"),
      );
      await session.db.unsafeExecute(
        "CREATE TABLE example (name text NOT NULL DEFAULT 'database');",
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isTrue);
      expect(logWriter.entries, isEmpty);
    },
  );

  test(
    'Given an unmanaged timestamp column with a custom default expression, '
    'when verifying database integrity, '
    'then verification succeeds without warnings.',
    () async {
      serializationManager.tables.add(
        _table(
          'example',
          managed: false,
          columnType: ColumnType.timestampWithoutTimeZone,
        ),
      );
      await session.db.unsafeExecute(
        'CREATE TABLE example '
        "(name timestamp NOT NULL DEFAULT (now() AT TIME ZONE 'utc'));",
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isTrue);
      expect(logWriter.entries, isEmpty);
    },
  );

  group('Given an unmanaged table with a mismatched vector dimension,', () {
    setUp(() async {
      serializationManager.tables.add(
        _table(
          'example',
          managed: false,
          columnType: ColumnType.vector,
          vectorDimension: 3,
        ),
      );
      await session.db.unsafeExecute('CREATE EXTENSION IF NOT EXISTS vector;');
      await session.db.unsafeExecute(
        'CREATE TABLE example (name vector(2) NOT NULL);',
      );
    });

    test(
      'when verifying database integrity, '
      'then verification fails and reports the dimension mismatch.',
      () async {
        final matches = await MigrationManager.verifyDatabaseIntegrity(session);
        await shared.log.flush();

        expect(matches, isFalse);
        expect(
          logWriter.entries.single.message,
          contains('expected vector dimension "3", found "2".'),
        );
      },
    );
  });

  test(
    'Given a missing explicitly managed table, '
    'when verifying database integrity, '
    'then verification fails and reports the missing table.',
    () async {
      serializationManager.tables.add(_table('example', managed: true));

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Table "example" is missing.'),
      );
    },
  );

  test(
    'Given a missing table with an unspecified managed flag, '
    'when verifying database integrity, '
    'then verification fails and reports the missing table.',
    () async {
      serializationManager.tables.add(_table('example'));

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Table "example" is missing.'),
      );
    },
  );

  group('Given a managed table with an undeclared expression index,', () {
    setUp(() async {
      serializationManager.tables.add(_table('example', managed: true));
      await session.db.unsafeExecute(
        'CREATE TABLE example (name text NOT NULL);',
      );
      await session.db.unsafeExecute(
        'CREATE INDEX example_lower_name_idx ON example (LOWER(name));',
      );
    });

    test(
      'when verifying database integrity, '
      'then verification fails and reports the index mismatch.',
      () async {
        final matches = await MigrationManager.verifyDatabaseIntegrity(session);
        await shared.log.flush();

        expect(matches, isFalse);
        expect(
          logWriter.entries.single.message,
          contains('example_lower_name_idx'),
        );
      },
    );
  });

  test(
    'Given a table with an unspecified managed flag and a column type mismatch, '
    'when verifying database integrity, '
    'then verification fails and reports the mismatch.',
    () async {
      serializationManager.tables.add(_table('example'));
      await session.db.unsafeExecute(
        'CREATE TABLE example (name integer NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Table "example" is not like the target database:'),
      );
    },
  );

  test(
    'Given a compatible unmanaged table followed by a missing managed table, '
    'when verifying database integrity, '
    'then verification fails and reports only the managed table.',
    () async {
      serializationManager.tables.addAll([
        _table('example', managed: false),
        _table('managed', managed: true),
      ]);
      await session.db.unsafeExecute(
        'CREATE TABLE example (name text NOT NULL, extra integer);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isFalse);
      expect(
        logWriter.entries.single.message,
        contains('Table "managed" is missing.'),
      );
      expect(logWriter.entries.single.message, isNot(contains('example')));
    },
  );

  test(
    'Given a compatible unmanaged table alongside a matching managed table, '
    'when verifying database integrity, '
    'then verification succeeds without warnings.',
    () async {
      serializationManager.tables.addAll([
        _table('example', managed: false),
        _table('managed', managed: true),
      ]);
      await session.db.unsafeExecute(
        'CREATE TABLE example (name text NOT NULL);',
      );
      await session.db.unsafeExecute(
        'CREATE TABLE managed (name text NOT NULL);',
      );

      final matches = await MigrationManager.verifyDatabaseIntegrity(session);
      await shared.log.flush();

      expect(matches, isTrue);
      expect(logWriter.entries, isEmpty);
    },
  );
}

TableDefinition _table(
  String name, {
  bool? managed,
  ColumnType columnType = ColumnType.text,
  bool isNullable = false,
  String? columnDefault,
  int? vectorDimension,
}) => TableDefinition(
  name: name,
  schema: 'public',
  columns: [
    ColumnDefinition(
      name: 'name',
      columnType: columnType,
      isNullable: isNullable,
      columnDefault: columnDefault,
      vectorDimension: vectorDimension,
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

class _TestSession implements DatabaseSession {
  _TestSession(this._database);

  final Database Function() _database;

  @override
  Database get db => _database();

  @override
  Transaction? get transaction => null;

  @override
  LogQueryFunction? get logQuery => null;

  @override
  LogWarningFunction? get logWarning => null;
}
