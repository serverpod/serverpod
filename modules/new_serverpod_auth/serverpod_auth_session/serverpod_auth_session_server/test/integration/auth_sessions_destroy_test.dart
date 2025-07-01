import 'dart:convert';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an auth sessions for a user,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      sessionKey = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      ))
          .sessionKey;
    });

    test(
      'when destroying the auth session, then a message for it is broadcast.',
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
      'when destroying all auth sessions for a user, then a message for it is broadcast.',
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

  withServerpod(
      'Given a user with 2 auth sessions where 1 was invalidated by `destroySession`,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String destroyedSessionKey;
    late String retainedSessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      destroyedSessionKey = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      ))
          .sessionKey;
      retainedSessionKey = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      ))
          .sessionKey;

      final sessionToDestroy = UuidValue.fromByteList(
          base64Decode(destroyedSessionKey.split(':')[1]));
      await AuthSessions.destroySession(
        session,
        authSessionId: sessionToDestroy,
      );
    });

    test(
      'when calling `authenticationHandler` with the destroyed session key, then it returns `null`.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
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
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          retainedSessionKey,
        );

        expect(
          authInfo,
          isNotNull,
        );
      },
    );
  });

  withServerpod(
      'Given a user with 2 sessions which were invalidated using `destroyAllSessions`,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String sessionKey1;
    late String sessionKey2;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      sessionKey1 = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      ))
          .sessionKey;
      sessionKey2 = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      ))
          .sessionKey;

      await AuthSessions.destroyAllSessions(
        session,
        authUserId: authUserId,
      );
    });

    test(
      'when calling the `authenticationHandler` with the first session key, then it returns `null`.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
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
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          sessionKey2,
        );

        expect(
          authInfo,
          isNull,
        );
      },
    );
  });
}
