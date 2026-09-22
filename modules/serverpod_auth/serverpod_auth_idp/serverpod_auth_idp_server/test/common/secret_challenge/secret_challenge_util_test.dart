import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

const _verificationCode = '123456';

void main() {
  late Session session;

  final hashUtil = _createTestHashUtil();

  withServerpod(
    '[SecretChallengeUtil]',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      setUpAll(() {
        session = sessionBuilder.build();
      });

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

      group('Given a plaintext verification code, ', () {
        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when creating a challenge, ', () {
          late SecretChallenge challenge;
          late SecretChallenge? persisted;
          late bool verificationCodeMatchesHash;

          setUpAll(() async {
            challenge = await session.db.transaction(
              (final transaction) => challengeUtil.createChallenge(
                session,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            persisted = await SecretChallenge.db.findById(
              session,
              challenge.id!,
            );

            verificationCodeMatchesHash = await hashUtil.validateHashFromString(
              secret: _verificationCode,
              hashString: persisted!.challengeCodeHash,
            );
          });

          test(
            'then it stores a hash that validates the verification code.',
            () async {
              expect(persisted!.challengeCodeHash, isNot(_verificationCode));

              expect(verificationCodeMatchesHash, isTrue);
            },
          );
        });
      });

      group('Given a valid challenge request, ', () {
        late _TestChallengeRequest request;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when verifying the request, ', () {
          setUpAll(() async {
            await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );
          });

          test(
            'then it links a completion challenge to the request.',
            () async {
              expect(request.completionChallenge, isNotNull);
            },
          );
        });
      });

      group('Given a valid challenge request, ', () {
        late _TestChallengeRequest request;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group(
          'when verifying the request and completing it with the returned token, ',
          () {
            late String completionToken;
            late Future<_TestChallengeRequest> result;
            late _TestChallengeRequest completedRequest;

            setUpAll(() async {
              completionToken = await session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );

              result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );
              completedRequest = await result;
            });

            test('then it returns the request.', () async {
              expect(completedRequest, same(request));
            });
          },
        );
      });

      group('Given a valid challenge request, ', () {
        late _TestChallengeRequest request;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group(
          'when verifying the request and completing it twice with the same token, ',
          () {
            late String completionToken;
            late _TestChallengeRequest completedRequest;
            late _TestChallengeRequest completedRequest2;

            setUpAll(() async {
              completionToken = await session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );

              Future<_TestChallengeRequest> complete() =>
                  session.db.transaction(
                    (final transaction) => challengeUtil.completeChallenge(
                      session,
                      completionToken: completionToken,
                      transaction: transaction,
                    ),
                  );

              completedRequest = await complete();

              completedRequest2 = await complete();
            });

            test('then it returns the request both times.', () async {
              expect(completedRequest, same(request));

              expect(completedRequest2, same(request));
            });
          },
        );
      });

      group('Given a challenge request and an invalid verification code, ', () {
        late _TestChallengeRequest request;
        late String invalidVerificationCode;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );

          invalidVerificationCode = 'invalid-code';
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when verifying the request, ', () {
          late Future<String> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: invalidVerificationCode,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then it throws an invalid verification code exception.',
            () async {
              expect(error, isA<ChallengeInvalidVerificationCodeException>());

              expect(request.completionChallenge, isNull);
            },
          );
        });
      });

      group(
        'Given an expired challenge request and a valid verification code, ',
        () {
          late _TestChallengeRequest request;
          late String validVerificationCode;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

            validVerificationCode = _verificationCode;

            request = await createRequest(
              verificationCode: _verificationCode,
              isAlreadyUsed: false,
              lifetime: const Duration(minutes: -1),
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying the request, ', () {
            late Future<String> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: validVerificationCode,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then it records the expiration and throws an expired exception.',
              () async {
                expect(error, isA<ChallengeExpiredException>());

                expect(expiredRequestIds, [request.id]);

                expect(request.completionChallenge, isNull);
              },
            );
          });
        },
      );

      group('Given an already used challenge request, ', () {
        late _TestChallengeRequest request;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: true,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when verifying the request, ', () {
          late Future<String> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test('then it throws an already used exception.', () async {
            expect(error, isA<ChallengeAlreadyUsedException>());
          });
        });
      });

      group('Given no matching challenge request, ', () {
        late UuidValue unknownRequestId;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          unknownRequestId = const Uuid().v4obj();
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when verifying the request, ', () {
          late Future<String> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: unknownRequestId,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test('then it throws a request not found exception.', () async {
            expect(error, isA<ChallengeRequestNotFoundException>());
          });
        });
      });

      group(
        'Given a challenge request after the verification rate limit is exceeded, ',
        () {
          late _TestChallengeRequest request;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

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

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying the request, ', () {
            late Future<String> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test('then it throws a rate limit exception.', () async {
              expect(error, isA<ChallengeRateLimitExceededException>());

              expect(
                await verificationRateLimiter.countAttempts(
                  session,
                  key: request.id.uuid,
                ),
                1,
              );
            });
          });
        },
      );

      group('Given an invalid completion token, ', () {
        late String invalidCompletionToken;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          invalidCompletionToken = 'not-base64';
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when completing a challenge, ', () {
          late Future<_TestChallengeRequest> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: invalidCompletionToken,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then it throws an invalid completion token exception.',
            () async {
              expect(error, isA<ChallengeInvalidCompletionTokenException>());
            },
          );
        });
      });

      group(
        'Given a challenge request without a linked completion challenge, ',
        () {
          late _TestChallengeRequest request;
          late String completionToken;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

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

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when completing the request, ', () {
            late Future<_TestChallengeRequest> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test('then it throws a not verified exception.', () async {
              expect(error, isA<ChallengeNotVerifiedException>());
            });
          });
        },
      );

      group(
        'Given a verified challenge request and a different completion token, ',
        () {
          late _TestChallengeRequest request;
          late String differentCompletionToken;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

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

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when completing the request, ', () {
            late Future<_TestChallengeRequest> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: differentCompletionToken,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then it throws an invalid verification code exception.',
              () async {
                expect(error, isA<ChallengeInvalidVerificationCodeException>());
              },
            );
          });
        },
      );

      group('Given an expired verified challenge request, ', () {
        late _TestChallengeRequest request;
        late String completionToken;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

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

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when completing the request, ', () {
          late Future<_TestChallengeRequest> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then it records the expiration and throws an expired exception.',
            () async {
              expect(error, isA<ChallengeExpiredException>());

              expect(expiredRequestIds, [request.id]);
            },
          );
        });
      });

      group(
        'Given a verified challenge request after the completion rate limit is exceeded, ',
        () {
          late _TestChallengeRequest request;
          late String completionToken;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

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

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when completing the request, ', () {
            late Future<_TestChallengeRequest> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test('then it throws a rate limit exception.', () async {
              expect(error, isA<ChallengeRateLimitExceededException>());

              expect(
                await completionRateLimiter.countAttempts(
                  session,
                  key: request.id.uuid,
                ),
                1,
              );
            });
          });
        },
      );

      group('Given a challenge util without rate limiters, ', () {
        late _TestChallengeRequest request;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          challengeUtil = buildChallengeUtil();

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group(
          'when verifying the request and completing it with the returned token, ',
          () {
            late String completionToken;
            late Future<_TestChallengeRequest> result;
            late _TestChallengeRequest completedRequest;

            setUpAll(() async {
              completionToken = await session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );

              result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );
              completedRequest = await result;
            });

            test('then the request is returned.', () async {
              expect(completedRequest, same(request));
            });
          },
        );
      });

      group(
        'Given an expired challenge request and an invalid verification code, ',
        () {
          late _TestChallengeRequest request;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

            request = await createRequest(
              verificationCode: _verificationCode,
              isAlreadyUsed: false,
              lifetime: const Duration(minutes: -1),
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying the request, ', () {
            late Future<String> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: 'invalid-code',
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then it throws an invalid verification code exception without recording the expiration.',
              () async {
                expect(error, isA<ChallengeInvalidVerificationCodeException>());

                expect(expiredRequestIds, isEmpty);
              },
            );
          });
        },
      );

      group(
        'Given an expired verified challenge request and a different completion token, ',
        () {
          late _TestChallengeRequest request;
          late String differentCompletionToken;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

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

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when completing the request, ', () {
            late Future<_TestChallengeRequest> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: differentCompletionToken,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then it throws an invalid verification code exception without recording the expiration.',
              () async {
                expect(error, isA<ChallengeInvalidVerificationCodeException>());

                expect(expiredRequestIds, isEmpty);
              },
            );
          });
        },
      );

      group('Given a completion token without a code separator, ', () {
        late String completionToken;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          completionToken = base64Encode(utf8.encode('missing-separator'));
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when completing a challenge, ', () {
          late Future<_TestChallengeRequest> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then it throws an invalid completion token exception.',
            () async {
              expect(error, isA<ChallengeInvalidCompletionTokenException>());
            },
          );
        });
      });

      group(
        'Given a completion token with an invalid request identifier, ',
        () {
          late String completionToken;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

            completionToken = base64Encode(
              utf8.encode('not-a-uuid:some-code'),
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when completing a challenge, ', () {
            late Future<_TestChallengeRequest> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: completionToken,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then it throws an invalid completion token exception.',
              () async {
                expect(error, isA<ChallengeInvalidCompletionTokenException>());
              },
            );
          });
        },
      );

      group('Given a completion token for an unknown challenge request, ', () {
        late String completionToken;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          completionToken = _completionTokenFor(
            const Uuid().v4obj(),
            verificationCode: 'some-code',
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when completing a challenge, ', () {
          late Future<_TestChallengeRequest> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test('then it throws a request not found exception.', () async {
            expect(error, isA<ChallengeRequestNotFoundException>());
          });
        });
      });

      group('Given a completion token with more than one code separator, ', () {
        late String completionToken;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          completionToken = base64Encode(
            utf8.encode('${const Uuid().v4obj()}:some:code'),
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when completing a challenge, ', () {
          late Future<_TestChallengeRequest> result;
          Object? error;

          setUpAll(() async {
            result = session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );
            try {
              await result;
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then it throws an invalid completion token exception.',
            () async {
              expect(error, isA<ChallengeInvalidCompletionTokenException>());
            },
          );
        });
      });

      group(
        'Given a request whose completion-link callback rejects concurrent use, ',
        () {
          late _TestChallengeRequest request;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

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

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying the request, ', () {
            late Future<String> result;
            Object? error;

            setUpAll(() async {
              result = session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );
              try {
                await result;
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test('then it throws an already used exception.', () async {
              expect(error, isA<ChallengeAlreadyUsedException>());
            });
          });
        },
      );

      group(
        'Given a plaintext code and a caller transaction that will roll back, ',
        () {
          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when creating a challenge in that transaction, ', () {
            Object? error;

            setUpAll(() async {
              try {
                await session.db.transaction((final transaction) async {
                  await challengeUtil.createChallenge(
                    session,
                    verificationCode: _verificationCode,
                    transaction: transaction,
                  );

                  throw _ExpectedRollbackException();
                });
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test('then no challenge is persisted.', () async {
              expect(error, isA<_ExpectedRollbackException>());

              expect(await SecretChallenge.db.count(session), 0);
            });
          });
        },
      );

      group(
        'Given a valid request with verification rate limiting enabled, ',
        () {
          late DatabaseRateLimiter limiter;
          late _TestChallengeRequest request;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
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

            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying its code, ', () {
            late List<RateLimitedRequestAttempt> attempts;

            setUpAll(() async {
              await session.db.transaction(
                (final transaction) => challengeUtil.verifyChallenge(
                  session,
                  requestId: request.id,
                  verificationCode: _verificationCode,
                  transaction: transaction,
                ),
              );

              attempts = await RateLimitedRequestAttempt.db.find(
                session,
                where: (final t) =>
                    t.domain.equals('secret_challenge_util_test'),
              );
            });

            test(
              'then the persisted attempt uses the plain UUID string.',
              () async {
                expect(attempts.single.key, request.id.uuid);
              },
            );
          });
        },
      );

      group(
        'Given a verified request with completion rate limiting enabled, ',
        () {
          late DatabaseRateLimiter limiter;
          late _TestChallengeRequest request;
          late String token;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
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

            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );

            token = await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when completing it with the correct token, ', () {
            late List<RateLimitedRequestAttempt> attempts;

            setUpAll(() async {
              await session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: token,
                  transaction: transaction,
                ),
              );

              attempts = await RateLimitedRequestAttempt.db.find(
                session,
                where: (final t) =>
                    t.domain.equals('secret_challenge_util_test'),
              );
            });

            test(
              'then the persisted attempt uses the plain UUID string.',
              () async {
                expect(attempts.single.key, request.id.uuid);
              },
            );
          });
        },
      );

      group('Given a valid request allowing one verification attempt, ', () {
        late DatabaseRateLimiter limiter;
        late _TestChallengeRequest request;

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
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

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group(
          'when an incorrect code rolls back and the correct code is submitted, ',
          () {
            Object? error;
            Object? error2;

            setUpAll(() async {
              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.verifyChallenge(
                    session,
                    requestId: request.id,
                    verificationCode: 'wrong',
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error = caughtError;
              }

              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.verifyChallenge(
                    session,
                    requestId: request.id,
                    verificationCode: _verificationCode,
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error2 = caughtError;
              }
            });

            test(
              'then the failed attempt still exhausts the verification budget.',
              () async {
                expect(error, isA<ChallengeInvalidVerificationCodeException>());

                expect(error2, isA<ChallengeRateLimitExceededException>());
              },
            );
          },
        );
      });

      group('Given a verified request allowing one completion attempt, ', () {
        late DatabaseRateLimiter limiter;
        late _TestChallengeRequest request;
        late String token;
        late String wrongToken;

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
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

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );

          token = await session.db.transaction(
            (final transaction) => challengeUtil.verifyChallenge(
              session,
              requestId: request.id,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );

          wrongToken = _completionTokenFor(
            request.id,
            verificationCode: 'wrong',
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group(
          'when an incorrect token rolls back and the correct token is submitted, ',
          () {
            Object? error;
            Object? error2;

            setUpAll(() async {
              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.completeChallenge(
                    session,
                    completionToken: wrongToken,
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error = caughtError;
              }

              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.completeChallenge(
                    session,
                    completionToken: token,
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error2 = caughtError;
              }
            });

            test(
              'then the failed attempt still exhausts the completion budget.',
              () async {
                expect(error, isA<ChallengeInvalidVerificationCodeException>());

                expect(error2, isA<ChallengeRateLimitExceededException>());
              },
            );
          },
        );
      });

      group('Given a valid challenge request, ', () {
        late _TestChallengeRequest request;

        setUpAll(() async {
          arrangeChallengeUtil(
            verificationRateLimiter: null,
            completionRateLimiter: null,
          );

          request = await createRequest(
            verificationCode: _verificationCode,
            lifetime: const Duration(hours: 1),
            isAlreadyUsed: false,
          );
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when verifying its code, ', () {
          late String token;
          late List<String> parts;
          late SecretChallenge? persisted;

          setUpAll(() async {
            token = await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            parts = utf8.decode(base64Decode(token)).split(':');

            persisted = await SecretChallenge.db.findById(
              session,
              request.completionChallenge!.id!,
            );
          });

          test(
            'then the returned token identifies the request and validates against the persisted completion hash.',
            () async {
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
        });
      });

      group(
        'Given a valid request whose completion-link callback rejects concurrent use, ',
        () {
          late _TestChallengeRequest request;

          setUpAll(() async {
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

            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying the code, ', () {
            Object? error;
            late List<SecretChallenge> challenges;

            setUpAll(() async {
              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.verifyChallenge(
                    session,
                    requestId: request.id,
                    verificationCode: _verificationCode,
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error = caughtError;
              }

              challenges = await SecretChallenge.db.find(session);
            });

            test(
              'then the newly created completion challenge rolls back.',
              () async {
                expect(error, isA<ChallengeAlreadyUsedException>());

                expect(challenges.map((final challenge) => challenge.id), [
                  request.verificationChallenge.id,
                ]);
              },
            );
          });
        },
      );

      group(
        'Given a valid request with separate one-attempt verification and completion budgets, ',
        () {
          late DatabaseRateLimiter verificationLimiter;
          late DatabaseRateLimiter completionLimiter;
          late _TestChallengeRequest request;

          setUpAll(() async {
            verificationLimiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: 'secret_challenge_util_test',
                source: 'verification',
                maxAttempts: 1,
              ),
            );

            completionLimiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: 'secret_challenge_util_test',
                source: 'completion',
                maxAttempts: 1,
              ),
            );

            arrangeChallengeUtil(
              verificationRateLimiter: verificationLimiter,
              completionRateLimiter: completionLimiter,
            );

            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: false,
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group(
            'when verifying its code and completing it with the returned token, ',
            () {
              late String token;
              late _TestChallengeRequest result;

              setUpAll(() async {
                token = await session.db.transaction(
                  (final transaction) => challengeUtil.verifyChallenge(
                    session,
                    requestId: request.id,
                    verificationCode: _verificationCode,
                    transaction: transaction,
                  ),
                );

                result = await session.db.transaction(
                  (final transaction) => challengeUtil.completeChallenge(
                    session,
                    completionToken: token,
                    transaction: transaction,
                  ),
                );
              });

              test(
                'then both phases succeed and each consumes only its own budget.',
                () async {
                  expect(result, same(request));

                  expect(
                    await verificationLimiter.countAttempts(
                      session,
                      key: request.id.uuid,
                    ),
                    1,
                  );
                  expect(
                    await completionLimiter.countAttempts(
                      session,
                      key: request.id.uuid,
                    ),
                    1,
                  );
                },
              );
            },
          );
        },
      );

      group(
        'Given an unknown request with a one-attempt verification budget, ',
        () {
          late DatabaseRateLimiter limiter;
          late UuidValue requestId;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
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

            requestId = const Uuid().v4obj();
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group(
            'when a not-found verification rolls back and verification is retried, ',
            () {
              Object? error;
              Object? error2;

              setUpAll(() async {
                try {
                  await session.db.transaction(
                    (final transaction) => challengeUtil.verifyChallenge(
                      session,
                      requestId: requestId,
                      verificationCode: _verificationCode,
                      transaction: transaction,
                    ),
                  );
                } catch (caughtError) {
                  error = caughtError;
                }

                try {
                  await session.db.transaction(
                    (final transaction) => challengeUtil.verifyChallenge(
                      session,
                      requestId: requestId,
                      verificationCode: _verificationCode,
                      transaction: transaction,
                    ),
                  );
                } catch (caughtError) {
                  error2 = caughtError;
                }
              });

              test(
                'then the first failure still exhausts the verification budget.',
                () async {
                  expect(error, isA<ChallengeRequestNotFoundException>());

                  expect(error2, isA<ChallengeRateLimitExceededException>());

                  expect(
                    await limiter.countAttempts(session, key: requestId.uuid),
                    1,
                  );
                },
              );
            },
          );
        },
      );

      group(
        'Given a well-formed token for an unknown request with a one-attempt completion budget, ',
        () {
          late DatabaseRateLimiter limiter;
          late UuidValue requestId;
          late String token;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
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

            requestId = const Uuid().v4obj();

            token = _completionTokenFor(
              requestId,
              verificationCode: 'any-code',
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group(
            'when a not-found completion rolls back and completion is retried, ',
            () {
              Object? error;
              Object? error2;

              setUpAll(() async {
                try {
                  await session.db.transaction(
                    (final transaction) => challengeUtil.completeChallenge(
                      session,
                      completionToken: token,
                      transaction: transaction,
                    ),
                  );
                } catch (caughtError) {
                  error = caughtError;
                }

                try {
                  await session.db.transaction(
                    (final transaction) => challengeUtil.completeChallenge(
                      session,
                      completionToken: token,
                      transaction: transaction,
                    ),
                  );
                } catch (caughtError) {
                  error2 = caughtError;
                }
              });

              test(
                'then the first failure still exhausts the completion budget.',
                () async {
                  expect(error, isA<ChallengeRequestNotFoundException>());

                  expect(error2, isA<ChallengeRateLimitExceededException>());

                  expect(
                    await limiter.countAttempts(session, key: requestId.uuid),
                    1,
                  );
                },
              );
            },
          );
        },
      );

      group(
        'Given a missing request whose verification budget is exhausted, ',
        () {
          late DatabaseRateLimiter limiter;
          late UuidValue id;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
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

            id = const Uuid().v4obj();

            await limiter.tryRecordAttempt(session, key: id.uuid);
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying it, ', () {
            Object? error;

            setUpAll(() async {
              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.verifyChallenge(
                    session,
                    requestId: id,
                    verificationCode: _verificationCode,
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then rate limiting takes precedence over request lookup.',
              () async {
                expect(error, isA<ChallengeRateLimitExceededException>());
              },
            );
          });
        },
      );

      group(
        'Given a missing request whose completion budget is exhausted, ',
        () {
          late DatabaseRateLimiter limiter;
          late UuidValue id;
          late String token;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
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

            id = const Uuid().v4obj();

            await limiter.tryRecordAttempt(session, key: id.uuid);

            token = _completionTokenFor(id, verificationCode: 'any-code');
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when completing it with a well-formed token, ', () {
            Object? error;

            setUpAll(() async {
              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.completeChallenge(
                    session,
                    completionToken: token,
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then rate limiting takes precedence over request lookup.',
              () async {
                expect(error, isA<ChallengeRateLimitExceededException>());
              },
            );
          });
        },
      );

      group(
        'Given an already used request with an incorrect verification code, ',
        () {
          late _TestChallengeRequest request;

          setUpAll(() async {
            arrangeChallengeUtil(
              verificationRateLimiter: null,
              completionRateLimiter: null,
            );

            request = await createRequest(
              verificationCode: _verificationCode,
              lifetime: const Duration(hours: 1),
              isAlreadyUsed: true,
            );
          });

          tearDownAll(() async {
            await _deleteTestData(session);
          });

          group('when verifying it, ', () {
            Object? error;

            setUpAll(() async {
              try {
                await session.db.transaction(
                  (final transaction) => challengeUtil.verifyChallenge(
                    session,
                    requestId: request.id,
                    verificationCode: 'wrong',
                    transaction: transaction,
                  ),
                );
              } catch (caughtError) {
                error = caughtError;
              }
            });

            test(
              'then the already used error takes precedence over code validation.',
              () async {
                expect(error, isA<ChallengeAlreadyUsedException>());
              },
            );
          });
        },
      );

      group('Given a base64 token containing invalid UTF-8, ', () {
        late DatabaseRateLimiter limiter;
        late String token;

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
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

          token = base64Encode([0xff, 0xfe]);
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when completing a challenge, ', () {
          Object? error;

          setUpAll(() async {
            try {
              await session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: token,
                  transaction: transaction,
                ),
              );
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then it rejects the token before consuming a rate limit attempt.',
            () async {
              expect(error, isA<ChallengeInvalidCompletionTokenException>());

              expect(
                await RateLimitedRequestAttempt.db.count(
                  session,
                  where: (final t) =>
                      t.domain.equals('secret_challenge_util_test'),
                ),
                0,
              );
            },
          );
        });
      });

      group('Given an empty completion token, ', () {
        late DatabaseRateLimiter limiter;
        const token = '';

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
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
        });

        tearDownAll(() async {
          await _deleteTestData(session);
        });

        group('when completing a challenge, ', () {
          Object? error;

          setUpAll(() async {
            try {
              await session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: token,
                  transaction: transaction,
                ),
              );
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then it rejects the token before consuming a rate limit attempt.',
            () async {
              expect(error, isA<ChallengeInvalidCompletionTokenException>());

              expect(
                await RateLimitedRequestAttempt.db.count(
                  session,
                  where: (final t) =>
                      t.domain.equals('secret_challenge_util_test'),
                ),
                0,
              );
            },
          );
        });
      });
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

Future<void> _deleteTestData(final Session session) async {
  await SecretChallenge.db.deleteWhere(
    session,
    where: (final _) => Constant.bool(true),
  );

  await RateLimitedRequestAttempt.db.deleteWhere(
    session,
    where: (final t) => t.domain.equals('secret_challenge_util_test'),
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
