import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/session/business/session_key.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import '../../test_tags.dart';

void main() {
  final serverSideSessions = ServerSideSessions(
    config: ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  withServerpod(
    'Given an auth sessions for a user,',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late String sessionKey;

      setUp(() async {
        session = sessionBuilder.build();

        authUserId = (await serverSideSessions.authUsers.create(session)).id;

        sessionKey = (await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        )).token;
      });

      tearDown(() async {
        await ServerSideSession.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
        );
      });

      test(
        'when calling `destroySession` with a valid `serverSideSessionId`, then it returns true.',
        () async {
          final deleted = await serverSideSessions.destroySession(
            session,
            serverSideSessionId: _extractServerSideSessionId(
              session,
              sessionKey,
            ),
          );

          expect(deleted, isTrue);
        },
      );

      test(
        'when calling `destroySession` with an invalid `serverSideSessionId`, then it returns false.',
        () async {
          final deleted = await serverSideSessions.destroySession(
            session,
            serverSideSessionId: const Uuid().v4obj(),
          );

          expect(deleted, isFalse);
        },
      );

      test(
        'when calling `destroyAllSessions`, then it returns the list of deleted session IDs.',
        () async {
          final newAuthSuccesses = await List.generate(
            3,
            (final _) async => serverSideSessions.createSession(
              session,
              authUserId: authUserId,
              method: 'test',
            ),
          ).wait;

          final deletedIds = await serverSideSessions.destroyAllSessions(
            session,
            authUserId: authUserId,
          );

          expect(deletedIds.toSet(), {
            _extractServerSideSessionId(session, sessionKey),
            for (final authSuccess in newAuthSuccesses)
              _extractServerSideSessionId(session, authSuccess.token),
          });
        },
      );

      test(
        'when destroying the auth session, then a message for it is broadcast.',
        () async {
          final authInfoABeforeRevocation = await serverSideSessions
              .authenticationHandler(
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

          await serverSideSessions.destroySession(
            session,
            serverSideSessionId: authInfoABeforeRevocation.serverSideSessionId,
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
        'when destroying all auth sessions for a user, then a message for it is broadcast.',
        () async {
          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(
                authUserId.uuid,
              );

          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          await serverSideSessions.destroyAllSessions(
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
    },
  );

  withServerpod(
    'Given a user with 2 auth sessions where 1 was invalidated by `destroySession`,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late String destroyedSessionKey;
      late String retainedSessionKey;

      setUp(() async {
        session = sessionBuilder.build();

        authUserId = (await serverSideSessions.authUsers.create(session)).id;

        destroyedSessionKey = (await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        )).token;
        retainedSessionKey = (await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        )).token;

        final sessionToDestroy = _extractServerSideSessionId(
          session,
          destroyedSessionKey,
        );
        await serverSideSessions.destroySession(
          session,
          serverSideSessionId: sessionToDestroy,
        );
      });

      test(
        'when calling `authenticationHandler` with the destroyed session key, then it returns `null`.',
        () async {
          final authInfo = await serverSideSessions.authenticationHandler(
            session,
            destroyedSessionKey,
          );

          expect(
            authInfo,
            isNull,
          );
        },
      );

      test(
        'when calling `authenticationHandler` with the retained session key, then it returns the auth info.',
        () async {
          final authInfo = await serverSideSessions.authenticationHandler(
            session,
            retainedSessionKey,
          );

          expect(
            authInfo,
            isNotNull,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a user with 2 sessions which were invalidated using `destroyAllSessions`,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late String sessionKey1;
      late String sessionKey2;

      setUp(() async {
        session = sessionBuilder.build();

        authUserId = (await serverSideSessions.authUsers.create(session)).id;

        sessionKey1 = (await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        )).token;
        sessionKey2 = (await serverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        )).token;

        await serverSideSessions.destroyAllSessions(
          session,
          authUserId: authUserId,
        );
      });

      test(
        'when calling the `authenticationHandler` with the first session key, then it returns `null`.',
        () async {
          final authInfo = await serverSideSessions.authenticationHandler(
            session,
            sessionKey1,
          );

          expect(
            authInfo,
            isNull,
          );
        },
      );

      test(
        'when calling the `authenticationHandler` with the  second session key, then it returns `null`.',
        () async {
          final authInfo = await serverSideSessions.authenticationHandler(
            session,
            sessionKey2,
          );

          expect(
            authInfo,
            isNull,
          );
        },
      );
    },
  );
}

UuidValue _extractServerSideSessionId(
  final Session session,
  final String sessionKey,
) {
  return tryParseSessionKey(session, sessionKey)!.serverSideSessionId;
}
