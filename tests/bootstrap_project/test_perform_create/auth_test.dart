import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

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
      late File serverFile;

      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();

        final context = TemplateContext(auth: true, postgres: true);

        await performCreate(
          projectName,
          ServerpodTemplateType.server,
          false,
          interactive: false,
          context: context,
        );

        serverFile = File(
          p.join(serverDir, 'lib', 'server.dart'),
        );
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      test(
        'then the email idp endpoint file is created',
        () async {
          final file = File(
            p.join(
              serverDir,
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
              serverDir,
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
          final content = await serverFile.readAsString();
          expect(content, contains('initializeAuthServices'));
          expect(content, contains('EmailIdpConfigFromPasswords'));
          expect(content, contains('JwtConfigFromPasswords'));
        },
      );

      test(
        'then the server passwords config contains auth secret keys',
        () async {
          final file = File(
            p.join(serverDir, 'config', 'passwords.yaml'),
          );
          final content = await file.readAsString();
          expect(content, contains('emailSecretHashPepper:'));
          expect(content, contains('jwtHmacSha512PrivateKey:'));
          expect(content, contains('jwtRefreshTokenHashPepper:'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with auth disabled, '
    'when performCreate is called with the context and a server template type',
    () {
      late File serverFile;

      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();

        await performCreate(
          projectName,
          ServerpodTemplateType.server,
          true,
          interactive: false,
          context: TemplateContext(auth: false),
        );

        serverFile = File(p.join(serverDir, 'lib', 'server.dart'));
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      test(
        'then the email idp endpoint file is not created',
        () async {
          final file = File(
            p.join(
              serverDir,
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
              serverDir,
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
          final content = await serverFile.readAsString();
          expect(content, isNot(contains('initializeAuthServices')));
          expect(content, isNot(contains('EmailIdpConfigFromPasswords')));
          expect(content, isNot(contains('JwtConfigFromPasswords')));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with auth disabled and a database option enabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final projectName =
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
      final (:serverDir, :flutterDir, :clientDir) = createProjectFolderPaths(
        projectName,
      );

      setUpAll(() async {
        setupForPerformCreateTest();
        final context = TemplateContext(auth: false, postgres: true);

        await performCreate(
          projectName,
          ServerpodTemplateType.server,
          true,
          interactive: false,
          context: context,
        );
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      test(
        'then the server passwords config does not contain auth secret keys',
        () async {
          final file = File(p.join(serverDir, 'config', 'passwords.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('emailSecretHashPepper:')));
          expect(content, isNot(contains('jwtHmacSha512PrivateKey:')));
          expect(content, isNot(contains('jwtRefreshTokenHashPepper:')));
        },
      );
    },
  );
}
