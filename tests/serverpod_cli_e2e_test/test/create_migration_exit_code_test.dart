@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
  group(
    'Given a serverpod project with an initial migration',
    () {
      late String projectName;
      late String serverDir;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

        var result = await runServerpod(
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
        );
        assert(
          result.exitCode == 0,
          'Failed to create the serverpod project.',
        );

        serverDir = path.join(
          d.sandbox,
          projectName,
          '${projectName}_server',
        );
      });

      test(
        'when create-migration is called with no changes then exit code is 0.',
        () async {
          var result = await runServerpod(
            ['create-migration', '--no-analytics'],
            workingDirectory: serverDir,
          );

          var allOutput = '${result.stdout}${result.stderr}'.toLowerCase();
          expect(
            allOutput.contains('no changes detected'),
            isTrue,
            reason: 'Should indicate no changes detected',
          );

          expect(
            result.exitCode,
            equals(0),
            reason: 'Empty migration (no changes) should exit with code 0',
          );
        },
      );
    },
  );

  group(
    'Given a serverpod project with a migration that has warnings',
    () {
      late String projectName;
      late String serverDir;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

        var createResult = await runServerpod(
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
        );
        assert(
          createResult.exitCode == 0,
          'Failed to create the serverpod project.',
        );

        serverDir = path.join(
          d.sandbox,
          projectName,
          '${projectName}_server',
        );

        // Add a model with a table
        var modelFile = File(
          path.join(serverDir, 'lib', 'src', 'protocol', 'example.yaml'),
        );
        modelFile.parent.createSync(recursive: true);
        modelFile.writeAsStringSync('''
class: Example
table: example
fields:
  name: String
  toBeDropped: String?
''');

        // Create initial migration with the column
        var initialMigrationResult = await runServerpod(
          ['create-migration', '--force', '--no-analytics'],
          workingDirectory: serverDir,
        );
        assert(
          initialMigrationResult.exitCode == 0,
          'Failed to create initial migration.',
        );

        // Remove the column to trigger a warning
        modelFile.writeAsStringSync('''
class: Example
table: example
fields:
  name: String
''');
      });

      test(
        'when create-migration is called without --force then exit code is 1.',
        () async {
          var result = await runServerpod(
            ['create-migration', '--no-analytics'],
            workingDirectory: serverDir,
          );

          var allOutput = '${result.stdout}${result.stderr}'.toLowerCase();
          expect(
            allOutput.contains('warning') || allOutput.contains('aborted'),
            isTrue,
            reason: 'Should indicate migration was aborted due to warnings',
          );

          expect(
            result.exitCode,
            equals(1),
            reason: 'Aborted migration should exit with code 1',
          );
        },
      );

      test(
        'when create-migration is called with --force then exit code is 0.',
        () async {
          var result = await runServerpod(
            ['create-migration', '--force', '--no-analytics'],
            workingDirectory: serverDir,
          );

          expect(
            result.exitCode,
            equals(0),
            reason: 'Migration with --force should succeed with exit code 0',
          );
        },
      );
    },
  );
}
