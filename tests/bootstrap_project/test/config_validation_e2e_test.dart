@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp-config-validation';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);
  final tempPath = path.join(rootPath, tempDirName);

  setUpAll(() async {
    await Directory(tempPath).create();
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  tearDownAll(() async {
    try {
      Directory(tempPath).deleteSync(recursive: true);
    } catch (e) {}
  });

  group('Given a serverpod project with invalid environment variables', () {
    final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

    setUpAll(() async {
      // Create a mini serverpod project for testing
      final createProcess = await startServerpodCli(
        [
          'create',
          '--template',
          'mini',
          projectName,
          '-v',
          '--no-analytics',
        ],
        rootPath: rootPath,
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      final createProjectExitCode = await createProcess.exitCode;
      expect(
        createProjectExitCode,
        0,
        reason: 'Failed to create the serverpod project.',
      );
    });

    test(
      'when starting server with negative websocketPingInterval '
      'then server exits with code 1 and displays error message',
      () async {
        final result = await runProcess(
          'dart',
          ['bin/main.dart'],
          workingDirectory: commandRoot,
          environment: {
            'SERVERPOD_WEBSOCKET_PING_INTERVAL': '-1',
          },
        );

        expect(result.exitCode, 1);
        expect(
          result.stderr.toString(),
          contains('Error loading ServerpodConfig'),
        );
        expect(
          result.stderr.toString(),
          contains('Invalid SERVERPOD_WEBSOCKET_PING_INTERVAL'),
        );
        expect(
          result.stderr.toString(),
          contains('from environment variable: -1'),
        );
        expect(
          result.stderr.toString(),
          contains('Expected a positive integer greater than 0'),
        );
      },
    );

    test(
      'when starting server with zero websocketPingInterval '
      'then server exits with code 1 and displays error message',
      () async {
        final result = await runProcess(
          'dart',
          ['bin/main.dart'],
          workingDirectory: commandRoot,
          environment: {
            'SERVERPOD_WEBSOCKET_PING_INTERVAL': '0',
          },
        );

        expect(result.exitCode, 1);
        expect(
          result.stderr.toString(),
          contains('Error loading ServerpodConfig'),
        );
        expect(
          result.stderr.toString(),
          contains('Invalid SERVERPOD_WEBSOCKET_PING_INTERVAL'),
        );
        expect(
          result.stderr.toString(),
          contains('from environment variable: 0'),
        );
        expect(
          result.stderr.toString(),
          contains('Expected a positive integer greater than 0'),
        );
      },
    );

    test(
      'when starting server with non-numeric websocketPingInterval '
      'then server exits with code 1 and displays error message',
      () async {
        final result = await runProcess(
          'dart',
          ['bin/main.dart'],
          workingDirectory: commandRoot,
          environment: {
            'SERVERPOD_WEBSOCKET_PING_INTERVAL': 'invalid',
          },
        );

        expect(result.exitCode, 1);
        expect(
          result.stderr.toString(),
          contains('Error loading ServerpodConfig'),
        );
        expect(
          result.stderr.toString(),
          contains('Invalid SERVERPOD_WEBSOCKET_PING_INTERVAL'),
        );
        expect(
          result.stderr.toString(),
          contains('from environment variable: invalid'),
        );
        expect(
          result.stderr.toString(),
          contains('Expected a positive integer'),
        );
      },
    );

    test(
      'when starting server with valid websocketPingInterval '
      'then server starts successfully in maintenance mode',
      () async {
        final result = await runProcess(
          'dart',
          ['bin/main.dart', '--role', 'maintenance'],
          workingDirectory: commandRoot,
          environment: {
            'SERVERPOD_WEBSOCKET_PING_INTERVAL': '15',
          },
        );

        expect(result.exitCode, 0);
      },
    );
  });
}
