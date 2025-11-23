import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_core_server/src/session/business/session_key.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

const _oldPepper = 'old-pepper-123';

void main() {
  final serverSideSessions = ServerSideSessions(
    config: ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
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
            await serverSideSessions.authenticationHandler(
              session,
              'some string',
            ),
            isNull,
          );
        },
      );

      test(
        'when calling `authenticationHandler` with an invalid string fitting the pattern, then it returns `null`.',
        () async {
          expect(
            await serverSideSessions.authenticationHandler(
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

      authUserId = (await serverSideSessions.authUsers.create(session)).id;

      sessionKey = (await serverSideSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      )).token;
    });

    test(
      'when calling `authenticationHandler` with the session key, then it returns an `AuthenticationInfo` for the user.',
      () async {
        final authInfo = await serverSideSessions.authenticationHandler(
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
          serverSideSessionId: sessionData.serverSideSessionId,
          secret: utf8.encode('some other secret'),
        );

        final authInfo = await serverSideSessions.authenticationHandler(
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
        final differentPepperServerSideSessions = ServerSideSessions(
          config: ServerSideSessionsConfig(
            sessionKeyHashPepper: 'another pepper',
          ),
        );

        final authInfo = await differentPepperServerSideSessions
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

      final authUserId = (await serverSideSessions.authUsers.create(
        session,
      )).id;

      sessionKey = (await serverSideSessions.createSession(
        session,
        authUserId: authUserId,
        scopes: {const Scope('test')},
        method: 'test',
      )).token;
    });

    test(
      'when calling `authenticationHandler` with the session key, then it returns an `AuthenticationInfo` with the correct scopes.',
      () async {
        final authInfo = await serverSideSessions.authenticationHandler(
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

        authUserId = (await serverSideSessions.authUsers.create(session)).id;

        sessionKey = (await serverSideSessions.createSession(
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
          final authInfo = await serverSideSessions.authenticationHandler(
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
            () => serverSideSessions.authenticationHandler(
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

      authUserId = (await serverSideSessions.authUsers.create(session)).id;

      sessionKey = (await serverSideSessions.createSession(
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
        final authInfo = await serverSideSessions.authenticationHandler(
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
          () => serverSideSessions.authenticationHandler(
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
          () => serverSideSessions.authenticationHandler(
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
          () => serverSideSessions.authenticationHandler(
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

  withServerpod(
    'Given an auth session created with a previous pepper,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late String sessionKey;

      setUp(() async {
        session = sessionBuilder.build();

        // Create session with an old pepper
        final oldPepperSeverSideSessions = ServerSideSessions(
          config: ServerSideSessionsConfig(sessionKeyHashPepper: _oldPepper),
        );

        authUserId = (await oldPepperSeverSideSessions.authUsers.create(
          session,
        )).id;

        sessionKey = (await oldPepperSeverSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        )).token;
      });

      test(
        'when calling `authenticationHandler` with the new pepper only then it returns `null`.',
        () async {
          final newPepperServerSideSessions = ServerSideSessions(
            config: ServerSideSessionsConfig(
              sessionKeyHashPepper: 'new-pepper-456',
            ),
          );

          final authInfo = await newPepperServerSideSessions
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

      test(
        'when calling `authenticationHandler` with the new pepper and old pepper in fallback list then it returns the user.',
        () async {
          final rotatedPepperServerSideSessions = ServerSideSessions(
            config: ServerSideSessionsConfig(
              sessionKeyHashPepper: 'new-pepper-456',
              fallbackSessionKeyHashPeppers: [_oldPepper],
            ),
          );

          final authInfo = await rotatedPepperServerSideSessions
              .authenticationHandler(
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
        'when calling `authenticationHandler` with multiple fallback peppers then it tries each until a match is found.',
        () async {
          final rotatedPepperServerSideSessions = ServerSideSessions(
            config: ServerSideSessionsConfig(
              sessionKeyHashPepper: 'newest-pepper',
              fallbackSessionKeyHashPeppers: [
                'intermediate-pepper',
                _oldPepper,
                'oldest-pepper',
              ],
            ),
          );

          final authInfo = await rotatedPepperServerSideSessions
              .authenticationHandler(
                session,
                sessionKey,
              );

          expect(
            authInfo?.authUserId,
            authUserId,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a new session created with the current pepper,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late String sessionKey;

      setUp(() async {
        session = sessionBuilder.build();

        // Create session with the current pepper
        final currentPepperServerSideSessions = ServerSideSessions(
          config: ServerSideSessionsConfig(
            sessionKeyHashPepper: 'current-pepper',
            fallbackSessionKeyHashPeppers: ['old-pepper-1', 'old-pepper-2'],
          ),
        );

        authUserId = (await currentPepperServerSideSessions.authUsers.create(
          session,
        )).id;

        sessionKey = (await currentPepperServerSideSessions.createSession(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        )).token;
      });

      test(
        'when calling `authenticationHandler` with the current pepper and fallback peppers then it validates successfully.',
        () async {
          final serverSideSessionsWithFallback = ServerSideSessions(
            config: ServerSideSessionsConfig(
              sessionKeyHashPepper: 'current-pepper',
              fallbackSessionKeyHashPeppers: ['old-pepper-1', 'old-pepper-2'],
            ),
          );

          final authInfo = await serverSideSessionsWithFallback
              .authenticationHandler(
                session,
                sessionKey,
              );

          expect(
            authInfo?.authUserId,
            authUserId,
          );
        },
      );
    },
  );
}
