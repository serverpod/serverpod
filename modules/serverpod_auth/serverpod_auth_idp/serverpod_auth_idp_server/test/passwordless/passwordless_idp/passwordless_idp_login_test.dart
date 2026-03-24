import 'dart:async';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';
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
      });

      group('Given a custom serializer with empty serialized handle', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(serializeHandle: (final handle) => '');
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

      group('Given passwordless provider with default int handle support', () {
        late PasswordlessIdpTestFixture<int> intFixture;
        late Map<int, UuidValue> intHandleToUserId;
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
                    required final String handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                  }) async {
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
      });

      group(
        'Given passwordless provider with default UuidValue handle support',
        () {
          late PasswordlessIdpTestFixture<UuidValue> uuidFixture;
          late Map<UuidValue, UuidValue> handleToAuthUserId;
          late String uuidHandle;

          setUp(() async {
            session = sessionBuilder.build();
            handleToAuthUserId = {};
            verificationCode = const Uuid().v4().toString();
            final typedHandle = UuidValue.withValidation(const Uuid().v4());
            uuidHandle = typedHandle.uuid;

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
                      required final String handle,
                      required final UuidValue requestId,
                      required final String verificationCode,
                      required final Transaction? transaction,
                    }) async {
                      deliveredRequestId = requestId;
                      deliveredVerificationCode = verificationCode;
                    },
              ),
            );

            final authUser = await uuidFixture.authUsers.create(session);
            handleToAuthUserId[typedHandle] = authUser.id;
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
                    required final String handle,
                    required final UuidValue requestId,
                    required final String verificationCode,
                    required final Transaction? transaction,
                  }) async {
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
          'when deleteIncompleteLoginAttempts is called then rate limit resets',
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
              await fixture.passwordlessIdp.deleteIncompleteLoginAttempts(
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
    },
  );
}

final class _TestHandle {
  final String value;

  const _TestHandle(this.value);
}
