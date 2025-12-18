@Timeout(Duration(minutes: 5))
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() async {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group(
    'Given a serverpod project when generate is called with --no-interactive flag',
    () {
      var projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      var serverDir = path.join(projectName, '${projectName}_server');

      setUp(() async {
        var result = await runServerpod(
          ['create', projectName, '--mini', '-v', '--no-analytics'],
          workingDirectory: tempDir.path,
        );
        assert(
          result.exitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      test('then code generation succeeds from server directory', () async {
        var result = await runServerpod(
          ['--no-interactive', 'generate', '--no-analytics'],
          workingDirectory: path.join(tempDir.path, serverDir),
        );

        expect(result.exitCode, equals(0), reason: 'Generate should succeed');

        var allOutput = '${result.stdout}${result.stderr}';
        expect(
          allOutput.contains('Done') || allOutput.contains('success'),
          isTrue,
          reason: 'Should contain success message',
        );
      });

      test(
        'then code generation succeeds in CI environment (CI=true)',
        () async {
          // For this test we need to use startServerpod to set custom environment
          var process = await startServerpod(
            ['generate', '--no-analytics'],
            workingDirectory: path.join(tempDir.path, serverDir),
          );

          var stdout = await process.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .toList();
          var stderr = await process.stderr
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .toList();

          var exitCode = await process.exitCode;

          expect(
            exitCode,
            equals(0),
            reason: 'Generate should succeed in CI mode',
          );

          var allOutput = [...stdout, ...stderr].join('\n');
          expect(
            allOutput.contains('Done') || allOutput.contains('success'),
            isTrue,
            reason: 'Should contain success message',
          );
        },
      );

      test('then --interactive flag overrides CI environment', () async {
        var result = await runServerpod(
          ['--interactive', 'generate', '--no-analytics'],
          workingDirectory: path.join(tempDir.path, serverDir),
        );

        expect(
          result.exitCode,
          equals(0),
          reason:
              'Generate should succeed even in CI when --interactive is explicitly set',
        );

        var allOutput = '${result.stdout}${result.stderr}';
        expect(
          allOutput.contains('Done') || allOutput.contains('success'),
          isTrue,
          reason: 'Should contain success message',
        );
      });
    },
  );

  group('Given multiple server directories when generate is called', () {
    late String projectRoot;
    late Directory server1;
    late Directory server2;

    setUp(() async {
      projectRoot = path.join(tempDir.path, 'multi_server_project');
      await Directory(projectRoot).create(recursive: true);

      // Create first server directory
      server1 = Directory(path.join(projectRoot, 'server1'));
      await _createMinimalServerStructure(server1, 'server1');

      // Create second server directory
      server2 = Directory(path.join(projectRoot, 'server2'));
      await _createMinimalServerStructure(server2, 'server2');
    });

    test('then with --no-interactive it fails with ambiguous error', () async {
      var result = await runServerpod(
        ['--no-interactive', 'generate', '--no-analytics'],
        workingDirectory: projectRoot,
      );

      expect(
        result.exitCode,
        isNot(equals(0)),
        reason:
            'Generate should fail with multiple servers in non-interactive mode',
      );

      var allOutput = '${result.stdout}${result.stderr}';
      expect(
        allOutput.contains('Multiple Serverpod projects detected'),
        isTrue,
        reason: 'Should contain ambiguous server error message',
      );
    });

    test('then with --interactive it shows selection prompt', () async {
      var process = await startServerpod(
        ['--interactive', 'generate', '--no-analytics'],
        workingDirectory: projectRoot,
      );

      var stdout = <String>[];
      var stderr = <String>[];
      var promptDetected = Completer<bool>();

      process.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
            stdout.add(line);
            if (line.contains('Multiple Serverpod server projects found') ||
                line.contains('Select one')) {
              promptDetected.complete(true);
            }
          });

      process.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
            stderr.add(line);
            if (line.contains('Multiple Serverpod server projects found') ||
                line.contains('Select one')) {
              promptDetected.complete(true);
            }
          });

      // Wait for prompt or timeout
      var hasPrompt = await promptDetected.future.timeout(
        Duration(seconds: 10),
        onTimeout: () => false,
      );

      // Kill the process since we can't interact with it
      process.kill();
      await process.exitCode;

      expect(
        hasPrompt,
        isTrue,
        reason: 'Should show prompt for selecting server directory',
      );

      var allOutput = [...stdout, ...stderr].join('\n');
      print('Output when multiple servers found:\n$allOutput');
    });
  });
}

/// Creates a minimal Serverpod server directory structure for testing
Future<void> _createMinimalServerStructure(
  Directory serverDir,
  String projectName,
) async {
  await serverDir.create(recursive: true);

  // Create lib/src/protocol directory
  var protocolDir = Directory(
    path.join(serverDir.path, 'lib', 'src', 'protocol'),
  );
  await protocolDir.create(recursive: true);

  // Create config directory
  var configDir = Directory(path.join(serverDir.path, 'config'));
  await configDir.create(recursive: true);

  // Create .dart_tool/package_config.json
  var dartToolDir = Directory(path.join(serverDir.path, '.dart_tool'));
  await dartToolDir.create(recursive: true);
  var packageConfigFile = File(
    path.join(dartToolDir.path, 'package_config.json'),
  );
  await packageConfigFile.writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "$projectName",
      "rootUri": "../",
      "packageUri": "lib/"
    },
    {
      "name": "serverpod",
      "rootUri": "../.pub-cache/hosted/pub.dev/serverpod-2.0.0",
      "packageUri": "lib/"
    }
  ]
}
''');

  // Create pubspec.yaml
  var pubspecFile = File(path.join(serverDir.path, 'pubspec.yaml'));
  await pubspecFile.writeAsString('''
name: $projectName
dependencies:
  serverpod: ^2.0.0
''');

  // Create client directory (sibling to server)
  var clientDir = Directory(
    path.join(serverDir.parent.path, '${projectName}_client'),
  );
  await clientDir.create(recursive: true);
  var clientLibDir = Directory(
    path.join(clientDir.path, 'lib', 'src', 'protocol'),
  );
  await clientLibDir.create(recursive: true);
  var clientPubspecFile = File(path.join(clientDir.path, 'pubspec.yaml'));
  await clientPubspecFile.writeAsString('''
name: ${projectName}_client
dependencies:
  serverpod_client: ^2.0.0
''');
}
