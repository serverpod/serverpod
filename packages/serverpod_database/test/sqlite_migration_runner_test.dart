import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_migration_runner.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_pool_manager.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late SqlitePoolManager poolManager;
  late Database database;
  late DatabaseSession session;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'sqlite_migration_test_',
    );

    poolManager = SqlitePoolManager(
      _TestSerializationManager(),
      SqliteDatabaseConfig(filePath: p.join(tempDir.path, 'test.db')),
    )..start();

    session = _TestSession(() => database);
    database = DatabaseConstructor.create(
      session: session,
      poolManager: poolManager,
    );
  });

  tearDown(() async {
    await poolManager.stop();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'Given schema migrations that violate foreign key constraints in a development environment, '
    'when running migrations, '
    'then it fails and reports each foreign key constraint violation.',
    () async {
      const runner = SqliteDatabaseMigrationRunner(runMode: 'development');
      await expectLater(
        runner.runMigrations(session, (tx) async {
          await _createParentChildTables(session, tx);
          await session.db.unsafeExecute(
            'INSERT INTO child(id, parent_id) VALUES (1, 999);',
            transaction: tx,
          );
        }),

        throwsA(
          isA<SqliteForeignKeyViolationException>().having(
            (e) => e.message,
            'message',
            equals(
              'Foreign key integrity check failed: 1 violation.\n'
              '  1. table=child, rowid=1, parent=parent, fkid=0',
            ),
          ),
        ),
      );

      final createdTables = await session.db.unsafeQuery(
        'SELECT * '
        'FROM sqlite_master '
        "WHERE type = 'table' AND (name = 'child' OR name = 'parent');",
      );
      expect(createdTables, isEmpty);
    },
  );

  test(
    'Given schema migrations that does not violate foreign key constraints in a development environment, '
    'when running migrations, '
    'then the migration completes successfully.',
    () async {
      const runner = SqliteDatabaseMigrationRunner(runMode: 'development');
      await runner.runMigrations(session, (tx) async {
        await _createParentChildTables(session, tx);
        await session.db.unsafeExecute(
          'INSERT INTO parent(id) VALUES (1);',
          transaction: tx,
        );
        await session.db.unsafeExecute(
          'INSERT INTO child(id, parent_id) VALUES (1, 1);',
          transaction: tx,
        );
      });

      final parents = await session.db.unsafeQuery('SELECT id FROM parent;');
      expect(parents, hasLength(1));
      expect(parents.first.toColumnMap()['id'], 1);

      final children = await session.db.unsafeQuery(
        'SELECT id, parent_id FROM child;',
      );
      expect(children, hasLength(1));
      expect(children.first.toColumnMap()['id'], 1);
      expect(children.first.toColumnMap()['parent_id'], 1);
    },
  );

  test(
    'Given schema migrations that violate foreign key constraints in a production environment, '
    'when running migrations, '
    'then the migration completes without failing due to foreign key constraint violations.',
    () async {
      const runner = SqliteDatabaseMigrationRunner(runMode: 'production');
      await runner.runMigrations(session, (tx) async {
        await _createParentChildTables(session, tx);
        await session.db.unsafeExecute(
          'INSERT INTO child(id, parent_id) VALUES (1, 999);',
          transaction: tx,
        );
      });

      final parents = await session.db.unsafeQuery('SELECT id FROM parent;');
      expect(parents, isEmpty);

      final children = await session.db.unsafeQuery(
        'SELECT id, parent_id FROM child;',
      );
      expect(children, hasLength(1));
      expect(children.first.toColumnMap()['id'], 1);
      expect(children.first.toColumnMap()['parent_id'], 999);
    },
  );
}

Future<void> _createParentChildTables(
  DatabaseSession session,
  Transaction? tx,
) async {
  await session.db.unsafeExecute(
    'CREATE TABLE parent (id INTEGER PRIMARY KEY);',
    transaction: tx,
  );
  await session.db.unsafeExecute(
    'CREATE TABLE child (id INTEGER PRIMARY KEY, parent_id INTEGER REFERENCES parent(id));',
    transaction: tx,
  );
}

class _TestSerializationManager extends SerializationManagerServer {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];
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
