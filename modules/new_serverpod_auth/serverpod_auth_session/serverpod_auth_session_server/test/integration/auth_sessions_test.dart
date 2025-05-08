import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given the `AuthSessions` implementation, ',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue userUuid;

      setUp(() async {
        session = sessionBuilder.build();
        final user = await AuthUser.db.insertRow(
          session,
          AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
        );
        userUuid = user.id!;
      });

      test(
        'when creating a session for a user, then the authentication handler resolves the returned secret correctly back to the user ID.',
        () async {
          final sessionSecret = await AuthSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final authInfo = await AuthSessions.authenticationHandler(
            session,
            sessionSecret,
          );

          expect(authInfo?.userUuid, userUuid);
        },
      );

      test(
        'when creating a session for a user with custom scopes, then the authentication handler returns those scopes.',
        () async {
          final sessionSecret = await AuthSessions.createSession(
            session,
            userId: userUuid,
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
        'when revoking a specific session for a user, then it is revoked but other sessions are unaffected.',
        () async {
          final sessionSecretA = await AuthSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final sessionSecretB = await AuthSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          // Revoke session A
          {
            final authInfoABeforeRevocation =
                await AuthSessions.authenticationHandler(
              session,
              sessionSecretA,
            );

            await AuthSessions.destroySession(
              session,
              authSessionId: authInfoABeforeRevocation!.authSessionId,
            );
          }

          final authInfoA = await AuthSessions.authenticationHandler(
            session,
            sessionSecretA,
          );

          expect(authInfoA, isNull);

          final authInfoB = await AuthSessions.authenticationHandler(
            session,
            sessionSecretB,
          );

          expect(authInfoB, isNotNull);
        },
      );

      test(
        'when revoking a session for a user, then a message for it is broadcast.',
        () async {
          final sessionSecretA = await AuthSessions.createSession(
            session,
            userId: userUuid,
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
                  authInfoABeforeRevocation!.userIdentifier);

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
        'when revoking all sessions for a user, then all their sessions are revoked.',
        () async {
          final sessionSecretA = await AuthSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final sessionSecretB = await AuthSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          expect(
            await AuthSessions.authenticationHandler(
              session,
              sessionSecretA,
            ),
            isNotNull,
          );

          await AuthSessions.destroyAllSessions(
            session,
            userId: userUuid,
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

      test(
        'when revoking all session for a user, then a message for it is broadcast.',
        () async {
          // ignore: unused_result
          await AuthSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(userUuid);

          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          await AuthSessions.destroyAllSessions(
            session,
            userId: userUuid,
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
            userId: userUuid,
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
            userId: userUuid,
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
}
