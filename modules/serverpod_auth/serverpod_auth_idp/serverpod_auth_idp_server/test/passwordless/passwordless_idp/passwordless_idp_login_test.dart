import 'dart:async';

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
        final PasswordlessLoginRequestStore? requestStore,
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
            loginRequestStore: requestStore ?? _defaultLoginRequestStore(),
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
          'when verifyLoginCode is called with invalid verification code then it throws PasswordlessLoginException with reason "invalid"',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = fixture.passwordlessIdp.verifyLoginCode(
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
                .findById(
                  session,
                  firstRequestId,
                );
            final secondRequest = await GenericPasswordlessLoginRequest.db
                .findById(
                  session,
                  secondRequestId,
                );

            expect(firstRequest, isNull);
            expect(secondRequest, isNotNull);
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

      group('Given a verified login token', () {
        late String token;

        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture();

          final requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );
          token = await fixture.passwordlessIdp.verifyLoginCode(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredVerificationCode,
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when finishLogin is called then it returns AuthSuccess',
          () async {
            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginToken: token,
            );

            expect(result, isA<AuthSuccess>());
          },
        );

        test(
          'when finishLogin is called concurrently with the same token then only one succeeds',
          () async {
            final attempts = [
              fixture.passwordlessIdp.finishLogin(session, loginToken: token),
              fixture.passwordlessIdp.finishLogin(session, loginToken: token),
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
            final token = await fixture.passwordlessIdp.verifyLoginCode(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginToken: token,
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
            final token = await fixture.passwordlessIdp.verifyLoginCode(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            final result = fixture.passwordlessIdp.finishLogin(
              session,
              loginToken: token,
            );

            await expectLater(result, throwsA(isA<AuthUserBlockedException>()));
          },
        );
      });

      group(
        'Given a verified login token and custom store that fails to delete request',
        () {
          late String token;

          setUp(() async {
            session = sessionBuilder.build();
            await initializeFixture(
              requestStore: _InMemoryPasswordlessLoginRequestStore(
                onDeleteById:
                    (
                      final Session session, {
                      required final UuidValue requestId,
                      required final Transaction? transaction,
                    }) async => false,
              ),
            );

            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            token = await fixture.passwordlessIdp.verifyLoginCode(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );
          });

          tearDown(() async {
            await fixture.tearDown(session);
          });

          test(
            'when finishLogin is called then it returns invalid reason',
            () async {
              final result = fixture.passwordlessIdp.finishLogin(
                session,
                loginToken: token,
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

      group(
        'Given a verified login token and missing auth user resolution',
        () {
          late String token;

          setUp(() async {
            session = sessionBuilder.build();
            await initializeFixture();

            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );
            token = await fixture.passwordlessIdp.verifyLoginCode(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );

            handleToUserId.remove(handle);
          });

          tearDown(() async {
            await fixture.tearDown(session);
          });

          test(
            'when finishLogin is called then it returns invalid reason',
            () async {
              final result = fixture.passwordlessIdp.finishLogin(
                session,
                loginToken: token,
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

      group('Given a custom login request store', () {
        late _InMemoryPasswordlessLoginRequestStore customStore;

        setUp(() async {
          session = sessionBuilder.build();
          customStore = _InMemoryPasswordlessLoginRequestStore();
          await initializeFixture(requestStore: customStore);
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when login flow completes then it works without default request table rows',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final defaultRequest = await GenericPasswordlessLoginRequest.db
                .findById(
                  session,
                  requestId,
                );
            expect(defaultRequest, isNull);
            expect(customStore.hasRequest(requestId), isTrue);

            final token = await fixture.passwordlessIdp.verifyLoginCode(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );
            final result = await fixture.passwordlessIdp.finishLogin(
              session,
              loginToken: token,
            );

            expect(result, isA<AuthSuccess>());
            expect(customStore.hasRequest(requestId), isFalse);
          },
        );
      });

      group(
        'Given a custom store that cannot atomically link completion challenge',
        () {
          setUp(() async {
            session = sessionBuilder.build();
            await initializeFixture(
              requestStore: _InMemoryPasswordlessLoginRequestStore(
                onLinkCompletionChallengeAtomically:
                    (
                      final Session session, {
                      required final UuidValue requestId,
                      required final UuidValue completionChallengeId,
                      required final Transaction? transaction,
                    }) async => false,
              ),
            );
          });

          tearDown(() async {
            await fixture.tearDown(session);
          });

          test(
            'when verifyLoginCode is called then it returns invalid reason',
            () async {
              final requestId = await fixture.passwordlessIdp.startLogin(
                session,
                handle: handle,
              );

              final result = fixture.passwordlessIdp.verifyLoginCode(
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

      group('Given a custom store with missing verification challenge', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(
            requestStore: _InMemoryPasswordlessLoginRequestStore(
              loadVerificationChallenge:
                  (
                    final Session session, {
                    required final UuidValue challengeId,
                    required final Transaction? transaction,
                  }) async => null,
            ),
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when verifyLoginCode is called then it returns invalid reason',
          () async {
            final requestId = await fixture.passwordlessIdp.startLogin(
              session,
              handle: handle,
            );

            final result = fixture.passwordlessIdp.verifyLoginCode(
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

      group('Given an expired custom store request', () {
        late _InMemoryPasswordlessLoginRequestStore customStore;
        late UuidValue requestId;

        setUp(() async {
          session = sessionBuilder.build();
          customStore = _InMemoryPasswordlessLoginRequestStore();
          await initializeFixture(
            requestStore: customStore,
            loginVerificationCodeLifetime: const Duration(minutes: 1),
          );
          requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );
          customStore.setCreatedAt(
            requestId,
            DateTime.now().subtract(const Duration(minutes: 2)),
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when verifyLoginCode is called then it returns expired reason',
          () async {
            final result = fixture.passwordlessIdp.verifyLoginCode(
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

        test(
          'when verifyLoginCode is called for an expired request then the request is cleaned up',
          () async {
            final result = fixture.passwordlessIdp.verifyLoginCode(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );
            await expectLater(
              result,
              throwsA(isA<PasswordlessLoginException>()),
            );

            expect(customStore.hasRequest(requestId), isFalse);
          },
        );
      });

      group('Given a custom serializer with empty serialized handle', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(
            serializeHandle: (final handle) => '',
          );
        });

        tearDown(() async {
          await fixture.tearDown(session);
        });

        test(
          'when startLogin is called then it returns invalid reason',
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

      group('Given a generic DB-backed request store', () {
        late SecretChallenge challenge;
        const store = GenericPasswordlessLoginRequestStore();

        setUp(() async {
          session = sessionBuilder.build();
          challenge = await SecretChallenge.db.insertRow(
            session,
            SecretChallenge(challengeCodeHash: 'hash'),
          );
        });

        tearDown(() async {
          await SecretChallenge.db.deleteWhere(
            session,
            where: (final _) => Constant.bool(true),
          );
          await GenericPasswordlessLoginRequest.db.deleteWhere(
            session,
            where: (final _) => Constant.bool(true),
          );
        });

        test(
          'when request is created then serialized handle is stored as plain text',
          () async {
            final requestId = await session.db.transaction((final transaction) {
              return store.createRequest(
                session,
                serializedHandle: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });

            final row = await GenericPasswordlessLoginRequest.db.findById(
              session,
              requestId,
            );

            expect(row, isNotNull);
            expect(row!.nonce, equals(handle));
          },
        );

        test(
          'when request is loaded then it returns the serialized handle unchanged',
          () async {
            final requestId = await session.db.transaction((final transaction) {
              return store.createRequest(
                session,
                serializedHandle: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });

            final request = await store.getRequestForVerification(
              session,
              requestId: requestId,
              transaction: null,
            );

            expect(request, isNotNull);
            expect(request!.serializedHandle, equals(handle));
          },
        );
      });

      group('Given generic DB-backed stores with different sources', () {
        late SecretChallenge challenge;
        const sourceAStore = GenericPasswordlessLoginRequestStore(
          source: 'source_a',
        );
        const sourceBStore = GenericPasswordlessLoginRequestStore(
          source: 'source_b',
        );

        setUp(() async {
          session = sessionBuilder.build();
          challenge = await SecretChallenge.db.insertRow(
            session,
            SecretChallenge(challengeCodeHash: 'hash'),
          );
        });

        tearDown(() async {
          await SecretChallenge.db.deleteWhere(
            session,
            where: (final _) => Constant.bool(true),
          );
          await GenericPasswordlessLoginRequest.db.deleteWhere(
            session,
            where: (final _) => Constant.bool(true),
          );
        });

        test(
          'when requests use different sources then they do not conflict',
          () async {
            final requestA = await session.db.transaction((final transaction) {
              return sourceAStore.createRequest(
                session,
                serializedHandle: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });
            final requestB = await session.db.transaction((final transaction) {
              return sourceBStore.createRequest(
                session,
                serializedHandle: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });

            final rowA = await GenericPasswordlessLoginRequest.db.findById(
              session,
              requestA,
            );
            final rowB = await GenericPasswordlessLoginRequest.db.findById(
              session,
              requestB,
            );

            expect(rowA, isNotNull);
            expect(rowB, isNotNull);
            expect(rowA!.nonce, equals('source_a::$handle'));
            expect(rowB!.nonce, equals('source_b::$handle'));
          },
        );

        test(
          'when a request is loaded through a store with a different source then it returns invalid reason',
          () async {
            final requestId = await session.db.transaction((final transaction) {
              return sourceBStore.createRequest(
                session,
                serializedHandle: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });

            final result = sourceAStore.getRequestForVerification(
              session,
              requestId: requestId,
              transaction: null,
            );

            await expectLater(
              result,
              throwsA(isA<PasswordlessLoginInvalidException>()),
            );
          },
        );
      });

      group('Given passwordless provider with default int handle support', () {
        late PasswordlessIdpTestFixture<int> intFixture;
        late Map<int, UuidValue> intHandleToUserId;
        const intHandle = '42';
        late String token;

        setUp(() async {
          session = sessionBuilder.build();
          intHandleToUserId = {};
          verificationCode = const Uuid().v4().toString();

          intFixture = PasswordlessIdpTestFixture(
            config: PasswordlessIdpConfig<int>(
              secretHashPepper: 'pepper',
              loginRequestStore: _defaultLoginRequestStore(),
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
            ),
          );

          final authUser = await intFixture.authUsers.create(session);
          intHandleToUserId[42] = authUser.id;

          final requestId = await intFixture.passwordlessIdp.startLogin(
            session,
            handle: intHandle,
          );
          token = await intFixture.passwordlessIdp.verifyLoginCode(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredVerificationCode,
          );
        });

        tearDown(() async {
          await intFixture.tearDown(session);
        });

        test(
          'when login completes then it resolves the int handle and stores its plain serialization',
          () async {
            final authSuccess = await intFixture.passwordlessIdp.finishLogin(
              session,
              loginToken: token,
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
          late String token;

          setUp(() async {
            session = sessionBuilder.build();
            handleToAuthUserId = {};
            verificationCode = const Uuid().v4().toString();
            final typedHandle = UuidValue.withValidation(const Uuid().v4());
            uuidHandle = typedHandle.uuid;

            uuidFixture = PasswordlessIdpTestFixture(
              config: PasswordlessIdpConfig<UuidValue>(
                secretHashPepper: 'pepper',
                loginRequestStore: _defaultLoginRequestStore(),
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
              ),
            );

            final authUser = await uuidFixture.authUsers.create(session);
            handleToAuthUserId[typedHandle] = authUser.id;

            final requestId = await uuidFixture.passwordlessIdp.startLogin(
              session,
              handle: uuidHandle,
            );
            token = await uuidFixture.passwordlessIdp.verifyLoginCode(
              session,
              loginRequestId: requestId,
              verificationCode: deliveredVerificationCode,
            );
          });

          tearDown(() async {
            await uuidFixture.tearDown(session);
          });

          test(
            'when login completes then it resolves the UuidValue handle using default callbacks',
            () async {
              final authSuccess = await uuidFixture.passwordlessIdp.finishLogin(
                session,
                loginToken: token,
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
        late String token;

        setUp(() async {
          session = sessionBuilder.build();
          serializedHandleToUserId = {};
          verificationCode = const Uuid().v4().toString();

          customFixture = PasswordlessIdpTestFixture(
            config: PasswordlessIdpConfig<_TestHandle>(
              secretHashPepper: 'pepper',
              loginRequestStore: _defaultLoginRequestStore(),
              normalizeHandle: (final handle) => handle.trim().toLowerCase(),
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
            ),
          );

          final authUser = await customFixture.authUsers.create(session);
          serializedHandleToUserId['custom:test-handle'] = authUser.id;

          final requestId = await customFixture.passwordlessIdp.startLogin(
            session,
            handle: '  test-handle  ',
          );
          token = await customFixture.passwordlessIdp.verifyLoginCode(
            session,
            loginRequestId: requestId,
            verificationCode: deliveredVerificationCode,
          );
        });

        tearDown(() async {
          await customFixture.tearDown(session);
        });

        test(
          'when login completes then rate limit, persistence, and auth resolution use the same serialized handle',
          () async {
            final request = await GenericPasswordlessLoginRequest.db.findById(
              session,
              deliveredRequestId,
            );
            final authSuccess = await customFixture.passwordlessIdp.finishLogin(
              session,
              loginToken: token,
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
    },
  );

  group('Passwordless configuration validation', () {
    test(
      'when THandle is not a supported basic type and custom callbacks are not provided then PasswordlessIdpConfig throws ArgumentError',
      () {
        expect(
          () => PasswordlessIdpConfig<_UnsupportedHandle>(
            secretHashPepper: 'pepper',
            loginRequestStore: _defaultLoginRequestStore(),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}

final class _InMemoryPasswordlessLoginRequestStore
    implements PasswordlessLoginRequestStore {
  final Map<UuidValue, _InMemoryPasswordlessLoginRequest> _byId = {};
  final Map<String, UuidValue> _idBySerializedHandle = {};

  final FutureOr<bool> Function(
    Session session, {
    required UuidValue requestId,
    required UuidValue completionChallengeId,
    required Transaction? transaction,
  })?
  onLinkCompletionChallengeAtomically;

  final FutureOr<SecretChallenge?> Function(
    Session session, {
    required UuidValue challengeId,
    required Transaction? transaction,
  })?
  loadVerificationChallenge;

  final FutureOr<bool> Function(
    Session session, {
    required UuidValue requestId,
    required Transaction? transaction,
  })?
  onDeleteById;

  _InMemoryPasswordlessLoginRequestStore({
    this.onLinkCompletionChallengeAtomically,
    this.loadVerificationChallenge,
    this.onDeleteById,
  });

  bool hasRequest(final UuidValue requestId) => _byId.containsKey(requestId);

  void setCreatedAt(final UuidValue requestId, final DateTime createdAt) {
    final request = _byId[requestId];
    if (request == null) return;
    request.createdAt = createdAt;
  }

  @override
  Future<void> deleteByHandle(
    final Session session, {
    required final String serializedHandle,
    required final Transaction transaction,
  }) async {
    final requestId = _idBySerializedHandle.remove(serializedHandle);
    if (requestId == null) return;
    _byId.remove(requestId);
  }

  @override
  Future<UuidValue> createRequest(
    final Session session, {
    required final String serializedHandle,
    required final UuidValue challengeId,
    required final Transaction transaction,
  }) async {
    final requestId = UuidValue.withValidation(const Uuid().v4());
    final request = _InMemoryPasswordlessLoginRequest(
      id: requestId,
      createdAt: DateTime.now(),
      serializedHandle: serializedHandle,
      challengeId: challengeId,
    );
    _idBySerializedHandle[serializedHandle] = requestId;
    _byId[requestId] = request;
    return requestId;
  }

  @override
  Future<PasswordlessLoginRequestData?> getRequestForVerification(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    final request = _byId[requestId];
    if (request == null) return null;

    final challengeLoader = loadVerificationChallenge;
    final challenge = challengeLoader == null
        ? await SecretChallenge.db.findById(
            session,
            request.challengeId,
            transaction: transaction,
          )
        : await challengeLoader(
            session,
            challengeId: request.challengeId,
            transaction: transaction,
          );
    final loginChallenge = request.loginChallengeId == null
        ? null
        : await SecretChallenge.db.findById(
            session,
            request.loginChallengeId!,
            transaction: transaction,
          );

    return PasswordlessLoginRequestData(
      id: request.id,
      createdAt: request.createdAt,
      serializedHandle: request.serializedHandle,
      challenge: challenge,
      loginChallengeId: request.loginChallengeId,
      loginChallenge: loginChallenge,
    );
  }

  @override
  Future<PasswordlessLoginRequestData?> getRequestForCompletion(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    final request = _byId[requestId];
    if (request == null) return null;

    final loginChallenge = request.loginChallengeId == null
        ? null
        : await SecretChallenge.db.findById(
            session,
            request.loginChallengeId!,
            transaction: transaction,
          );

    return PasswordlessLoginRequestData(
      id: request.id,
      createdAt: request.createdAt,
      serializedHandle: request.serializedHandle,
      challenge: null,
      loginChallengeId: request.loginChallengeId,
      loginChallenge: loginChallenge,
    );
  }

  @override
  Future<bool> linkCompletionChallengeAtomically(
    final Session session, {
    required final UuidValue requestId,
    required final UuidValue completionChallengeId,
    required final Transaction? transaction,
  }) async {
    final override = onLinkCompletionChallengeAtomically;
    if (override != null) {
      return await override(
        session,
        requestId: requestId,
        completionChallengeId: completionChallengeId,
        transaction: transaction,
      );
    }

    final request = _byId[requestId];
    if (request == null || request.loginChallengeId != null) {
      return false;
    }
    request.loginChallengeId = completionChallengeId;
    return true;
  }

  @override
  Future<bool> deleteById(
    final Session session, {
    required final UuidValue requestId,
    final Transaction? transaction,
  }) async {
    final override = onDeleteById;
    if (override != null) {
      return await override(
        session,
        requestId: requestId,
        transaction: transaction,
      );
    }

    final request = _byId.remove(requestId);
    if (request == null) return false;
    _idBySerializedHandle.remove(request.serializedHandle);
    return true;
  }
}

PasswordlessLoginRequestStore _defaultLoginRequestStore() =>
    const GenericPasswordlessLoginRequestStore();

final class _InMemoryPasswordlessLoginRequest {
  final UuidValue id;
  DateTime createdAt;
  final String serializedHandle;
  final UuidValue challengeId;
  UuidValue? loginChallengeId;

  _InMemoryPasswordlessLoginRequest({
    required this.id,
    required this.createdAt,
    required this.serializedHandle,
    required this.challengeId,
  });
}

final class _TestHandle {
  final String value;

  const _TestHandle(this.value);
}

final class _UnsupportedHandle {
  const _UnsupportedHandle();
}
