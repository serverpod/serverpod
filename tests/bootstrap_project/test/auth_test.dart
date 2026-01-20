@Timeout(Duration(minutes: 12))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

import '../lib/src/util.dart';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);

  setUpAll(() async {
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  group('Given a clean state', () {
    final projectName =
        'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
    final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
      projectName,
    );

    group('when creating a new project', () {
      late File serverFile;
      late File mainFile;

      setUpAll(() async {
        var process = await startServerpodCli(
          [
            'create',
            projectName,
            '-v',
            '--no-analytics',
          ],
          rootPath: rootPath,
          workingDirectory: d.sandbox,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        var exitCode = await process.exitCode;
        assert(exitCode == 0);

        serverFile = File(
          path.join(d.sandbox, serverDir, 'lib', 'server.dart'),
        );
        mainFile = File(
          path.join(d.sandbox, flutterDir, 'lib', 'main.dart'),
        );
      });

      test('then the server pubspec contains auth dependencies', () {
        final pubspec = File(path.join(d.sandbox, serverDir, 'pubspec.yaml'));
        final content = pubspec.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_server'));
      });

      test('then the client pubspec contains auth dependencies', () {
        final pubspec = File(path.join(d.sandbox, clientDir, 'pubspec.yaml'));
        final content = pubspec.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_client'));
      });

      test('then the flutter pubspec contains auth dependencies', () {
        final pubspec = File(path.join(d.sandbox, flutterDir, 'pubspec.yaml'));
        final content = pubspec.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_flutter'));
      });

      test('then the email idp endpoint file is created', () {
        final endpointFile = File(
          path.join(
            d.sandbox,
            serverDir,
            'lib',
            'src',
            'auth',
            'email_idp_endpoint.dart',
          ),
        );
        expect(endpointFile.existsSync(), isTrue);
      });

      test('then the jwt refresh endpoint file is created', () {
        final endpointFile = File(
          path.join(
            d.sandbox,
            serverDir,
            'lib',
            'src',
            'auth',
            'jwt_refresh_endpoint.dart',
          ),
        );
        expect(endpointFile.existsSync(), isTrue);
      });

      test('then the server server.dart contains auth imports', () {
        final content = serverFile.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_server'));
      });

      test('then the server server.dart contains auth configuration', () {
        final content = serverFile.readAsStringSync();
        expect(content, contains('initializeAuthServices'));
        expect(content, contains('EmailIdpConfigFromPasswords'));
        expect(content, contains('JwtConfigFromPasswords'));
      });

      test('then the flutter main.dart contains auth imports', () {
        final content = mainFile.readAsStringSync();
        expect(content, contains('serverpod_auth_idp_flutter'));
      });

      test('then the flutter main.dart contains SignInWidget', () {
        final content = mainFile.readAsStringSync();
        expect(content, contains('SignInScreen'));
      });

      test('then the flutter main.dart contains FlutterAuthSessionManager', () {
        final content = mainFile.readAsStringSync();
        expect(content, contains('FlutterAuthSessionManager'));
      });
    });
  });
}
