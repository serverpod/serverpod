import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
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

  Future<void> initServerpodWithPasswords(final String passwords) async {
    await d.dir('config', [
      d.file('passwords.yaml', passwords),
    ]).create();

    // Constructing `Serverpod` internally sets `Serverpod.instance`, which the
    // config reads passwords and the run mode from.
    Serverpod(
      ['-m', 'test'],
      Protocol(),
      Endpoints(),
      config: ServerpodConfig(apiServer: portZeroConfig),
      serverDirectory: Directory(d.sandbox),
    );
  }

  group('Given the emailSecretHashPepper password is missing', () {
    setUpAll(() => initServerpodWithPasswords('test:\n  database: "test"'));

    test(
      'when constructing ServerpodCloudEmailIdpConfig then it throws a '
      'PasswordNotFoundException for emailSecretHashPepper',
      () {
        expect(
          () => ServerpodCloudEmailIdpConfig(appDisplayName: 'My App'),
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
  });

  group(
    'Given the emailSecretHashPepper password is present and development mode',
    () {
      setUpAll(
        () => initServerpodWithPasswords(
          "test:\n  database: 'test'\n  emailSecretHashPepper: 'a-pepper'\n",
        ),
      );

      test(
        'when constructing ServerpodCloudEmailIdpConfig then it succeeds '
        'without the cloud email key (codes are logged to the console)',
        () {
          final config = ServerpodCloudEmailIdpConfig(appDisplayName: 'My App');
          expect(config, isA<EmailIdpConfig>());
        },
      );
    },
  );

  group(
    'Given staging run mode and the scloudAuthEmailKey password is missing',
    () {
      setUpAll(
        () => initServerpodWithPasswords(
          "test:\n  database: 'test'\n  emailSecretHashPepper: 'a-pepper'\n",
        ),
      );

      test(
        'when constructing ServerpodCloudEmailIdpConfig then it still succeeds '
        '(the key is read lazily, so the server boots without it)',
        () {
          final config = ServerpodCloudEmailIdpConfig(
            appDisplayName: 'My App',
            runMode: ServerpodRunMode.staging,
          );
          expect(config, isA<EmailIdpConfig>());
        },
      );
    },
  );

  group('Given staging run mode and all required passwords are present', () {
    setUpAll(
      () => initServerpodWithPasswords(
        "test:\n  database: 'test'\n  emailSecretHashPepper: 'a-pepper'\n"
        "  scloudAuthEmailKey: 'a-cloud-token'\n",
      ),
    );

    test(
      'when constructing ServerpodCloudEmailIdpConfig then it succeeds',
      () {
        final config = ServerpodCloudEmailIdpConfig(
          appDisplayName: 'My App',
          runMode: ServerpodRunMode.staging,
        );
        expect(config, isA<EmailIdpConfig>());
      },
    );
  });
}
