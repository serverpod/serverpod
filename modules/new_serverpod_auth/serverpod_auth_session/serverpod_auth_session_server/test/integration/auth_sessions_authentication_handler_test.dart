import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart';
import 'package:serverpod_auth_session_server/src/business/auth_session_secrets.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
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
          await AuthSessions.authenticationHandler(session, 'some string'),
          isNull,
        );
      });

      test(
          'when calling `authenticationHandler` with an invalid string fitting the pattern, then it returns `null`.',
          () async {
        expect(
          await AuthSessions.authenticationHandler(
            session,
            'sat:noguid64:nosecret64',
          ),
          isNull,
        );
      });
    },
  );

  withServerpod('Given an auth session,',
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
      'when calling `authenticationHandler` with the session key, then it returns an `AuthenticationInfo` for the user.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(
          authInfo?.userUuid,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` with the wrong secret in the session key, then it returns `null`.',
      () async {
        final sessionKeyParts = sessionKey.split(':');
        sessionKeyParts[2] = base64Encode(utf8.encode('some other secret'));
        final sessionKeyWithInvalidSecret = sessionKeyParts.join(':');

        final authInfo = await AuthSessions.authenticationHandler(
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
        AuthSessions.secretsTestOverride = AuthSessionSecrets(
          sessionKeyHashPepper: 'another pepper',
        );

        final authInfo = await AuthSessions.authenticationHandler(
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

  withServerpod('Given an auth session with custom scopes,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late String sessionKey;

    setUp(() async {
      session = sessionBuilder.build();

      final authUserId = await createAuthUser(session);

      sessionKey = (await AuthSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {const Scope('test')},
        method: 'test',
      ))
          .sessionKey;
    });

    test(
      'when calling `authenticationHandler` with the session key, then it returns an `AuthenticationInfo` with the correct scopes.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
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

        authUserId = await createAuthUser(session);

        sessionKey = (await AuthSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
          expiresAt: expiresAt,
        ))
            .sessionKey;
      });

      tearDown(() {
        AuthSessions.secretsTestOverride = null;
      });

      test(
        'when calling `authenticationHandler` right away, then it returns an `AuthenticationInfo` for the user.',
        () async {
          final authInfo = await AuthSessions.authenticationHandler(
            session,
            sessionKey,
          );

          expect(
            authInfo?.userUuid,
            authUserId,
          );
        },
      );

      test(
        'when calling `authenticationHandler` after the expiration date, then it returns `null`.',
        () async {
          final authInfo = await withClock(
            Clock.fixed(expiresAt.add(const Duration(seconds: 1))),
            () => AuthSessions.authenticationHandler(
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

  withServerpod('Given an auth session which will expire when unused,',
      (final sessionBuilder, final endpoints) {
    const expireAfterUnusedFor = Duration(minutes: 10);
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
        expireAfterUnusedFor: expireAfterUnusedFor,
      ))
          .sessionKey;
    });

    test(
      'when calling `authenticationHandler` right away, then it returns an `AuthenticationInfo` for the user.',
      () async {
        final authInfo = await AuthSessions.authenticationHandler(
          session,
          sessionKey,
        );

        expect(
          authInfo?.userUuid,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` within the time limit and then afterwards, then it returns an `AuthenticationInfo` for the user (as the lifetime was extended).',
      () async {
        final firstUseTime = DateTime.now()
            .add(expireAfterUnusedFor - const Duration(minutes: 1));
        final authInfoBeforeInitialExpiration = await withClock(
          Clock.fixed(firstUseTime),
          () => AuthSessions.authenticationHandler(
            session,
            sessionKey,
          ),
        );

        expect(
          authInfoBeforeInitialExpiration?.userUuid,
          authUserId,
        );

        final secondUseTime =
            firstUseTime.add(expireAfterUnusedFor - const Duration(minutes: 1));
        final authInfoAfterExtension = await withClock(
          Clock.fixed(secondUseTime),
          () => AuthSessions.authenticationHandler(
            session,
            sessionKey,
          ),
        );

        expect(
          authInfoAfterExtension?.userUuid,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` after the inactivity time limit, then it returns `null`',
      () async {
        final authInfo = await withClock(
          Clock.fixed(DateTime.now()
              .add(expireAfterUnusedFor + const Duration(minutes: 1))),
          () => AuthSessions.authenticationHandler(
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
