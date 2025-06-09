import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/business/auth_session_secrets.dart';
import 'package:serverpod_auth_session_server/src/generated/auth_session.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a plain auth session,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();
      authUserId = await _createAuthUser(session);
      sessionKey = await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        method: 'test',
        scopes: const {},
      );
    });

    tearDown(() {
      AuthSessions.secretsTestOverride = null;
    });

    test(
      'when resolving that session through the `authenticationHandler`, then the auth user ID is available on the auth info.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(authInfo?.userIdentifier, authUserId.toString());
        expect(authInfo?.userUuid, authUserId);
      },
    );

    test(
      'when resolving that session through the `authenticationHandler`, then it has no scopes.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(authInfo?.scopes, isEmpty);
      },
    );

    test(
      'when revoking a session for a user, then a message for it is broadcast.',
      () async {
        final authInfoABeforeRevocation =
            await AuthSessions.authenticationHandler(
          session,
          sessionKey,
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
      'when sending an invalid session key which does not contain the correct secret, then `null` is returned.',
      () async {
        final parts = sessionKey.split(':');
        parts[2] = base64Encode(utf8.encode('not-the-secret'));
        final invalidSessionKey = parts.join(':');

        final authInfo = await AuthSessions.authenticationHandler(
          session,
          invalidSessionKey,
        );

        expect(authInfo, isNull);
      },
    );

    test(
      'when sending an invalid session key which does not contain a known session entry ID, then `null` is returned.`',
      () async {
        final parts = sessionKey.split(':');
        parts[1] = 'm6XDpRhOTWKfSbkTLC5oRA=='; // abse64 encoded UUID
        final invalidSessionKey = parts.join(':');

        final authInfo = await AuthSessions.authenticationHandler(
          session,
          invalidSessionKey,
        );

        expect(authInfo, isNull);
      },
    );

    test(
        "when the session key hash pepper is changed, then the user's session key becomes invalid.",
        () async {
      final authInfoBeforeChange = await AuthSessions.authenticationHandler(
        session,
        sessionKey,
      );

      expect(authInfoBeforeChange, isNotNull);

      AuthSessions.secretsTestOverride = AuthSessionSecrets(
        sessionKeyHashPepper: 'new pepper 123',
      );

      final authInfoAfterChange = await AuthSessions.authenticationHandler(
        session,
        sessionKey,
      );

      expect(authInfoAfterChange, isNull);
    });

    test(
        "when the session key hash salte is changed in the database, then the user's session key becomes invalid.",
        () async {
      final authInfoBeforeChange = await AuthSessions.authenticationHandler(
        session,
        sessionKey,
      );

      expect(authInfoBeforeChange, isNotNull);

      final authSessionRow = (await AuthSession.db.find(session)).single;

      await AuthSession.db.updateRow(
        session,
        authSessionRow.copyWith(sessionKeyHash: ByteData(10)),
      );

      final authInfoAfterChange = await AuthSessions.authenticationHandler(
        session,
        sessionKey,
      );

      expect(authInfoAfterChange, isNull);
    });
  });

  withServerpod('Given an auth session with scopes,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();
      authUserId = await _createAuthUser(session);
      sessionKey = await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        method: 'test',
        scopes: {Scope.admin},
      );
    });

    test(
      'when resolving that session through the `authenticationHandler`, then it has the original scopes.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(authInfo?.scopes, {Scope.admin});
      },
    );
  });

  withServerpod(
    'Given no auth sessions,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

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
    },
  );

  withServerpod(
    'Given the `AuthSessions` implementation with 2 active sessions for a user,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late String sessionKey1;
      late String sessionKey2;

      setUp(() async {
        session = sessionBuilder.build();
        authUserId = await _createAuthUser(session);
        sessionKey1 = await _createAuthSession(session, authUserId);
        sessionKey2 = await _createAuthSession(session, authUserId);
      });

      group(
        'when revoking a single session,',
        () {
          setUp(() async {
            final authInfoABeforeRevocation =
                await AuthSessions.authenticationHandler(
              session,
              sessionKey1,
            );

            await AuthSessions.destroySession(
              session,
              authSessionId: authInfoABeforeRevocation!.authSessionId,
            );
          });

          test('then it is not usable anymore.', () async {
            final authInfoA = await AuthSessions.authenticationHandler(
              session,
              sessionKey1,
            );

            expect(authInfoA, isNull);
          });

          test('then the other is still usable.', () async {
            final authInfoB = await AuthSessions.authenticationHandler(
              session,
              sessionKey2,
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
            sessionKey1,
          );

          expect(authInfoA, isNull);

          final authInfoB = await AuthSessions.authenticationHandler(
            session,
            sessionKey2,
          );

          expect(authInfoB, isNull);
        },
      );
    },
  );
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
