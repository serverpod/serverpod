import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given missing core passwords', () {
    late Directory originalDir;

    setUpAll(() async {
      originalDir = Directory.current;
      await d.dir('config', [
        d.file('passwords.yaml', 'test:\n  database: "test"'),
      ]).create();
      Directory.current = d.sandbox;

      // Constructing `Serverpod` internally sets `Serverpod.instance`.
      // This is used in `*FromPasswords` constructors to retrieve passwords.
      Serverpod(
        ['-m', 'test'],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
      );

      // Teardown need to be done using `addTearDown` instead of `tearDownAll`
      // because the call to `addTearDown` inside `d.sandbox` will add a tear
      // down that will run before any declared `tearDown` functions. Otherwise,
      // the tests will fail on Windows because the `d.sandbox` teardown will
      // try to delete the original directory while `Directory.current` is still
      // set to it.
      addTearDown(() async {
        Directory.current = originalDir;
      });
    });

    test(
      'when constructing JwtConfigFromPasswords then throws PasswordNotFoundException.',
      () {
        expect(
          () => JwtConfigFromPasswords(),
          throwsA(
            isA<PasswordNotFoundException>().having(
              (final e) => e.key,
              'key',
              'jwtRefreshTokenHashPepper',
            ),
          ),
        );
      },
    );

    test(
      'when constructing ServerSideSessionsConfigFromPasswords then throws PasswordNotFoundException.',
      () {
        expect(
          () => ServerSideSessionsConfigFromPasswords(),
          throwsA(
            isA<PasswordNotFoundException>().having(
              (final e) => e.key,
              'key',
              'serverSideSessionKeyHashPepper',
            ),
          ),
        );
      },
    );
  });

  group('Given JWT passwords are present', () {
    late Directory originalDir;

    setUpAll(() async {
      originalDir = Directory.current;
      await d.dir('config', [
        d.file(
          'passwords.yaml',
          '''
test:
  database: 'test'
  jwtRefreshTokenHashPepper: 'xK9#mP2\$vL5nQ8wR3jF6hY1cT4bN7zA0'
  jwtHmacSha512PrivateKey: 'super-secret-key-for-hmac-sha512-signing'
''',
        ),
      ]).create();
      Directory.current = d.sandbox;

      Serverpod(
        ['-m', 'test'],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
      );

      addTearDown(() async {
        Directory.current = originalDir;
      });
    });

    test(
      'when constructing JwtConfigFromPasswords then succeeds.',
      () {
        final config = JwtConfigFromPasswords();
        expect(config, isA<JwtConfig>());
      },
    );
  });

  group('Given serverSideSessionKeyHashPepper password is present', () {
    late Directory originalDir;

    setUpAll(() async {
      originalDir = Directory.current;
      await d.dir('config', [
        d.file(
          'passwords.yaml',
          '''
test:
  database: 'test'
  serverSideSessionKeyHashPepper: 'xK9#mP2\$vL5nQ8wR3jF6hY1cT4bN7zA0'
''',
        ),
      ]).create();
      Directory.current = d.sandbox;

      Serverpod(
        ['-m', 'test'],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
      );

      addTearDown(() async {
        Directory.current = originalDir;
      });
    });

    test(
      'when constructing ServerSideSessionsConfigFromPasswords then succeeds.',
      () {
        final config = ServerSideSessionsConfigFromPasswords();
        expect(config, isA<ServerSideSessionsConfig>());
      },
    );
  });
}
