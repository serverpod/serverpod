import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

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
          authUserId = (await authSessions.authUsers.create(session)).id;

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          )).token;
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

        test(
          'then session is valid before default lifetime expires.',
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
          },
        );
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
          authUserId = (await authSessions.authUsers.create(session)).id;
          explicitExpiresAt = clock.now().add(const Duration(days: 1));

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
            expiresAt: explicitExpiresAt,
          )).token;
        });

        test(
          'then explicit expiresAt takes precedence over default.',
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
          },
        );
      },
    );
  });

  group(
    'Given AuthSessions with default session inactivity timeout configured',
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
            authUserId = (await authSessions.authUsers.create(session)).id;

            sessionKey = (await authSessions.createSession(
              session,
              authUserId: authUserId,
              method: 'test',
            )).token;
          });

          test('then session is valid immediately after creation.', () async {
            final authInfo = await authSessions.authenticationHandler(
              session,
              sessionKey,
            );

            expect(authInfo?.authUserId, equals(authUserId));
          });

          test(
            'then session expires after default inactivity timeout.',
            () async {
              await withClock(
                Clock.fixed(
                  clock.now().add(const Duration(hours: 2, seconds: 1)),
                ),
                () async {
                  final authInfo = await authSessions.authenticationHandler(
                    session,
                    sessionKey,
                  );

                  expect(authInfo, isNull);
                },
              );
            },
          );

          test(
            'then session is valid before default inactivity timeout expires.',
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
            },
          );
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
            authUserId = (await authSessions.authUsers.create(session)).id;

            sessionKey = (await authSessions.createSession(
              session,
              authUserId: authUserId,
              method: 'test',
              expireAfterUnusedFor: const Duration(minutes: 30),
            )).token;
          });

          test(
            'then explicit expireAfterUnusedFor takes precedence over default.',
            () async {
              // Session should be invalid after explicit timeout (30 minutes)
              await withClock(
                Clock.fixed(
                  clock.now().add(const Duration(minutes: 30, seconds: 1)),
                ),
                () async {
                  final authInfo = await authSessions.authenticationHandler(
                    session,
                    sessionKey,
                  );

                  expect(authInfo, isNull);
                },
              );
            },
          );
        },
      );
    },
  );

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
          authUserId = (await authSessions.authUsers.create(session)).id;

          sessionKey = (await authSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          )).token;
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
