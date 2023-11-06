import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/migrations/migration_exceptions.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = p.join('test', 'migrations', 'test_assets');

  group('Given a latest version migration folder that is empty', () {
    var projectDirectory = Directory(p.join(testAssetsPath, 'empty_migration'));
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
            runMode: CreateMigrationCommand.runModes.first /* development */,
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
