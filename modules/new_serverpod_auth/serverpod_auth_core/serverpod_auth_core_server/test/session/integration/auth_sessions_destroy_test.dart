import 'dart:convert';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import '../test_utils.dart';

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
          .token;
    });

    test(
        'when calling `destroySession` with a valid `authSessionId`, then it returns true.',
        () async {
      final deleted = await AuthSessions.destroySession(
        session,
        authSessionId: _extractAuthSessionId(sessionKey),
      );

      expect(deleted, isTrue);
    });

    test(
        'when calling `destroySession` with an invalid `authSessionId`, then it returns false.',
        () async {
      final deleted = await AuthSessions.destroySession(
        session,
        authSessionId: const Uuid().v4obj(),
      );

      expect(deleted, isFalse);
    });

    test(
        'when calling `destroyAllSessions`, then it returns the list of deleted session IDs.',
        () async {
      final newAuthSuccesses = await List.generate(
        3,
        (final _) async => AuthSessions.createSession(
          session,
          authUserId: authUserId,
          method: 'test',
        ),
      ).wait;

      final deletedIds = await AuthSessions.destroyAllSessions(
        session,
        authUserId: authUserId,
      );

      expect(deletedIds.toSet(), {
        _extractAuthSessionId(sessionKey),
        for (final authSuccess in newAuthSuccesses)
          _extractAuthSessionId(authSuccess.token),
      });
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
          authUserId.uuid,
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
          .token;
      retainedSessionKey = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      ))
          .token;

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
          .token;
      sessionKey2 = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      ))
          .token;

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

UuidValue _extractAuthSessionId(final String sessionKey) {
  final parts = sessionKey.split(':');
  return UuidValue.fromByteList(base64Url.decode(parts[1]));
}
