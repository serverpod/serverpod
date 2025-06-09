import 'dart:convert';
import 'dart:typed_data';

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
  withServerpod('Given a plain auth session,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionSecret;

    setUp(() async {
      session = sessionBuilder.build();
      authUserId = await _createAuthUser(session);
      sessionSecret = await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        method: 'test',
        scopes: const {},
      );
    });

    test(
      'when resolving that session through the `authenticationHandler`, then the auth user ID is available on the auth info.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          sessionSecret,
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
          sessionSecret,
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
          sessionSecret,
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
        final parts = sessionSecret.split(':');
        parts[2] = base64Encode(utf8.encode('not-the-secret'));
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
  });

  withServerpod('Given an auth session with scopes,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionSecret;

    setUp(() async {
      session = sessionBuilder.build();
      authUserId = await _createAuthUser(session);
      sessionSecret = await AuthSessions.createSession(
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
          sessionSecret,
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
