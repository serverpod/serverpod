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
            ['create', '.', '--template', 'server', '--no-interactive'],
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
            allOutput.contains('cd $projectName'),
            isTrue,
            reason: 'Start instructions should point to the project directory.',
          );

          expect(
            allOutput.contains('serverpod start'),
            isTrue,
            reason: 'Start instructions should mention serverpod start command',
          );
        },
      );
    },
  );
}
