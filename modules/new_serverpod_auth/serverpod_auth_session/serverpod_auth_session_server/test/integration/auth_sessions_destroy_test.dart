import 'dart:convert';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given two sessions for a user,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      sessionKey = await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
    });

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
            MessageCentralServerpodChannels.revokedAuthentication(
          authUserId,
        );

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
  });

  withServerpod('Given two sessions for a user,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionKey1;
    late String sessionKey2;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      sessionKey1 = await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
      sessionKey2 = await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
    });

    test(
      'when calling `destroySession` for one session, then this gets invalid while the other continues to work.',
      () async {
        final session1Id =
            UuidValue.fromByteList(base64Decode(sessionKey1.split(':')[1]));
        await AuthSessions.destroySession(
          session,
          authSessionId: session1Id,
        );

        final authInfo1 = await AuthSessions.authenticationHandler(
          session,
          sessionKey1,
        );

        expect(
          authInfo1,
          isNull,
        );

        final authInfo2 = await AuthSessions.authenticationHandler(
          session,
          sessionKey2,
        );

        expect(
          authInfo2,
          isNotNull,
        );
      },
    );

    test(
      'when calling `destroyAllSessions`, then all their sessions become invalid.',
      () async {
        await AuthSessions.destroyAllSessions(
          session,
          authUserId: authUserId,
        );

        final authInfo1 = await AuthSessions.authenticationHandler(
          session,
          sessionKey1,
        );

        expect(
          authInfo1,
          isNull,
        );

        final authInfo2 = await AuthSessions.authenticationHandler(
          session,
          sessionKey2,
        );

        expect(
          authInfo2,
          isNull,
        );
      },
    );
  });
}
