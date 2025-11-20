@Timeout(Duration(minutes: 5))
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

  group('Given a serverpod project when generate is called from anywhere', () {
    var projectName =
        'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
    var serverDir = path.join(projectName, '${projectName}_server');
    var clientDir = path.join(projectName, '${projectName}_client');

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

    test('then code generation succeeds when running from client directory.',
        () async {
      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--no-analytics'],
        workingDirectory: path.join(tempDir.path, clientDir),
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

      // Verify that generated files exist
      var generatedEndpointsFile = File(path.join(
        tempDir.path,
        serverDir,
        'lib',
        'src',
        'generated',
        'endpoints.dart',
      ));
      expect(
        generatedEndpointsFile.existsSync(),
        isTrue,
        reason: 'Generated endpoints file should exist',
      );

      var generatedProtocolFile = File(path.join(
        tempDir.path,
        serverDir,
        'lib',
        'src',
        'generated',
        'protocol.dart',
      ));
      expect(
        generatedProtocolFile.existsSync(),
        isTrue,
        reason: 'Generated protocol file should exist',
      );
    });

    test('then code generation succeeds when running from server subdirectory.',
        () async {
      var libSrcPath = path.join(tempDir.path, serverDir, 'lib', 'src');

      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--no-analytics'],
        workingDirectory: libSrcPath,
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

      // Verify that generated files exist
      var generatedEndpointsFile = File(path.join(
        tempDir.path,
        serverDir,
        'lib',
        'src',
        'generated',
        'endpoints.dart',
      ));
      expect(
        generatedEndpointsFile.existsSync(),
        isTrue,
        reason: 'Generated endpoints file should exist',
      );
    });

    test('then code generation succeeds when running from project root.',
        () async {
      var generateProcess = await Process.start(
        'serverpod',
        ['generate', '--no-analytics'],
        workingDirectory: path.join(tempDir.path, projectName),
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

      // Verify that generated files exist
      var generatedEndpointsFile = File(path.join(
        tempDir.path,
        serverDir,
        'lib',
        'src',
        'generated',
        'endpoints.dart',
      ));
      expect(
        generatedEndpointsFile.existsSync(),
        isTrue,
        reason: 'Generated endpoints file should exist',
      );
    });
  });
}
