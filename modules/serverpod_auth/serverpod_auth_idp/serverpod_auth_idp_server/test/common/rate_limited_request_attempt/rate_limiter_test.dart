import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

const _testDomain = 'rate_limit_util_test';
const _otherDomain = 'rate_limit_util_test_other_domain';
const _testSource = 'verification';
const _otherSource = 'other_source';

void main() {
  late Session Function() buildSession;
  late Session session;

  setUpAll(() {
    session = buildSession();
  });

  withServerpod(
    '[DatabaseRateLimiter]',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      buildSession = sessionBuilder.build;

      late List<String> rateLimitExceededKeys;

      group('Given a rate limiter that allows two attempts, ', () {
        late DatabaseRateLimiter rateLimitUtil;

        setUpAll(() async {
          rateLimitExceededKeys = [];

          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
              onRateLimitExceeded: (final session, final key) async {
                rateLimitExceededKeys.add(key);
              },
            ),
          );
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when checking the rate limit three times for one request, ', () {
          late List<bool> admitted;
          late int attemptCount;

          setUpAll(() async {
            admitted = [
              for (var attempt = 0; attempt < 3; attempt++)
                await rateLimitUtil.tryRecordAttempt(
                  session,
                  key: 'request',
                ),
            ];

            attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: 'request',
            );
          });

          test(
            'then it allows the first two checks and rate limits the third.',
            () async {
              expect(admitted, [true, true, false]);
            },
          );

          test('then it only records the two allowed attempts.', () async {
            expect(attemptCount, 2);
          });

          test(
            'then it reports the request to the rate limit callback.',
            () async {
              expect(rateLimitExceededKeys, ['request']);
            },
          );
        });
      });

      group('Given a rate limiter that allows two attempts, ', () {
        late DatabaseRateLimiter rateLimitUtil;

        setUpAll(() async {
          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group(
          'when six concurrent sessions check the rate limit for one request, ',
          () {
            late List<bool> admitted;
            late int attemptCount;

            setUpAll(() async {
              admitted = await Future.wait([
                for (var attempt = 0; attempt < 6; attempt++)
                  rateLimitUtil.tryRecordAttempt(
                    sessionBuilder.build(),
                    key: 'request',
                  ),
              ]);

              attemptCount = await rateLimitUtil.countAttempts(
                session,
                key: 'request',
              );
            });

            test('then it allows exactly two of the checks.', () async {
              expect(admitted.where((final limited) => limited), hasLength(2));
            });

            test('then it records exactly two attempts.', () async {
              expect(attemptCount, 2);
            });
          },
        );
      });

      group(
        'Given a rate limit check happened inside a rolled-back caller transaction, ',
        () {
          late DatabaseRateLimiter rateLimitUtil;

          setUpAll(() async {
            rateLimitUtil = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 2,
              ),
            );

            try {
              await session.db.transaction((final transaction) async {
                await rateLimitUtil.tryRecordAttempt(
                  session,
                  key: 'request',
                );

                throw _ExpectedRollbackException();
              });
            } on _ExpectedRollbackException {
              // Expected test setup rollback.
            }
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when counting attempts for the request, ', () {
            late int attemptCount;

            setUpAll(() async {
              attemptCount = await rateLimitUtil.countAttempts(
                session,
                key: 'request',
              );
            });

            test('then the recorded attempt remains counted.', () async {
              expect(attemptCount, 1);
            });
          });
        },
      );

      group(
        'Given a rate limiter that allows one attempt and has no rate limit callback, ',
        () {
          late DatabaseRateLimiter rateLimitUtil;

          setUpAll(() async {
            rateLimitUtil = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 1,
              ),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when checking the rate limit twice for one request, ', () {
            late bool admitted;

            setUpAll(() async {
              await rateLimitUtil.tryRecordAttempt(session, key: 'request');

              admitted = await rateLimitUtil.tryRecordAttempt(
                session,
                key: 'request',
              );
            });

            test(
              'then the second check reports the request as rate limited.',
              () async {
                expect(admitted, isFalse);
              },
            );
          });
        },
      );

      group(
        'Given a rate limiter with default extra data for every attempt, ',
        () {
          late DatabaseRateLimiter rateLimitUtil;

          setUpAll(() async {
            rateLimitUtil = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 2,
                defaultExtraData: const {
                  'client': 'mobile',
                  'shared': 'default',
                },
              ),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when recording an attempt with request extra data, ', () {
            late List<RateLimitedRequestAttempt> attempts;

            setUpAll(() async {
              await rateLimitUtil.tryRecordAttempt(
                session,
                key: 'request',
                extraData: const {
                  'requestId': '123',
                  'shared': 'request',
                },
              );

              attempts = await _findAttempts(session, key: 'request');
            });

            test(
              'then it stores the attempt with the request data merged over the default data.',
              () async {
                expect(attempts, hasLength(1));
                expect(attempts.single.domain, _testDomain);
                expect(attempts.single.source, _testSource);
                expect(attempts.single.key, 'request');
                expect(attempts.single.extraData, {
                  'client': 'mobile',
                  'shared': 'request',
                  'requestId': '123',
                });
              },
            );
          });
        },
      );

      group('Given a rate limiter without default extra data, ', () {
        late DatabaseRateLimiter rateLimitUtil;

        setUpAll(() async {
          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when recording an attempt without extra data, ', () {
          late List<RateLimitedRequestAttempt> attempts;

          setUpAll(() async {
            await rateLimitUtil.tryRecordAttempt(session, key: 'request');

            attempts = await _findAttempts(session, key: 'request');
          });

          test('then it stores the attempt with no extra data.', () async {
            expect(attempts, hasLength(1));
            expect(attempts.single.extraData, isNull);
          });
        });
      });

      group('Given a rate limiter for UUID request identifiers, ', () {
        late UuidValue requestId;
        late DatabaseRateLimiter rateLimitUtil;

        setUpAll(() async {
          requestId = const Uuid().v4obj();

          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when recording an attempt, ', () {
          late List<RateLimitedRequestAttempt> attempts;

          setUpAll(() async {
            await rateLimitUtil.tryRecordAttempt(session, key: requestId.uuid);

            attempts = await _findAttempts(session);
          });

          test(
            'then it stores the identifier as the caller-provided string key.',
            () async {
              expect(attempts, hasLength(1));
              expect(attempts.single.key, requestId.uuid);
            },
          );
        });
      });

      group('Given a recorded attempt for a UUID request identifier, ', () {
        late UuidValue requestId;
        late DatabaseRateLimiter rateLimitUtil;

        setUpAll(() async {
          requestId = const Uuid().v4obj();

          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );

          await rateLimitUtil.tryRecordAttempt(session, key: requestId.uuid);
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when counting attempts, ', () {
          late int attemptCount;

          setUpAll(() async {
            attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: requestId.uuid,
            );
          });

          test('then it counts the attempt by its string key.', () async {
            expect(attemptCount, 1);
          });
        });
      });

      group(
        'Given a rate limiter with a one-hour timeframe, and a request with an attempt two hours ago and an attempt now, ',
        () {
          late DateTime now;
          late DatabaseRateLimiter rateLimitUtil;

          setUp(() async {
            now = DateTime.utc(2026, 1, 1, 12);

            rateLimitUtil = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 2,
                timeframe: const Duration(hours: 1),
              ),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 2))),
              () => rateLimitUtil.tryRecordAttempt(session, key: 'request'),
            );

            await withClock(
              Clock.fixed(now),
              () => rateLimitUtil.tryRecordAttempt(session, key: 'request'),
            );
          });

          tearDown(() async {
            await _deleteTestAttempts(session);
          });

          group('when counting attempts for the request, ', () {
            late int attemptCount;

            setUp(() async {
              await withClock(Clock.fixed(now), () async {
                attemptCount = await rateLimitUtil.countAttempts(
                  session,
                  key: 'request',
                );
              });
            });

            test(
              'then it only counts the attempt inside the timeframe.',
              () async {
                expect(attemptCount, 1);
              },
            );
          });

          group(
            'when deleting attempts for the request before the window, ',
            () {
              late int deletedAttempts;
              late List<RateLimitedRequestAttempt> attempts;

              setUp(() async {
                await withClock(Clock.fixed(now), () async {
                  deletedAttempts = await rateLimitUtil.deleteAttempts(
                    session,
                    key: 'request',
                    olderThan: const Duration(hours: 1),
                  );
                });

                attempts = await _findAttempts(session, key: 'request');
              });

              test(
                'then it only deletes the attempt older than the timeframe.',
                () async {
                  expect(deletedAttempts, 1);

                  expect(attempts, hasLength(1));
                },
              );
            },
          );

          group('when deleting attempts older than two hours, ', () {
            late int deleted;
            late List<RateLimitedRequestAttempt> remaining;

            setUp(() async {
              deleted = await withClock(
                Clock.fixed(now),
                () => rateLimitUtil.deleteAttempts(
                  session,
                  key: 'request',
                  olderThan: const Duration(hours: 2),
                ),
              );

              remaining = await _findAttempts(session, key: 'request');
            });

            test(
              'then the explicit age preserves both the cutoff attempt and the recent one.',
              () {
                expect(deleted, 0);

                expect(remaining.map((final attempt) => attempt.attemptedAt), [
                  now.subtract(const Duration(hours: 2)),
                  now,
                ]);
              },
            );
          });

          group(
            'when deleting old attempts in a transaction that rolls back, ',
            () {
              late int deleted;
              late List<RateLimitedRequestAttempt> remaining;
              Object? error;

              setUp(() async {
                try {
                  await session.db.transaction((final transaction) async {
                    deleted = await withClock(
                      Clock.fixed(now),
                      () => rateLimitUtil.deleteAttempts(
                        session,
                        olderThan: const Duration(hours: 1),
                        transaction: transaction,
                      ),
                    );

                    throw _ExpectedRollbackException();
                  });
                } catch (caughtError) {
                  error = caughtError;
                }

                remaining = await _findAttempts(session, key: 'request');
              });

              test(
                'then the deletion is rolled back with the caller transaction.',
                () {
                  expect(error, isA<_ExpectedRollbackException>());

                  expect(deleted, 1);

                  expect(
                    remaining.map((final attempt) => attempt.attemptedAt),
                    [
                      now.subtract(const Duration(hours: 2)),
                      now,
                    ],
                  );
                },
              );
            },
          );
        },
      );

      group(
        'Given a request with an attempt two hours ago and an attempt now, and another request with an attempt two hours ago, ',
        () {
          late DateTime now;
          late DatabaseRateLimiter rateLimitUtil;

          setUpAll(() async {
            now = DateTime.utc(2026, 1, 1, 12);

            rateLimitUtil = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 2,
              ),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 2))),
              () async {
                await rateLimitUtil.tryRecordAttempt(session, key: 'request');

                await rateLimitUtil.tryRecordAttempt(
                  session,
                  key: 'other-request',
                );
              },
            );

            await withClock(
              Clock.fixed(now),
              () => rateLimitUtil.tryRecordAttempt(session, key: 'request'),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group(
            'when deleting attempts for the request older than one hour, ',
            () {
              late int deletedAttempts;
              late List<RateLimitedRequestAttempt> attempts;
              late List<RateLimitedRequestAttempt> otherAttempts;

              setUpAll(() async {
                await withClock(Clock.fixed(now), () async {
                  deletedAttempts = await rateLimitUtil.deleteAttempts(
                    session,
                    key: 'request',
                    olderThan: const Duration(hours: 1),
                  );
                });

                attempts = await _findAttempts(session, key: 'request');

                otherAttempts = await _findAttempts(
                  session,
                  key: 'other-request',
                );
              });

              test(
                'then it keeps the newer attempt and the other request attempt.',
                () async {
                  expect(deletedAttempts, 1);

                  expect(attempts, hasLength(1));

                  expect(otherAttempts, hasLength(1));
                },
              );
            },
          );
        },
      );

      group(
        'Given a request with an attempt two hours ago and an attempt now, and another request with an attempt two hours ago, ',
        () {
          late DateTime now;
          late DatabaseRateLimiter rateLimitUtil;

          setUpAll(() async {
            now = DateTime.utc(2026, 1, 1, 12);

            rateLimitUtil = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 2,
              ),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 2))),
              () async {
                await rateLimitUtil.tryRecordAttempt(session, key: 'request');

                await rateLimitUtil.tryRecordAttempt(
                  session,
                  key: 'other-request',
                );
              },
            );

            await withClock(
              Clock.fixed(now),
              () => rateLimitUtil.tryRecordAttempt(session, key: 'request'),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group(
            'when deleting attempts older than one hour without a key, ',
            () {
              late int deletedAttempts;
              late List<RateLimitedRequestAttempt> attempts;

              setUpAll(() async {
                await withClock(Clock.fixed(now), () async {
                  deletedAttempts = await rateLimitUtil.deleteAttempts(
                    session,
                    olderThan: const Duration(hours: 1),
                  );
                });

                attempts = await _findAttempts(session);
              });

              test(
                'then it deletes the old attempt of every request.',
                () async {
                  expect(deletedAttempts, 2);

                  expect(attempts, hasLength(1));
                  expect(attempts.single.key, 'request');
                },
              );
            },
          );
        },
      );

      group(
        'Given a rate limiter that allows two attempts within one hour, and a request that used both attempts two hours ago, ',
        () {
          late DateTime now;
          late DatabaseRateLimiter rateLimitUtil;

          setUpAll(() async {
            now = DateTime.utc(2026, 1, 1, 12);

            rateLimitExceededKeys = [];

            rateLimitUtil = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 2,
                timeframe: const Duration(hours: 1),
                onRateLimitExceeded: (final session, final key) async {
                  rateLimitExceededKeys.add(key);
                },
              ),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 2))),
              () async {
                await rateLimitUtil.tryRecordAttempt(session, key: 'request');

                await rateLimitUtil.tryRecordAttempt(session, key: 'request');
              },
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when checking the rate limit now, ', () {
            late bool admitted;

            setUpAll(() async {
              await withClock(Clock.fixed(now), () async {
                admitted = await rateLimitUtil.tryRecordAttempt(
                  session,
                  key: 'request',
                );
              });
            });

            test('then it allows the attempt.', () async {
              expect(admitted, isTrue);

              expect(rateLimitExceededKeys, isEmpty);
            });
          });
        },
      );

      group('Given a request with an attempt under two sources, ', () {
        late DateTime now;
        late DatabaseRateLimiter rateLimitUtil;

        setUp(() async {
          now = DateTime.utc(2026, 1, 1, 12);

          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );

          final otherSourceUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _otherSource,
              maxAttempts: 2,
            ),
          );

          await withClock(
            Clock.fixed(now.subtract(const Duration(minutes: 1))),
            () async {
              await rateLimitUtil.tryRecordAttempt(session, key: 'request');

              await otherSourceUtil.tryRecordAttempt(session, key: 'request');
            },
          );
        });

        tearDown(() async {
          await _deleteTestAttempts(session);
        });

        group('when counting attempts for the request, ', () {
          late int attemptCount;

          setUp(() async {
            attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: 'request',
            );
          });

          test(
            'then it does not count the attempt from the other source.',
            () async {
              expect(attemptCount, 1);
            },
          );
        });

        group('when deleting attempts for the request, ', () {
          late int deletedAttempts;
          late List<RateLimitedRequestAttempt> attempts;
          late List<RateLimitedRequestAttempt> otherSourceAttempts;

          setUp(() async {
            await withClock(Clock.fixed(now), () async {
              deletedAttempts = await rateLimitUtil.deleteAttempts(
                session,
                key: 'request',
              );
            });

            attempts = await _findAttempts(session, key: 'request');

            otherSourceAttempts = await _findAttempts(
              session,
              source: _otherSource,
              key: 'request',
            );
          });

          test('then it keeps the attempt from the other source.', () async {
            expect(deletedAttempts, 1);

            expect(attempts, isEmpty);

            expect(otherSourceAttempts, hasLength(1));
          });
        });
      });

      group('Given a request with an attempt under two domains, ', () {
        late DateTime now;
        late DatabaseRateLimiter rateLimitUtil;

        setUp(() async {
          now = DateTime.utc(2026, 1, 1, 12);

          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );

          final otherDomainUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _otherDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );

          await withClock(
            Clock.fixed(now.subtract(const Duration(minutes: 1))),
            () async {
              await rateLimitUtil.tryRecordAttempt(session, key: 'request');

              await otherDomainUtil.tryRecordAttempt(session, key: 'request');
            },
          );
        });

        tearDown(() async {
          await _deleteTestAttempts(session);
        });

        group('when counting attempts for the request, ', () {
          late int attemptCount;

          setUp(() async {
            attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: 'request',
            );
          });

          test(
            'then it does not count the attempt from the other domain.',
            () async {
              expect(attemptCount, 1);
            },
          );
        });

        group('when deleting attempts for the request, ', () {
          late int deletedAttempts;
          late List<RateLimitedRequestAttempt> attempts;
          late List<RateLimitedRequestAttempt> otherDomainAttempts;

          setUp(() async {
            await withClock(Clock.fixed(now), () async {
              deletedAttempts = await rateLimitUtil.deleteAttempts(
                session,
                key: 'request',
              );
            });

            attempts = await _findAttempts(session, key: 'request');

            otherDomainAttempts = await _findAttempts(
              session,
              domain: _otherDomain,
              key: 'request',
            );
          });

          test('then it keeps the attempt from the other domain.', () async {
            expect(deletedAttempts, 1);

            expect(attempts, isEmpty);

            expect(otherDomainAttempts, hasLength(1));
          });
        });
      });

      group(
        'Given a key with quotes, separators, whitespace, and Unicode, ',
        () {
          const key = ' "request:ação/雪" ';
          late DatabaseRateLimiter limiter;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 1,
              ),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when admitting an attempt, ', () {
            late List<RateLimitedRequestAttempt> attempts;

            setUpAll(() async {
              await limiter.tryRecordAttempt(session, key: key);

              attempts = await _findAttempts(session);
            });

            test('then it persists the exact caller-provided key.', () async {
              expect(attempts.single.key, key);
            });
          });
        },
      );

      group('Given an empty string key and a budget of one, ', () {
        late DatabaseRateLimiter limiter;

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 1,
            ),
          );
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when admitting two attempts, ', () {
          late bool first;
          late bool second;

          setUpAll(() async {
            first = await limiter.tryRecordAttempt(session, key: '');

            second = await limiter.tryRecordAttempt(session, key: '');
          });

          test('then the empty key identifies one shared bucket.', () async {
            expect([first, second], [true, false]);
          });
        });
      });

      group('Given an exhausted key and an unused key, ', () {
        late DatabaseRateLimiter limiter;

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 1,
            ),
          );

          await limiter.tryRecordAttempt(session, key: 'exhausted');
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when admitting an attempt for the unused key, ', () {
          late bool admitted;

          setUpAll(() async {
            admitted = await limiter.tryRecordAttempt(
              session,
              key: 'unused',
            );
          });

          test('then it has its own attempt budget.', () async {
            expect(admitted, isTrue);
          });
        });
      });

      group('Given an exhausted limiter whose rejection callback throws, ', () {
        late DatabaseRateLimiter limiter;

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 1,
              onRateLimitExceeded: (final session, final key) async {
                throw _ExpectedRollbackException();
              },
            ),
          );

          await limiter.tryRecordAttempt(session, key: 'request');
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when admitting another attempt, ', () {
          Object? error;

          setUpAll(() async {
            try {
              await limiter.tryRecordAttempt(session, key: 'request');
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then the callback exception propagates without consuming an attempt.',
            () async {
              expect(error, isA<_ExpectedRollbackException>());

              expect(await limiter.countAttempts(session, key: 'request'), 1);
            },
          );
        });
      });

      group(
        'Given an exhausted limiter whose rejection callback clears the bucket, ',
        () {
          late DatabaseRateLimiter limiter;

          setUpAll(() async {
            limiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 1,
                onRateLimitExceeded: (final session, final key) async {
                  await limiter.deleteAttempts(session, key: key);

                  throw _ExpectedRollbackException();
                },
              ),
            );

            await limiter.tryRecordAttempt(session, key: 'request');
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group(
            'when rejecting an attempt in a rolled-back caller transaction and retrying, ',
            () {
              Object? error;
              late bool admitted;

              setUpAll(() async {
                try {
                  await session.db.transaction(
                    (final transaction) =>
                        limiter.tryRecordAttempt(session, key: 'request'),
                  );
                } catch (caughtError) {
                  error = caughtError;
                }

                admitted = await limiter.tryRecordAttempt(
                  session,
                  key: 'request',
                );
              });

              test(
                'then callback cleanup persists and the bucket can be used again.',
                () async {
                  expect(error, isA<_ExpectedRollbackException>());

                  expect(admitted, isTrue);
                },
              );
            },
          );
        },
      );

      group(
        'Given a one-hour window with attempts before, at, and after its cutoff, ',
        () {
          late DatabaseRateLimiter limiter;
          late DateTime now;

          setUpAll(() async {
            now = DateTime.utc(2026, 1, 1, 12);

            limiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 3,
                timeframe: const Duration(hours: 1),
              ),
            );

            await withClock(
              Clock.fixed(
                now.subtract(const Duration(hours: 1, microseconds: 1)),
              ),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 1))),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(minutes: 59))),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when counting attempts now, ', () {
            late int count;

            setUpAll(() async {
              count = await withClock(
                Clock.fixed(now),
                () => limiter.countAttempts(session, key: 'request'),
              );
            });

            test(
              'then only the attempt strictly inside the window counts.',
              () async {
                expect(count, 1);
              },
            );
          });
        },
      );

      group(
        'Given a one-hour window with attempts before, at, and after its cutoff, ',
        () {
          late DatabaseRateLimiter limiter;
          late DateTime now;

          setUpAll(() async {
            now = DateTime.utc(2026, 1, 1, 12);

            limiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 3,
                timeframe: const Duration(hours: 1),
              ),
            );

            await withClock(
              Clock.fixed(
                now.subtract(const Duration(hours: 1, microseconds: 1)),
              ),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 1))),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(minutes: 59))),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when deleting attempts older than one hour, ', () {
            late int deleted;
            late List<RateLimitedRequestAttempt> remaining;

            setUpAll(() async {
              deleted = await withClock(
                Clock.fixed(now),
                () => limiter.deleteAttempts(
                  session,
                  key: 'request',
                  olderThan: const Duration(hours: 1),
                ),
              );

              remaining = await _findAttempts(session);
            });

            test(
              'then the attempt at the cutoff and the newer attempt remain.',
              () async {
                expect(deleted, 1);

                expect(remaining.map((final attempt) => attempt.attemptedAt), [
                  now.subtract(const Duration(hours: 1)),
                  now.subtract(const Duration(minutes: 59)),
                ]);
              },
            );
          });
        },
      );

      group(
        'Given a one-hour window with attempts before, at, and after its cutoff, ',
        () {
          late RateLimiter limiter;
          late DateTime now;

          setUpAll(() async {
            now = DateTime.utc(2026, 1, 1, 12);

            limiter = DatabaseRateLimiter(
              RateLimiterConfig(
                domain: _testDomain,
                source: _testSource,
                maxAttempts: 3,
                timeframe: const Duration(hours: 1),
              ),
            );

            await withClock(
              Clock.fixed(
                now.subtract(const Duration(hours: 1, microseconds: 1)),
              ),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 1))),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(minutes: 59))),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );
          });

          tearDownAll(() async {
            await _deleteTestAttempts(session);
          });

          group('when deleting the key without an age filter, ', () {
            late int deleted;

            setUpAll(() async {
              deleted = await limiter.deleteAttempts(
                session,
                key: 'request',
              );
            });

            test(
              'then all its attempts are removed regardless of the configured window.',
              () async {
                expect(deleted, 3);

                expect(await _findAttempts(session), isEmpty);
              },
            );
          });
        },
      );

      group('Given a one-attempt window exhausted exactly one hour ago, ', () {
        late DateTime now;
        late DatabaseRateLimiter limiter;

        setUpAll(() async {
          now = DateTime.utc(2026, 1, 1, 12);

          limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 1,
              timeframe: const Duration(hours: 1),
            ),
          );

          await withClock(
            Clock.fixed(now.subtract(const Duration(hours: 1))),
            () => limiter.tryRecordAttempt(session, key: 'request'),
          );
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when admitting an attempt at the window boundary, ', () {
          late bool admitted;

          setUpAll(() async {
            admitted = await withClock(
              Clock.fixed(now),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );
          });

          test(
            'then the expired attempt no longer consumes the budget.',
            () async {
              expect(admitted, isTrue);
            },
          );
        });
      });

      group('Given a one-attempt lifetime limit used a year ago, ', () {
        late DateTime now;
        late DatabaseRateLimiter limiter;

        setUpAll(() async {
          now = DateTime.utc(2026, 1, 1);

          limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 1,
            ),
          );

          await withClock(
            Clock.fixed(now.subtract(const Duration(days: 365))),
            () => limiter.tryRecordAttempt(session, key: 'request'),
          );
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when admitting another attempt, ', () {
          late bool admitted;

          setUpAll(() async {
            admitted = await withClock(
              Clock.fixed(now),
              () => limiter.tryRecordAttempt(session, key: 'request'),
            );
          });

          test('then the old attempt still exhausts the budget.', () async {
            expect(admitted, isFalse);
          });
        });
      });

      group('Given attempts for two keys at the current timestamp, ', () {
        late DateTime now;
        late RateLimiter limiter;

        setUp(() async {
          now = DateTime.utc(2026, 1, 1);

          limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 1,
            ),
          );

          await withClock(Clock.fixed(now), () async {
            await limiter.tryRecordAttempt(session, key: 'first');

            await limiter.tryRecordAttempt(session, key: 'second');
          });
        });

        tearDown(() async {
          await _deleteTestAttempts(session);
        });

        group('when deleting without a key or age filter, ', () {
          late int deletedAttempts;

          setUp(() async {
            await withClock(Clock.fixed(now), () async {
              deletedAttempts = await limiter.deleteAttempts(session);
            });
          });

          test(
            'then both keys are cleared and the deletion count is returned.',
            () async {
              expect(deletedAttempts, 2);

              expect(await _findAttempts(session), isEmpty);
            },
          );
        });

        group('when deleting attempts older than zero, ', () {
          late int deletedAttempts;
          late List<RateLimitedRequestAttempt> remaining;

          setUp(() async {
            deletedAttempts = await withClock(
              Clock.fixed(now),
              () => limiter.deleteAttempts(
                session,
                olderThan: Duration.zero,
              ),
            );

            remaining = await _findAttempts(session);
          });

          test(
            'then both attempts at the current timestamp are preserved.',
            () {
              expect(deletedAttempts, 0);

              expect(
                remaining.map((final attempt) => attempt.key),
                unorderedEquals(['first', 'second']),
              );
            },
          );
        });
      });

      group('Given a key with one recorded attempt, ', () {
        late RateLimiter limiter;

        setUpAll(() async {
          limiter = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 1,
            ),
          );

          await limiter.tryRecordAttempt(session, key: 'request');
        });

        tearDownAll(() async {
          await _deleteTestAttempts(session);
        });

        group('when deleting it in a transaction that rolls back, ', () {
          Object? error;

          setUpAll(() async {
            try {
              await session.db.transaction((final transaction) async {
                await limiter.deleteAttempts(
                  session,
                  key: 'request',
                  transaction: transaction,
                );

                throw _ExpectedRollbackException();
              });
            } catch (caughtError) {
              error = caughtError;
            }
          });

          test(
            'then the deletion is rolled back with that transaction.',
            () async {
              expect(error, isA<_ExpectedRollbackException>());

              expect(await limiter.countAttempts(session, key: 'request'), 1);
            },
          );
        });
      });
    },
  );
}

Future<void> _deleteTestAttempts(final Session session) async {
  await RateLimitedRequestAttempt.db.deleteWhere(
    session,
    where: (final t) =>
        t.domain.equals(_testDomain) | t.domain.equals(_otherDomain),
  );
}

Future<List<RateLimitedRequestAttempt>> _findAttempts(
  final Session session, {
  final String domain = _testDomain,
  final String source = _testSource,
  final String? key,
}) async {
  return RateLimitedRequestAttempt.db.find(
    session,
    where: (final t) {
      var expression = t.domain.equals(domain) & t.source.equals(source);

      if (key != null) {
        expression &= t.key.equals(key);
      }

      return expression;
    },
    orderBy: (final t) => t.attemptedAt,
  );
}

final class _ExpectedRollbackException implements Exception {}
