@Timeout(Duration(minutes: 12))

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliPath = path.join(rootPath, 'tools', 'serverpod_cli');
  final tempPath = path.join(rootPath, tempDirName);

  setUpAll(() async {
    await runProcess(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    await Directory(tempPath).create();
  });

  tearDownAll(() async {
    try {
      await Directory(tempPath).delete(recursive: true);
    } catch (e) {}
  });

  group('Given a clean state', () {
    group('when creating a new project', () {
      final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

      late Process createProcess;

      tearDown(() async {
        createProcess.kill();
      });

      test('then workspace pubspec.yaml is created', () async {
        createProcess = await startProcess(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var createProjectExitCode = await createProcess.exitCode;
        expect(
          createProjectExitCode,
          0,
          reason: 'Failed to create the serverpod project.',
        );

        // Check workspace pubspec exists
        final workspacePubspec =
            File(path.join(tempPath, projectName, 'pubspec.yaml'));
        expect(
          workspacePubspec.existsSync(),
          isTrue,
          reason: 'Workspace pubspec.yaml should exist at project root',
        );

        // Read and verify workspace pubspec content
        final content = workspacePubspec.readAsStringSync();
        expect(content, contains('name: _'));
        expect(content, contains('publish_to: none'));
        expect(content, contains('sdk: ^3.6.0'));
        expect(content, contains('workspace:'));
        expect(content, contains('  - ${projectName}_server'));
        expect(content, contains('  - ${projectName}_client'));
        expect(content, contains('  - ${projectName}_flutter'));

        // In development mode, should have dependency overrides
        expect(content, contains('dependency_overrides:'));
        expect(content, contains('serverpod:'));
        expect(content, contains('path: $rootPath/packages/serverpod'));
      });
    });

    group('when creating a new module', () {
      final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

      late Process createProcess;

      tearDown(() async {
        createProcess.kill();
      });

      test('then workspace has correct members', () async {
        createProcess = await startProcess(
          'serverpod',
          [
            'create',
            projectName,
            '--template',
            'module',
            '-v',
            '--no-analytics'
          ],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var createProjectExitCode = await createProcess.exitCode;
        expect(
          createProjectExitCode,
          0,
          reason: 'Failed to create the serverpod module.',
        );

        // Check workspace pubspec exists
        final workspacePubspec =
            File(path.join(tempPath, projectName, 'pubspec.yaml'));
        expect(
          workspacePubspec.existsSync(),
          isTrue,
          reason: 'Workspace pubspec.yaml should exist at module root',
        );

        // Read and verify workspace pubspec content
        final content = workspacePubspec.readAsStringSync();
        expect(content, contains('workspace:'));
        expect(content, contains('  - ${projectName}_server'));
        expect(content, contains('  - ${projectName}_client'));
        // Module should NOT have flutter
        expect(content, isNot(contains('  - ${projectName}_flutter')));
      });
    });

    group('when creating a project', () {
      final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

      late Process createProcess;

      setUpAll(() async {
        createProcess = await startProcess(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var createProjectExitCode = await createProcess.exitCode;
        assert(createProjectExitCode == 0);
      });

      tearDownAll(() async {
        createProcess.kill();
      });

      test('then individual packages have resolution: workspace', () async {
        // Check server pubspec has resolution: workspace
        final serverPubspec = File(path.join(
            tempPath, projectName, '${projectName}_server', 'pubspec.yaml'));
        final serverContent = serverPubspec.readAsStringSync();
        expect(serverContent, contains('resolution: workspace'));

        // Check client pubspec has resolution: workspace
        final clientPubspec = File(path.join(
            tempPath, projectName, '${projectName}_client', 'pubspec.yaml'));
        final clientContent = clientPubspec.readAsStringSync();
        expect(clientContent, contains('resolution: workspace'));

        // Check flutter pubspec has resolution: workspace
        final flutterPubspec = File(path.join(
            tempPath, projectName, '${projectName}_flutter', 'pubspec.yaml'));
        final flutterContent = flutterPubspec.readAsStringSync();
        expect(flutterContent, contains('resolution: workspace'));
      });

      test('then only one pubspec.lock exists at root', () async {
        // Check root lock file exists
        final rootLock = File(path.join(tempPath, projectName, 'pubspec.lock'));
        expect(
          rootLock.existsSync(),
          isTrue,
          reason: 'Root pubspec.lock should exist',
        );

        // Check individual packages don't have lock files
        final serverLock = File(path.join(
            tempPath, projectName, '${projectName}_server', 'pubspec.lock'));
        final clientLock = File(path.join(
            tempPath, projectName, '${projectName}_client', 'pubspec.lock'));
        final flutterLock = File(path.join(
            tempPath, projectName, '${projectName}_flutter', 'pubspec.lock'));

        expect(
          serverLock.existsSync(),
          isFalse,
          reason: 'Server should not have its own pubspec.lock',
        );
        expect(
          clientLock.existsSync(),
          isFalse,
          reason: 'Client should not have its own pubspec.lock',
        );
        expect(
          flutterLock.existsSync(),
          isFalse,
          reason: 'Flutter should not have its own pubspec.lock',
        );
      });

      test('then dart pub workspace list shows all members', () async {
        // Run dart pub workspace list
        final workspaceListResult = await Process.run(
          'dart',
          ['pub', 'workspace', 'list'],
          workingDirectory: path.join(tempPath, projectName),
        );

        expect(
          workspaceListResult.exitCode,
          equals(0),
          reason: 'dart pub workspace list should succeed',
        );

        final output = workspaceListResult.stdout.toString();
        expect(output, contains('${projectName}_server'));
        expect(output, contains('${projectName}_client'));
        expect(output, contains('${projectName}_flutter'));
      });
    });
  });
}
