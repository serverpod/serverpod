import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import '../test_utils.dart';

void main() {
  group('Given AuthSessions with default session lifetime configured', () {
    final authSessions = AuthSessions(
      config: AuthSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
        defaultSessionLifetime: const Duration(days: 7),
      ),
    );

    withServerpod(
      'when creating a session without explicit expiresAt',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;
        late String sessionKey;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;
        });

        test('then session is valid immediately after creation.', () async {
          final authInfo = await authSessions.authenticationHandler(
            session,
            sessionKey,
          );

          expect(authInfo?.authUserId, equals(authUserId));
        });

        test('then session expires after default lifetime.', () async {
          await withClock(
            Clock.fixed(clock.now().add(const Duration(days: 7, seconds: 1))),
            () async {
              final authInfo = await authSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo, isNull);
            },
          );
        });

        test('then session is valid before default lifetime expires.',
            () async {
          await withClock(
            Clock.fixed(clock.now().add(const Duration(days: 6))),
            () async {
              final authInfo = await authSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo?.authUserId, equals(authUserId));
            },
          );
        });
      },
    );

    withServerpod(
      'when creating a session with explicit expiresAt',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;
        late String sessionKey;
        late DateTime explicitExpiresAt;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);
          explicitExpiresAt = clock.now().add(const Duration(days: 1));

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            expiresAt: explicitExpiresAt,
          ))
              .token;
        });

        test('then explicit expiresAt takes precedence over default.',
            () async {
          // Session should be invalid after explicit expiration (1 day)
          await withClock(
            Clock.fixed(explicitExpiresAt.add(const Duration(seconds: 1))),
            () async {
              final authInfo = await authSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo, isNull);
            },
          );
        });
      },
    );
  });

  group('Given AuthSessions with default session inactivity timeout configured',
      () {
    final authSessions = AuthSessions(
      config: AuthSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
        defaultSessionInactivityTimeout: const Duration(hours: 2),
      ),
    );

    withServerpod(
      'when creating a session without explicit expireAfterUnusedFor',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;
        late String sessionKey;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;
        });

        test('then session is valid immediately after creation.', () async {
          final authInfo = await authSessions.authenticationHandler(
            session,
            sessionKey,
          );

          expect(authInfo?.authUserId, equals(authUserId));
        });

        test('then session expires after default inactivity timeout.',
            () async {
          await withClock(
            Clock.fixed(clock.now().add(const Duration(hours: 2, seconds: 1))),
            () async {
              final authInfo = await authSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo, isNull);
            },
          );
        });

        test('then session is valid before default inactivity timeout expires.',
            () async {
          await withClock(
            Clock.fixed(clock.now().add(const Duration(hours: 1))),
            () async {
              final authInfo = await authSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo?.authUserId, equals(authUserId));
            },
          );
        });
      },
    );

    withServerpod(
      'when creating a session with explicit expireAfterUnusedFor',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;
        late String sessionKey;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            expireAfterUnusedFor: const Duration(minutes: 30),
          ))
              .token;
        });

        test(
            'then explicit expireAfterUnusedFor takes precedence over default.',
            () async {
          // Session should be invalid after explicit timeout (30 minutes)
          await withClock(
            Clock.fixed(
                clock.now().add(const Duration(minutes: 30, seconds: 1))),
            () async {
              final authInfo = await authSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo, isNull);
            },
          );
        });
      },
    );
  });

  group('Given AuthSessions with max concurrent sessions per user configured',
      () {
    final authSessions = AuthSessions(
      config: AuthSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
        maxConcurrentSessionsPerUser: 3,
      ),
    );

    withServerpod(
      'when creating sessions up to the limit',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);
        });

        test('then all sessions are valid.', () async {
          final session1Key = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;

          final session2Key = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;

          final session3Key = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;

          expect(
            await authSessions.authenticationHandler(session, session1Key),
            isNotNull,
          );
          expect(
            await authSessions.authenticationHandler(session, session2Key),
            isNotNull,
          );
          expect(
            await authSessions.authenticationHandler(session, session3Key),
            isNotNull,
          );
        });
      },
    );

    withServerpod(
      'when creating more sessions than the limit',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);
        });

        test('then oldest sessions are removed.', () async {
          final session1Key = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;

          final session2Key = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;

          final session3Key = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;

          // Creating a 4th session should remove the oldest (session1)
          final session4Key = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;

          // First session should be invalid (removed)
          expect(
            await authSessions.authenticationHandler(session, session1Key),
            isNull,
          );

          // Other sessions should still be valid
          expect(
            await authSessions.authenticationHandler(session, session2Key),
            isNotNull,
          );
          expect(
            await authSessions.authenticationHandler(session, session3Key),
            isNotNull,
          );
          expect(
            await authSessions.authenticationHandler(session, session4Key),
            isNotNull,
          );
        });
      },
    );

    withServerpod(
      'when creating multiple sessions beyond the limit',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);
        });

        test('then only the most recent sessions remain valid.', () async {
          final sessions = <String>[];

          // Create 5 sessions (limit is 3)
          for (var i = 0; i < 5; i++) {
            final sessionKey = (await authSessions.createSession(
              session,
              authUserId: authUserId,
              method: 'test',
            ))
                .token;
            sessions.add(sessionKey);
          }

          // First two sessions should be invalid
          expect(
            await authSessions.authenticationHandler(session, sessions[0]),
            isNull,
          );
          expect(
            await authSessions.authenticationHandler(session, sessions[1]),
            isNull,
          );

          // Last three sessions should be valid
          expect(
            await authSessions.authenticationHandler(session, sessions[2]),
            isNotNull,
          );
          expect(
            await authSessions.authenticationHandler(session, sessions[3]),
            isNotNull,
          );
          expect(
            await authSessions.authenticationHandler(session, sessions[4]),
            isNotNull,
          );
        });
      },
    );
  });

  group('Given AuthSessions with no session configuration defaults', () {
    final authSessions = AuthSessions(
      config: AuthSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
      ),
    );

    withServerpod(
      'when creating a session',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;
        late String sessionKey;

        setUp(() async {
          session = sessionBuilder.build();
          authUserId = await createAuthUser(session);

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          ))
              .token;
        });

        test('then session is valid without expiration.', () async {
          final authInfo = await authSessions.authenticationHandler(
            session,
            sessionKey,
          );

          expect(authInfo?.authUserId, equals(authUserId));
        });

        test('then session is still valid after a long time.', () async {
          await withClock(
            Clock.fixed(clock.now().add(const Duration(days: 365))),
            () async {
              final authInfo = await authSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo?.authUserId, equals(authUserId));
            },
          );
        });
      },
    );
  });
}
