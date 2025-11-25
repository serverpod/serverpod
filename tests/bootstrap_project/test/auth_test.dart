@Timeout(Duration(minutes: 12))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp_auth';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);
  final cliDartEntrypoint = getServerpodCliEntrypointPath(rootPath: rootPath);
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
      await Directory(tempPath).delete(recursive: true);
    } catch (e) {}
  });

  group('Given a clean state', () {
    var (:projectName, :commandRoot) = createRandomProjectName(tempPath);
    final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
      projectName,
    );

    group('when creating a new project', () {
      setUpAll(() async {
        var process = await startProcess(
          'dart',
          [
            'run',
            cliDartEntrypoint,
            'create',
            projectName,
            '-v',
            '--no-analytics',
          ],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var exitCode = await process.exitCode;
        assert(exitCode == 0);
      });

      test('then the server pubspec contains auth dependencies', () {
        final pubspec = File(path.join(tempPath, serverDir, 'pubspec.yaml'));
        final content = pubspec.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_server'));
      });

      test('then the client pubspec contains auth dependencies', () {
        final pubspec = File(path.join(tempPath, clientDir, 'pubspec.yaml'));
        final content = pubspec.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_client'));
      });

      test('then the flutter pubspec contains auth dependencies', () {
        final pubspec = File(path.join(tempPath, flutterDir, 'pubspec.yaml'));
        final content = pubspec.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_flutter'));
      });

      test('then the email idp endpoint file is created', () {
        final endpointFile = File(
          path.join(
            tempPath,
            serverDir,
            'lib',
            'src',
            'endpoints',
            'email_idp_endpoint.dart',
          ),
        );
        expect(endpointFile.existsSync(), isTrue);
      });
    });
  });
}
