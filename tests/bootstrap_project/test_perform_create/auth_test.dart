import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  final rootPath = p.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);

  setUpAll(() async {
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  group(
    'Given a TemplateContext with auth and a database option enabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          auth: true,
          postgres: true,
        ),
      );

      test(
        'then the email idp endpoint file is created',
        () async {
          final file = File(
            p.join(
              project.serverDir,
              'lib',
              'src',
              'auth',
              'email_idp_endpoint.dart',
            ),
          );

          await expectLater(file.exists(), completion(true));
        },
      );

      test(
        'then the jwt refresh endpoint file is created',
        () async {
          final file = File(
            p.join(
              project.serverDir,
              'lib',
              'src',
              'auth',
              'jwt_refresh_endpoint.dart',
            ),
          );

          await expectLater(file.exists(), completion(true));
        },
      );

      test(
        'then the server server.dart file contains auth imports',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();

          expect(
            content,
            contains('package:serverpod_auth_idp_server/core.dart'),
          );

          expect(
            content,
            contains('package:serverpod_auth_idp_server/providers/email.dart'),
          );
        },
      );

      test(
        'then the server server.dart contains auth configuration',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('initializeAuthServices'));
          expect(content, contains('ServerpodCloudEmailIdpConfig'));
          expect(content, contains('JwtConfigFromPasswords'));
        },
      );

      test(
        'then the server passwords config contains auth secret keys',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'passwords.yaml'),
          );
          final content = await file.readAsString();
          expect(content, contains('emailSecretHashPepper:'));
          expect(content, contains('jwtHmacSha512PrivateKey:'));
          expect(content, contains('jwtRefreshTokenHashPepper:'));
        },
      );

      test(
        'then the server pubspec.yaml contains serverpod_auth_idp_server dependency',
        () async {
          final serverPubspec = File(p.join(project.serverDir, 'pubspec.yaml'));
          final content = await serverPubspec.readAsString();
          expect(content, contains('serverpod_auth_idp_server:'));
        },
      );

      test(
        'then the sign in screen file is created',
        () async {
          final file = File(
            p.join(
              project.flutterDir,
              'lib',
              'screens',
              'sign_in_screen.dart',
            ),
          );

          await expectLater(file.exists(), completion(true));
        },
      );

      test(
        'then the flutter main.dart contains auth configurations',
        () async {
          final file = File(
            p.join(project.flutterDir, 'lib', 'main.dart'),
          );
          final content = await file.readAsString();
          expect(
            content,
            contains(
              "import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';",
            ),
          );
          expect(
            content,
            contains('..authSessionManager = FlutterAuthSessionManager()'),
          );
          expect(content, contains('client.auth.initialize();'));
          expect(
            content,
            contains(
              '// To test authentication in this example app, uncomment the line below',
            ),
          );
        },
      );

      test(
        'then the flutter app pubspec.yaml contains serverpod_auth_idp_flutter dependency',
        () async {
          final pubspec = File(p.join(project.flutterDir, 'pubspec.yaml'));
          final content = await pubspec.readAsString();
          expect(content, contains('serverpod_auth_idp_flutter:'));
        },
      );

      test(
        'then the flutter app pubspec.yaml contains flutter_secure_storage override',
        () async {
          final pubspec = File(p.join(project.flutterDir, 'pubspec.yaml'));
          final content = await pubspec.readAsString();
          expect(content, contains('flutter_secure_storage:'));
        },
      );

      test(
        'then the client pubspec.yaml contains serverpod_auth_idp_client dependency',
        () async {
          final clientPubspec = File(p.join(project.clientDir, 'pubspec.yaml'));
          final content = await clientPubspec.readAsString();
          expect(content, contains('serverpod_auth_idp_client:'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with auth disabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          auth: false,
        ),
      );

      test(
        'then the email idp endpoint file is not created',
        () async {
          final file = File(
            p.join(
              project.serverDir,
              'lib',
              'src',
              'auth',
              'email_idp_endpoint.dart',
            ),
          );

          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the jwt refresh endpoint file is not created',
        () async {
          final file = File(
            p.join(
              project.serverDir,
              'lib',
              'src',
              'auth',
              'jwt_refresh_endpoint.dart',
            ),
          );

          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the server server.dart file does not contain auth imports',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();

          expect(
            content,
            isNot(contains('package:serverpod_auth_idp_server/core.dart')),
          );

          expect(
            content,
            isNot(
              contains(
                'package:serverpod_auth_idp_server/providers/email.dart',
              ),
            ),
          );
        },
      );

      test(
        'then the server server.dart does not contain auth configuration',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, isNot(contains('initializeAuthServices')));
          expect(content, isNot(contains('ServerpodCloudEmailIdpConfig')));
          expect(content, isNot(contains('JwtConfigFromPasswords')));
        },
      );

      test(
        'then the server pubspec.yaml does not contain serverpod_auth_idp_server dependency',
        () async {
          final serverPubspec = File(p.join(project.serverDir, 'pubspec.yaml'));
          final content = await serverPubspec.readAsString();
          expect(content, isNot(contains('serverpod_auth_idp_server:')));
        },
      );

      test(
        'then the sign in screen file is not created',
        () async {
          final file = File(
            p.join(
              project.flutterDir,
              'lib',
              'screens',
              'sign_in_screen.dart',
            ),
          );

          await expectLater(file.exists(), completion(false));
        },
      );

      test(
        'then the flutter main.dart does not contain auth configurations',
        () async {
          final file = File(
            p.join(project.flutterDir, 'lib', 'main.dart'),
          );
          final content = await file.readAsString();
          expect(
            content,
            isNot(
              contains(
                "import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';",
              ),
            ),
          );
          expect(
            content,
            isNot(
              contains('..authSessionManager = FlutterAuthSessionManager()'),
            ),
          );
          expect(content, isNot(contains('client.auth.initialize();')));
          expect(
            content,
            isNot(
              contains(
                '// To test authentication in this example app, uncomment the line below',
              ),
            ),
          );
        },
      );

      test(
        'then the flutter app pubspec.yaml does not contain serverpod_auth_idp_flutter dependency',
        () async {
          final pubspec = File(p.join(project.flutterDir, 'pubspec.yaml'));
          final content = await pubspec.readAsString();
          expect(content, isNot(contains('serverpod_auth_idp_flutter:')));
        },
      );

      test(
        'then the flutter app pubspec.yaml does not contain flutter_secure_storage override',
        () async {
          final pubspec = File(p.join(project.flutterDir, 'pubspec.yaml'));
          final content = await pubspec.readAsString();
          expect(content, isNot(contains('flutter_secure_storage:')));
        },
      );

      test(
        'then the client pubspec.yaml does not contain serverpod_auth_idp_client dependency',
        () async {
          final clientPubspec = File(p.join(project.clientDir, 'pubspec.yaml'));
          final content = await clientPubspec.readAsString();
          expect(content, isNot(contains('serverpod_auth_idp_client:')));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with auth disabled and a database option enabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          auth: false,
          postgres: true,
        ),
      );

      test(
        'then the server passwords config does not contain auth secret keys',
        () async {
          final file = File(
            p.join(project.serverDir, 'config', 'passwords.yaml'),
          );
          final content = await file.readAsString();
          expect(content, isNot(contains('emailSecretHashPepper:')));
          expect(content, isNot(contains('jwtHmacSha512PrivateKey:')));
          expect(content, isNot(contains('jwtRefreshTokenHashPepper:')));
        },
      );
    },
  );
}
