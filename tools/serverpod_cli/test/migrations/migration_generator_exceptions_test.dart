import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = path.join('test', 'migrations', 'test_assets');

  group('Given a corrupt migration registry file', () {
    var projectDirectory = Directory(path.join(
      testAssetsPath,
      'corrupt_migration_registry',
    ));
    var projectName = 'test_project';
    var generator = MigrationGenerator(
      directory: projectDirectory,
      projectName: projectName,
    );

    group('when creating migration', () {
      test('then migration registry load exception is thrown.', () async {
        expect(
          generator.createMigration(force: false, priority: 0),
          throwsA(
            isA<MigrationRegistryLoadException>()
                .having((e) => e.directoryPath, 'Directory path',
                    equals(generator.migrationsProjectDirectory.path))
                .having((e) => e.exception, 'Matching exception',
                    startsWith('FormatException: No')),
          ),
        );
      });
    });

    group('when creating repair migration', () {
      test('then null is returned.', () async {
        expect(
          generator.repairMigration(
            runMode:
                CreateRepairMigrationCommand.runModes.first /* development */,
            force: false,
          ),
          throwsA(
            isA<MigrationRegistryLoadException>()
                .having((e) => e.directoryPath, 'Directory path',
                    equals(generator.migrationsProjectDirectory.path))
                .having((e) => e.exception, 'Matching exception',
                    startsWith('FormatException: No')),
          ),
        );
      });
    });
  });

  group('Given a latest version migration folder that is empty', () {
    var projectDirectory =
        Directory(path.join(testAssetsPath, 'empty_migration'));
    var projectName = 'test_project';
    var generator = MigrationGenerator(
      directory: projectDirectory,
      projectName: projectName,
    );

    group('when creating migration', () {
      test('then migration version load exception is thrown.', () async {
        expect(
          generator.createMigration(force: false, priority: 0),
          throwsA(isA<MigrationVersionLoadException>()
              .having((e) => e.moduleName, 'Matching module name',
                  equals(projectName))
              .having((e) => e.versionName, 'Matching version name',
                  '00000000000000')
              .having((e) => e.exception, 'Matching exception',
                  startsWith('PathNotFoundException: Cannot open file'))),
        );
      });
    });

    group('when creating repair migration', () {
      test('then null is returned.', () async {
        expect(
          generator.repairMigration(
            runMode:
                CreateRepairMigrationCommand.runModes.first /* development */,
            force: false,
          ),
          throwsA(isA<MigrationVersionLoadException>()
              .having((e) => e.moduleName, 'Matching module name',
                  equals(projectName))
              .having((e) => e.versionName, 'Matching version name',
                  '00000000000000')
              .having((e) => e.exception, 'Matching exception',
                  startsWith('PathNotFoundException: Cannot open file'))),
        );
      });
    });
  });
}
