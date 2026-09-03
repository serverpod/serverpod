import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'web_auth_test_utils.dart';

void main() {
  group('Given AuthServices is not initialized', () {
    test(
      'when configureWebAuthRoutes is called then it throws StateError.',
      () {
        final pod = createWebAuthPod();
        expect(pod.configureWebAuthRoutes, throwsA(isA<StateError>()));
      },
    );
  });

  group('Given AuthServices initialized with SAS', () {
    test(
      'when authCookie is unset then configureWebAuthRoutes throws.',
      () {
        final pod = createWebAuthPod(authCookie: null, allowedOrigins: null);
        initSasAuth(pod);
        expect(pod.configureWebAuthRoutes, throwsA(isA<StateError>()));
      },
    );

    test(
      'when loginSuccessPath is unsafe then configureWebAuthRoutes throws.',
      () {
        final pod = createWebAuthPod();
        initSasAuth(pod);
        expect(
          () => pod.configureWebAuthRoutes(loginSuccessPath: '//evil'),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when authCookie.sameSite is strict then configureWebAuthRoutes throws.',
      () {
        final pod = createWebAuthPod(
          authCookie: const WebAuthCookieConfig(
            secure: false,
            sameSite: CookieSameSite.strict,
          ),
        );
        initSasAuth(pod);
        expect(pod.configureWebAuthRoutes, throwsA(isA<ArgumentError>()));
      },
    );

    test(
      'when the HMAC pepper is missing then configureWebAuthRoutes throws.',
      () async {
        await d.dir('config', [
          d.file('passwords.yaml', 'test:\n  database: "test"\n'),
        ]).create();
        final pod = createWebAuthPod(serverDirectory: Directory(d.sandbox));
        initSasAuth(pod);
        expect(
          pod.configureWebAuthRoutes,
          throwsA(isA<PasswordNotFoundException>()),
        );
      },
    );

    test(
      'when Google redirectUris does not include the HTML callback '
      'then configureWebAuthRoutes throws.',
      () {
        final pod = createWebAuthPod();
        initSasAuth(
          pod,
          identityProviderBuilders: [
            GoogleIdpConfig(
              clientSecret: googleSecret(
                redirectUris: ['https://evil.example/callback'],
              ),
            ),
          ],
        );
        expect(pod.configureWebAuthRoutes, throwsA(isA<ArgumentError>()));
      },
    );

    test(
      'when Google redirectUris is empty then configureWebAuthRoutes succeeds.',
      () {
        final pod = createWebAuthPod();
        initSasAuth(
          pod,
          identityProviderBuilders: [
            GoogleIdpConfig(
              clientSecret: googleSecret(redirectUris: const []),
            ),
          ],
        );
        expect(pod.configureWebAuthRoutes, returnsNormally);
      },
    );
  });

  group('Given JWT as the primary token manager', () {
    test('when configureWebAuthRoutes is called then it throws.', () {
      final pod = createWebAuthPod();
      pod.initializeAuthServices(
        tokenManagerBuilders: [
          JwtConfig(
            refreshTokenHashPepper: 'test-pepper-long-enough',
            algorithm: JwtAlgorithm.hmacSha512(
              SecretKey('test-private-key-for-HS512'),
            ),
          ),
        ],
      );
      expect(pod.configureWebAuthRoutes, throwsA(isA<StateError>()));
    });
  });
}
