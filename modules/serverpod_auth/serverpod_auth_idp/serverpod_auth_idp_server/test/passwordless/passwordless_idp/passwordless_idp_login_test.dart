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

void main() {
  withServerpod(
    'Passwordless login scenarios',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late PasswordlessIdpTestFixture<String> fixture;
      late Map<String, UuidValue> handleToUserId;

      const handle = 'test-handle';
      late String verificationCode;
      late UuidValue deliveredRequestId;
      late String deliveredHandle;
      late String deliveredVerificationCode;

      Future<void> initializeFixture({
        final SerializeHandleFunction<String>? serializeHandle,
        final DeserializeHandleFunction<String>? deserializeHandle,
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
                  required final Transaction? transaction,
                }) async {
                  final authUserId = handleToUserId[handle];
                  if (authUserId == null) {
                    throw PasswordlessLoginNotFoundException();
                  }
                  return authUserId;
                },
            serializeHandle: serializeHandle,
            deserializeHandle: deserializeHandle,
            loginVerificationCodeLifetime: loginVerificationCodeLifetime,
            loginVerificationCodeGenerator: () => verificationCode,
            sendLoginVerificationCode:
                (
                  final Session session, {
                  required final String handle,
                  required final UuidValue requestId,
                  required final String verificationCode,
                  required final Transaction? transaction,
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

      group('Given passwordless provider rotating secret hash peppers', () {
        late PasswordlessIdpTestFixture<String> oldPepperFixture;
        late PasswordlessIdpTestFixture<String> rotatedPepperFixture;
        late PasswordlessIdpTestFixture<String> noFallbackFixture;

        Future<PasswordlessIdpTestFixture<String>> createFixture({
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

            final firstRequest = await GenericPasswordlessLoginRequest.db
                .findById(session, firstRequestId);
            final secondRequest = await GenericPasswordlessLoginRequest.db
                .findById(session, secondRequestId);

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

            final firstRequest = await GenericPasswordlessLoginRequest.db
                .findById(session, firstRequestId);
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
      });

      group('Given login request attempts matching the rate limit', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          for (var i = 0; i < 5; i++) {
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
          'when a login request is started and completed then a single SecretChallenge covers the full verify-and-consume lifecycle',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final request = await GenericPasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengesBeforeFinish = await SecretChallenge.db.find(
              session,
            );

            expect(request, isNotNull);
            expect(challengesBeforeFinish, hasLength(1));
            expect(
              challengesBeforeFinish.single.id,
              equals(request!.challengeId),
            );

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(result, isA<AuthSuccess>());
            expect(await SecretChallenge.db.find(session), isEmpty);
          },
        );

        test(
          'when finishLogin succeeds then the associated SecretChallenge is also deleted',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final request = await GenericPasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            await fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            final challenge = await SecretChallenge.db.findById(
              session,
              challengeId,
            );
            expect(challenge, isNull);
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

            final row = await GenericPasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            expect(row, isNull);
          },
        );

        test(
          'when finishLogin cleans up an expired request then the associated SecretChallenge is also deleted',
          () async {
            final request = await GenericPasswordlessLoginRequest.db.findById(
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

        test(
          'when an expired login is finished inside a caller transaction then cleanup rolls back with the savepoint',
          () async {
            final request = await GenericPasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );
            final challengeId = request!.challengeId;

            await session.db.transaction((final transaction) async {
              await withClock(
                Clock.fixed(clock.now().add(const Duration(minutes: 2))),
                () async {
                  final result = fixture.passwordlessIdp.finishLogin(
                    session,
                    loginRequestId: requestId,
                    verificationCode: deliveredVerificationCode,
                    transaction: transaction,
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
                await GenericPasswordlessLoginRequest.db.findById(
                  session,
                  requestId,
                  transaction: transaction,
                ),
                isNotNull,
              );
              expect(
                await SecretChallenge.db.findById(
                  session,
                  challengeId,
                  transaction: transaction,
                ),
                isNotNull,
              );
            });

            expect(
              await GenericPasswordlessLoginRequest.db.findById(
                session,
                requestId,
              ),
              isNotNull,
            );
            expect(
              await SecretChallenge.db.findById(session, challengeId),
              isNotNull,
            );
          },
        );
      });

      group('Given a custom deserializer that reports invalid handle format', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(
            deserializeHandle: (final handle) {
              throw const FormatException('invalid handle format');
            },
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called then it throws PasswordlessLoginException with reason "invalid"',
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
                  PasswordlessLoginExceptionReason.invalid,
                ),
              ),
            );
          },
        );
      });

      group(
        'Given a stored handle that reports invalid serialized format',
        () {
          late UuidValue requestId;

          setUp(() async {
            session = sessionBuilder.build();
            await initializeFixture(
              deserializeHandle: (final handle) {
                if (handle == 'test-handle') return handle;
                throw const FormatException('invalid stored handle format');
              },
              serializeHandle: (final handle) => 'stored:$handle',
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
        },
      );

      group('Given a stored handle that triggers a custom deserializer bug', () {
        late UuidValue requestId;

        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(
            deserializeHandle: (final handle) {
              if (handle == 'test-handle') return handle;
              throw StateError('broken stored handle parser');
            },
            serializeHandle: (final handle) => 'stored:$handle',
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
          'when finishLogin is called then it surfaces the deserializer error',
          () async {
            final result = fixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            await expectLater(result, throwsA(isA<StateError>()));
          },
        );
      });

      group('Given passwordless provider with default int handle support', () {
        late PasswordlessIdpTestFixture<int> intFixture;
        late Map<int, UuidValue> intHandleToUserId;
        late int deliveredIntHandle;
        const intHandle = '42';

        setUp(() async {
          session = sessionBuilder.build();
          intHandleToUserId = {};
          verificationCode = const Uuid().v4().toString();

          intFixture = PasswordlessIdpTestFixture(
            config: PasswordlessIdpConfig<int>(
              secretHashPepper: 'pepper',
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final int handle,
                    required final Transaction? transaction,
                  }) async {
                    final authUserId = intHandleToUserId[handle];
                    if (authUserId == null) {
                      throw PasswordlessLoginNotFoundException();
                    }
                    return authUserId;
                  },
              loginVerificationCodeGenerator: () => verificationCode,
              sendLoginVerificationCode:
                  (
                    final Session session, {
                    required final int handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                  }) async {
                    deliveredIntHandle = handle;
                    deliveredRequestId = requestId;
                    deliveredVerificationCode = verificationCode;
                  },
            ),
          );

          final authUser = await intFixture.authUsers.create(session);
          intHandleToUserId[42] = authUser.id;
        });

        tearDown(() async {
          await intFixture.tearDown(session);
        });

        test(
          'when login completes then it resolves the int handle and stores its plain serialization',
          () async {
            final requestId = await intFixture.passwordlessIdp.startLogin(
              session,
              handle: intHandle,
            );

            final authSuccess = await intFixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(authSuccess, isA<AuthSuccess>());
            expect(deliveredIntHandle, equals(42));
            final request = await GenericPasswordlessLoginRequest.db
                .findFirstRow(
                  session,
                  where: (final t) => t.id.equals(deliveredRequestId),
                );
            expect(request, isNull);

            final attempts = await RateLimitedRequestAttempt.db.find(
              session,
              where: (final t) =>
                  t.domain.equals('passwordless') &
                  t.source.equals('login_request'),
            );
            expect(attempts.single.nonce, equals(intHandle));
          },
        );

        test(
          'when startLogin is called with an invalid raw handle then it throws PasswordlessLoginException with reason "invalid"',
          () async {
            final result = intFixture.passwordlessIdp.startLogin(
              session,
              handle: 'not-a-number',
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
        'Given passwordless provider with default UuidValue handle support',
        () {
          late PasswordlessIdpTestFixture<UuidValue> uuidFixture;
          late Map<UuidValue, UuidValue> handleToAuthUserId;
          late UuidValue deliveredUuidHandle;
          late UuidValue typedUuidHandle;
          late String uuidHandle;

          setUp(() async {
            session = sessionBuilder.build();
            handleToAuthUserId = {};
            verificationCode = const Uuid().v4().toString();
            typedUuidHandle = UuidValue.withValidation(const Uuid().v4());
            uuidHandle = typedUuidHandle.uuid;

            uuidFixture = PasswordlessIdpTestFixture(
              config: PasswordlessIdpConfig<UuidValue>(
                secretHashPepper: 'pepper',
                resolveAuthUserId:
                    (
                      final Session session, {
                      required final UuidValue handle,
                      required final Transaction? transaction,
                    }) async {
                      final authUserId = handleToAuthUserId[handle];
                      if (authUserId == null) {
                        throw PasswordlessLoginNotFoundException();
                      }
                      return authUserId;
                    },
                loginVerificationCodeGenerator: () => verificationCode,
                sendLoginVerificationCode:
                    (
                      final Session session, {
                      required final UuidValue handle,
                      required final UuidValue requestId,
                      required final String verificationCode,
                      required final Transaction? transaction,
                    }) async {
                      deliveredUuidHandle = handle;
                      deliveredRequestId = requestId;
                      deliveredVerificationCode = verificationCode;
                    },
              ),
            );

            final authUser = await uuidFixture.authUsers.create(session);
            handleToAuthUserId[typedUuidHandle] = authUser.id;
          });

          tearDown(() async {
            await uuidFixture.tearDown(session);
          });

          test(
            'when login completes then it resolves the UuidValue handle using default callbacks',
            () async {
              final requestId = await uuidFixture.passwordlessIdp.startLogin(
                session,
                handle: uuidHandle,
              );

              final authSuccess = await uuidFixture.passwordlessIdp.finishLogin(
                session,
                loginRequestId: requestId,
                verificationCode: deliveredVerificationCode,
              );

              expect(authSuccess, isA<AuthSuccess>());
              expect(deliveredUuidHandle, equals(typedUuidHandle));
              final attempts = await RateLimitedRequestAttempt.db.find(
                session,
                where: (final t) =>
                    t.domain.equals('passwordless') &
                    t.source.equals('login_request'),
              );
              expect(attempts.single.nonce, equals(uuidHandle));
            },
          );
        },
      );

      group('Given passwordless provider with custom handle serialization', () {
        late PasswordlessIdpTestFixture<_TestHandle> customFixture;
        late _TestHandle deliveredCustomHandle;
        late Map<String, UuidValue> serializedHandleToUserId;

        setUp(() async {
          session = sessionBuilder.build();
          serializedHandleToUserId = {};
          verificationCode = const Uuid().v4().toString();

          customFixture = PasswordlessIdpTestFixture(
            config: PasswordlessIdpConfig<_TestHandle>(
              secretHashPepper: 'pepper',
              resolveAuthUserId:
                  (
                    final Session session, {
                    required final _TestHandle handle,
                    required final Transaction? transaction,
                  }) async {
                    final authUserId =
                        serializedHandleToUserId['custom:${handle.value}'];
                    if (authUserId == null) {
                      throw PasswordlessLoginNotFoundException();
                    }
                    return authUserId;
                  },
              deserializeHandle: (final handle) => _TestHandle(
                handle.startsWith('custom:')
                    ? handle.substring('custom:'.length)
                    : handle,
              ),
              serializeHandle: (final handle) => 'custom:${handle.value}',
              loginVerificationCodeGenerator: () => verificationCode,
              sendLoginVerificationCode:
                  (
                    final Session session, {
                    required final _TestHandle handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                  }) async {
                    deliveredCustomHandle = handle;
                    deliveredRequestId = requestId;
                    deliveredVerificationCode = verificationCode;
                  },
            ),
          );

          final authUser = await customFixture.authUsers.create(session);
          serializedHandleToUserId['custom:test-handle'] = authUser.id;
        });

        tearDown(() async {
          await customFixture.tearDown(session);
        });

        test(
          'when login completes then rate limit, persistence, and auth resolution use the same serialized handle',
          () async {
            final requestId = await customFixture.passwordlessIdp.startLogin(
              session,
              handle: 'test-handle',
            );

            final request = await GenericPasswordlessLoginRequest.db.findById(
              session,
              deliveredRequestId,
            );

            final authSuccess = await customFixture.passwordlessIdp.finishLogin(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            expect(authSuccess, isA<AuthSuccess>());
            expect(deliveredCustomHandle.value, equals('test-handle'));
            expect(request, isNotNull);
            expect(request!.nonce, equals('custom:test-handle'));

            final attempts = await RateLimitedRequestAttempt.db.find(
              session,
              where: (final t) =>
                  t.domain.equals('passwordless') &
                  t.source.equals('login_request'),
            );
            expect(attempts.single.nonce, equals('custom:test-handle'));
          },
        );
      });

      group('Given rate-limited login request attempts', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          for (var i = 0; i < 5; i++) {
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

          for (var i = 0; i < 3; i++) {
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
            final request = await GenericPasswordlessLoginRequest.db.findById(
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

            final verificationAttempts = await RateLimitedRequestAttempt.db
                .find(
                  session,
                  where: (final t) =>
                      t.domain.equals('passwordless') &
                      t.source.equals('login_verify') &
                      t.nonce.equals(requestId.uuid),
                );
            expect(verificationAttempts, isEmpty);
            expect(
              await GenericPasswordlessLoginRequest.db.findById(
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
          final expiredRequest = await GenericPasswordlessLoginRequest.db
              .findById(session, expiredRequestId);
          expiredChallengeId = expiredRequest!.challengeId;

          await withClock(Clock.fixed(cleanupTime), () async {
            activeRequestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: activeHandle,
            );
          });
          final activeRequest = await GenericPasswordlessLoginRequest.db
              .findById(
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
              await GenericPasswordlessLoginRequest.db.findById(
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
              await GenericPasswordlessLoginRequest.db.findById(
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
            staleChallengeId =
                (await GenericPasswordlessLoginRequest.db.findById(
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
            recentChallengeId =
                (await GenericPasswordlessLoginRequest.db.findById(
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
                await GenericPasswordlessLoginRequest.db.findById(
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
                await GenericPasswordlessLoginRequest.db.findById(
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
                    t.nonce.equals(staleHandle),
              );
              final recentAttempts = await RateLimitedRequestAttempt.db.find(
                session,
                where: (final t) =>
                    t.domain.equals('passwordless') &
                    t.source.equals('login_request') &
                    t.nonce.equals(recentHandle),
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

final class _TestHandle {
  final String value;

  const _TestHandle(this.value);
}
