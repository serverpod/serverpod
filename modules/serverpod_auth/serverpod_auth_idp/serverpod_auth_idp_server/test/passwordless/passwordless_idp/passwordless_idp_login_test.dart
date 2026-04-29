import 'dart:async';
import 'dart:convert' show jsonEncode;

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

void main() {
  withServerpod(
    'Passwordless login scenarios',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late PasswordlessIdpTestFixture fixture;
      late Map<String, UuidValue> handleToUserId;

      const handle = 'test-handle';
      late String verificationCode;
      late UuidValue deliveredRequestId;
      late String deliveredHandle;
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
                  deliveredHandle = handle;
                  deliveredRequestId = requestId;
                  deliveredVerificationCode = verificationCode;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        handleToUserId[handle] = authUser.id;
      }

      group('Given a valid handle and configured passwordless provider', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called then it returns a request id',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            expect(requestId, isA<UuidValue>());
            expect(deliveredRequestId, equals(requestId));
            expect(deliveredHandle, equals(handle));
            expect(deliveredVerificationCode, equals(verificationCode));
          },
        );

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

      group(
        'Given passwordless provider without sendLoginVerificationCode callback',
        () {
          setUp(() async {
            session = sessionBuilder.build();
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
                loginVerificationCodeGenerator: () => verificationCode,
                sendLoginVerificationCode: null,
              ),
            );

            final authUser = await fixture.authUsers.create(session);
            handleToUserId[handle] = authUser.id;
          });

          tearDown(() async {
            await fixture.tearDown(session);
          });

          test(
            'when startLogin and finishLogin are called then login still succeeds',
            () async {
              final requestId = await fixture.passwordlessIdp.startLogin(
                session,
                handle: handle,
              );

              final result = await fixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: verificationCode,
              );

              expect(requestId, isA<UuidValue>());
              expect(result, isA<AuthSuccess>());
            },
          );
        },
      );

      group('Given sendLoginVerificationCode throws', () {
        setUp(() async {
          session = sessionBuilder.build();
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
                    throw StateError('send failed');
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
          'when startLogin is called then the error propagates, login_request rate limit is recorded, and no pending request or challenge remains',
          () async {
            expect(
              await _countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
              ),
              equals(0),
            );
            expect(
              await PasswordlessLoginRequest.db.count(session),
              equals(0),
            );
            expect(
              await SecretChallenge.db.count(session),
              equals(0),
            );

            await expectLater(
              fixture.passwordlessIdp.startLogin(session, handle: handle),
              throwsA(
                isA<StateError>().having(
                  (final e) => e.message,
                  'message',
                  'send failed',
                ),
              ),
            );

            expect(
              await _countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
              ),
              equals(1),
            );
            expect(
              await PasswordlessLoginRequest.db.find(
                session,
                where: (final t) => t.handle.equals(handle),
              ),
              isEmpty,
            );
            expect(
              await SecretChallenge.db.find(session),
              isEmpty,
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
                    deliveredHandle = handle;
                    deliveredRequestId = requestId;
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

      group('Given an existing login request', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called for the same handle then previous request is replaced',
          () async {
            final firstRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            final secondRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final firstRequest = await PasswordlessLoginRequest.db.findById(
              session,
              firstRequestId,
            );
            final secondRequest = await PasswordlessLoginRequest.db.findById(
              session,
              secondRequestId,
            );

            expect(firstRequest, isNull);
            expect(secondRequest, isNotNull);
          },
        );

        test(
          'when startLogin replaces a previous request then the old SecretChallenge is also deleted',
          () async {
            final firstRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final firstRequest = await PasswordlessLoginRequest.db.findById(
              session,
              firstRequestId,
            );
            final firstChallengeId = firstRequest!.challengeId;

            await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final oldChallenge = await SecretChallenge.db.findById(
              session,
              firstChallengeId,
            );
            expect(oldChallenge, isNull);
          },
        );

        test(
          'when startLogin is called for the same handle with a different handleType then previous request is kept',
          () async {
            final firstRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
              handleType: 'email',
            );
            final secondRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
              handleType: 'sms',
            );

            final firstRequest = await PasswordlessLoginRequest.db.findById(
              session,
              firstRequestId,
            );
            final secondRequest = await PasswordlessLoginRequest.db.findById(
              session,
              secondRequestId,
            );

            expect(firstRequest, isNotNull);
            expect(firstRequest!.handleType, equals('email'));
            expect(secondRequest, isNotNull);
            expect(secondRequest!.handleType, equals('sms'));
            expect(
              await _countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
                handleType: 'email',
              ),
              equals(1),
            );
            expect(
              await _countPasswordlessLoginRequestAttempts(
                session,
                handle: handle,
                handleType: 'sms',
              ),
              equals(1),
            );
          },
        );
      });

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
          'when startLogin is called then it throws PasswordlessLoginException with reason "tooManyAttempts"',
          () async {
            final result = fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            await expectLater(
              result,
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

      group('Given a valid login request', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called with correct code then it returns AuthSuccess',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(result, isA<AuthSuccess>());
          },
        );

        test(
          'when finishLogin succeeds then it does not insert login_verify rate limit rows for that request id',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            expect(
              await _countPasswordlessLoginVerifyAttempts(
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
              await _countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(0),
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
            expect(
              challengesBeforeFinish.single.id,
              equals(challengeId),
            );

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

      group('Given an existing account with scopes', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          final authUserId = handleToUserId[handle]!;
          await fixture.authUsers.update(
            session,
            authUserId: authUserId,
            scopes: {const Scope('test-scope'), const Scope('admin')},
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when login is completed then the returned AuthSuccess contains the user scopes',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(result.scopeNames, contains('test-scope'));
            expect(result.scopeNames, contains('admin'));
            expect(result.scopeNames, hasLength(2));
          },
        );
      });

      group('Given a blocked auth user account', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          final authUserId = handleToUserId[handle]!;
          await fixture.authUsers.update(
            session,
            authUserId: authUserId,
            blocked: true,
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when login is completed with correct credentials then it throws AuthUserBlockedException',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(result, throwsA(isA<AuthUserBlockedException>()));
          },
        );

        test(
          'when login is blocked after verification then the request is still consumed',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            final request = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            final firstAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              firstAttempt,
              throwsA(isA<AuthUserBlockedException>()),
            );
            expect(
              await PasswordlessLoginRequest.db.findById(
                session,
                requestId,
              ),
              isNull,
            );
            expect(
              await SecretChallenge.db.findById(session, challengeId),
              isNull,
            );

            final secondAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              secondAttempt,
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

      group('Given a login request with missing auth user resolution', () {
        late UuidValue requestId;

        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );
          handleToUserId.remove(handle);
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called then it throws PasswordlessLoginException with reason "invalid"',
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
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          },
        );

        test(
          'when finishLogin fails during auth user resolution then the request is still consumed',
          () async {
            final request = await PasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            final firstAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              firstAttempt,
              throwsA(
                isA<PasswordlessLoginException>().having(
                  (final e) => e.reason,
                  'reason',
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
            expect(
              await PasswordlessLoginRequest.db.findById(
                session,
                requestId,
              ),
              isNull,
            );
            expect(
              await SecretChallenge.db.findById(session, challengeId),
              isNull,
            );

            final secondAttempt = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(
              secondAttempt,
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
          'when finishLogin is called after expiration with an invalid verification code then it throws PasswordlessLoginException with reason "expired"',
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
                      PasswordlessLoginExceptionReason.expired,
                    ),
                  ),
                );
              },
            );
          },
        );

        test(
          'when finishLogin is called after expiration then it does not insert login_verify rate limit rows for that request id',
          () async {
            expect(
              await _countPasswordlessLoginVerifyAttempts(
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
              await _countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(0),
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
            expect(row, isNotNull);
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
            expect(challenge, isNotNull);
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
              await _countPasswordlessLoginVerifyAttempts(
                session,
                loginRequestId: requestId,
              ),
              equals(0),
            );
            expect(
              await PasswordlessLoginRequest.db.findById(
                session,
                requestId,
              ),
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
                    t.nonce.equals(_loginRequestRateLimitNonce(staleHandle)),
              );
              final recentAttempts = await RateLimitedRequestAttempt.db.find(
                session,
                where: (final t) =>
                    t.domain.equals('passwordless') &
                    t.source.equals('login_request') &
                    t.nonce.equals(_loginRequestRateLimitNonce(recentHandle)),
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

Future<int> _countPasswordlessLoginRequestAttempts(
  final Session session, {
  required final String handle,
  final String? handleType,
}) => RateLimitedRequestAttempt.db.count(
  session,
  where: (final t) =>
      t.domain.equals('passwordless') &
      t.source.equals('login_request') &
      t.nonce.equals(
        _loginRequestRateLimitNonce(handle, handleType: handleType),
      ),
);

String _loginRequestRateLimitNonce(
  final String handle, {
  final String? handleType,
}) => jsonEncode([handle, handleType]);

Future<int> _countPasswordlessLoginVerifyAttempts(
  final Session session, {
  required final UuidValue loginRequestId,
}) => RateLimitedRequestAttempt.db.count(
  session,
  where: (final t) =>
      t.domain.equals('passwordless') &
      t.source.equals('login_verify') &
      t.nonce.equals(loginRequestId.uuid),
);
