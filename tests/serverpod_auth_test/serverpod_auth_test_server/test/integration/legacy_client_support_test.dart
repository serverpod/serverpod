import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart'
    as legacy_auth;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart';
import 'package:test/test.dart';

import '../util/test_tags.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: 'test-pepper',
  );

  tearDown(() {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [],
    );
  });

  withServerpod(
    'Given a migrated legacy user,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      // Must run before withServerpod starts the server; doing this in setUp
      // is too late for the server auth handler wiring used by legacy routes.
      _configurePublicLegacySupport(sessionBuilder);

      const email = 'legacy-client-test@serverpod.dev';
      const password = 'LegacyPass123!';

      setUp(() async {
        const config = EmailIdpConfig(secretHashPepper: 'test');
        AuthServices.set(
          identityProviderBuilders: [config],
          tokenManagerBuilders: [
            tokenManagerConfig,
            LegacySessionTokenManagerBuilder(),
          ],
        );

        final legacyUserId = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
              sessionBuilder,
              email: email,
              password: password,
            );

        await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
          sessionBuilder,
          legacyUserId: legacyUserId,
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when authenticating with correct credentials then returns success with session key.',
        () async {
          final client = _createClient(sessionBuilder);
          final result = await client.modules.auth.email.authenticate(
            email,
            password,
          );

          expect(result.success, isTrue);
          expect(result.key, isNotNull);
          expect(result.keyId, isNotNull);
          expect(result.userInfo, isNotNull);
          expect(result.userInfo!.id, isA<int>());
          expect(result.userInfo!.email, equals(email));
        },
      );

      test(
        'when authenticating with wrong password then returns invalidCredentials.',
        () async {
          final client = _createClient(sessionBuilder);
          final result = await client.modules.auth.email.authenticate(
            email,
            'wrong-password',
          );

          expect(result.success, isFalse);
          expect(
            result.failReason,
            equals(legacy_auth.AuthenticationFailReason.invalidCredentials),
          );
        },
      );

      test(
        'when authenticating with non-existent email then returns invalidCredentials.',
        () async {
          final client = _createClient(sessionBuilder);
          final result = await client.modules.auth.email.authenticate(
            'nobody@serverpod.dev',
            password,
          );

          expect(result.success, isFalse);
          expect(
            result.failReason,
            equals(legacy_auth.AuthenticationFailReason.invalidCredentials),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a migrated legacy user and a successful legacy authentication,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      _configurePublicLegacySupport(sessionBuilder);

      const email = 'legacy-session-test@serverpod.dev';
      const password = 'LegacyPass123!';

      late UuidValue authUserId;

      setUp(() async {
        const config = EmailIdpConfig(secretHashPepper: 'test');
        AuthServices.set(
          identityProviderBuilders: [config],
          tokenManagerBuilders: [
            tokenManagerConfig,
            LegacySessionTokenManagerBuilder(),
          ],
        );

        final legacyUserId = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
              sessionBuilder,
              email: email,
              password: password,
            );

        await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
          sessionBuilder,
          legacyUserId: legacyUserId,
        );

        final newAuthUserIdResult = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .getNewAuthUserId(sessionBuilder, userId: legacyUserId);
        authUserId = newAuthUserIdResult!;
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when validating the legacy session token then it is valid.',
        () async {
          final authKeyProvider = MutableAuthKeyProvider();
          final client = _createClient(
            sessionBuilder,
            authKeyProvider: authKeyProvider,
          );
          final authResult = await client.modules.auth.email.authenticate(
            email,
            password,
          );
          authKeyProvider.setToken('${authResult.keyId}:${authResult.key}');

          final isValid = await client.modules.auth.status.isSignedIn();

          expect(isValid, isTrue);
        },
      );

      test(
        'when validating the token then the user identifier matches.',
        () async {
          final authKeyProvider = MutableAuthKeyProvider();
          final client = _createClient(
            sessionBuilder,
            authKeyProvider: authKeyProvider,
          );
          final authResult = await client.modules.auth.email.authenticate(
            email,
            password,
          );
          authKeyProvider.setToken('${authResult.keyId}:${authResult.key}');

          final userInfo = await client.modules.auth.status.getUserInfo();

          expect(userInfo?.userIdentifier, equals(authUserId.toString()));
        },
      );

      test(
        'when revoking the token then it becomes invalid.',
        () async {
          final authKeyProvider = MutableAuthKeyProvider();
          final client = _createClient(
            sessionBuilder,
            authKeyProvider: authKeyProvider,
          );
          final authResult = await client.modules.auth.email.authenticate(
            email,
            password,
          );
          authKeyProvider.setToken('${authResult.keyId}:${authResult.key}');

          await client.modules.auth.status.signOutDevice();

          final isValid = await client.modules.auth.status.isSignedIn();

          expect(isValid, isFalse);
        },
      );
    },
  );

  withServerpod(
    'Given a migrated user with multiple legacy sessions,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      _configurePublicLegacySupport(sessionBuilder);

      const email = 'legacy-multi-session@serverpod.dev';
      const password = 'LegacyPass123!';

      late MutableAuthKeyProvider authKeyProvider1;
      late MutableAuthKeyProvider authKeyProvider2;
      late Client client1;
      late Client client2;

      setUp(() async {
        const config = EmailIdpConfig(secretHashPepper: 'test');
        AuthServices.set(
          identityProviderBuilders: [config],
          tokenManagerBuilders: [
            tokenManagerConfig,
            LegacySessionTokenManagerBuilder(),
          ],
        );

        final legacyUserId = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
              sessionBuilder,
              email: email,
              password: password,
            );

        await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
          sessionBuilder,
          legacyUserId: legacyUserId,
        );

        authKeyProvider1 = MutableAuthKeyProvider();
        authKeyProvider2 = MutableAuthKeyProvider();
        client1 = _createClient(
          sessionBuilder,
          authKeyProvider: authKeyProvider1,
        );
        client2 = _createClient(
          sessionBuilder,
          authKeyProvider: authKeyProvider2,
        );

        final result1 = await client1.modules.auth.email.authenticate(
          email,
          password,
        );
        authKeyProvider1.setToken('${result1.keyId}:${result1.key}');

        final result2 = await client2.modules.auth.email.authenticate(
          email,
          password,
        );
        authKeyProvider2.setToken('${result2.keyId}:${result2.key}');
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when revoking all tokens then all become invalid.',
        () async {
          await client1.modules.auth.status.signOutAllDevices();

          final isValid1 = await client1.modules.auth.status.isSignedIn();
          final isValid2 = await client2.modules.auth.status.isSignedIn();

          expect(isValid1, isFalse);
          expect(isValid2, isFalse);
        },
      );
    },
  );

  withServerpod(
    'Given a post-migration user (no legacy record),',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      _configurePublicLegacySupport(sessionBuilder);

      const email = 'post-migration@serverpod.dev';
      const password = 'NewPass123!';

      setUp(() async {
        String? receivedVerificationCode;
        final config = EmailIdpConfig(
          secretHashPepper: 'test',
          sendRegistrationVerificationCode:
              (
                final session, {
                required final email,
                required final accountRequestId,
                required final transaction,
                required final verificationCode,
              }) {
                receivedVerificationCode = verificationCode;
              },
        );
        AuthServices.set(
          identityProviderBuilders: [config],
          tokenManagerBuilders: [
            tokenManagerConfig,
            LegacySessionTokenManagerBuilder(),
          ],
        );

        final requestId = await endpoints.emailAccount.startRegistration(
          sessionBuilder,
          email: email,
        );

        final registrationToken = await endpoints.emailAccount
            .verifyRegistrationCode(
              sessionBuilder,
              accountRequestId: requestId,
              verificationCode: receivedVerificationCode!,
            );

        await endpoints.emailAccount.finishRegistration(
          sessionBuilder,
          registrationToken: registrationToken,
          password: password,
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when authenticating via legacy endpoint then returns internalError.',
        () async {
          final client = _createClient(sessionBuilder);
          final result = await client.modules.auth.email.authenticate(
            email,
            password,
          );

          expect(result.success, isFalse);
          expect(
            result.failReason,
            equals(legacy_auth.AuthenticationFailReason.internalError),
          );
        },
      );
    },
  );

  withServerpod(
    'Given unsupported legacy email methods,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      _configurePublicLegacySupport(sessionBuilder);

      test(
        'when calling createAccountRequest then returns not found.',
        () async {
          final client = _createClient(sessionBuilder);
          await expectLater(
            client.modules.auth.email.createAccountRequest(
              'test',
              'test@test.com',
              'pass',
            ),
            throwsA(isA<ServerpodClientNotFound>()),
          );
        },
      );

      test(
        'when calling changePassword then returns not found.',
        () async {
          final client = _createClient(sessionBuilder);
          await expectLater(
            client.modules.auth.email.changePassword(
              'old',
              'new',
            ),
            throwsA(isA<ServerpodClientNotFound>()),
          );
        },
      );

      test(
        'when calling initiatePasswordReset then returns not found.',
        () async {
          final client = _createClient(sessionBuilder);
          await expectLater(
            client.modules.auth.email.initiatePasswordReset(
              'test@test.com',
            ),
            throwsA(isA<ServerpodClientNotFound>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given unsupported legacy social auth endpoints,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      _configurePublicLegacySupport(sessionBuilder);

      test(
        'when calling Google authenticate then returns not found.',
        () async {
          final client = _createClient(sessionBuilder);
          await expectLater(
            client.modules.auth.google.authenticateWithIdToken(
              'fake-token',
            ),
            throwsA(isA<ServerpodClientNotFound>()),
          );
        },
      );

      test(
        'when calling Firebase authenticate then returns not found.',
        () async {
          final client = _createClient(sessionBuilder);
          await expectLater(
            client.modules.auth.firebase.authenticate(
              'fake-token',
            ),
            throwsA(isA<ServerpodClientNotFound>()),
          );
        },
      );
    },
  );
}

Client _createClient(
  final TestSessionBuilder sessionBuilder, {
  final ClientAuthKeyProvider? authKeyProvider,
}) {
  final session = sessionBuilder.build();
  final baseUrl = 'http://localhost:${session.server.port}/';
  return Client(baseUrl)..authKeyProvider = authKeyProvider;
}

void _configurePublicLegacySupport(final TestSessionBuilder sessionBuilder) {
  final pod = sessionBuilder.build().server.serverpod;
  pod.authenticationHandler = (final session, final authKey) =>
      AuthServices.instance.authenticationHandler(session, authKey);
  enableLegacyClientSupport(pod);
}

class MutableAuthKeyProvider implements ClientAuthKeyProvider {
  String? _token;

  @override
  Future<String?> get authHeaderValue async {
    if (_token == null) return null;
    return wrapAsBearerAuthHeaderValue(_token!);
  }

  void setToken(final String token) {
    _token = token;
  }
}

Future<void> _cleanUpDatabase(final Session session) async {
  await AuthUser.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await RateLimitedRequestAttempt.db.deleteWhere(
    session,
    where: (final t) => t.domain.equals('email'),
  );
}
