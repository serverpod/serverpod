import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../../test/integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given the `UserSessions` implementation, ',
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
          final sessionSecret = await UserSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final authInfo = await UserSessions.authenticationHandler(
            session,
            sessionSecret,
          );

          expect(authInfo?.userUuid, userUuid);
        },
      );

      test(
        'when creating a session for a user with custom scopes, then the authentication handler returns those scopes.',
        () async {
          final sessionSecret = await UserSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: {Scope.admin},
          );

          final authInfo = await UserSessions.authenticationHandler(
            session,
            sessionSecret,
          );

          expect(authInfo?.scopes, {Scope.admin});
        },
      );

      test(
        'when revoking a specific session for a user, then it is revoked but other sessions are unaffected.',
        () async {
          final sessionSecretA = await UserSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final sessionSecretB = await UserSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          // Revoke session A
          {
            final authInfoABeforeRevocation =
                await UserSessions.authenticationHandler(
              session,
              sessionSecretA,
            );

            await UserSessions.destroySession(
              session,
              userSessionId: authInfoABeforeRevocation!.userSessionUuid,
            );
          }

          await expectLater(
            () => UserSessions.authenticationHandler(
              session,
              sessionSecretA,
            ),
            throwsA(isA<Exception>()),
          );

          final authInfoB = await UserSessions.authenticationHandler(
            session,
            sessionSecretB,
          );

          expect(authInfoB, isNotNull);
        },
      );

      test(
        'when revoking a session for a user, then a message for it is broadcast.',
        () async {
          final sessionSecretA = await UserSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final authInfoABeforeRevocation =
              await UserSessions.authenticationHandler(
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

          await UserSessions.destroySession(
            session,
            userSessionId: authInfoABeforeRevocation.userSessionUuid,
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
          final sessionSecretA = await UserSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          final sessionSecretB = await UserSessions.createSession(
            session,
            userId: userUuid,
            method: 'test',
            scopes: const {},
          );

          expect(
            await UserSessions.authenticationHandler(
              session,
              sessionSecretA,
            ),
            isNotNull,
          );

          await UserSessions.destroyAllSessions(
            session,
            userId: userUuid,
          );

          await expectLater(
            () => UserSessions.authenticationHandler(
              session,
              sessionSecretA,
            ),
            throwsA(isA<Exception>()),
          );

          await expectLater(
            () => UserSessions.authenticationHandler(
              session,
              sessionSecretB,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );

      test(
        'when revoking all session for a user, then a message for it is broadcast.',
        () async {
          // ignore: unused_result
          await UserSessions.createSession(
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

          await UserSessions.destroyAllSessions(
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
    },
  );
}
