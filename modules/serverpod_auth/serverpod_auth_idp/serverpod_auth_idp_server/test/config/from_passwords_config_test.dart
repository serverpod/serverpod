import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given missing IDP passwords', () {
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
      'when constructing EmailIdpConfigFromPasswords then throws PasswordNotFoundException.',
      () {
        expect(
          () => EmailIdpConfigFromPasswords(),
          throwsA(
            isA<PasswordNotFoundException>().having(
              (final e) => e.key,
              'key',
              'emailSecretHashPepper',
            ),
          ),
        );
      },
    );

    test(
      'when constructing GoogleIdpConfigFromPasswords then throws PasswordNotFoundException.',
      () {
        expect(
          () => GoogleIdpConfigFromPasswords(),
          throwsA(
            isA<PasswordNotFoundException>().having(
              (final e) => e.key,
              'key',
              'googleClientSecret',
            ),
          ),
        );
      },
    );

    test(
      'when constructing AppleIdpConfigFromPasswords then throws PasswordNotFoundException.',
      () {
        expect(
          () => AppleIdpConfigFromPasswords(),
          throwsA(
            isA<PasswordNotFoundException>().having(
              (final e) => e.key,
              'key',
              'appleServiceIdentifier',
            ),
          ),
        );
      },
    );

    test(
      'when constructing PasskeyIdpConfigFromPasswords then throws PasswordNotFoundException.',
      () {
        expect(
          () => PasskeyIdpConfigFromPasswords(),
          throwsA(
            isA<PasswordNotFoundException>().having(
              (final e) => e.key,
              'key',
              'passkeyHostname',
            ),
          ),
        );
      },
    );
  });

  group('Given emailSecretHashPepper password is present', () {
    late Directory originalDir;

    setUpAll(() async {
      originalDir = Directory.current;
      await d.dir('config', [
        d.file(
          'passwords.yaml',
          '''
test:
  database: 'test'
  emailSecretHashPepper: 'xK9#mP2\$vL5nQ8wR3jF6hY1cT4bN7zA0'
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
      'when constructing EmailIdpConfigFromPasswords then succeeds.',
      () {
        final config = EmailIdpConfigFromPasswords();
        expect(config, isA<EmailIdpConfig>());
      },
    );
  });

  group('Given googleClientSecret password is present', () {
    late Directory originalDir;

    setUpAll(() async {
      originalDir = Directory.current;
      await d.dir('config', [
        d.file(
          'passwords.yaml',
          '''
test:
  database: 'test'
  googleClientSecret: '{"web":{"client_id":"123456789012-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com","client_secret":"GOCSPX-abc123def456ghi789jkl012mno","redirect_uris":["http://localhost:8080/auth/google/callback"]}}'
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
      'when constructing GoogleIdpConfigFromPasswords then succeeds.',
      () {
        final config = GoogleIdpConfigFromPasswords();
        expect(config, isA<GoogleIdpConfig>());
      },
    );
  });

  group('Given all apple passwords are present', () {
    late Directory originalDir;

    setUpAll(() async {
      originalDir = Directory.current;
      await d.dir('config', [
        d.file(
          'passwords.yaml',
          '''
test:
  database: 'test'
  appleServiceIdentifier: 'com.example.service.auth'
  appleBundleIdentifier: 'com.example.app'
  appleRedirectUri: 'https://example.com/auth/apple/callback'
  appleTeamId: 'ABC1234DEF'
  appleKeyId: 'KEY1234567'
  appleKey: |
    -----BEGIN PRIVATE KEY-----
    MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgExample
    PrivateKeyContentHereBase64EncodedDataExample1234567890
    abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
    -----END PRIVATE KEY-----
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
      'when constructing AppleIdpConfigFromPasswords then succeeds.',
      () {
        final config = AppleIdpConfigFromPasswords();
        expect(config, isA<AppleIdpConfig>());
      },
    );
  });

  group('Given passkeyHostname password is present', () {
    late Directory originalDir;

    setUpAll(() async {
      originalDir = Directory.current;
      await d.dir('config', [
        d.file(
          'passwords.yaml',
          '''
test:
  database: 'test'
  passkeyHostname: 'auth.example.com'
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
      'when constructing PasskeyIdpConfigFromPasswords then succeeds.',
      () {
        final config = PasskeyIdpConfigFromPasswords();
        expect(config, isA<PasskeyIdpConfig>());
      },
    );
  });
}
