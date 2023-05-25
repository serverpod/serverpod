import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'config.dart';
import 'service_protocol_test.dart';

void applyMigrationTestFiles(String version) {
  var packageDirectory = Directory.current;
  var migrationDirectory = Directory(path.join(
    packageDirectory.path,
    'test',
    'migration_test_files',
    version,
  ));
  var protocolDirectory = Directory(path.join(
    packageDirectory.path,
    'lib',
    'src',
    'protocol',
  ));

  assert(
    migrationDirectory.existsSync(),
    'You need to run the tests from the serverpod_test_server directory',
  );
  assert(protocolDirectory.existsSync());

  var files = migrationDirectory.listSync();
  for (var file in files) {
    if (file is File) {
      var fileName = path.basename(file.path);
      if (!fileName.endsWith('.yaml')) {
        continue;
      }

      var destination = path.join(protocolDirectory.path, fileName);

      var contents = file.readAsStringSync();
      if (contents == '') {
        // Remove the file.
        var destinationFile = File(destination);
        if (destinationFile.existsSync()) {
          destinationFile.deleteSync();
        }
      } else {
        // Copy the file.
        file.copySync(destination);
      }
    }
  }
}

Future<void> testMigration({
  required String version,
  required bool force,
  required bool expectSuccess,
  required Client serviceClient,
}) async {
  // Copy the migration files to the protocol directory.
  applyMigrationTestFiles(version);

  // Run the migration.
  var generator = MigrationGenerator(
    directory: Directory.current,
    projectName: 'serverpod_test',
  );

  var migration = await generator.createMigration(
    force: force,
    tag: version,
    verbose: true,
  );
  if (expectSuccess) {
    expect(migration, isNotNull);

    var sql = migration!.migration.toPgSql(
      version: migration.versionName,
      module: 'serverdpod_test',
      priority: 1,
    );

    await serviceClient.insights.executeSql(sql);

    // Validate the migration.
    var liveDefinition =
        await serviceClient.insights.getLiveDatabaseDefinition();

    // Check that all tables in the migration are found in the live definition.
    for (var table in migration.databaseDefinition.tables) {
      if (table.module != 'serverpod_test') {
        continue;
      }

      TableDefinition? liveTable;
      for (var t in liveDefinition.tables) {
        if (t.name == table.name) {
          liveTable = t;
          break;
        }
      }

      // Check that table is found and looks like expected.
      expect(liveTable, isNotNull);

      var alike = table.like(liveTable!);
      expect(alike, isTrue);
    }

    // Check that all tables in the live definition are found in the migration.
    // TODO: Fix somehow.
    for (var table in liveDefinition.tables) {
      if (table.module != 'serverpod_test') {
        continue;
      }

      TableDefinition? migrationTable;
      for (var t in migration.databaseDefinition.tables) {
        if (t.name == table.name) {
          migrationTable = t;
          break;
        }
      }

      // Check that table is found and looks like expected.
      expect(migrationTable, isNotNull);
    }
  } else {
    expect(migration, isNull);
  }
}

void cleanUpMigrationDirectories() {
  var packageDirectory = Directory.current;
  var migrationDirectory = Directory(path.join(
    packageDirectory.path,
    'migrations',
    'serverpod_test',
  ));

  // Remove any migration that which has a tag.
  for (var entity in migrationDirectory.listSync()) {
    if (entity is Directory) {
      if (path.basename(entity.path).contains('-')) {
        entity.deleteSync(recursive: true);
      }
    }
  }
}

Future<void> cleanUp({
  required Client serviceClient,
}) async {
  await testMigration(
    version: 'cleanup',
    force: true,
    expectSuccess: true,
    serviceClient: serviceClient,
  );

  cleanUpMigrationDirectories();
}

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  group('Migrations', () {
    test('Setup', () async {
      cleanUpMigrationDirectories();
    });
    test('Apply migrations 1 - create table', () async {
      await testMigration(
        serviceClient: serviceClient,
        version: '1',
        force: false,
        expectSuccess: true,
      );
    });

    test('Apply migrations 2 - add optional column', () async {
      await testMigration(
        serviceClient: serviceClient,
        version: '2',
        force: false,
        expectSuccess: true,
      );
    });

    test('Apply migrations 3 - add not null column', () async {
      await testMigration(
        serviceClient: serviceClient,
        version: '3',
        force: false,
        expectSuccess: false,
      );
    });

    test('Apply migrations 3 - add not null column (force)', () async {
      await testMigration(
        serviceClient: serviceClient,
        version: '3',
        force: true,
        expectSuccess: true,
      );
    });

    test('Apply migrations 4 - add index and parent', () async {
      await testMigration(
        serviceClient: serviceClient,
        version: '4',
        force: false,
        expectSuccess: true,
      );
    });

    test('Clean up', () async {
      await cleanUp(
        serviceClient: serviceClient,
      );
    });
  });
}
