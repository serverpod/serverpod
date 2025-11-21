@Timeout(Duration(minutes: 5))
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() async {
  late Directory tempDir;
  var rootPath = path.join(Directory.current.path, '..', '..');
  var cliPath = path.join(rootPath, 'tools', 'serverpod_cli');

  setUpAll(() async {
    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    // Run command and activate again to force cache pub dependencies.
    await Process.run(
      'serverpod',
      ['version'],
      workingDirectory: cliPath,
    );

    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );
  });

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

    late Process createProcess;

    setUp(() async {
      createProcess = await Process.start(
        'serverpod',
        ['create', projectName, '--mini', '-v', '--no-analytics'],
        workingDirectory: tempDir.path,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      createProcess.stdout.transform(const Utf8Decoder()).listen(print);
      createProcess.stderr.transform(const Utf8Decoder()).listen(print);

      var createProjectExitCode = await createProcess.exitCode;
      assert(
        createProjectExitCode == 0,
        'Failed to create the serverpod project.',
      );
    });

    tearDown(() async {
      createProcess.kill();
    });

    test('then code generation succeeds from server directory', () async {
      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--no-interactive', '--no-analytics'],
        workingDirectory: path.join(tempDir.path, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var stdout = <String>[];
      var stderr = <String>[];

      generateProcess.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stdout.add(line);
      });

      generateProcess.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stderr.add(line);
      });

      var exitCode = await generateProcess.exitCode;

      expect(exitCode, equals(0), reason: 'Generate should succeed');

      var allOutput = [...stdout, ...stderr].join('\n');
      expect(
        allOutput.contains('Done') || allOutput.contains('success'),
        isTrue,
        reason: 'Should contain success message',
      );
    });

    test('then code generation succeeds in CI environment (CI=true)', () async {
      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--no-analytics'],
        workingDirectory: path.join(tempDir.path, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
          'CI': 'true', // Simulate CI environment
        },
      );

      var stdout = <String>[];
      var stderr = <String>[];

      generateProcess.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stdout.add(line);
      });

      generateProcess.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stderr.add(line);
      });

      var exitCode = await generateProcess.exitCode;

      expect(exitCode, equals(0), reason: 'Generate should succeed in CI mode');

      var allOutput = [...stdout, ...stderr].join('\n');
      expect(
        allOutput.contains('Done') || allOutput.contains('success'),
        isTrue,
        reason: 'Should contain success message',
      );
    });

    test('then --interactive flag overrides CI environment', () async {
      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--interactive', '--no-analytics'],
        workingDirectory: path.join(tempDir.path, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
          'CI': 'true', // Simulate CI environment
        },
      );

      var stdout = <String>[];
      var stderr = <String>[];

      generateProcess.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stdout.add(line);
      });

      generateProcess.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stderr.add(line);
      });

      var exitCode = await generateProcess.exitCode;

      expect(
        exitCode,
        equals(0),
        reason:
            'Generate should succeed even in CI when --interactive is explicitly set',
      );

      var allOutput = [...stdout, ...stderr].join('\n');
      expect(
        allOutput.contains('Done') || allOutput.contains('success'),
        isTrue,
        reason: 'Should contain success message',
      );
    });
  });

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
      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--no-interactive', '--no-analytics'],
        workingDirectory: projectRoot,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var stdout = <String>[];
      var stderr = <String>[];

      generateProcess.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stdout.add(line);
      });

      generateProcess.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stderr.add(line);
      });

      var exitCode = await generateProcess.exitCode;

      expect(
        exitCode,
        isNot(equals(0)),
        reason:
            'Generate should fail with multiple servers in non-interactive mode',
      );

      var allOutput = [...stdout, ...stderr].join('\n');
      expect(
        allOutput.contains('Multiple Serverpod projects detected'),
        isTrue,
        reason: 'Should contain ambiguous server error message',
      );
    });

    test('then with --interactive it shows selection prompt', () async {
      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--interactive', '--no-analytics'],
        workingDirectory: projectRoot,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var stdout = <String>[];
      var stderr = <String>[];
      var promptDetected = Completer<bool>();

      generateProcess.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((line) {
        stdout.add(line);
        if (line.contains('Multiple Serverpod server projects found') ||
            line.contains('Select one')) {
          promptDetected.complete(true);
        }
      });

      generateProcess.stderr
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
      generateProcess.kill();
      await generateProcess.exitCode;

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
  var protocolDir =
      Directory(path.join(serverDir.path, 'lib', 'src', 'protocol'));
  await protocolDir.create(recursive: true);

  // Create config directory
  var configDir = Directory(path.join(serverDir.path, 'config'));
  await configDir.create(recursive: true);

  // Create .dart_tool/package_config.json
  var dartToolDir = Directory(path.join(serverDir.path, '.dart_tool'));
  await dartToolDir.create(recursive: true);
  var packageConfigFile =
      File(path.join(dartToolDir.path, 'package_config.json'));
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
  var clientDir =
      Directory(path.join(serverDir.parent.path, '${projectName}_client'));
  await clientDir.create(recursive: true);
  var clientLibDir =
      Directory(path.join(clientDir.path, 'lib', 'src', 'protocol'));
  await clientLibDir.create(recursive: true);
  var clientPubspecFile = File(path.join(clientDir.path, 'pubspec.yaml'));
  await clientPubspecFile.writeAsString('''
name: ${projectName}_client
dependencies:
  serverpod_client: ^2.0.0
''');
}
