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
    setUpAll(() async {
      await d.dir('config', [
        d.file('passwords.yaml', 'test:\n  database: "test"'),
      ]).create();

      // Constructing `Serverpod` internally sets `Serverpod.instance`.
      // This is used in `*FromPasswords` constructors to retrieve passwords.
      Serverpod(
        ['-m', 'test'],
        Protocol(),
        Endpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
        serverDirectory: Directory(d.sandbox),
      );
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

  group(
    'Given JWT passwords are present',
    () {
      setUpAll(() async {
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

        Serverpod(
          ['-m', 'test'],
          Protocol(),
          Endpoints(),
          config: ServerpodConfig(apiServer: portZeroConfig),
          serverDirectory: Directory(d.sandbox),
        );
      });

      test(
        'when constructing JwtConfigFromPasswords then succeeds.',
        () {
          final config = JwtConfigFromPasswords();
          expect(config, isA<JwtConfig>());
        },
      );

      test(
        'when constructing JwtConfigFromPasswords with onRefreshTokenCreated then callback is stored correctly.',
        () {
          Future<void> onRefreshTokenCreated(
            final Session session, {
            required final UuidValue authUserId,
            required final UuidValue refreshTokenId,
            required final Transaction? transaction,
          }) async {}

          final config = JwtConfigFromPasswords(
            onRefreshTokenCreated: onRefreshTokenCreated,
          );
          expect(config.onRefreshTokenCreated, same(onRefreshTokenCreated));
        },
      );
    },
  );

  group(
    'Given serverSideSessionKeyHashPepper password is present',
    () {
      setUpAll(() async {
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

        Serverpod(
          ['-m', 'test'],
          Protocol(),
          Endpoints(),
          config: ServerpodConfig(apiServer: portZeroConfig),
          serverDirectory: Directory(d.sandbox),
        );
      });

      test(
        'when constructing ServerSideSessionsConfigFromPasswords then succeeds.',
        () {
          final config = ServerSideSessionsConfigFromPasswords();
          expect(config, isA<ServerSideSessionsConfig>());
        },
      );

      test(
        'when constructing ServerSideSessionsConfigFromPasswords with onSessionCreated then callback is stored correctly.',
        () {
          Future<void> onSessionCreated(
            final Session session, {
            required final UuidValue authUserId,
            required final UuidValue serverSideSessionId,
            required final Transaction? transaction,
          }) async {}

          final config = ServerSideSessionsConfigFromPasswords(
            onSessionCreated: onSessionCreated,
          );
          expect(config.onSessionCreated, same(onSessionCreated));
        },
      );
    },
  );
}
