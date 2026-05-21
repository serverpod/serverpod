import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';
import 'package:serverpod_auth_idp_server/src/providers/passwordless/business/passwordless_idp_server_exceptions.dart'
    show PasswordlessLoginNotFoundException;
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/passwordless_idp_test_fixture.dart';
import '../test_utils/passwordless_rate_limit_test_helpers.dart';

void main() {
  withServerpod(
    'Passwordless admin cleanup scenarios',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late PasswordlessIdpTestFixture fixture;
      late Map<String, UuidValue> handleToUserId;

      const handle = 'test-handle';
      late String verificationCode;
      late String deliveredVerificationCode;

      Future<void> initializeFixture({
        final Duration loginVerificationCodeLifetime = const Duration(
          minutes: 10,
        ),
      }) async {
        handleToUserId = {};
        verificationCode = const Uuid().v4().toString();

        fixture = PasswordlessIdpTestFixture(
          config: PasswordlessIdpConfig(
            secretHashPepper: 'pepper',
            resolveAuthUserId:
                (
                  final Session session, {
                  required final String handle,
                  required final String handleType,
                  required final Transaction? transaction,
                }) async {
                  final authUserId = handleToUserId[handle];
                  if (authUserId == null) {
                    throw PasswordlessLoginNotFoundException();
                  }
                  return authUserId;
                },
            loginVerificationCodeLifetime: loginVerificationCodeLifetime,
            loginVerificationCodeGenerator: () => verificationCode,
            sendLoginVerificationCode:
                (
                  final Session session, {
                  required final String handle,
                  required final UuidValue requestId,
                  required final String verificationCode,
                  required final Transaction? transaction,
                  required final String handleType,
                }) async {
                  deliveredVerificationCode = verificationCode;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        handleToUserId[handle] = authUser.id;
      }

      group('Given login request attempts at the default rate limit', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          for (
            var i = 0;
            i <
                fixture
                    .passwordlessIdp
                    .config
                    .loginRequestRateLimit
                    .maxAttempts;
            i++
          ) {
            await fixture.passwordlessIdp.startLogin(session, handle: handle);
          }
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when deleteIncompleteLoginAttempts is called from admin then request-side rate limit resets',
          () async {
            await expectLater(
              fixture.passwordlessIdp.startLogin(session, handle: handle),
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.tooManyAttempts,
                ),
              ),
            );

            await session.db.transaction((final transaction) async {
              await fixture.passwordlessIdp.admin.deleteIncompleteLoginAttempts(
                session,
                olderThan: Duration.zero,
                transaction: transaction,
              );
            });

            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            expect(requestId, isA<UuidValue>());
          },
        );
      });

      group('Given rate-limited login verification attempts', () {
        late UuidValue requestId;

        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );

          for (
            var i = 0;
            i <
                fixture
                    .passwordlessIdp
                    .config
                    .loginVerificationCodeAllowedAttempts;
            i++
          ) {
            await expectLater(
              fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: '$deliveredVerificationCode-invalid-$i',
              ),
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          }
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when deleteIncompleteLoginAttempts is called from admin then verification-side attempts and the pending request are cleared',
          () async {
            final request = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            await expectLater(
              fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: deliveredVerificationCode,
              ),
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.tooManyAttempts,
                ),
              ),
            );

            await session.db.transaction((final transaction) async {
              await fixture.passwordlessIdp.admin.deleteIncompleteLoginAttempts(
                session,
                olderThan: Duration.zero,
                transaction: transaction,
              );
            });

            expect(
              await countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(0),
            );
            expect(
              await PasswordlessLoginRequest.db.findById(session, requestId),
              isNull,
            );
            expect(
              await SecretChallenge.db.findById(session, challengeId),
              isNull,
            );

            final newRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: newRequestId,
              verificationCode: deliveredVerificationCode,
            );
            expect(result, isA<AuthSuccess>());
          },
        );
      });

      group('Given both expired and active login requests', () {
        late DateTime cleanupTime;
        late UuidValue expiredRequestId;
        late UuidValue activeRequestId;
        late UuidValue expiredChallengeId;
        late UuidValue activeChallengeId;

        const activeHandle = 'fresh-handle';

        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(
            loginVerificationCodeLifetime: const Duration(minutes: 1),
          );

          final activeAuthUser = await fixture.authUsers.create(session);
          handleToUserId[activeHandle] = activeAuthUser.id;

          final initialTime = clock.now();
          cleanupTime = initialTime.add(const Duration(minutes: 2));

          await withClock(Clock.fixed(initialTime), () async {
            expiredRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
          });
          final expiredRequest = await PasswordlessLoginRequest.db.findById(
            session,
            expiredRequestId,
          );
          expiredChallengeId = expiredRequest!.challengeId;

          await withClock(Clock.fixed(cleanupTime), () async {
            activeRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: activeHandle,
            );
          });
          final activeRequest = await PasswordlessLoginRequest.db.findById(
            session,
            activeRequestId,
          );
          activeChallengeId = activeRequest!.challengeId;
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when deleteIncompleteLoginAttempts uses the default cutoff then it deletes expired requests but keeps active ones',
          () async {
            await withClock(Clock.fixed(cleanupTime), () async {
              await session.db.transaction((final transaction) async {
                await fixture.passwordlessIdp.admin
                    .deleteIncompleteLoginAttempts(
                      session,
                      transaction: transaction,
                    );
              });
            });

            expect(
              await PasswordlessLoginRequest.db.findById(
                session,
                expiredRequestId,
              ),
              isNull,
            );
            expect(
              await SecretChallenge.db.findById(session, expiredChallengeId),
              isNull,
            );
            expect(
              await PasswordlessLoginRequest.db.findById(
                session,
                activeRequestId,
              ),
              isNotNull,
            );
            expect(
              await SecretChallenge.db.findById(session, activeChallengeId),
              isNotNull,
            );
          },
        );
      });

      group(
        'Given stale and recent login state with a custom cleanup window',
        () {
          late DateTime cleanupTime;
          late UuidValue staleRequestId;
          late UuidValue recentRequestId;
          late UuidValue staleChallengeId;
          late UuidValue recentChallengeId;

          const staleHandle = 'stale-handle';
          const recentHandle = 'recent-handle';
          const cleanupWindow = Duration(minutes: 30);

          setUp(() async {
            session = sessionBuilder.build();
            await initializeFixture();

            handleToUserId[staleHandle] = (await fixture.authUsers.create(
              session,
            )).id;
            handleToUserId[recentHandle] = (await fixture.authUsers.create(
              session,
            )).id;

            final initialTime = clock.now();
            cleanupTime = initialTime.add(const Duration(minutes: 40));

            await withClock(Clock.fixed(initialTime), () async {
              staleRequestId = await fixture.passwordlessIdp.startLogin(
                session,
                handle: staleHandle,
              );
            });
            staleChallengeId = (await PasswordlessLoginRequest.db.findById(
              session,
              staleRequestId,
            ))!.challengeId;

            await withClock(
              Clock.fixed(initialTime.add(const Duration(minutes: 20))),
              () async {
                recentRequestId = await fixture.passwordlessIdp.startLogin(
                  session,
                  handle: recentHandle,
                );
              },
            );
            recentChallengeId = (await PasswordlessLoginRequest.db.findById(
              session,
              recentRequestId,
            ))!.challengeId;
          });

          tearDown(() async {
            await fixture.tearDown(session);
          });

          test(
            'when deleteIncompleteLoginAttempts uses a positive olderThan then it only deletes older state',
            () async {
              await withClock(Clock.fixed(cleanupTime), () async {
                await session.db.transaction((final transaction) async {
                  await fixture.passwordlessIdp.admin
                      .deleteIncompleteLoginAttempts(
                        session,
                        olderThan: cleanupWindow,
                        transaction: transaction,
                      );
                });
              });

              expect(
                await PasswordlessLoginRequest.db.findById(
                  session,
                  staleRequestId,
                ),
                isNull,
              );
              expect(
                await SecretChallenge.db.findById(session, staleChallengeId),
                isNull,
              );
              expect(
                await PasswordlessLoginRequest.db.findById(
                  session,
                  recentRequestId,
                ),
                isNotNull,
              );
              expect(
                await SecretChallenge.db.findById(session, recentChallengeId),
                isNotNull,
              );

              final staleAttempts = await RateLimitedRequestAttempt.db.find(
                session,
                where: (final t) =>
                    t.domain.equals('passwordless') &
                    t.source.equals('login_request') &
                    t.nonce.equals(
                      passwordlessLoginRequestRateLimitNonce(staleHandle),
                    ),
              );
              final recentAttempts = await RateLimitedRequestAttempt.db.find(
                session,
                where: (final t) =>
                    t.domain.equals('passwordless') &
                    t.source.equals('login_request') &
                    t.nonce.equals(
                      passwordlessLoginRequestRateLimitNonce(recentHandle),
                    ),
              );

              expect(staleAttempts, isEmpty);
              expect(recentAttempts, isNotEmpty);
            },
          );
        },
      );
    },
  );
}
