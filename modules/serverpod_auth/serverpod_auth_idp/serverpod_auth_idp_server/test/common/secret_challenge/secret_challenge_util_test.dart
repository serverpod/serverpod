import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

const _verificationCode = '123456';

void main() {
  late Session Function() buildSession;
  late Session session;
  final hashUtil = _createTestHashUtil();

  setUp(() async {
    session = buildSession();
    await _deleteSecretChallenges(session);
    await RateLimitedRequestAttempt.db.deleteWhere(
      session,
      where: (final t) => t.domain.equals('secret_challenge_util_test'),
    );
  });

  tearDown(() async {
    await _deleteSecretChallenges(session);
    await RateLimitedRequestAttempt.db.deleteWhere(
      session,
      where: (final t) => t.domain.equals('secret_challenge_util_test'),
    );
  });
  withServerpod(
    '[SecretChallengeUtil]',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      buildSession = sessionBuilder.build;
      late SecretChallengeUtil<_TestChallengeRequest> challengeUtil;
      late Map<String, _TestChallengeRequest> requests;
      late List<UuidValue> expiredRequestIds;
      late DatabaseRateLimiter verificationRateLimiter;
      late DatabaseRateLimiter completionRateLimiter;

      SecretChallengeUtil<_TestChallengeRequest> buildChallengeUtil({
        final RateLimiter? verificationRateLimiter,
        final RateLimiter? completionRateLimiter,
        final LinkCompletionTokenCallback<_TestChallengeRequest>?
        linkCompletionToken,
      }) {
        return SecretChallengeUtil<_TestChallengeRequest>(
          hashUtil: hashUtil,
          verificationConfig: SecretChallengeVerificationConfig(
            getRequest:
                (
                  final session,
                  final requestId, {
                  required final Transaction? transaction,
                }) async {
                  return requests[requestId.uuid];
                },
            isAlreadyUsed: (final request) => request.isAlreadyUsed,
            getChallenge: (final request) => request.verificationChallenge,
            isExpired: (final request) => request.expiresAt.isBefore(
              DateTime.now(),
            ),
            onExpired: (final session, final request) async {
              expiredRequestIds.add(request.id);
            },
            linkCompletionToken:
                linkCompletionToken ??
                (
                  final session,
                  final request,
                  final completionChallenge, {
                  required final Transaction? transaction,
                }) async {
                  request.completionChallenge = completionChallenge;
                },
            rateLimiter: verificationRateLimiter,
          ),
          completionConfig: SecretChallengeCompletionConfig(
            getRequest:
                (
                  final session,
                  final requestId, {
                  required final Transaction? transaction,
                }) async {
                  return requests[requestId.uuid];
                },
            getCompletionChallenge: (final request) {
              return request.completionChallenge;
            },
            isExpired: (final request) => request.expiresAt.isBefore(
              DateTime.now(),
            ),
            onExpired: (final session, final request) async {
              expiredRequestIds.add(request.id);
            },
            rateLimiter: completionRateLimiter,
          ),
        );
      }

      void arrangeChallengeUtil({
        required final RateLimiter? verificationRateLimiter,
        required final RateLimiter? completionRateLimiter,
      }) {
        requests = {};
        expiredRequestIds = [];
        challengeUtil = buildChallengeUtil(
          verificationRateLimiter: verificationRateLimiter,
          completionRateLimiter: completionRateLimiter,
        );
      }

      Future<_TestChallengeRequest> createRequest({
        required final String verificationCode,
        required final Duration lifetime,
        required final bool isAlreadyUsed,
      }) async {
        final verificationChallenge = await session.db.transaction(
          (final transaction) => challengeUtil.createChallenge(
            session,
            verificationCode: verificationCode,
            transaction: transaction,
          ),
        );
        final request = _TestChallengeRequest(
          id: const Uuid().v4obj(),
          verificationChallenge: verificationChallenge,
          expiresAt: DateTime.now().add(lifetime),
          isAlreadyUsed: isAlreadyUsed,
        );

        requests[request.id.uuid] = request;

        return request;
      }

      test(
        'Given a plaintext verification code, '
        'when creating a challenge, '
        'then it stores a hash that validates the verification code.',
        () async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
          final challenge = await session.db.transaction(
            (final transaction) => challengeUtil.createChallenge(
              session,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );

          final persisted = await SecretChallenge.db.findById(
            session,
            challenge.id!,
          );
          final verificationCodeMatchesHash = await hashUtil
              .validateHashFromString(
                secret: _verificationCode,
                hashString: persisted!.challengeCodeHash,
              );

          expect(persisted.challengeCodeHash, isNot(_verificationCode));
          expect(verificationCodeMatchesHash, isTrue);
        },
      );

      group('Given a valid challenge request, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late _TestChallengeRequest request;

        setUp(() async {
          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        test(
          'when verifying the request, '
          'then it links a completion challenge to the request.',
          () async {
            await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            expect(request.completionChallenge, isNotNull);
          },
        );

        test(
          'when verifying the request and completing it with the returned token, '
          'then it returns the request.',
          () async {
            final completionToken = await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            final result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );

            await expectLater(result, completion(same(request)));
          },
        );

        test(
          'when verifying the request and completing it twice with the same token, '
          'then it returns the request both times.',
          () async {
            final completionToken = await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            Future<_TestChallengeRequest> complete() => session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );

            await expectLater(complete(), completion(same(request)));
            await expectLater(complete(), completion(same(request)));
          },
        );
      });

      group('Given a challenge request and an invalid verification code, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late _TestChallengeRequest request;
        late String invalidVerificationCode;

        setUp(() async {
          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
          invalidVerificationCode = 'invalid-code';
        });

        test(
          'when verifying the request, '
          'then it throws an invalid verification code exception.',
          () async {
            final result = session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: invalidVerificationCode,
                transaction: transaction,
              ),
            );

            await expectLater(
              result,
              throwsA(isA<ChallengeInvalidVerificationCodeException>()),
            );
            expect(request.completionChallenge, isNull);
          },
        );
      });

      group(
        'Given an expired challenge request and a valid verification code, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;
          late String validVerificationCode;

          setUp(() async {
            validVerificationCode = _verificationCode;
            request = await createRequest(
              verificationCode: _verificationCode,
              isAlreadyUsed: false,
              lifetime: const Duration(minutes: -1),
            );
          });

          test(
            'when verifying the request, '
            'then it records the expiration and throws an expired exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: validVerificationCode,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeExpiredException>()),
              );
              expect(expiredRequestIds, [request.id]);
              expect(request.completionChallenge, isNull);
            },
          );
        },
      );

      group('Given an already used challenge request, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late _TestChallengeRequest request;

        setUp(() async {
          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: true,
          );
        });

        test(
          'when verifying the request, '
          'then it throws an already used exception.',
          () async {
            final result = session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            await expectLater(
              result,
              throwsA(isA<ChallengeAlreadyUsedException>()),
            );
          },
        );
      });

      group('Given no matching challenge request, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late UuidValue unknownRequestId;

        setUp(() {
          unknownRequestId = const Uuid().v4obj();
        });

        test(
          'when verifying the request, '
          'then it throws a request not found exception.',
          () async {
            final result = session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: unknownRequestId,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            await expectLater(
              result,
              throwsA(isA<ChallengeRequestNotFoundException>()),
            );
          },
        );
      });

      group(
        'Given a challenge request after the verification rate limit is exceeded, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;

          setUp(() async {
            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );
            verificationRateLimiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: 'secret_challenge_util_test',
                source: 'verification',
                maxAttempts: 1,
              ),
            );
            challengeUtil = buildChallengeUtil(
              verificationRateLimiter: verificationRateLimiter,
            );
            await verificationRateLimiter.tryRecordAttempt(
              session,
              key: request.id.uuid,
            );
          });

          test(
            'when verifying the request, '
            'then it throws a rate limit exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeRateLimitExceededException>()),
              );
              expect(
                await verificationRateLimiter.countAttempts(
                  session,
                  key: request.id.uuid,
                ),
                1,
              );
            },
          );
        },
      );

      group('Given an invalid completion token, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late String invalidCompletionToken;

        setUp(() {
          invalidCompletionToken = 'not-base64';
        });

        test(
          'when completing a challenge, '
          'then it throws an invalid completion token exception.',
          () async {
            final result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: invalidCompletionToken,
                transaction: transaction,
              ),
            );

            await expectLater(
              result,
              throwsA(isA<ChallengeInvalidCompletionTokenException>()),
            );
          },
        );
      });

      group(
        'Given a challenge request without a linked completion challenge, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;
          late String completionToken;

          setUp(() async {
            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );
            completionToken = _completionTokenFor(
              request.id,
              verificationCode: 'unlinked-token',
            );
          });

          test(
            'when completing the request, '
            'then it throws a not verified exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeNotVerifiedException>()),
              );
            },
          );
        },
      );

      group(
        'Given a verified challenge request and a different completion token, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;
          late String differentCompletionToken;

          setUp(() async {
            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );

            await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            differentCompletionToken = _completionTokenFor(
              request.id,
              verificationCode: 'different-token',
            );
          });

          test(
            'when completing the request, '
            'then it throws an invalid verification code exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: differentCompletionToken,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeInvalidVerificationCodeException>()),
              );
            },
          );
        },
      );

      group('Given an expired verified challenge request, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late _TestChallengeRequest request;
        late String completionToken;

        setUp(() async {
          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );

          completionToken = await session.db.transaction(
            (final transaction) => challengeUtil.verifyChallenge(
              session,
              requestId: request.id,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );
          request.expiresAt = DateTime.now().subtract(
            const Duration(minutes: 1),
          );
        });

        test(
          'when completing the request, '
          'then it records the expiration and throws an expired exception.',
          () async {
            final result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );

            await expectLater(
              result,
              throwsA(isA<ChallengeExpiredException>()),
            );
            expect(expiredRequestIds, [request.id]);
          },
        );
      });

      group(
        'Given a verified challenge request after the completion rate limit is exceeded, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;
          late String completionToken;

          setUp(() async {
            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );

            completionToken = await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );
            completionRateLimiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: 'secret_challenge_util_test',
                source: 'completion',
                maxAttempts: 1,
              ),
            );
            challengeUtil = buildChallengeUtil(
              completionRateLimiter: completionRateLimiter,
            );
            await completionRateLimiter.tryRecordAttempt(
              session,
              key: request.id.uuid,
            );
          });

          test(
            'when completing the request, '
            'then it throws a rate limit exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeRateLimitExceededException>()),
              );
              expect(
                await completionRateLimiter.countAttempts(
                  session,
                  key: request.id.uuid,
                ),
                1,
              );
            },
          );
        },
      );

      group('Given a challenge util without rate limiters, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late _TestChallengeRequest request;

        setUp(() async {
          challengeUtil = buildChallengeUtil();
          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        test(
          'when verifying the request and completing it with the returned token, '
          'then the request is returned.',
          () async {
            final completionToken = await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            final result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );

            await expectLater(result, completion(same(request)));
          },
        );
      });

      group(
        'Given an expired challenge request and an invalid verification code, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;

          setUp(() async {
            request = await createRequest(
              verificationCode: _verificationCode,
              isAlreadyUsed: false,
              lifetime: const Duration(minutes: -1),
            );
          });

          test(
            'when verifying the request, '
            'then it throws an invalid verification code exception without '
            'recording the expiration.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: 'invalid-code',
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeInvalidVerificationCodeException>()),
              );
              expect(expiredRequestIds, isEmpty);
            },
          );
        },
      );

      group(
        'Given an expired verified challenge request and a different completion token, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;
          late String differentCompletionToken;

          setUp(() async {
            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );

            await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            request.expiresAt = DateTime.now().subtract(
              const Duration(minutes: 1),
            );
            differentCompletionToken = _completionTokenFor(
              request.id,
              verificationCode: 'different-token',
            );
          });

          test(
            'when completing the request, '
            'then it throws an invalid verification code exception without '
            'recording the expiration.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: differentCompletionToken,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeInvalidVerificationCodeException>()),
              );
              expect(expiredRequestIds, isEmpty);
            },
          );
        },
      );

      group('Given a completion token without a code separator, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late String completionToken;

        setUp(() {
          completionToken = base64Encode(utf8.encode('missing-separator'));
        });

        test(
          'when completing a challenge, '
          'then it throws an invalid completion token exception.',
          () async {
            final result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );

            await expectLater(
              result,
              throwsA(isA<ChallengeInvalidCompletionTokenException>()),
            );
          },
        );
      });

      group(
        'Given a completion token with an invalid request identifier, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late String completionToken;

          setUp(() {
            completionToken = base64Encode(
              utf8.encode('not-a-uuid:some-code'),
            );
          });

          test(
            'when completing a challenge, '
            'then it throws an invalid completion token exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeInvalidCompletionTokenException>()),
              );
            },
          );
        },
      );

      group(
        'Given a completion token for an unknown challenge request, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late String completionToken;

          setUp(() {
            completionToken = _completionTokenFor(
              const Uuid().v4obj(),
              verificationCode: 'some-code',
            );
          });

          test(
            'when completing a challenge, '
            'then it throws a request not found exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeRequestNotFoundException>()),
              );
            },
          );
        },
      );

      group('Given a completion token with more than one code separator, ', () {
        setUp(() {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });
        late String completionToken;

        setUp(() {
          completionToken = base64Encode(
            utf8.encode('${const Uuid().v4obj()}:some:code'),
          );
        });

        test(
          'when completing a challenge, '
          'then it throws an invalid completion token exception.',
          () async {
            final result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );

            await expectLater(
              result,
              throwsA(isA<ChallengeInvalidCompletionTokenException>()),
            );
          },
        );
      });

      group(
        'Given a request whose completion-link callback rejects concurrent use, ',
        () {
          setUp(() {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });
          late _TestChallengeRequest request;

          setUp(() async {
            challengeUtil = buildChallengeUtil(
              linkCompletionToken:
                  (
                    final session,
                    final request,
                    final completionChallenge, {
                    required final Transaction? transaction,
                  }) async {
                    throw ChallengeAlreadyUsedException();
                  },
            );
            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );
          });

          test(
            'when verifying the request, '
            'then it throws an already used exception.',
            () async {
              final result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );

              await expectLater(
                result,
                throwsA(isA<ChallengeAlreadyUsedException>()),
              );
            },
          );
        },
      );

      test(
        'Given a plaintext code and a caller transaction that will roll back, '
        'when creating a challenge in that transaction, '
        'then no challenge is persisted.',
        () async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
          await expectLater(
            session.db.transaction((final transaction) async {
              await challengeUtil.createChallenge(
                session,
                verificationCode: _verificationCode,
                transaction: transaction,
              );
              throw _ExpectedRollbackException();
            }),
            throwsA(isA<_ExpectedRollbackException>()),
          );
          expect(await SecretChallenge.db.count(session), 0);
        },
      );

      test(
        'Given a valid request with verification rate limiting enabled, '
        'when verifying its code, '
        'then the persisted attempt uses the plain UUID string.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'verification',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: limiter,
            completionRateLimiter: null,
          );
          final request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
          await session.db.transaction(
            (final transaction) => challengeUtil.verifyChallenge(
              session,
              requestId: request.id,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );
          final attempts = await RateLimitedRequestAttempt.db.find(
            session,
            where: (final t) => t.domain.equals('secret_challenge_util_test'),
          );
          expect(attempts.single.key, request.id.uuid);
        },
      );

      test(
        'Given a verified request with completion rate limiting enabled, '
        'when completing it with the correct token, '
        'then the persisted attempt uses the plain UUID string.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'completion',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: limiter,
          );
          final request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
          final token = await session.db.transaction(
            (final transaction) => challengeUtil.verifyChallenge(
              session,
              requestId: request.id,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );
          await session.db.transaction(
            (final transaction) => challengeUtil.completeChallenge(
              session,
              completionToken: token,
              transaction: transaction,
            ),
          );
          final attempts = await RateLimitedRequestAttempt.db.find(
            session,
            where: (final t) => t.domain.equals('secret_challenge_util_test'),
          );
          expect(attempts.single.key, request.id.uuid);
        },
      );

      test(
        'Given a valid request allowing one verification attempt, '
        'when an incorrect code rolls back and the correct code is submitted, '
        'then the failed attempt still exhausts the verification budget.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'verification',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: limiter,
            completionRateLimiter: null,
          );
          final request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: 'wrong',
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeInvalidVerificationCodeException>()),
          );
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeRateLimitExceededException>()),
          );
        },
      );

      test(
        'Given a verified request allowing one completion attempt, '
        'when an incorrect token rolls back and the correct token is submitted, '
        'then the failed attempt still exhausts the completion budget.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'completion',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: limiter,
          );
          final request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
          final token = await session.db.transaction(
            (final transaction) => challengeUtil.verifyChallenge(
              session,
              requestId: request.id,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );
          final wrongToken = _completionTokenFor(
            request.id,
            verificationCode: 'wrong',
          );
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: wrongToken,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeInvalidVerificationCodeException>()),
          );
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: token,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeRateLimitExceededException>()),
          );
        },
      );

      test(
        'Given a valid challenge request, '
        'when verifying its code, '
        'then the returned token identifies the request and validates against the persisted completion hash.',
        () async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
          final request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
          final token = await session.db.transaction(
            (final transaction) => challengeUtil.verifyChallenge(
              session,
              requestId: request.id,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );
          final parts = utf8.decode(base64Decode(token)).split(':');
          final persisted = await SecretChallenge.db.findById(
            session,
            request.completionChallenge!.id!,
          );
          expect(parts, hasLength(2));
          expect(parts.first, request.id.uuid);
          expect(
            await hashUtil.validateHashFromString(
              secret: parts.last,
              hashString: persisted!.challengeCodeHash,
            ),
            isTrue,
          );
        },
      );

      test(
        'Given a valid request whose completion-link callback rejects concurrent use, '
        'when verifying the code, '
        'then the newly created completion challenge rolls back.',
        () async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
          challengeUtil = buildChallengeUtil(
            linkCompletionToken:
                (
                  final session,
                  final request,
                  final challenge, {
                  required final Transaction? transaction,
                }) async {
                  throw ChallengeAlreadyUsedException();
                },
          );
          final request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeAlreadyUsedException>()),
          );
          final challenges = await SecretChallenge.db.find(session);
          expect(challenges.map((final challenge) => challenge.id), [
            request.verificationChallenge.id,
          ]);
        },
      );

      test(
        'Given a missing request whose verification budget is exhausted, '
        'when verifying it, '
        'then rate limiting takes precedence over request lookup.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'verification',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: limiter,
            completionRateLimiter: null,
          );
          final id = const Uuid().v4obj();
          await limiter.tryRecordAttempt(session, key: id.uuid);
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeRateLimitExceededException>()),
          );
        },
      );

      test(
        'Given a missing request whose completion budget is exhausted, '
        'when completing it with a well-formed token, '
        'then rate limiting takes precedence over request lookup.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'completion',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: limiter,
          );
          final id = const Uuid().v4obj();
          await limiter.tryRecordAttempt(session, key: id.uuid);
          final token = _completionTokenFor(id, verificationCode: 'any-code');
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: token,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeRateLimitExceededException>()),
          );
        },
      );

      test(
        'Given an already used request with an incorrect verification code, '
        'when verifying it, '
        'then the already used error takes precedence over code validation.',
        () async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
          final request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: true,
          );
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: 'wrong',
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeAlreadyUsedException>()),
          );
        },
      );

      test(
        'Given a base64 token containing invalid UTF-8, '
        'when completing a challenge, '
        'then it rejects the token before consuming a rate limit attempt.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'completion',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: limiter,
          );
          final token = base64Encode([0xff, 0xfe]);
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: token,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeInvalidCompletionTokenException>()),
          );
          expect(
            await RateLimitedRequestAttempt.db.count(
              session,
              where: (final t) => t.domain.equals('secret_challenge_util_test'),
            ),
            0,
          );
        },
      );

      test(
        'Given an empty completion token, '
        'when completing a challenge, '
        'then it rejects the token before consuming a rate limit attempt.',
        () async {
          final limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: 'secret_challenge_util_test',
              source: 'completion',
              maxAttempts: 1,
            ),
          );
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: limiter,
          );
          const token = '';
          await expectLater(
            session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: token,
                transaction: transaction,
              ),
            ),
            throwsA(isA<ChallengeInvalidCompletionTokenException>()),
          );
          expect(
            await RateLimitedRequestAttempt.db.count(
              session,
              where: (final t) => t.domain.equals('secret_challenge_util_test'),
            ),
            0,
          );
        },
      );
    },
  );
}

Argon2HashUtil _createTestHashUtil() {
  return Argon2HashUtil(
    hashPepper: 'test-pepper',
    hashSaltLength: 8,
    parameters: Argon2HashParameters(
      memory: 32,
      iterations: 1,
      lanes: 1,
      desiredKeyLength: 16,
    ),
  );
}

Future<void> _deleteSecretChallenges(final Session session) async {
  await SecretChallenge.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );
}

String _completionTokenFor(
  final UuidValue requestId, {
  required final String verificationCode,
}) {
  return base64Encode(utf8.encode('$requestId:$verificationCode'));
}

final class _TestChallengeRequest {
  _TestChallengeRequest({
    required this.id,
    required this.verificationChallenge,
    required this.expiresAt,
    required this.isAlreadyUsed,
  });

  final UuidValue id;
  final SecretChallenge verificationChallenge;
  DateTime expiresAt;
  final bool isAlreadyUsed;
  SecretChallenge? completionChallenge;
}

final class _ExpectedRollbackException implements Exception {}
