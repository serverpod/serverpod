import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
  group(
    'Given a serverpod project with a root pubspec',
    () {
      late String projectName;

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

        // Create a root pubspec.yaml with name: _ (simulating workspace)
        await d.dir(projectName, [
          d.file('pubspec.yaml', '''
name: _
environment:
  sdk: ^3.0.0
'''),
        ]).create();
      });

      test(
        'when create-migration is called from project root then it should succeed.',
        () async {
          var result = await runServerpod(
            ['create-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, projectName),
          );

          var allOutput = '${result.stdout}${result.stderr}'.toLowerCase();
          expect(
            allOutput.contains('not a server package (_)'),
            isFalse,
            reason: 'Should not error about root pubspec name',
          );

          expect(
            result.exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

          expect(
            allOutput.contains('no changes detected') ||
                allOutput.contains('migration created'),
            isTrue,
            reason: 'Should indicate no changes or migration created',
          );
        },
      );

      test(
        'when create-repair-migration is called from project root then it should not fail due to root pubspec.',
        () async {
          var result = await runServerpod(
            ['create-repair-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, projectName),
          );

          var allOutput = '${result.stdout}${result.stderr}'.toLowerCase();
          expect(
            allOutput.contains('not a server package (_)'),
            isFalse,
            reason: 'Should not error about root pubspec name',
          );

          if (result.exitCode != 0) {
            expect(
              allOutput.contains('not a server package'),
              isFalse,
              reason: 'Should not fail due to server package detection',
            );
          }
        },
      );
    },
  );

  group(
    'Given a serverpod project without a root pubspec',
    () {
      late String projectName;
      late String clientDir;

      setUp(() async {
        projectName =
            'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
        clientDir = path.join(projectName, '${projectName}_client');

        var result = await runServerpod(
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: d.sandbox,
        );
        assert(
          result.exitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      test(
        'when create-migration is called from client directory then it should succeed.',
        () async {
          var result = await runServerpod(
            ['create-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, clientDir),
          );

          expect(
            result.exitCode,
            equals(0),
            reason: 'create-migration should succeed with exit code 0',
          );

          var allOutput = '${result.stdout}${result.stderr}'.toLowerCase();
          expect(
            allOutput.contains('no changes detected') ||
                allOutput.contains('migration created'),
            isTrue,
            reason: 'Should indicate no changes or migration created',
          );
        },
      );

      test(
        'when create-repair-migration is called from client directory then it should not fail due to package detection.',
        () async {
          var result = await runServerpod(
            ['create-repair-migration', '--no-analytics'],
            workingDirectory: path.join(d.sandbox, clientDir),
          );

          var allOutput = '${result.stdout}${result.stderr}'.toLowerCase();
          expect(
            allOutput.contains('not a server package'),
            isFalse,
            reason: 'Should not error about client package name',
          );

          if (result.exitCode != 0) {
            expect(
              allOutput.contains('not a server package'),
              isFalse,
              reason: 'Should not fail due to server package detection',
            );
          }
        },
      );
    },
  );
}
