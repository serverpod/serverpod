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

  group(
    'Given a serverpod project when generate is called with -d option from a different directory',
    () {
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

      test(
        'then code generation succeeds when using absolute path with -d option.',
        () async {
          // Run generate from temp directory (parent of project) using -d with absolute path
          var absoluteServerPath = path.join(tempDir.path, serverDir);
          var generateProcess = await Process.start(
            'serverpod',
            ['generate', '-d', absoluteServerPath, '--no-analytics'],
            workingDirectory: tempDir.path,
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
          var generatedEndpointsFile = File(
            path.join(
              tempDir.path,
              serverDir,
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            ),
          );
          expect(
            generatedEndpointsFile.existsSync(),
            isTrue,
            reason: 'Generated endpoints file should exist',
          );

          var generatedProtocolFile = File(
            path.join(
              tempDir.path,
              serverDir,
              'lib',
              'src',
              'generated',
              'protocol.dart',
            ),
          );
          expect(
            generatedProtocolFile.existsSync(),
            isTrue,
            reason: 'Generated protocol file should exist',
          );

          // Verify client files were generated
          var clientProtocolDir = Directory(
            path.join(
              tempDir.path,
              clientDir,
              'lib',
              'src',
              'protocol',
            ),
          );
          expect(
            clientProtocolDir.existsSync(),
            isTrue,
            reason: 'Client protocol directory should exist',
          );
        },
      );

      test(
        'then code generation succeeds when using relative path with -d option.',
        () async {
          // Run generate from temp directory using -d with relative path
          var generateProcess = await Process.start(
            'serverpod',
            ['generate', '-d', serverDir, '--no-analytics'],
            workingDirectory: tempDir.path,
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
          var generatedEndpointsFile = File(
            path.join(
              tempDir.path,
              serverDir,
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            ),
          );
          expect(
            generatedEndpointsFile.existsSync(),
            isTrue,
            reason: 'Generated endpoints file should exist',
          );
        },
      );

      test(
        'then code generation fails with proper error when directory does not exist.',
        () async {
          var nonExistentDir = path.join(tempDir.path, 'nonexistent_server');
          var generateProcess = await Process.start(
            'serverpod',
            ['generate', '-d', nonExistentDir, '--no-analytics'],
            workingDirectory: tempDir.path,
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

          expect(exitCode, isNot(equals(0)), reason: 'Generate should fail');

          var allOutput = [...stdout, ...stderr].join('\n').toLowerCase();
          expect(
            allOutput.contains('error') || allOutput.contains('failed'),
            isTrue,
            reason: 'Should contain error message',
          );
        },
      );
    },
  );
}
