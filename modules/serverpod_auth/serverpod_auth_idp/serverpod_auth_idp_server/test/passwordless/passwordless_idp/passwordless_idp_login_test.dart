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
      late PasswordlessIdpTestFixture fixture;
      late Map<String, UuidValue> nonceToUserId;

      const handle = 'test-handle';
      late String verificationCode;
      late UuidValue deliveredRequestId;
      late String deliveredVerificationCode;

      Future<void> initializeFixture({
        final PasswordlessLoginRequestStore<String>? requestStore,
        final Duration loginVerificationCodeLifetime = const Duration(
          minutes: 10,
        ),
      }) async {
        nonceToUserId = {};
        verificationCode = const Uuid().v4().toString();

        fixture = PasswordlessIdpTestFixture(
          config: PasswordlessIdpConfig(
            secretHashPepper: 'pepper',
            loginRequestStore: requestStore ?? _defaultLoginRequestStore(),
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
                  required final String nonce,
                  required final Transaction? transaction,
                }) async {
                  final authUserId = nonceToUserId[nonce];
                  if (authUserId == null) {
                    throw PasswordlessLoginNotFoundException();
                  }
                  return authUserId;
                },
          ),
        );

        final authUser = await fixture.authUsers.create(session);
        nonceToUserId[handle] = authUser.id;
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

          final authUserId = nonceToUserId[handle]!;
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

          final authUserId = nonceToUserId[handle]!;
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

            nonceToUserId.remove(handle);
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

      group('Given a custom store with empty encoded nonce', () {
        setUp(() async {
          session = sessionBuilder.build();
          await initializeFixture(
            requestStore: GenericPasswordlessLoginRequestStore<String>(
              domain: 'passwordless',
              source: 'login',
              encodeNonce: (final nonce) => '',
              decodeNonce: (final nonce) => nonce,
            ),
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

      group('Given generic stores with shared nonce and different sources', () {
        late SecretChallenge challenge;
        late GenericPasswordlessLoginRequestStore<String> sourceAStore;
        late GenericPasswordlessLoginRequestStore<String> sourceBStore;

        setUp(() async {
          session = sessionBuilder.build();
          sourceAStore = GenericPasswordlessLoginRequestStore<String>(
            domain: 'passwordless',
            source: 'source_a',
            encodeNonce: (final nonce) => nonce,
            decodeNonce: (final nonce) => nonce,
          );
          sourceBStore = GenericPasswordlessLoginRequestStore<String>(
            domain: 'passwordless',
            source: 'source_b',
            encodeNonce: (final nonce) => nonce,
            decodeNonce: (final nonce) => nonce,
          );
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
          'when requests are created with the same nonce in different sources then they do not conflict',
          () async {
            final requestA = await session.db.transaction((final transaction) {
              return sourceAStore.createRequest(
                session,
                nonce: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });
            final requestB = await session.db.transaction((final transaction) {
              return sourceBStore.createRequest(
                session,
                nonce: handle,
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
            expect(rowA!.nonce, isNot(equals(rowB!.nonce)));
            expect(rowA.nonce.startsWith('passwordless::source_a::'), isTrue);
            expect(rowB.nonce.startsWith('passwordless::source_b::'), isTrue);
          },
        );

        test(
          'when request is loaded from a namespaced nonce then it round-trips to original nonce',
          () async {
            final requestId = await session.db.transaction((final transaction) {
              return sourceAStore.createRequest(
                session,
                nonce: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });

            final request = await sourceAStore.getRequestForVerification(
              session,
              requestId: requestId,
              transaction: null,
            );

            expect(request, isNotNull);
            expect(request!.nonce, equals(handle));
          },
        );

        test(
          'when stored nonce format is invalid then loading request throws PasswordlessLoginInvalidException',
          () async {
            final malformedRow = await GenericPasswordlessLoginRequest.db
                .insertRow(
                  session,
                  GenericPasswordlessLoginRequest(
                    nonce: 'invalid-format',
                    challengeId: challenge.id!,
                  ),
                );

            final result = sourceAStore.getRequestForVerification(
              session,
              requestId: malformedRow.id!,
              transaction: null,
            );

            await expectLater(
              result,
              throwsA(isA<PasswordlessLoginInvalidException>()),
            );
          },
        );

        test(
          'when stored nonce has invalid base64 payload then loading request throws PasswordlessLoginInvalidException',
          () async {
            final malformedRow = await GenericPasswordlessLoginRequest.db
                .insertRow(
                  session,
                  GenericPasswordlessLoginRequest(
                    nonce: 'passwordless::source_a::%invalid%',
                    challengeId: challenge.id!,
                  ),
                );

            final result = sourceAStore.getRequestForVerification(
              session,
              requestId: malformedRow.id!,
              transaction: null,
            );

            await expectLater(
              result,
              throwsA(isA<PasswordlessLoginInvalidException>()),
            );
          },
        );

        test(
          'when request source does not match store source then loading request throws PasswordlessLoginInvalidException',
          () async {
            final requestId = await session.db.transaction((final transaction) {
              return sourceBStore.createRequest(
                session,
                nonce: handle,
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

        test(
          'when request domain does not match store domain then loading request throws PasswordlessLoginInvalidException',
          () async {
            final requestId = await session.db.transaction((final transaction) {
              return sourceAStore.createRequest(
                session,
                nonce: handle,
                challengeId: challenge.id!,
                transaction: transaction,
              );
            });

            final differentDomainStore =
                GenericPasswordlessLoginRequestStore<String>(
                  domain: 'another_domain',
                  source: 'source_a',
                  encodeNonce: (final nonce) => nonce,
                  decodeNonce: (final nonce) => nonce,
                );

            final result = differentDomainStore.getRequestForVerification(
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
    },
  );

  group('Passwordless configuration validation', () {
    test(
      'when TNonce is non-string and buildNonce is not provided then PasswordlessIdpConfig throws ArgumentError',
      () {
        expect(
          () => PasswordlessIdpConfig<int>(
            secretHashPepper: 'pepper',
            loginRequestStore: GenericPasswordlessLoginRequestStore<int>(
              domain: 'passwordless',
              source: 'login',
              encodeNonce: (final nonce) => nonce.toString(),
              decodeNonce: int.parse,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when GenericPasswordlessLoginRequestStore domain is empty then it throws ArgumentError',
      () {
        expect(
          () => GenericPasswordlessLoginRequestStore<String>(
            domain: '  ',
            source: 'login',
            encodeNonce: (final nonce) => nonce,
            decodeNonce: (final nonce) => nonce,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when GenericPasswordlessLoginRequestStore domain contains namespace separator then it throws ArgumentError',
      () {
        expect(
          () => GenericPasswordlessLoginRequestStore<String>(
            domain: 'domain::invalid',
            source: 'login',
            encodeNonce: (final nonce) => nonce,
            decodeNonce: (final nonce) => nonce,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when GenericPasswordlessLoginRequestStore source is empty then it throws ArgumentError',
      () {
        expect(
          () => GenericPasswordlessLoginRequestStore<String>(
            domain: 'passwordless',
            source: '  ',
            encodeNonce: (final nonce) => nonce,
            decodeNonce: (final nonce) => nonce,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when GenericPasswordlessLoginRequestStore source contains namespace separator then it throws ArgumentError',
      () {
        expect(
          () => GenericPasswordlessLoginRequestStore<String>(
            domain: 'passwordless',
            source: 'source::invalid',
            encodeNonce: (final nonce) => nonce,
            decodeNonce: (final nonce) => nonce,
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}

final class _InMemoryPasswordlessLoginRequestStore
    implements PasswordlessLoginRequestStore<String> {
  final Map<UuidValue, _InMemoryPasswordlessLoginRequest> _byId = {};
  final Map<String, UuidValue> _idByNonce = {};

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
  Future<void> deleteByNonce(
    final Session session, {
    required final String nonce,
    required final Transaction transaction,
  }) async {
    final requestId = _idByNonce.remove(nonce);
    if (requestId == null) return;
    _byId.remove(requestId);
  }

  @override
  Future<UuidValue> createRequest(
    final Session session, {
    required final String nonce,
    required final UuidValue challengeId,
    required final Transaction transaction,
  }) async {
    final requestId = UuidValue.withValidation(const Uuid().v4());
    final request = _InMemoryPasswordlessLoginRequest(
      id: requestId,
      createdAt: DateTime.now(),
      nonce: nonce,
      challengeId: challengeId,
    );
    _idByNonce[nonce] = requestId;
    _byId[requestId] = request;
    return requestId;
  }

  @override
  Future<PasswordlessLoginRequestData<String>?> getRequestForVerification(
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
      nonce: request.nonce,
      challenge: challenge,
      loginChallengeId: request.loginChallengeId,
      loginChallenge: loginChallenge,
    );
  }

  @override
  Future<PasswordlessLoginRequestData<String>?> getRequestForCompletion(
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
      nonce: request.nonce,
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
    _idByNonce.remove(request.nonce);
    return true;
  }
}

PasswordlessLoginRequestStore<String> _defaultLoginRequestStore({
  final String source = 'login',
}) {
  return GenericPasswordlessLoginRequestStore<String>(
    domain: 'passwordless',
    source: source,
    encodeNonce: (final nonce) => nonce,
    decodeNonce: (final nonce) => nonce,
  );
}

final class _InMemoryPasswordlessLoginRequest {
  final UuidValue id;
  DateTime createdAt;
  final String nonce;
  final UuidValue challengeId;
  UuidValue? loginChallengeId;

  _InMemoryPasswordlessLoginRequest({
    required this.id,
    required this.createdAt,
    required this.nonce,
    required this.challengeId,
  });
}
