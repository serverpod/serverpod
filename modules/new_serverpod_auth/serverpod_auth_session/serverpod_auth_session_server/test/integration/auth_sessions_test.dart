import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/business/auth_session_secrets.dart';
import 'package:serverpod_auth_session_server/src/generated/auth_session.dart';
import 'package:serverpod_auth_session_server/src/util/session_key_hash.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given the `AuthSessions` implementation,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();
        authUserId = await _createAuthUser(session);
      });

      test(
        'when creating a session for a user, then the authentication handler resolves the returned secret correctly back to the user ID.',
        () async {
          final sessionSecret = await AuthSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            scopes: const {},
          );

          final authInfo = await AuthSessions.authenticationHandler(
            session,
            sessionSecret,
          );

          expect(authInfo?.userUuid, authUserId);
        },
      );

      test(
        'when creating a session for a user with custom scopes, then the authentication handler returns those scopes.',
        () async {
          final sessionSecret = await AuthSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            scopes: {Scope.admin},
          );

          final authInfo = await AuthSessions.authenticationHandler(
            session,
            sessionSecret,
          );

          expect(authInfo?.scopes, {Scope.admin});
        },
      );

      test(
        'when revoking a session for a user, then a message for it is broadcast.',
        () async {
          final sessionSecretA = await AuthSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            scopes: const {},
          );

          final authInfoABeforeRevocation =
              await AuthSessions.authenticationHandler(
            session,
            sessionSecretA,
          );

          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(
            authInfoABeforeRevocation!.userIdentifier,
          );

          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          await AuthSessions.destroySession(
            session,
            authSessionId: authInfoABeforeRevocation.authSessionId,
          );

          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );

          expect(revocationMessages, [
            isA<RevokedAuthenticationAuthId>().having(
              (final m) => m.authId,
              'authId',
              authInfoABeforeRevocation.authId!,
            ),
          ]);
        },
      );

      test(
        'when revoking all session for a user, then a message for it is broadcast.',
        () async {
          // ignore: unused_result
          await AuthSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            scopes: const {},
          );

          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(authUserId);

          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          await AuthSessions.destroyAllSessions(
            session,
            authUserId: authUserId,
          );

          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );

          expect(revocationMessages, [isA<RevokedAuthenticationUser>()]);
        },
      );

      test(
        "when sending an invalid session key which has the module's prefix, then `null` is returned.",
        () async {
          final authInfo = await AuthSessions.authenticationHandler(
            session,
            'sas:xx',
          );

          expect(authInfo, isNull);
        },
      );

      test(
        'when sending an invalid session key which does not contain the correct secret, then `null` is returned.',
        () async {
          final sessionSecret = await AuthSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            scopes: const {},
          );

          final parts = sessionSecret.split(':');
          parts[2] = 'not-the-secret';
          final invalidSessionSecret = parts.join(':');

          final authInfo = await AuthSessions.authenticationHandler(
            session,
            invalidSessionSecret,
          );

          expect(authInfo, isNull);
        },
      );

      test(
        'when sending an invalid session key which does not contain a known session entry ID, then `null` is returned.`',
        () async {
          final sessionSecret = await AuthSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            scopes: const {},
          );

          final parts = sessionSecret.split(':');
          parts[1] = 'm6XDpRhOTWKfSbkTLC5oRA=='; // abse64 encoded UUID
          final invalidSessionSecret = parts.join(':');

          final authInfo = await AuthSessions.authenticationHandler(
            session,
            invalidSessionSecret,
          );

          expect(authInfo, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given the `AuthSessions` implementation with 2 active sessions for a user,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late String sessionSecretA;
      late String sessionSecretB;

      setUp(() async {
        session = sessionBuilder.build();
        authUserId = await _createAuthUser(session);
        sessionSecretA = await _createAuthSession(session, authUserId);
        sessionSecretB = await _createAuthSession(session, authUserId);
      });

      group(
        'when revoking a single session,',
        () {
          setUp(() async {
            final authInfoABeforeRevocation =
                await AuthSessions.authenticationHandler(
              session,
              sessionSecretA,
            );

            await AuthSessions.destroySession(
              session,
              authSessionId: authInfoABeforeRevocation!.authSessionId,
            );
          });

          test('then it is not usable anymore.', () async {
            final authInfoA = await AuthSessions.authenticationHandler(
              session,
              sessionSecretA,
            );

            expect(authInfoA, isNull);
          });

          test('then the other is still usable.', () async {
            final authInfoB = await AuthSessions.authenticationHandler(
              session,
              sessionSecretB,
            );

            expect(authInfoB, isNotNull);
          });
        },
      );

      test(
        'when revoking all sessions for a user, then all their sessions are revoked.',
        () async {
          await AuthSessions.destroyAllSessions(
            session,
            authUserId: authUserId,
          );

          final authInfoA = await AuthSessions.authenticationHandler(
            session,
            sessionSecretA,
          );

          expect(authInfoA, isNull);

          final authInfoB = await AuthSessions.authenticationHandler(
            session,
            sessionSecretB,
          );

          expect(authInfoB, isNull);
        },
      );
    },
  );

  withServerpod('Given an active user session for an existing user,',
      (final sessionBuilder, final endpoints) {
    late final Session session;
    late final UuidValue authUserId;
    late final String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await _createAuthUser(session);
      sessionKey = await _createAuthSession(session, authUserId);
    });

    tearDown(() {
      AuthSessionSecrets.sessionKeyHashPepperTestOverride = null;
    });

    test(
        "when the session key hash pepper is changed, then the user's session key becomes invalid.",
        () async {
      final authInfoBeforeChange = await AuthSessions.authenticationHandler(
        session,
        sessionKey,
      );

      expect(authInfoBeforeChange, isNotNull);

      AuthSessionSecrets.sessionKeyHashPepperTestOverride = 'new pepper 123';

      final authInfoAfterChange = await AuthSessions.authenticationHandler(
        session,
        sessionKey,
      );

      expect(authInfoAfterChange, isNull);
    });
  });

  withServerpod('Given the `AuthSessions` implementation,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();
      authUserId = await _createAuthUser(session);
    });

    tearDown(() {
      AuthSessionSecrets.sessionKeyHashPepperTestOverride = null;
    });

    test(
        'when the session key is checked, then it can be verified that it was built using `hashSessionKey` with the configured hash read beforehand.',
        () async {
      AuthSessionSecrets.sessionKeyHashPepperTestOverride =
          'test_pepper_override_1';

      {
        final sessionKey = await AuthSessions.createSession(
          session,
          authUserId: authUserId,
          method: 'test',
          scopes: {},
        );

        final authSession = await AuthSession.db.findFirstRow(
          session,
          orderBy: (final t) => t.created,
          orderDescending: true,
        );

        final secret = sessionKey.split(':')[2];

        expect(
          authSession!.sessionKeyHash,
          hashSessionKey(
            secret,
            pepper: AuthSessionSecrets.sessionKeyHashPepper,
          ),
        );
        expect(
          authSession.sessionKeyHash,
          isNot(
            hashSessionKey(
              secret,
              pepper: 'some other pepper value',
            ),
          ),
        );
      }

      AuthSessionSecrets.sessionKeyHashPepperTestOverride =
          'test_pepper_override_2';

      {
        final sessionKey = await AuthSessions.createSession(
          session,
          authUserId: authUserId,
          method: 'test',
          scopes: {},
        );

        final authSession = await AuthSession.db.findFirstRow(
          session,
          orderBy: (final t) => t.created,
          orderDescending: true,
        );

        final secret = sessionKey.split(':')[2];

        expect(
          authSession!.sessionKeyHash,
          hashSessionKey(
            secret,
            pepper: AuthSessionSecrets.sessionKeyHashPepper,
          ),
        );
      }
    });
  });
}

Future<UuidValue> _createAuthUser(final Session session) async {
  final authUser = await AuthUser.db.insertRow(
    session,
    AuthUser(
      created: DateTime.now(),
      scopeNames: {},
      blocked: false,
    ),
  );

  return authUser.id!;
}

Future<String> _createAuthSession(
  final Session session,
  final UuidValue authUserId,
) {
  return AuthSessions.createSession(
    session,
    authUserId: authUserId,
    method: 'test',
    scopes: const {},
  );
}
