@Timeout(Duration(minutes: 5))

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  group('Given new protocol entity with table', () {
    var scenario = 'add-table';
    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then database contains new table.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var expectedAddedTable = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(expectedAddedTable),
        reason: 'Could not find migration table in live table definitions.',
      );
    });
  });

  group('Given multiple new protocol entities with table', () {
    var scenario = 'add-multiple-tables';
    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then database contains new tables.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var expectedNewTables = [
        'migrated_table',
        'migrated_table_2',
        'migrated_table_3',
      ];
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        containsAll(expectedNewTables),
        reason: 'Could not find the new tables in live table definitions.',
      );
    });
  });

  group('Given protocol entity with table that is removed', () {
    var scenario = 'drop-table';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        isNot(0),
        reason: 'Should fail to create migration, exit code was 0.',
      );
    });
  });

  group('Given protocol entity with table that is removed', () {
    var scenario = 'drop-table';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating migration using --force and applying it then table is removed from database.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(
        scenario,
        force: true,
      );
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var expectedRemovedTable = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        isNot(contains(expectedRemovedTable)),
        reason: 'Could still find migration table in live table definitions.',
      );
    });
  });

  group('Given existing protocol entity with added nullable column', () {
    var scenario = 'add-nullable-column';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test('when creating and applying migration then contains new column.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var expectedColumnName = 'addedColumn';
      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var databaseColumns = migratedTable.columns.map((c) => c.name);
      expect(
        databaseColumns,
        contains(expectedColumnName),
        reason: 'Could not find added column in migrated table columns.',
      );
    });
  });

  group('Given existing protocol entity with removed column', () {
    var scenario = 'drop-column';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating migration using --force and applying it then table is removed from database.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(
        scenario,
        force: true,
      );
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var expectedRemovedColumn = 'columnToRemove';
      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var databaseColumns = migratedTable.columns.map((c) => c.name);
      expect(
        databaseColumns,
        isNot(contains(expectedRemovedColumn)),
        reason: 'Could still find removed column in migrated table columns.',
      );
    });
  });

  group('Given existing protocol entity with removed column', () {
    var scenario = 'drop-column';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        isNot(0),
        reason: 'Should fail to create migration, exit code was 0.',
      );
    });
  });

  group('Given existing protocol entity with added non nullable column', () {
    var scenario = 'add-non-nullable-column';

    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        isNot(0),
        reason: 'Should fail to create migration, exit code was 0.',
      );
    });
  });

  group('Given existing protocol entity with non nullable column', () {
    var scenario = 'add-non-nullable-column';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating migration using --force and applying it then database contains new column.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(
        scenario,
        force: true,
      );
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var expectedColumnName = 'addedColumn';
      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var databaseColumns = migratedTable.columns.map((c) => c.name);
      expect(
        databaseColumns,
        contains(expectedColumnName),
        reason: 'Could not find added column in migrated table columns.',
      );
    });
  });

  group('Given existing protocol entity with nullability added to column', () {
    var scenario = 'add-column-nullability';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then database column is nullable.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var expectedModifiedColumn = 'previouslyNonNullableColumn';
      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var migratedTableColumnNames = migratedTable.columns.map((c) => c.name);
      expect(
        migratedTableColumnNames,
        contains(expectedModifiedColumn),
        reason: 'Could not find modified column in migrated table columns.',
      );

      var migratedTableColumn = migratedTable.columns
          .firstWhere((c) => c.name == expectedModifiedColumn);
      expect(
        migratedTableColumn.isNullable,
        isTrue,
        reason: 'Column should be nullable after migration',
      );
    });
  });

  group('Given existing protocol entity with nullability removed from column',
      () {
    var scenario = 'drop-column-nullability';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating migration using --force and applying it then database contains non nullable column.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(
        scenario,
        force: true,
      );
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var expectedModifiedColumn = 'previouslyNullableColumn';
      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var migratedTableColumnNames = migratedTable.columns.map((c) => c.name);
      expect(
        migratedTableColumnNames,
        contains(expectedModifiedColumn),
        reason: 'Could not find modified column in migrated table columns.',
      );

      var migratedTableColumn = migratedTable.columns
          .firstWhere((c) => c.name == expectedModifiedColumn);
      expect(
        migratedTableColumn.isNullable,
        isFalse,
        reason: 'Column should not be nullable after migration',
      );
    });
  });

  group('Given existing protocol entity with nullability removed from column',
      () {
    var scenario = 'drop-column-nullability';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(
        scenario,
      );
      expect(
        await createMigrationExitCode,
        isNot(0),
        reason: 'Should fail to create migration, exit code was 0.',
      );
    });
  });

  group('Given protocol entity with added index', () {
    var scenario = 'add-index';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test('when creating and applying migration then contains new index.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var expectedAddedIndex = 'migrated_table_index';
      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var tableIndexes = migratedTable.indexes.map((i) => i.indexName);
      expect(
        tableIndexes,
        contains(expectedAddedIndex),
        reason: 'Could not find added index for migrated table.',
      );
    });
  });

  group('Given protocol entity with index that is removed', () {
    var scenario = 'drop-index';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then index is removed from database.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var expectedRemovedIndex = 'migrated_table_index';
      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var tableIndexes = migratedTable.indexes.map((i) => i.indexName);
      expect(
        tableIndexes,
        isNot(contains(expectedRemovedIndex)),
        reason: 'Could still find removed index for migrated table.',
      );
    });
  });

  group('Given protocol entity with added relation', () {
    var scenario = 'add-relation';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then database contains new relation.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var relations = migratedTable.foreignKeys;
      expect(
        relations,
        isNotEmpty,
        reason: 'Could not find added relation for migrated table.',
      );
    });
  });

  group('Given protocol entity with relation that is removed', () {
    var scenario = 'drop-relation';
    setUp(() async {
      await _createInitialState(scenario: scenario);
    });

    tearDown(() async {
      await _migrationTestCleanup(
        scenario: scenario,
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then relation is removed from database.',
        () async {
      _copyTestProtocolFiles(
        scenario: scenario,
        assetType: AssetType.targetState,
      );

      var createMigrationExitCode = await _runCreateMigrations(scenario);
      expect(
        await createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        await applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var tableName = 'migrated_table';
      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );

      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == tableName,
      );
      var relations = migratedTable.foreignKeys;
      expect(
        relations,
        isEmpty,
        reason: 'Could still find relation for migrated table.',
      );
    });
  });
}

Future<void> _migrationTestCleanup({
  required String scenario,
  required Client serviceClient,
}) async {
  _removeAllTaggedMigrations();
  _removeMigrationTestProtocolFolder();
  await _resetDatabase(scenario: scenario, serviceClient: serviceClient);
  await _setDatabaseMigrationToLatest(serviceClient: serviceClient);
}

Future<int> _runApplyMigrations() async {
  var applyMigrationProcess = await Process.start(
    'dart',
    [
      'run',
      'bin/main.dart',
      '--apply-migrations',
      '--role',
      'maintenance',
      '--mode',
      'production',
    ],
    workingDirectory: Directory.current.path,
  );

  applyMigrationProcess.stderr.transform(utf8.decoder).listen(print);
  applyMigrationProcess.stdout.transform(utf8.decoder).listen(print);

  return await applyMigrationProcess.exitCode;
}

void _copyTestProtocolFiles({
  required String scenario,
  required AssetType assetType,
}) {
  var protocolDirectory = _migrationProtocolTestDirectory();

  var testAssetDirectory = Directory(path.join(
    Directory.current.path,
    'test_e2e_migrations',
    'test_assets',
    scenario,
    assetType.name,
  ));

  _removeMigrationTestProtocolFolder();
  _copyYamlFiles(testAssetDirectory, protocolDirectory);
}

void _copyYamlFiles(Directory src, Directory target) {
  target.createSync(recursive: true);

  for (var entity in src.listSync()) {
    if (entity is File) {
      var fileName = path.basename(entity.path);
      if (!fileName.endsWith('.yaml')) {
        continue;
      }

      var destination = path.join(target.path, fileName);
      entity.copySync(destination);
    }
  }
}

Future<void> _createInitialState({required String scenario}) async {
  _copyTestProtocolFiles(scenario: scenario, assetType: AssetType.initialState);
  assert(
    await _runCreateMigrations(scenario) == 0,
    'Failed to create migration.',
  );
  assert(
    await _runApplyMigrations() == 0,
    'Failed to create migration.',
  );
}

Future<int> _runCreateMigrations(String scenario, {bool force = false}) async {
  var createMigrationProcess = await Process.start(
    'serverpod',
    [
      'create-migration',
      '--tag',
      scenario,
      if (force) '--force',
    ],
    workingDirectory: Directory.current.path,
  );

  createMigrationProcess.stderr.transform(utf8.decoder).listen(print);
  createMigrationProcess.stdout.transform(utf8.decoder).listen(print);
  return await createMigrationProcess.exitCode;
}

Directory _migrationProtocolTestDirectory() => Directory(path.join(
      Directory.current.path,
      'lib',
      'src',
      'protocol',
      'migration_test_protocol_files',
    ));

Directory _migrationsProjectDirectory() => Directory(path.join(
      Directory.current.path,
      'migrations',
      'serverpod_test',
    ));

void _removeAllTaggedMigrations() {
  for (var entity in _migrationsProjectDirectory().listSync()) {
    if (entity is Directory) {
      if (path.basename(entity.path).contains('-')) {
        entity.deleteSync(recursive: true);
      }
    }
  }
}

void _removeMigrationTestProtocolFolder() {
  var protocolDirectory = _migrationProtocolTestDirectory();
  if (protocolDirectory.existsSync()) {
    protocolDirectory.deleteSync(recursive: true);
  }
}

String _getLatestMigration() {
  var migrationsDirectory = _migrationsProjectDirectory();
  List<String> versions = [];
  var fileEntities = migrationsDirectory.listSync();
  for (var entity in fileEntities) {
    if (entity is Directory) {
      versions.add(path.basename(entity.path));
    }
  }
  versions.sort();
  return versions.last;
}

Future<void> _setDatabaseMigrationToLatest({
  required Client serviceClient,
}) async {
  var latestMigration = _getLatestMigration();

  await serviceClient.insights.executeSql('''
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '$latestMigration', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '$latestMigration', "priority" = 2;
''');
}

Future<void> _resetDatabase({
  required String scenario,
  required Client serviceClient,
}) async {
  var teardownSql = File(path.join(
    Directory.current.path,
    'test_e2e_migrations',
    'test_assets',
    scenario,
    'database_reset',
    'reset.sql',
  ));

  assert(teardownSql.existsSync(), 'Expected teardown SQL file to exist.');

  var sql = teardownSql.readAsStringSync();
  await serviceClient.insights.executeSql(sql);
}

enum AssetType {
  initialState('initial_state'),
  targetState('target_state');

  final String name;
  const AssetType(this.name);
}
