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
    'Given passwordless login is configured',
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
        final PasswordlessLoginRequestStore? requestStore,
        final Duration loginVerificationCodeLifetime = const Duration(
          minutes: 10,
        ),
      }) async {
        nonceToUserId = {};
        verificationCode = const Uuid().v4().toString();

        fixture = PasswordlessIdpTestFixture(
          config: PasswordlessIdpConfig(
            secretHashPepper: 'pepper',
            loginRequestStore: requestStore,
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

      setUp(() async {
        session = sessionBuilder.build();
        await initializeFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test('when startLogin is called then it returns a request id', () async {
        final requestId = await fixture.passwordlessIdp.startLogin(
          session,
          handle: handle,
        );

        expect(requestId, isA<UuidValue>());
        expect(deliveredRequestId, equals(requestId));
        expect(deliveredVerificationCode, equals(verificationCode));
      });

      test(
        'when startLogin is called twice for same handle then previous request is replaced',
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

      test(
        'when startLogin is called too many times then it throws PasswordlessLoginException with reason "tooManyAttempts"',
        () async {
          for (var i = 0; i < 5; i++) {
            await fixture.passwordlessIdp.startLogin(session, handle: handle);
          }

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
        'when login is completed then it returns AuthSuccess',
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

          expect(result, isA<AuthSuccess>());
        },
      );

      test(
        'when finishLogin is called concurrently with same token then only one succeeds',
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

      test(
        'when custom login request store is configured then flow works without default request table rows',
        () async {
          final customStore = _InMemoryPasswordlessLoginRequestStore();
          await initializeFixture(requestStore: customStore);

          final requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );
          final defaultRequest = await PasswordlessLoginRequest.db.findById(
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

      test(
        'when custom store cannot atomically link completion challenge then verifyLoginCode returns invalid reason',
        () async {
          final customStore = _InMemoryPasswordlessLoginRequestStore(
            failAtomicLink: true,
          );
          await initializeFixture(requestStore: customStore);

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
          expect(customStore.hasRequest(requestId), isTrue);
        },
      );

      test(
        'when custom store returns missing verification challenge then verifyLoginCode returns invalid reason instead of server error',
        () async {
          final customStore = _InMemoryPasswordlessLoginRequestStore(
            returnMissingVerificationChallenge: true,
          );
          await initializeFixture(requestStore: customStore);

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

      test(
        'when custom store request is expired then verifyLoginCode returns expired reason and request is cleaned up',
        () async {
          final customStore = _InMemoryPasswordlessLoginRequestStore();
          await initializeFixture(
            requestStore: customStore,
            loginVerificationCodeLifetime: const Duration(minutes: 1),
          );

          final requestId = await fixture.passwordlessIdp.startLogin(
            session,
            handle: handle,
          );

          customStore.setCreatedAt(
            requestId,
            DateTime.now().subtract(const Duration(minutes: 2)),
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
                PasswordlessLoginExceptionReason.expired,
              ),
            ),
          );

          expect(customStore.hasRequest(requestId), isFalse);
        },
      );
    },
  );
}

final class _InMemoryPasswordlessLoginRequestStore
    implements PasswordlessLoginRequestStore {
  final bool failAtomicLink;
  final bool returnMissingVerificationChallenge;
  final Map<UuidValue, _InMemoryPasswordlessLoginRequest> _byId = {};
  final Map<String, UuidValue> _idByNonce = {};

  _InMemoryPasswordlessLoginRequestStore({
    this.failAtomicLink = false,
    this.returnMissingVerificationChallenge = false,
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
  Future<PasswordlessLoginRequestData?> getRequestForVerification(
    final Session session, {
    required final UuidValue requestId,
    required final Transaction? transaction,
  }) async {
    final request = _byId[requestId];
    if (request == null) return null;

    final challenge = returnMissingVerificationChallenge
        ? null
        : await SecretChallenge.db.findById(
            session,
            request.challengeId,
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
    if (failAtomicLink) {
      return false;
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
    final request = _byId.remove(requestId);
    if (request == null) return false;
    _idByNonce.remove(request.nonce);
    return true;
  }
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
