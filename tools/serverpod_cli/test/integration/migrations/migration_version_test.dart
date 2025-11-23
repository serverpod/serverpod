import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/migration_version_builder.dart';

MigrationVersion _createMigrationVersion(
  Directory projectDirectory,
  String versionName,
) {
  var databaseDefinition = DatabaseDefinition(
    moduleName: 'example_project',
    tables: [],
    installedModules: [
      DatabaseMigrationVersion(
        module: 'serverpod',
        version: '00000000000000',
      ),
      DatabaseMigrationVersion(
        module: 'example_project',
        version: versionName,
      ),
    ],
    migrationApiVersion: DatabaseConstants.migrationApiVersion,
  );

  return MigrationVersion(
    moduleName: 'example_project',
    projectDirectory: projectDirectory,
    versionName: versionName,
    migration: DatabaseMigration(
      actions: [],
      warnings: [],
      migrationApiVersion: DatabaseConstants.migrationApiVersion,
    ),
    databaseDefinitionProject: databaseDefinition,
    databaseDefinitionFull: databaseDefinition,
  );
}

void main() {
  var testAssetsPath =
      path.join('test', 'integration', 'migrations', 'test_assets');
  var tempDirectory = Directory(path.join(testAssetsPath, 'temp'));

  setUp(() {
    tempDirectory.createSync();
  });

  tearDown(() {
    tempDirectory.deleteSync(recursive: true);
  });

  test(
      'Given an existing directory when writing migration version with same name then exception is thrown.',
      () async {
    var versionName = '00000000000000';
    var versionDirectory = Directory(path.join(
      tempDirectory.path,
      'migrations',
      versionName,
    ));
    versionDirectory.createSync(recursive: true);

    var migrationVersion = MigrationVersionBuilder()
        .withProjectDirectory(tempDirectory)
        .withVersionName(versionName)
        .build();

    expect(
      () => migrationVersion.write(
        installedModules: [],
        removedModules: [],
        previousVersion: null,
      ),
      throwsA(isA<MigrationVersionAlreadyExistsException>()),
    );
  });

  test(
      'Given custom database setup SQL in previous migration when writing new migration then files are copied.',
      () async {
    const previousVersion = '20240101000000';
    const currentVersion = '20240102000000';

    var previousDirectory = MigrationConstants.migrationVersionDirectory(
      tempDirectory,
      previousVersion,
    );
    previousDirectory.createSync(recursive: true);

    var previousPreFile = MigrationConstants.preDatabaseSetupSQLPath(
      tempDirectory,
      previousVersion,
    );
    var previousPostFile = MigrationConstants.postDatabaseSetupSQLPath(
      tempDirectory,
      previousVersion,
    );
    previousPreFile.writeAsStringSync('PRE-CUSTOM-SQL;');
    previousPostFile.writeAsStringSync('POST-CUSTOM-SQL;');

    var migrationVersion =
        _createMigrationVersion(tempDirectory, currentVersion);

    await migrationVersion.write(
      installedModules:
          migrationVersion.databaseDefinitionFull.installedModules,
      removedModules: const [],
      previousVersion: previousVersion,
    );

    var newPreFile = MigrationConstants.preDatabaseSetupSQLPath(
      tempDirectory,
      currentVersion,
    );
    var newPostFile = MigrationConstants.postDatabaseSetupSQLPath(
      tempDirectory,
      currentVersion,
    );

    expect(newPreFile.readAsStringSync(), 'PRE-CUSTOM-SQL;');
    expect(newPostFile.readAsStringSync(), 'POST-CUSTOM-SQL;');
  });

  test(
      'Given no previous migration when writing migration version then database setup SQL files are empty.',
      () async {
    const currentVersion = '20240103000000';
    var migrationVersion =
        _createMigrationVersion(tempDirectory, currentVersion);

    await migrationVersion.write(
      installedModules:
          migrationVersion.databaseDefinitionFull.installedModules,
      removedModules: const [],
      previousVersion: null,
    );

    var preFile = MigrationConstants.preDatabaseSetupSQLPath(
      tempDirectory,
      currentVersion,
    );
    var postFile = MigrationConstants.postDatabaseSetupSQLPath(
      tempDirectory,
      currentVersion,
    );

    expect(preFile.existsSync(), isTrue);
    expect(postFile.existsSync(), isTrue);
    expect(preFile.readAsStringSync(), isEmpty);
    expect(postFile.readAsStringSync(), isEmpty);
  });

  test(
      'Given no previousVersion parameter but existing migrations when writing migration version then it reuses latest available setup SQL files.',
      () async {
    const previousVersion = '20240104000000';
    const currentVersion = '20240105000000';

    var previousDirectory = MigrationConstants.migrationVersionDirectory(
      tempDirectory,
      previousVersion,
    );
    previousDirectory.createSync(recursive: true);

    var previousPreFile = MigrationConstants.preDatabaseSetupSQLPath(
      tempDirectory,
      previousVersion,
    );
    var previousPostFile = MigrationConstants.postDatabaseSetupSQLPath(
      tempDirectory,
      previousVersion,
    );
    previousPreFile.writeAsStringSync('LEGACY-PRE;');
    previousPostFile.writeAsStringSync('LEGACY-POST;');

    var migrationVersion =
        _createMigrationVersion(tempDirectory, currentVersion);

    await migrationVersion.write(
      installedModules:
          migrationVersion.databaseDefinitionFull.installedModules,
      removedModules: const [],
      previousVersion: null,
    );

    var newPreFile = MigrationConstants.preDatabaseSetupSQLPath(
      tempDirectory,
      currentVersion,
    );
    var newPostFile = MigrationConstants.postDatabaseSetupSQLPath(
      tempDirectory,
      currentVersion,
    );

    expect(newPreFile.readAsStringSync(), 'LEGACY-PRE;');
    expect(newPostFile.readAsStringSync(), 'LEGACY-POST;');
  });
}
