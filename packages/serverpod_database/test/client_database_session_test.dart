import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late String databasePath;
  late ClientDatabaseSession session;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('client_database_session_');
    databasePath = p.join(tempDir.path, 'test.db');
  });

  tearDown(() async {
    await session.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'Given a client migration registry, '
    'when opening a client database session, '
    'then the latest migration is applied.',
    () async {
      session = await ClientDatabaseSession.open(
        databasePath,
        _TestSerializationManager(),
        clientMigrations: [_testClientMigration()],
      );

      final createdTables = await session.db.unsafeQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'example';",
      );
      expect(createdTables, hasLength(1));

      final installedVersions = await session.db.unsafeQuery(
        'SELECT version FROM "serverpod_migrations" WHERE module = \'test\';',
      );
      expect(installedVersions, hasLength(1));
      expect(
        installedVersions.first.toColumnMap()['version'],
        '20240101000000000',
      );
    },
  );

  test(
    'Given a client migration registry, '
    'when opening a client database session with migrations disabled, '
    'then no migration is applied.',
    () async {
      session = await ClientDatabaseSession.open(
        databasePath,
        _TestSerializationManager(),
        clientMigrations: [_testClientMigration()],
        runMigrations: false,
      );

      final createdTables = await session.db.unsafeQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'example';",
      );
      expect(createdTables, isEmpty);
    },
  );

  test(
    'Given a client migration registry, '
    'when opening a client database session with the same migration applied twice, '
    'then the migration is applied only once.',
    () async {
      session = await ClientDatabaseSession.open(
        databasePath,
        _TestSerializationManager(),
        clientMigrations: [_testClientMigration()],
      );
      await session.close();

      session = await ClientDatabaseSession.open(
        databasePath,
        _TestSerializationManager(),
        clientMigrations: [_testClientMigration()],
      );

      final createdTables = await session.db.unsafeQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'example';",
      );
      expect(createdTables, hasLength(1));
    },
  );
}

class _TestSerializationManager extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => Table(tableName: 'example');

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];
}

MigrationVersionSql _testClientMigration() {
  const version = '20240101000000000';
  const moduleName = 'test';
  const definitionSql =
      '''
BEGIN;

CREATE TABLE "example" (
    "id" INTEGER PRIMARY KEY
) STRICT;

DROP TABLE IF EXISTS "serverpod_sqlite_schema";

CREATE TABLE "serverpod_sqlite_schema" (
    "table_name" TEXT NOT NULL,
    "column_name" TEXT NOT NULL,
    "column_type" TEXT NOT NULL,
    "column_vector_dimension" INTEGER,
    PRIMARY KEY ("table_name", "column_name")
);

CREATE TABLE IF NOT EXISTS "serverpod_migrations" (
    "module" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "timestamp" INTEGER,
    PRIMARY KEY ("module")
) STRICT;

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('$moduleName', '$version', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '$version', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

COMMIT;
''';

  return const MigrationVersionSql(
    version: version,
    moduleName: moduleName,
    migrationSql: definitionSql,
    definitionSql: definitionSql,
  );
}
