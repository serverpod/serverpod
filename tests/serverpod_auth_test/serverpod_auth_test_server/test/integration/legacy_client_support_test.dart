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
      // Must run before withServerpod boots the server so legacy middleware is
      // active for all requests in this group.
      _configurePublicLegacySupport(sessionBuilder);

      const email = 'legacy-client-test@serverpod.dev';
      const password = 'LegacyPass123!';

      setUp(() async {
        const config = EmailIdpConfig(secretHashPepper: 'test');
        AuthServices.set(
          identityProviderBuilders: [config],
          tokenManagerBuilders: [
            tokenManagerConfig,
            const LegacySessionTokenManager(),
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
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result =
              await legacy_auth.Caller(
                legacyClient,
              ).email.authenticate(
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
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result =
              await legacy_auth.Caller(
                legacyClient,
              ).email.authenticate(
                email,
                'wrong-password',
              );

          expect(result.success, isFalse);
          expect(
            result.failReason,
            equals(
              legacy_auth.AuthenticationFailReason.invalidCredentials,
            ),
          );
        },
      );

      test(
        'when authenticating with non-existent email then returns invalidCredentials.',
        () async {
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result =
              await legacy_auth.Caller(
                legacyClient,
              ).email.authenticate(
                'nobody@serverpod.dev',
                password,
              );

          expect(result.success, isFalse);
          expect(
            result.failReason,
            equals(
              legacy_auth.AuthenticationFailReason.invalidCredentials,
            ),
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
            const LegacySessionTokenManager(),
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
          final legacyClient = _createLegacyClient(
            sessionBuilder,
            authKeyProvider: authKeyProvider,
          );
          final authResult = await legacy_auth.Caller(legacyClient).email
              .authenticate(
                email,
                password,
              );
          authKeyProvider.setToken('${authResult.keyId}:${authResult.key}');

          final isValid = await legacyClient.modules.auth.status.isSignedIn();

          expect(isValid, isTrue);
        },
      );

      test(
        'when validating the token then the user identifier matches.',
        () async {
          final authKeyProvider = MutableAuthKeyProvider();
          final legacyClient = _createLegacyClient(
            sessionBuilder,
            authKeyProvider: authKeyProvider,
          );
          final authResult = await legacy_auth.Caller(legacyClient).email
              .authenticate(
                email,
                password,
              );
          authKeyProvider.setToken('${authResult.keyId}:${authResult.key}');

          final userInfo = await legacyClient.modules.auth.status.getUserInfo();

          expect(userInfo?.userIdentifier, equals(authUserId.toString()));
        },
      );

      test(
        'when changing full name via legacy user endpoint then it is updated.',
        () async {
          final authKeyProvider = MutableAuthKeyProvider();
          final legacyClient = _createLegacyClient(
            sessionBuilder,
            authKeyProvider: authKeyProvider,
          );
          final authResult = await legacy_auth.Caller(legacyClient).email
              .authenticate(
                email,
                password,
              );
          authKeyProvider.setToken('${authResult.keyId}:${authResult.key}');

          final changed = await legacyClient.modules.auth.user.changeFullName(
            'Legacy Full Name',
          );
          final updatedUserInfo = await legacyClient.modules.auth.status
              .getUserInfo();

          expect(changed, isTrue);
          expect(updatedUserInfo?.fullName, equals('Legacy Full Name'));
        },
      );

      test(
        'when revoking the token then it becomes invalid.',
        () async {
          final authKeyProvider = MutableAuthKeyProvider();
          final legacyClient = _createLegacyClient(
            sessionBuilder,
            authKeyProvider: authKeyProvider,
          );
          final authResult = await legacy_auth.Caller(legacyClient).email
              .authenticate(
                email,
                password,
              );
          authKeyProvider.setToken('${authResult.keyId}:${authResult.key}');

          await legacy_auth.Caller(legacyClient).status.signOutDevice();

          final isValid = await legacyClient.modules.auth.status.isSignedIn();

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
      late _LegacyClient legacyClient1;
      late _LegacyClient legacyClient2;

      setUp(() async {
        const config = EmailIdpConfig(secretHashPepper: 'test');
        AuthServices.set(
          identityProviderBuilders: [config],
          tokenManagerBuilders: [
            tokenManagerConfig,
            const LegacySessionTokenManager(),
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
        legacyClient1 = _createLegacyClient(
          sessionBuilder,
          authKeyProvider: authKeyProvider1,
        );
        legacyClient2 = _createLegacyClient(
          sessionBuilder,
          authKeyProvider: authKeyProvider2,
        );

        final result1 =
            await legacy_auth.Caller(
              legacyClient1,
            ).email.authenticate(
              email,
              password,
            );
        authKeyProvider1.setToken('${result1.keyId}:${result1.key}');

        final result2 =
            await legacy_auth.Caller(
              legacyClient2,
            ).email.authenticate(
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
          await legacy_auth.Caller(legacyClient1).status.signOutAllDevices();

          final isValid1 = await legacy_auth.Caller(
            legacyClient1,
          ).status.isSignedIn();
          final isValid2 = await legacy_auth.Caller(
            legacyClient2,
          ).status.isSignedIn();

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
            const LegacySessionTokenManager(),
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
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result =
              await legacy_auth.Caller(
                legacyClient,
              ).email.authenticate(
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
        'when calling createAccountRequest then returns false.',
        () async {
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result = await legacy_auth.Caller(legacyClient).email
              .createAccountRequest(
                'test',
                'test@test.com',
                'pass',
              );

          expect(result, isFalse);
        },
      );

      test(
        'when calling changePassword then returns false.',
        () async {
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result = await legacyClient.modules.auth.email.changePassword(
            'old',
            'new',
          );

          expect(result, isFalse);
        },
      );

      test(
        'when calling initiatePasswordReset then returns false.',
        () async {
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result = await legacy_auth.Caller(legacyClient).email
              .initiatePasswordReset(
                'test@test.com',
              );

          expect(result, isFalse);
        },
      );
    },
  );

  withServerpod(
    'Given legacy endpoints outside the forwarding allowlist,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      _configurePublicLegacySupport(sessionBuilder);

      test(
        'when calling Google authenticate then it is handled by non-legacy endpoint.',
        () async {
          final legacyClient = _createLegacyClient(sessionBuilder);
          await expectLater(
            legacy_auth.Caller(legacyClient).google.authenticateWithIdToken(
              'fake-token',
            ),
            throwsA(isA<legacy_auth.ServerpodClientInternalServerError>()),
          );
        },
      );

      test(
        'when calling Firebase authenticate then it is handled by non-legacy endpoint.',
        () async {
          final legacyClient = _createLegacyClient(sessionBuilder);
          final result = await legacyClient.modules.auth.firebase.authenticate(
            'fake-token',
          );

          expect(result.success, isFalse);
          expect(
            result.failReason,
            equals(legacy_auth.AuthenticationFailReason.internalError),
          );
        },
      );

      test(
        'when calling Admin getUserInfo then it is handled by non-legacy endpoint.',
        () async {
          final legacyClient = _createLegacyClient(sessionBuilder);
          await expectLater(
            legacy_auth.Caller(legacyClient).admin.getUserInfo(1),
            throwsA(isA<legacy_auth.ServerpodClientUnauthorized>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given migrated legacy users and an authenticated admin session,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      _configurePublicLegacySupport(sessionBuilder);

      const adminEmail = 'legacy-admin@serverpod.dev';
      const targetEmail = 'legacy-user@serverpod.dev';
      const password = 'LegacyPass123!';

      late int targetLegacyUserId;
      late MutableAuthKeyProvider adminAuthKeyProvider;
      late Client adminClient;
      late _LegacyClient adminLegacyClient;

      setUp(() async {
        const config = EmailIdpConfig(secretHashPepper: 'test');
        AuthServices.set(
          identityProviderBuilders: [config],
          tokenManagerBuilders: [
            tokenManagerConfig,
            const LegacySessionTokenManager(),
          ],
        );

        final adminLegacyUserId = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
              sessionBuilder,
              email: adminEmail,
              password: password,
            );
        targetLegacyUserId = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .createLegacyUser(
              sessionBuilder,
              email: targetEmail,
              password: password,
            );

        await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
          sessionBuilder,
          legacyUserId: adminLegacyUserId,
        );
        await endpoints.emailAccountBackwardsCompatibilityTest.migrateUser(
          sessionBuilder,
          legacyUserId: targetLegacyUserId,
        );

        final adminAuthUserId = await endpoints
            .emailAccountBackwardsCompatibilityTest
            .getNewAuthUserId(sessionBuilder, userId: adminLegacyUserId);

        final session = sessionBuilder.build();
        final adminAuthUser = await AuthServices.instance.authUsers.get(
          session,
          authUserId: adminAuthUserId!,
        );
        await AuthServices.instance.authUsers.update(
          session,
          authUserId: adminAuthUserId,
          scopes: {...adminAuthUser.scopes, Scope.admin},
        );

        adminAuthKeyProvider = MutableAuthKeyProvider();
        adminClient = _createClient(
          sessionBuilder,
          authKeyProvider: adminAuthKeyProvider,
        );
        adminLegacyClient = _createLegacyClient(
          sessionBuilder,
          authKeyProvider: adminAuthKeyProvider,
        );
        final adminAuthResult = await legacy_auth.Caller(
          adminLegacyClient,
        ).email.authenticate(adminEmail, password);
        adminAuthKeyProvider.setToken(
          '${adminAuthResult.keyId}:${adminAuthResult.key}',
        );
      });

      tearDown(() async {
        await _cleanUpDatabase(sessionBuilder.build());
      });

      test(
        'when calling getUserInfo then it returns mapped user data.',
        () async {
          final userInfo = await adminClient
              .modules
              .serverpod_auth_bridge
              .legacyAdmin
              .getUserInfo(targetLegacyUserId);

          expect(userInfo, isNotNull);
          expect(userInfo!.id, equals(targetLegacyUserId));
          expect(userInfo.email, equals(targetEmail));
          expect(userInfo.blocked, isFalse);
        },
      );

      test(
        'when blocking a user then authentication fails with blocked.',
        () async {
          await adminClient.modules.serverpod_auth_bridge.legacyAdmin.blockUser(
            targetLegacyUserId,
          );

          final blockedInfo = await adminClient
              .modules
              .serverpod_auth_bridge
              .legacyAdmin
              .getUserInfo(targetLegacyUserId);
          expect(blockedInfo!.blocked, isTrue);

          final targetLegacyClient = _createLegacyClient(sessionBuilder);
          final authResult = await targetLegacyClient.modules.auth.email
              .authenticate(
                targetEmail,
                password,
              );

          expect(authResult.success, isFalse);
          expect(
            authResult.failReason,
            equals(legacy_auth.AuthenticationFailReason.blocked),
          );
        },
      );

      test(
        'when unblocking a user then authentication succeeds again.',
        () async {
          await adminClient.modules.serverpod_auth_bridge.legacyAdmin.blockUser(
            targetLegacyUserId,
          );
          await adminClient.modules.serverpod_auth_bridge.legacyAdmin
              .unblockUser(
                targetLegacyUserId,
              );

          final unblockedInfo = await adminClient
              .modules
              .serverpod_auth_bridge
              .legacyAdmin
              .getUserInfo(targetLegacyUserId);
          expect(unblockedInfo!.blocked, isFalse);

          final targetLegacyClient = _createLegacyClient(sessionBuilder);
          final authResult = await legacy_auth.Caller(
            targetLegacyClient,
          ).email.authenticate(targetEmail, password);

          expect(authResult.success, isTrue);
        },
      );
    },
  );
}

_LegacyClient _createLegacyClient(
  final TestSessionBuilder sessionBuilder, {
  final ClientAuthKeyProvider? authKeyProvider,
}) {
  final session = sessionBuilder.build();
  final baseUrl = 'http://localhost:${session.server.port}/';
  return _LegacyClient(baseUrl)..authKeyProvider = authKeyProvider;
}

class _LegacyClient extends ServerpodClientShared {
  _LegacyClient(final String host)
    : super(
        host,
        legacy_auth.Protocol(),
        streamingConnectionTimeout: null,
        connectionTimeout: null,
      ) {
    modules = _LegacyModules(this);
  }

  late final _LegacyModules modules;

  @override
  Map<String, EndpointRef> get endpointRefLookup => const {};

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
  };
}

class _LegacyModules {
  _LegacyModules(final _LegacyClient client) {
    auth = legacy_auth.Caller(client);
  }

  late final legacy_auth.Caller auth;
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
  pod.enableLegacyClientSupport();
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
