import 'dart:async';

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
    'Passwordless finishLogin verification scenarios',
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
                  required final String? handleType,
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
                  required final String? handleType,
                }) async {
                  deliveredVerificationCode = verificationCode;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        handleToUserId[handle] = authUser.id;
      }

      group('Given a valid login request', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called with invalid verification code then it throws PasswordlessLoginException with reason "invalid"',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: '$verificationCode-invalid',
            );

            await expectLater(
              result,
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          },
        );
      });

      group('Given passwordless provider rotating secret hash peppers', () {
        late PasswordlessIdpTestFixture oldPepperFixture;
        late PasswordlessIdpTestFixture rotatedPepperFixture;
        late PasswordlessIdpTestFixture noFallbackFixture;

        Future<PasswordlessIdpTestFixture> createFixture({
          required final String secretHashPepper,
          final List<String> fallbackSecretHashPeppers = const [],
        }) async {
          return PasswordlessIdpTestFixture(
            config: PasswordlessIdpConfig(
              secretHashPepper: secretHashPepper,
              fallbackSecretHashPeppers: fallbackSecretHashPeppers,
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final String handle,
                    required final String? handleType,
                    required final Transaction? transaction,
                  }) async {
                    final authUserId = handleToUserId[handle];
                    if (authUserId == null) {
                      throw PasswordlessLoginNotFoundException();
                    }
                    return authUserId;
                  },
              loginVerificationCodeGenerator: () => verificationCode,
              sendLoginVerificationCode: null,
            ),
          );
        }

        setUp(() async {
          session = sessionBuilder.build();
          handleToUserId = {};
          verificationCode = const Uuid().v4().toString();

          oldPepperFixture = await createFixture(
            secretHashPepper: 'old-pepper',
          );
          rotatedPepperFixture = await createFixture(
            secretHashPepper: 'new-pepper',
            fallbackSecretHashPeppers: const ['old-pepper'],
          );
          noFallbackFixture = await createFixture(
            secretHashPepper: 'new-pepper',
          );

          final authUser = await oldPepperFixture.authUsers.create(session);
          handleToUserId[handle] = authUser.id;
        });

        tearDown(() async {
          await oldPepperFixture.tearDown(session);
          await rotatedPepperFixture.tearDown(session);
          await noFallbackFixture.tearDown(session);
        });

        test(
          'when finishLogin uses a rotated pepper with a fallback then it still succeeds',
          () async {
            final requestId = await oldPepperFixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = await rotatedPepperFixture.passwordlessIdp
                .finishLogin(
                  session,
                  loginRequestId: requestId,
                  verificationCode: verificationCode,
                );

            expect(result, isA<AuthSuccess>());
          },
        );

        test(
          'when finishLogin uses a rotated pepper without a fallback then it throws PasswordlessLoginException with reason "invalid"',
          () async {
            final requestId = await oldPepperFixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = noFallbackFixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: verificationCode,
            );

            await expectLater(
              result,
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          },
        );
      });

      group('Given loginVerificationCodeAllowedAttempts is 2', () {
        const customVerificationLimit = 2;

        setUp(() async {
          session = sessionBuilder.build();
          handleToUserId = {};
          verificationCode = const Uuid().v4().toString();

          fixture = PasswordlessIdpTestFixture(
            config: PasswordlessIdpConfig(
              secretHashPepper: 'pepper',
              loginVerificationCodeAllowedAttempts: customVerificationLimit,
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final String handle,
                    required final String? handleType,
                    required final Transaction? transaction,
                  }) async {
                    final authUserId = handleToUserId[handle];
                    if (authUserId == null) {
                      throw PasswordlessLoginNotFoundException();
                    }
                    return authUserId;
                  },
              loginVerificationCodeGenerator: () => verificationCode,
              sendLoginVerificationCode:
                  (
                    final Session session, {
                    required final String handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                    required final String? handleType,
                  }) async {
                    deliveredVerificationCode = verificationCode;
                  },
            ),
          );

          final authUser = await fixture.authUsers.create(session);
          handleToUserId[handle] = authUser.id;
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin fails loginVerificationCodeAllowedAttempts times with wrong codes then the next call throws tooManyAttempts',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            for (var i = 0; i < customVerificationLimit; i++) {
              await expectLater(
                fixture.passwordlessIdp.finishLogin(
                  session,
                  loginRequestId: requestId,
                  verificationCode: '$deliveredVerificationCode-wrong-$i',
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

            await expectLater(
              fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: '$deliveredVerificationCode-wrong-final',
              ),
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.tooManyAttempts,
                ),
              ),
            );
          },
        );
      });

      group('Given a valid login request', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin succeeds then it records a login_verify attempt for that request id',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            expect(
              await countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(0),
            );

            await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(
              await countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(1),
            );
          },
        );

        test(
          'when a login request is started and completed then a single SecretChallenge covers the full verify-and-consume lifecycle',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final request = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengesBeforeFinish = await SecretChallenge.db.find(
              session,
            );

            expect(request, isNotNull);
            expect(challengesBeforeFinish, hasLength(1));
            final challengeId = request!.challengeId;
            expect(challengesBeforeFinish.single.id, equals(challengeId));

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(result, isA<AuthSuccess>());
            expect(await SecretChallenge.db.find(session), isEmpty);
            expect(
              await SecretChallenge.db.findById(session, challengeId),
              isNull,
            );
          },
        );

        test(
          'when finishLogin is called concurrently with the same request then only one succeeds',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final attempts = [
              fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: deliveredVerificationCode,
              ),
              fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: deliveredVerificationCode,
              ),
            ].wait;

            await expectLater(
              attempts,
              throwsA(
                isA<ParallelWaitError>()
                    .having(
                      (final e) => (e.values as List<AuthSuccess?>).nonNulls,
                      'successful results',
                      hasLength(1),
                    )
                    .having(
                      (final e) => (e.errors as List<AsyncError?>).nonNulls.map(
                        (final error) => error.error,
                      ),
                      'failed results',
                      everyElement(
                        isA<PasswordlessLoginException>().having(
                          (final exception) => exception.reason,
                          'reason',
                          PasswordlessLoginExceptionReason.invalid,
                        ),
                      ),
                    ),
              ),
            );
          },
        );
      });

      group('Given a missing login request', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called then it throws PasswordlessLoginException with reason "invalid"',
          () async {
            final result = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: UuidValue.withValidation(const Uuid().v4()),
              verificationCode: verificationCode,
            );

            await expectLater(
              result,
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          },
        );

        test(
          'when finishLogin is called repeatedly with the same unknown request id then failed attempts are recorded until tooManyAttempts',
          () async {
            final unknownId = UuidValue.withValidation(const Uuid().v4());

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
                  loginRequestId: unknownId,
                  verificationCode: verificationCode,
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

            await expectLater(
              fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: unknownId,
                verificationCode: verificationCode,
              ),
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.tooManyAttempts,
                ),
              ),
            );
          },
        );
      });

      group('Given an expired login request', () {
        late UuidValue requestId;

        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(
            loginVerificationCodeLifetime: const Duration(minutes: 1),
          );

          requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called after expiration then it throws PasswordlessLoginException with reason "expired"',
          () async {
            await withClock(
              Clock.fixed(clock.now().add(const Duration(minutes: 2))),
              () async {
                final result = fixture.passwordlessIdp.finishLogin(
                  session,
                  loginRequestId: requestId,
                  verificationCode: deliveredVerificationCode,
                );

                await expectLater(
                  result,
                  throwsA(
                    isA<PasswordlessLoginException>().having(
                      (final e) => e.reason,
                      'reason',
                      PasswordlessLoginExceptionReason.expired,
                    ),
                  ),
                );
              },
            );
          },
        );

        test(
          'when finishLogin is called after expiration with an invalid verification code then it throws PasswordlessLoginException with reason "invalid"',
          () async {
            await withClock(
              Clock.fixed(clock.now().add(const Duration(minutes: 2))),
              () async {
                final result = fixture.passwordlessIdp.finishLogin(
                  session,
                  loginRequestId: requestId,
                  verificationCode: '$deliveredVerificationCode-wrong',
                );

                await expectLater(
                  result,
                  throwsA(
                    isA<PasswordlessLoginException>().having(
                      (final e) => e.reason,
                      'reason',
                      PasswordlessLoginExceptionReason.invalid,
                    ),
                  ),
                );
              },
            );
          },
        );

        test(
          'when finishLogin is called after expiration then it records a login_verify attempt for that request id',
          () async {
            expect(
              await countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(0),
            );

            await withClock(
              Clock.fixed(clock.now().add(const Duration(minutes: 2))),
              () async {
                final result = fixture.passwordlessIdp.finishLogin(
                  session,
                  loginRequestId: requestId,
                  verificationCode: deliveredVerificationCode,
                );
                await expectLater(
                  result,
                  throwsA(
                    isA<PasswordlessLoginException>().having(
                      (final e) => e.reason,
                      'reason',
                      PasswordlessLoginExceptionReason.expired,
                    ),
                  ),
                );
              },
            );

            expect(
              await countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(1),
            );
          },
        );

        test(
          'when finishLogin is called for an expired request then the request is cleaned up',
          () async {
            await withClock(
              Clock.fixed(clock.now().add(const Duration(minutes: 2))),
              () async {
                final result = fixture.passwordlessIdp.finishLogin(
                  session,
                  loginRequestId: requestId,
                  verificationCode: deliveredVerificationCode,
                );
                await expectLater(
                  result,
                  throwsA(isA<PasswordlessLoginException>()),
                );
              },
            );

            final row = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            expect(row, isNull);
          },
        );

        test(
          'when finishLogin cleans up an expired request then the associated SecretChallenge is also deleted',
          () async {
            final request = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            await withClock(
              Clock.fixed(clock.now().add(const Duration(minutes: 2))),
              () async {
                final result = fixture.passwordlessIdp.finishLogin(
                  session,
                  loginRequestId: requestId,
                  verificationCode: deliveredVerificationCode,
                );
                await expectLater(
                  result,
                  throwsA(isA<PasswordlessLoginException>()),
                );
              },
            );

            final challenge = await SecretChallenge.db.findById(
              session,
              challengeId,
            );
            expect(challenge, isNull);
          },
        );
      });
    },
  );
}
