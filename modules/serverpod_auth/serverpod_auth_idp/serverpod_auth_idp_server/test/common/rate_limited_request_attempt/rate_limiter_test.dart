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

  setUp(() async {
    session = buildSession();
    await _deleteTestAttempts(session);
  });

  tearDown(() async {
    await _deleteTestAttempts(session);
  });
  withServerpod(
    '[DatabaseRateLimiter]',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      buildSession = sessionBuilder.build;
      late List<String> rateLimitExceededKeys;

      Future<void> recordRateLimitExceeded(
        final Session session,
        final String key,
      ) async {
        rateLimitExceededKeys.add(key);
      }

      DatabaseRateLimiter buildRateLimitUtil({
        final String domain = _testDomain,
        final String source = _testSource,
        final Map<String, String>? defaultExtraData,
        required final int maxAttempts,
        final Duration? timeframe,
        final Future<void> Function(Session session, String key)?
        onRateLimitExceeded,
      }) {
        return DatabaseRateLimiter(
          RateLimiterConfig(
            domain: domain,
            source: source,
            defaultExtraData: defaultExtraData,
            maxAttempts: maxAttempts,
            timeframe: timeframe,
            onRateLimitExceeded: onRateLimitExceeded,
          ),
        );
      }

      group('Given a rate limiter that allows two attempts, ', () {
        late DatabaseRateLimiter rateLimitUtil;

        setUp(() {
          rateLimitExceededKeys = [];
          rateLimitUtil = buildRateLimitUtil(
            maxAttempts: 2,
            onRateLimitExceeded: recordRateLimitExceeded,
          );
        });

        group('when checking the rate limit three times for one request, ', () {
          late List<bool> admitted;

          setUp(() async {
            admitted = [
              for (var attempt = 0; attempt < 3; attempt++)
                await rateLimitUtil.tryRecordAttempt(
                  session,
                  key: 'request',
                ),
            ];
          });

          test(
            'then it allows the first two checks and rate limits the third.',
            () {
              expect(admitted, [true, true, false]);
            },
          );

          test('then it only records the two allowed attempts.', () async {
            final attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: 'request',
            );

            expect(attemptCount, 2);
          });

          test('then it reports the request to the rate limit callback.', () {
            expect(rateLimitExceededKeys, ['request']);
          });
        });

        group(
          'when six concurrent sessions check the rate limit for one request, ',
          () {
            late List<bool> admitted;

            setUp(() async {
              admitted = await Future.wait([
                for (var attempt = 0; attempt < 6; attempt++)
                  rateLimitUtil.tryRecordAttempt(
                    sessionBuilder.build(),
                    key: 'request',
                  ),
              ]);
            });

            test('then it allows exactly two of the checks.', () {
              expect(
                admitted.where((final limited) => limited),
                hasLength(2),
              );
            });

            test('then it records exactly two attempts.', () async {
              final attemptCount = await rateLimitUtil.countAttempts(
                session,
                key: 'request',
              );

              expect(attemptCount, 2);
            });
          },
        );
      });

      group(
        'Given a rate limit check happened inside a rolled-back caller transaction, ',
        () {
          late DatabaseRateLimiter rateLimitUtil;

          setUp(() async {
            rateLimitUtil = buildRateLimitUtil(maxAttempts: 2);

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

          test(
            'when counting attempts for the request, '
            'then the recorded attempt remains counted.',
            () async {
              final attemptCount = await rateLimitUtil.countAttempts(
                session,
                key: 'request',
              );

              expect(attemptCount, 1);
            },
          );
        },
      );

      test(
        'Given a rate limiter that allows one attempt and has no rate limit callback, '
        'when checking the rate limit twice for one request, '
        'then the second check reports the request as rate limited.',
        () async {
          final rateLimitUtil = buildRateLimitUtil(maxAttempts: 1);

          await rateLimitUtil.tryRecordAttempt(session, key: 'request');
          final admitted = await rateLimitUtil.tryRecordAttempt(
            session,
            key: 'request',
          );

          expect(admitted, isFalse);
        },
      );

      group(
        'Given a rate limiter with default extra data for every attempt, ',
        () {
          late DatabaseRateLimiter rateLimitUtil;

          setUp(() {
            rateLimitUtil = buildRateLimitUtil(
              maxAttempts: 2,
              defaultExtraData: const {
                'client': 'mobile',
                'shared': 'default',
              },
            );
          });

          test(
            'when recording an attempt with request extra data, '
            'then it stores the attempt with the request data merged over the '
            'default data.',
            () async {
              await rateLimitUtil.tryRecordAttempt(
                session,
                key: 'request',
                extraData: const {
                  'requestId': '123',
                  'shared': 'request',
                },
              );

              final attempts = await _findAttempts(session, key: 'request');

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
        },
      );

      test(
        'Given a rate limiter without default extra data, '
        'when recording an attempt without extra data, '
        'then it stores the attempt with no extra data.',
        () async {
          final rateLimitUtil = buildRateLimitUtil(maxAttempts: 2);

          await rateLimitUtil.tryRecordAttempt(session, key: 'request');

          final attempts = await _findAttempts(session, key: 'request');

          expect(attempts, hasLength(1));
          expect(attempts.single.extraData, isNull);
        },
      );

      group('Given a rate limiter for UUID request identifiers, ', () {
        late UuidValue requestId;
        late DatabaseRateLimiter rateLimitUtil;

        setUp(() {
          requestId = const Uuid().v4obj();
          rateLimitUtil = DatabaseRateLimiter(
            RateLimiterConfig(
              domain: _testDomain,
              source: _testSource,
              maxAttempts: 2,
            ),
          );
        });

        test(
          'when recording an attempt, '
          'then it stores the identifier as the caller-provided string key.',
          () async {
            await rateLimitUtil.tryRecordAttempt(session, key: requestId.uuid);

            final attempts = await _findAttempts(session);

            expect(attempts, hasLength(1));
            expect(attempts.single.key, requestId.uuid);
          },
        );

        test(
          'when counting attempts after recording one, '
          'then it counts the attempt by its string key.',
          () async {
            await rateLimitUtil.tryRecordAttempt(session, key: requestId.uuid);

            final attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: requestId.uuid,
            );

            expect(attemptCount, 1);
          },
        );
      });

      group(
        'Given a rate limiter with a one-hour timeframe, '
        'and a request with an attempt two hours ago and an attempt now, ',
        () {
          late DateTime now;
          late DatabaseRateLimiter rateLimitUtil;

          setUp(() async {
            now = DateTime.utc(2026, 1, 1, 12);
            rateLimitUtil = buildRateLimitUtil(
              maxAttempts: 2,
              timeframe: const Duration(hours: 1),
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

          test(
            'when counting attempts for the request, '
            'then it only counts the attempt inside the timeframe.',
            () async {
              await withClock(Clock.fixed(now), () async {
                final attemptCount = await rateLimitUtil.countAttempts(
                  session,
                  key: 'request',
                );

                expect(attemptCount, 1);
              });
            },
          );

          test(
            'when deleting attempts for the request before the window, '
            'then it only deletes the attempt older than the timeframe.',
            () async {
              await withClock(Clock.fixed(now), () async {
                final deletedAttempts = await rateLimitUtil.deleteAttempts(
                  session,
                  key: 'request',
                  before: now.subtract(const Duration(hours: 1)),
                );

                expect(deletedAttempts, 1);
              });

              final attempts = await _findAttempts(session, key: 'request');

              expect(attempts, hasLength(1));
            },
          );
        },
      );

      group(
        'Given a request with an attempt two hours ago and an attempt now, '
        'and another request with an attempt two hours ago, ',
        () {
          late DateTime now;
          late DatabaseRateLimiter rateLimitUtil;

          setUp(() async {
            now = DateTime.utc(2026, 1, 1, 12);
            rateLimitUtil = buildRateLimitUtil(maxAttempts: 2);

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

          test(
            'when deleting attempts for the request older than one hour, '
            'then it keeps the newer attempt and the other request attempt.',
            () async {
              await withClock(Clock.fixed(now), () async {
                final deletedAttempts = await rateLimitUtil.deleteAttempts(
                  session,
                  key: 'request',
                  before: now.subtract(const Duration(hours: 1)),
                );

                expect(deletedAttempts, 1);
              });

              final attempts = await _findAttempts(session, key: 'request');
              final otherAttempts = await _findAttempts(
                session,
                key: 'other-request',
              );

              expect(attempts, hasLength(1));
              expect(otherAttempts, hasLength(1));
            },
          );

          test(
            'when deleting attempts older than one hour without a key, '
            'then it deletes the old attempt of every request.',
            () async {
              await withClock(Clock.fixed(now), () async {
                final deletedAttempts = await rateLimitUtil.deleteAttempts(
                  session,
                  before: now.subtract(const Duration(hours: 1)),
                );

                expect(deletedAttempts, 2);
              });

              final attempts = await _findAttempts(session);

              expect(attempts, hasLength(1));
              expect(attempts.single.key, 'request');
            },
          );
        },
      );

      group(
        'Given a rate limiter that allows two attempts within one hour, '
        'and a request that used both attempts two hours ago, ',
        () {
          late DateTime now;
          late DatabaseRateLimiter rateLimitUtil;

          setUp(() async {
            now = DateTime.utc(2026, 1, 1, 12);
            rateLimitExceededKeys = [];
            rateLimitUtil = buildRateLimitUtil(
              maxAttempts: 2,
              timeframe: const Duration(hours: 1),
              onRateLimitExceeded: recordRateLimitExceeded,
            );

            await withClock(
              Clock.fixed(now.subtract(const Duration(hours: 2))),
              () async {
                await rateLimitUtil.tryRecordAttempt(session, key: 'request');
                await rateLimitUtil.tryRecordAttempt(session, key: 'request');
              },
            );
          });

          test(
            'when checking the rate limit now, '
            'then it allows the attempt.',
            () async {
              await withClock(Clock.fixed(now), () async {
                final admitted = await rateLimitUtil.tryRecordAttempt(
                  session,
                  key: 'request',
                );

                expect(admitted, isTrue);
                expect(rateLimitExceededKeys, isEmpty);
              });
            },
          );
        },
      );

      group('Given a request with an attempt under two sources, ', () {
        late DateTime now;
        late DatabaseRateLimiter rateLimitUtil;

        setUp(() async {
          now = DateTime.utc(2026, 1, 1, 12);
          rateLimitUtil = buildRateLimitUtil(maxAttempts: 2);
          final otherSourceUtil = buildRateLimitUtil(
            source: _otherSource,
            maxAttempts: 2,
          );

          await withClock(
            Clock.fixed(now.subtract(const Duration(minutes: 1))),
            () async {
              await rateLimitUtil.tryRecordAttempt(session, key: 'request');
              await otherSourceUtil.tryRecordAttempt(session, key: 'request');
            },
          );
        });

        test(
          'when counting attempts for the request, '
          'then it does not count the attempt from the other source.',
          () async {
            final attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: 'request',
            );

            expect(attemptCount, 1);
          },
        );

        test(
          'when deleting attempts for the request, '
          'then it keeps the attempt from the other source.',
          () async {
            await withClock(Clock.fixed(now), () async {
              final deletedAttempts = await rateLimitUtil.deleteAttempts(
                session,
                key: 'request',
              );

              expect(deletedAttempts, 1);
            });

            final attempts = await _findAttempts(session, key: 'request');
            final otherSourceAttempts = await _findAttempts(
              session,
              source: _otherSource,
              key: 'request',
            );

            expect(attempts, isEmpty);
            expect(otherSourceAttempts, hasLength(1));
          },
        );
      });

      group('Given a request with an attempt under two domains, ', () {
        late DateTime now;
        late DatabaseRateLimiter rateLimitUtil;

        setUp(() async {
          now = DateTime.utc(2026, 1, 1, 12);
          rateLimitUtil = buildRateLimitUtil(maxAttempts: 2);
          final otherDomainUtil = buildRateLimitUtil(
            domain: _otherDomain,
            maxAttempts: 2,
          );

          await withClock(
            Clock.fixed(now.subtract(const Duration(minutes: 1))),
            () async {
              await rateLimitUtil.tryRecordAttempt(session, key: 'request');
              await otherDomainUtil.tryRecordAttempt(session, key: 'request');
            },
          );
        });

        test(
          'when counting attempts for the request, '
          'then it does not count the attempt from the other domain.',
          () async {
            final attemptCount = await rateLimitUtil.countAttempts(
              session,
              key: 'request',
            );

            expect(attemptCount, 1);
          },
        );

        test(
          'when deleting attempts for the request, '
          'then it keeps the attempt from the other domain.',
          () async {
            await withClock(Clock.fixed(now), () async {
              final deletedAttempts = await rateLimitUtil.deleteAttempts(
                session,
                key: 'request',
              );

              expect(deletedAttempts, 1);
            });

            final attempts = await _findAttempts(session, key: 'request');
            final otherDomainAttempts = await _findAttempts(
              session,
              domain: _otherDomain,
              key: 'request',
            );

            expect(attempts, isEmpty);
            expect(otherDomainAttempts, hasLength(1));
          },
        );
      });

      test(
        'Given a key with quotes, separators, whitespace, and Unicode, '
        'when admitting an attempt, '
        'then it persists the exact caller-provided key.',
        () async {
          const key = ' "request:ação/雪" ';
          final limiter = buildRateLimitUtil(maxAttempts: 1);
          await limiter.tryRecordAttempt(session, key: key);
          final attempts = await _findAttempts(session);
          expect(attempts.single.key, key);
        },
      );

      test(
        'Given an empty string key, '
        'when admitting two attempts with a budget of one, '
        'then the empty key identifies one shared bucket.',
        () async {
          final limiter = buildRateLimitUtil(maxAttempts: 1);
          final first = await limiter.tryRecordAttempt(session, key: '');
          final second = await limiter.tryRecordAttempt(session, key: '');
          expect([first, second], [true, false]);
        },
      );

      test(
        'Given an exhausted key and an unused key, '
        'when admitting an attempt for the unused key, '
        'then it has its own attempt budget.',
        () async {
          final limiter = buildRateLimitUtil(maxAttempts: 1);
          await limiter.tryRecordAttempt(session, key: 'exhausted');
          final admitted = await limiter.tryRecordAttempt(
            session,
            key: 'unused',
          );
          expect(admitted, isTrue);
        },
      );

      test(
        'Given an exhausted limiter whose rejection callback throws, '
        'when admitting another attempt, '
        'then the callback exception propagates without consuming an attempt.',
        () async {
          final limiter = buildRateLimitUtil(
            maxAttempts: 1,
            onRateLimitExceeded: (final session, final key) async {
              throw _ExpectedRollbackException();
            },
          );
          await limiter.tryRecordAttempt(session, key: 'request');
          await expectLater(
            limiter.tryRecordAttempt(session, key: 'request'),
            throwsA(isA<_ExpectedRollbackException>()),
          );
          expect(await limiter.countAttempts(session, key: 'request'), 1);
        },
      );

      test(
        'Given an exhausted limiter whose rejection callback clears the bucket, '
        'when rejecting an attempt inside a caller transaction that rolls back, '
        'then callback cleanup persists and the bucket can be used again.',
        () async {
          late DatabaseRateLimiter limiter;
          limiter = buildRateLimitUtil(
            maxAttempts: 1,
            onRateLimitExceeded: (final session, final key) async {
              await limiter.deleteAttempts(session, key: key);
              throw _ExpectedRollbackException();
            },
          );
          await limiter.tryRecordAttempt(session, key: 'request');
          await expectLater(
            session.db.transaction(
              (final transaction) =>
                  limiter.tryRecordAttempt(session, key: 'request'),
            ),
            throwsA(isA<_ExpectedRollbackException>()),
          );
          expect(
            await limiter.tryRecordAttempt(session, key: 'request'),
            isTrue,
          );
        },
      );

      group(
        'Given a one-hour window with attempts before, at, and after its cutoff, ',
        () {
          late DatabaseRateLimiter limiter;
          late DateTime now;
          setUp(() async {
            now = DateTime.utc(2026, 1, 1, 12);
            limiter = buildRateLimitUtil(
              maxAttempts: 3,
              timeframe: const Duration(hours: 1),
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
          test(
            'when counting attempts now, '
            'then only the attempt strictly inside the window counts.',
            () async {
              final count = await withClock(
                Clock.fixed(now),
                () => limiter.countAttempts(session, key: 'request'),
              );
              expect(count, 1);
            },
          );
          test(
            'when deleting attempts before the cutoff, '
            'then the attempt at the cutoff and the newer attempt remain.',
            () async {
              final deleted = await limiter.deleteAttempts(
                session,
                key: 'request',
                before: now.subtract(const Duration(hours: 1)),
              );
              final remaining = await _findAttempts(session);
              expect(deleted, 1);
              expect(remaining.map((final attempt) => attempt.attemptedAt), [
                now.subtract(const Duration(hours: 1)),
                now.subtract(const Duration(minutes: 59)),
              ]);
            },
          );
          test(
            'when deleting the key without a cutoff, '
            'then all its attempts are removed regardless of the configured window.',
            () async {
              final RateLimiter publicLimiter = limiter;
              final deleted = await publicLimiter.deleteAttempts(
                session,
                key: 'request',
              );
              expect(deleted, 3);
              expect(await _findAttempts(session), isEmpty);
            },
          );
        },
      );

      test(
        'Given a one-attempt window exhausted exactly one hour ago, '
        'when admitting an attempt at the window boundary, '
        'then the expired attempt no longer consumes the budget.',
        () async {
          final now = DateTime.utc(2026, 1, 1, 12);
          final limiter = buildRateLimitUtil(
            maxAttempts: 1,
            timeframe: const Duration(hours: 1),
          );
          await withClock(
            Clock.fixed(now.subtract(const Duration(hours: 1))),
            () => limiter.tryRecordAttempt(session, key: 'request'),
          );
          final admitted = await withClock(
            Clock.fixed(now),
            () => limiter.tryRecordAttempt(session, key: 'request'),
          );
          expect(admitted, isTrue);
        },
      );

      test(
        'Given a one-attempt lifetime limit used a year ago, '
        'when admitting another attempt, '
        'then the old attempt still exhausts the budget.',
        () async {
          final now = DateTime.utc(2026, 1, 1);
          final limiter = buildRateLimitUtil(maxAttempts: 1);
          await withClock(
            Clock.fixed(now.subtract(const Duration(days: 365))),
            () => limiter.tryRecordAttempt(session, key: 'request'),
          );
          final admitted = await withClock(
            Clock.fixed(now),
            () => limiter.tryRecordAttempt(session, key: 'request'),
          );
          expect(admitted, isFalse);
        },
      );

      test(
        'Given attempts for two keys at the current timestamp, '
        'when deleting without a key or cutoff, '
        'then both keys are cleared and the deletion count is returned.',
        () async {
          final now = DateTime.utc(2026, 1, 1);
          final RateLimiter limiter = buildRateLimitUtil(maxAttempts: 1);
          await withClock(Clock.fixed(now), () async {
            await limiter.tryRecordAttempt(session, key: 'first');
            await limiter.tryRecordAttempt(session, key: 'second');
            expect(await limiter.deleteAttempts(session), 2);
          });
          expect(await _findAttempts(session), isEmpty);
        },
      );

      test(
        'Given a key with one recorded attempt, '
        'when deleting it in a transaction that rolls back, '
        'then the deletion is rolled back with that transaction.',
        () async {
          final RateLimiter limiter = buildRateLimitUtil(maxAttempts: 1);
          await limiter.tryRecordAttempt(session, key: 'request');
          await expectLater(
            session.db.transaction((final transaction) async {
              await limiter.deleteAttempts(
                session,
                key: 'request',
                transaction: transaction,
              );
              throw _ExpectedRollbackException();
            }),
            throwsA(isA<_ExpectedRollbackException>()),
          );
          expect(await limiter.countAttempts(session, key: 'request'), 1);
        },
      );
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
