@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
  group(
    'Given an existing directory with a valid project name and no server directory',
    () {
      late String projectName;
      late String projectDir;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
        projectDir = path.join(d.sandbox, projectName);

        await Directory(projectDir).create(recursive: true);
        await File(path.join(projectDir, 'README.md')).writeAsString(
          '# Existing repository\n',
        );
      });

      test(
        'when create is called with dot then project is created in the current directory.',
        () async {
          var result = await runServerpod(
            ['create', '.', '--mini'],
            workingDirectory: projectDir,
          );

          expect(
            result.exitCode,
            equals(0),
            reason:
                'create should succeed when targeting the current directory',
          );

          expect(
            File(path.join(projectDir, 'README.md')).existsSync(),
            isTrue,
            reason: 'Existing repository files should be preserved',
          );
          expect(
            File(path.join(projectDir, 'pubspec.yaml')).existsSync(),
            isTrue,
            reason:
                'Root workspace pubspec should be created in the current directory',
          );
          expect(
            Directory(
              path.join(projectDir, '${projectName}_server'),
            ).existsSync(),
            isTrue,
            reason: 'Server package should be created in the current directory',
          );
          expect(
            Directory(
              path.join(projectDir, '${projectName}_client'),
            ).existsSync(),
            isTrue,
            reason: 'Client package should be created in the current directory',
          );

          var allOutput = '${result.stdout}${result.stderr}';
          expect(
            allOutput.contains('cd ${projectName}_server'),
            isTrue,
            reason:
                'Start instructions should point to the server directory in the current location',
          );
          expect(
            allOutput.contains(
              'cd ${path.join(projectName, '${projectName}_server')}',
            ),
            isFalse,
            reason:
                'Start instructions should not point to a nested project directory',
          );
        },
      );
    },
  );

  group(
    'Given a mini Serverpod project',
    () {
      late String projectName;
      late String projectDir;
      late String serverDir;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
        projectDir = path.join(d.sandbox, projectName);
        serverDir = path.join(projectDir, '${projectName}_server');

        var result = await runServerpod(
          ['create', projectName, '--mini'],
          workingDirectory: d.sandbox,
        );
        if (result.exitCode != 0) {
          fail('Failed to create the serverpod mini project.');
        }
      });

      test(
        'when create is called with dot from the server directory then current project is upgraded.',
        () async {
          var result = await runServerpod(
            ['create', '.', '--template', 'server'],
            workingDirectory: serverDir,
          );

          expect(
            result.exitCode,
            equals(0),
            reason:
                'create should still upgrade an existing mini project from the server directory',
          );
          expect(
            Directory(path.join(serverDir, 'config')).existsSync(),
            isTrue,
            reason:
                'Upgrade should add the full server configuration to the current project',
          );
        },
      );
    },
  );
}
