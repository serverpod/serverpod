import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_core_server/src/session/business/session_key.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  final authSessions = AuthSessions(
    config: AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
  );

  withServerpod(
    'Given no session,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

      test(
        'when calling `authenticationHandler` with an unrelated string, then it returns `null`.',
        () async {
          expect(
            await authSessions.authenticationHandler(session, 'some string'),
            isNull,
          );
        },
      );

      test(
        'when calling `authenticationHandler` with an invalid string fitting the pattern, then it returns `null`.',
        () async {
          expect(
            await authSessions.authenticationHandler(
              session,
              base64Url.encode([
                ...utf8.encode('sat'),
                ...const Uuid().v4obj().toBytes(),
                ...utf8.encode('nosecret64'),
              ]),
            ),
            isNull,
          );
        },
      );
    },
  );

  withServerpod('Given an auth session,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = (await authSessions.authUsers.create(session)).id;

      sessionKey = (await authSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      )).token;
    });

    test(
      'when calling `authenticationHandler` with the session key, then it returns an `AuthenticationInfo` for the user.',
      () async {
        final authInfo = await authSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(
          authInfo?.authUserId,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` with the wrong secret in the session key, then it returns `null`.',
      () async {
        final sessionData = tryParseSessionKey(session, sessionKey)!;
        final sessionKeyWithInvalidSecret = buildSessionKey(
          authSessionId: sessionData.authSessionId,
          secret: utf8.encode('some other secret'),
        );

        final authInfo = await authSessions.authenticationHandler(
          session,
          sessionKeyWithInvalidSecret,
        );

        expect(
          authInfo,
          isNull,
        );
      },
    );

    test(
      'when calling `authenticationHandler` after the pepper has been changed, then it returns `null`.',
      () async {
        final differentPepperAuthSessions = AuthSessions(
          config: AuthSessionsConfig(sessionKeyHashPepper: 'another pepper'),
        );

        final authInfo = await differentPepperAuthSessions
            .authenticationHandler(
              session,
              sessionKey,
            );

        expect(
          authInfo,
          isNull,
        );
      },
    );
  });

  withServerpod('Given an auth session with custom scopes,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      final authUserId = (await authSessions.authUsers.create(session)).id;

      sessionKey = (await authSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {const Scope('test')},
        method: 'test',
      )).token;
    });

    test(
      'when calling `authenticationHandler` with the session key, then it returns an `AuthenticationInfo` with the correct scopes.',
      () async {
        final authInfo = await authSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(
          authInfo?.scopes,
          {const Scope('test')},
        );
      },
    );
  });

  withServerpod(
    'Given an auth session with an expiration date,',
    (final sessionBuilder, final endpoints) {
      final expiresAt = DateTime.now().add(const Duration(days: 1));
      late Session session;
      late UuidValue authUserId;
      late String sessionKey;

      setUp(() async {
        session = sessionBuilder.build();

        authUserId = (await authSessions.authUsers.create(session)).id;

        sessionKey = (await authSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
          expiresAt: expiresAt,
        )).token;
      });

      test(
        'when calling `authenticationHandler` right away, then it returns an `AuthenticationInfo` for the user.',
        () async {
          final authInfo = await authSessions.authenticationHandler(
            session,
            sessionKey,
          );

          expect(
            authInfo?.authUserId,
            authUserId,
          );
        },
      );

      test(
        'when calling `authenticationHandler` after the expiration date, then it returns `null`.',
        () async {
          final authInfo = await withClock(
            Clock.fixed(expiresAt.add(const Duration(seconds: 1))),
            () => authSessions.authenticationHandler(
              session,
              sessionKey,
            ),
          );

          expect(
            authInfo,
            isNull,
          );
        },
      );
    },
  );

  withServerpod('Given an auth session which will expire when unused,', (
    final sessionBuilder,
    final endpoints,
  ) {
    const expireAfterUnusedFor = Duration(minutes: 10);
    late Session session;
    late UuidValue authUserId;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = (await authSessions.authUsers.create(session)).id;

      sessionKey = (await authSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
        expireAfterUnusedFor: expireAfterUnusedFor,
      )).token;
    });

    test(
      'when calling `authenticationHandler` right away, then it returns an `AuthenticationInfo` for the user.',
      () async {
        final authInfo = await authSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(
          authInfo?.authUserId,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` within the time limit and then afterwards, then it returns an `AuthenticationInfo` for the user (as the lifetime was extended).',
      () async {
        final firstUseTime = DateTime.now().add(
          expireAfterUnusedFor - const Duration(minutes: 1),
        );
        final authInfoBeforeInitialExpiration = await withClock(
          Clock.fixed(firstUseTime),
          () => authSessions.authenticationHandler(
            session,
            sessionKey,
          ),
        );

        expect(
          authInfoBeforeInitialExpiration?.authUserId,
          authUserId,
        );

        final secondUseTime = firstUseTime.add(
          expireAfterUnusedFor - const Duration(minutes: 1),
        );
        final authInfoAfterExtension = await withClock(
          Clock.fixed(secondUseTime),
          () => authSessions.authenticationHandler(
            session,
            sessionKey,
          ),
        );

        expect(
          authInfoAfterExtension?.authUserId,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` after the inactivity time limit, then it returns `null`',
      () async {
        final authInfo = await withClock(
          Clock.fixed(
            DateTime.now().add(
              expireAfterUnusedFor + const Duration(minutes: 1),
            ),
          ),
          () => authSessions.authenticationHandler(
            session,
            sessionKey,
          ),
        );

        expect(
          authInfo,
          isNull,
        );
      },
    );
  });
}
