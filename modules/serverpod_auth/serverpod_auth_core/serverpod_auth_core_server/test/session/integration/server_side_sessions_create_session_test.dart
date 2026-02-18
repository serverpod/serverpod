import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  group(
    'Given ServerSideSessions with default session lifetime configured',
    () {
      const defaultSessionLifetime = Duration(days: 7);
      final serverSideSessions = ServerSideSessions(
        config: ServerSideSessionsConfig(
          sessionKeyHashPepper: 'test-pepper',
          defaultSessionLifetime: defaultSessionLifetime,
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
            authUserId = (await serverSideSessions.authUsers.create(
              session,
            )).id;

            sessionKey = (await serverSideSessions.createSession(
              session,
              authUserId: authUserId,
              method: 'test',
            )).token;
          });

          test('then session is valid immediately after creation.', () async {
            final authInfo = await serverSideSessions.authenticationHandler(
              session,
              sessionKey,
            );

            expect(authInfo?.authUserId, equals(authUserId));
          });

          test('then session expires after default lifetime.', () async {
            await withClock(
              Clock.fixed(clock.now().add(const Duration(days: 7, seconds: 1))),
              () async {
                final authInfo = await serverSideSessions.authenticationHandler(
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
                  final authInfo = await serverSideSessions
                      .authenticationHandler(
                        session,
                        sessionKey,
                      );

                  expect(authInfo?.authUserId, equals(authUserId));
                },
              );
            },
          );

          test(
            'then tokenExpiresAt matches default session lifetime.',
            () async {
              final now = clock.now();
              late AuthSuccess authSuccess;

              await withClock(Clock.fixed(now), () async {
                authSuccess = await serverSideSessions.createSession(
                  session,
                  authUserId: authUserId,
                  method: 'test',
                );
              });

              final expirationExpected = now.add(defaultSessionLifetime);

              expect(authSuccess.tokenExpiresAt, isA<DateTime>());
              expect(authSuccess.tokenExpiresAt, expirationExpected);
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
            authUserId = (await serverSideSessions.authUsers.create(
              session,
            )).id;
            explicitExpiresAt = clock.now().add(const Duration(days: 1));

            sessionKey = (await serverSideSessions.createSession(
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
                  final authInfo = await serverSideSessions
                      .authenticationHandler(
                        session,
                        sessionKey,
                      );

                  expect(authInfo, isNull);
                },
              );
            },
          );

          test(
            'then tokenExpiresAt matches explicit expiresAt.',
            () async {
              final now = clock.now();
              final explicitExpiresAt = now.add(const Duration(days: 1));
              late AuthSuccess authSuccess;

              await withClock(Clock.fixed(now), () async {
                authSuccess = await serverSideSessions.createSession(
                  session,
                  authUserId: authUserId,
                  method: 'test',
                  expiresAt: explicitExpiresAt,
                );
              });

              expect(authSuccess.tokenExpiresAt, isA<DateTime>());
              expect(authSuccess.tokenExpiresAt, explicitExpiresAt);
            },
          );
        },
      );
    },
  );

  group(
    'Given ServerSideSessions with default session inactivity timeout configured',
    () {
      final serverSideSessions = ServerSideSessions(
        config: ServerSideSessionsConfig(
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
            authUserId = (await serverSideSessions.authUsers.create(
              session,
            )).id;

            sessionKey = (await serverSideSessions.createSession(
              session,
              authUserId: authUserId,
              method: 'test',
            )).token;
          });

          test('then session is valid immediately after creation.', () async {
            final authInfo = await serverSideSessions.authenticationHandler(
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
                  final authInfo = await serverSideSessions
                      .authenticationHandler(
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
                  final authInfo = await serverSideSessions
                      .authenticationHandler(
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
            authUserId = (await serverSideSessions.authUsers.create(
              session,
            )).id;

            sessionKey = (await serverSideSessions.createSession(
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
                  final authInfo = await serverSideSessions
                      .authenticationHandler(
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

  group('Given ServerSideSessions with no session configuration defaults', () {
    final serverSideSessions = ServerSideSessions(
      config: ServerSideSessionsConfig(
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
          authUserId = (await serverSideSessions.authUsers.create(session)).id;

          sessionKey = (await serverSideSessions.createSession(
            session,
            authUserId: authUserId,
            method: 'test',
          )).token;
        });

        test('then session is valid without expiration.', () async {
          final authInfo = await serverSideSessions.authenticationHandler(
            session,
            sessionKey,
          );

          expect(authInfo?.authUserId, equals(authUserId));
        });

        test('then session is still valid after a long time.', () async {
          await withClock(
            Clock.fixed(clock.now().add(const Duration(days: 365))),
            () async {
              final authInfo = await serverSideSessions.authenticationHandler(
                session,
                sessionKey,
              );

              expect(authInfo?.authUserId, equals(authUserId));
            },
          );
        });

        test(
          'then tokenExpiresAt is null due to no default expiration.',
          () async {
            final authSuccess = await serverSideSessions.createSession(
              session,
              authUserId: authUserId,
              method: 'test',
            );

            expect(authSuccess.tokenExpiresAt, isNull);
          },
        );
      },
    );
  });
}
