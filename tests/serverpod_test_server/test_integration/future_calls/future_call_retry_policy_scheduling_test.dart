import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/futureCalls/test_retry_policies.dart';
import 'package:serverpod_test_server/src/generated/future_calls.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart'
    as test_server;
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

/// A retry policy that is not registered in the protocol, because it is not
/// declared in the server project's `lib` directory.
class _UnregisteredRetryPolicy extends FutureCallRetryPolicy {
  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}

void main() {
  var protocol = test_server.Protocol();
  const futureCallName = 'TestGeneratedCallHelloFutureCall';
  const fixedDelayPolicy = FixedDelayRetryPolicy(
    maxAttempts: 3,
    delay: Duration(seconds: 30),
  );

  withServerpod(
    'Given the generated future calls are initialized,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late Session session;
      late Serverpod pod;

      Future<List<FutureCallEntry>> findEntries() {
        return FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(futureCallName),
        );
      }

      /// Expects a single stored entry that holds [fixedDelayPolicy] and has
      /// no failed attempts.
      Future<void> expectEntryWithFixedDelayPolicy() async {
        var entries = await findEntries();
        expect(entries, hasLength(1));
        expect(entries.single.failedAttempts, 0);
        expect(
          protocol.decodeWithType(entries.single.serializedRetryPolicy!),
          isA<FixedDelayRetryPolicy>()
              .having(
                (p) => p.maxAttempts,
                'maxAttempts',
                fixedDelayPolicy.maxAttempts,
              )
              .having((p) => p.delay, 'delay', fixedDelayPolicy.delay),
        );
      }

      setUp(() async {
        session = sessionBuilder.build();
        pod = session.serverpod;

        var futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();
        pod.futureCalls.initialize(futureCallManager, 'default');
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(futureCallName),
        );
        await session.close();
      });

      test(
        'when a future call is scheduled at a time with a FixedDelayRetryPolicy,'
        'then the stored entry holds that policy and no failed attempts.',
        () async {
          await pod.futureCalls
              .callAtTime(DateTime.now())
              .withRetryPolicy(fixedDelayPolicy)
              .testGeneratedCall
              .hello('Lucky');

          await expectEntryWithFixedDelayPolicy();
        },
      );

      test(
        'when a future call is scheduled with a delay and a FixedDelayRetryPolicy,'
        'then the stored entry holds that policy and no failed attempts.',
        () async {
          await pod.futureCalls
              .callWithDelay(const Duration(minutes: 1))
              .withRetryPolicy(fixedDelayPolicy)
              .testGeneratedCall
              .hello('Lucky');

          await expectEntryWithFixedDelayPolicy();
        },
      );

      test(
        'when a recurring future call is scheduled with a cron expression and a FixedDelayRetryPolicy,'
        'then the stored entry holds that policy and no failed attempts.',
        () async {
          await pod.futureCalls
              .callRecurring()
              .cron('0 8 * * *')
              .withRetryPolicy(fixedDelayPolicy)
              .testGeneratedCall
              .hello('Lucky');

          await expectEntryWithFixedDelayPolicy();
        },
      );

      test(
        'when a recurring future call is scheduled with an interval and a FixedDelayRetryPolicy,'
        'then the stored entry holds that policy and no failed attempts.',
        () async {
          await pod.futureCalls
              .callRecurring()
              .every(const Duration(hours: 1))
              .withRetryPolicy(fixedDelayPolicy)
              .testGeneratedCall
              .hello('Lucky');

          await expectEntryWithFixedDelayPolicy();
        },
      );

      test(
        'when a future call is scheduled without a retry policy,'
        'then the stored entry has no policy and no failed attempts.',
        () async {
          await pod.futureCalls
              .callWithDelay(const Duration(minutes: 1))
              .testGeneratedCall
              .hello('Lucky');

          var entries = await findEntries();
          expect(entries, hasLength(1));
          expect(entries.single.serializedRetryPolicy, isNull);
          expect(entries.single.failedAttempts, 0);
        },
      );

      test(
        'when a future call is scheduled with a retry policy declared in the project,'
        'then the stored entry holds that policy.',
        () async {
          await pod.futureCalls
              .callWithDelay(const Duration(minutes: 1))
              .withRetryPolicy(
                TestRetryPolicy(
                  maxAttempts: 2,
                  delay: const Duration(seconds: 5),
                ),
              )
              .testGeneratedCall
              .hello('Lucky');

          var entries = await findEntries();
          expect(
            protocol.decodeWithType(entries.single.serializedRetryPolicy!),
            isA<TestRetryPolicy>()
                .having((p) => p.maxAttempts, 'maxAttempts', 2)
                .having((p) => p.delay, 'delay', const Duration(seconds: 5)),
          );
        },
      );

      group(
        'when a future call is scheduled with a retry policy that cannot work,',
        () {
          Object? error;

          setUp(() async {
            try {
              await pod.futureCalls
                  .callWithDelay(const Duration(minutes: 1))
                  .withRetryPolicy(
                    const FixedDelayRetryPolicy(
                      maxAttempts: 0,
                      delay: Duration(seconds: 30),
                    ),
                  )
                  .testGeneratedCall
                  .hello('Lucky');
            } catch (e) {
              error = e;
            }
          });

          test(
            'then an ArgumentError is thrown.',
            () {
              expect(error, isA<ArgumentError>());
            },
          );

          test(
            'then no entry is stored.',
            () async {
              expect(await findEntries(), isEmpty);
            },
          );
        },
      );

      group(
        'when a future call is scheduled with a retry policy that is not registered in the protocol,',
        () {
          Object? error;

          setUp(() async {
            try {
              await pod.futureCalls
                  .callWithDelay(const Duration(minutes: 1))
                  .withRetryPolicy(_UnregisteredRetryPolicy())
                  .testGeneratedCall
                  .hello('Lucky');
            } catch (e) {
              error = e;
            }
          });

          test(
            'then an ArgumentError is thrown.',
            () {
              expect(error, isA<ArgumentError>());
            },
          );

          test(
            'then no entry is stored.',
            () async {
              expect(await findEntries(), isEmpty);
            },
          );
        },
      );
    },
  );
}
