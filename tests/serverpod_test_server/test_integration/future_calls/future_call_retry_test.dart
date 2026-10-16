import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';
import 'package:serverpod_test_server/src/futureCalls/test_retry_policies.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart'
    as test_server;
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

/// A future call that fails a given number of times before it succeeds.
class FailingTestCall extends FutureCall<test_server.SimpleData>
    implements InvokableFutureCall<test_server.SimpleData> {
  /// How many runs fail before a run succeeds.
  final int failures;

  /// Called at the start of every run, before the run fails or succeeds.
  final Future<void> Function(Session session)? onRun;

  /// How many times the call ran.
  int runs = 0;

  FailingTestCall({required this.failures, this.onRun});

  @override
  Future<void> invoke(Session session, test_server.SimpleData? object) async {
    runs++;
    await onRun?.call(session);
    if (runs <= failures) {
      throw Exception('FailingTestCall failed on run $runs.');
    }
  }
}

/// Records the errors the future call manager reports.
class RecordingDiagnosticsService implements FutureCallDiagnosticsService {
  final callExceptions = <Object>[];
  final frameworkExceptions = <Object>[];

  @override
  void submitCallException(
    Object error,
    StackTrace stackTrace, {
    required Session session,
  }) {
    callExceptions.add(error);
  }

  @override
  void submitFrameworkException(
    Object error,
    StackTrace stackTrace, {
    String? message,
  }) {
    frameworkExceptions.add(error);
  }
}

void main() {
  var protocol = test_server.Protocol();
  const callName = 'retry-test-call';
  const identifier = 'retry-test-call-identifier';

  withServerpod(
    'Given the future call manager,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late Session session;
      late FailingTestCall testCall;
      late List<int> retryAttemptsOfSessions;
      late RecordingDiagnosticsService diagnostics;

      Future<List<FutureCallEntry>> findEntries() {
        return FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(callName),
          orderBy: (entry) => entry.time,
        );
      }

      /// Runs the due future calls once, with a new future call manager, as
      /// another server instance or a restarted server would.
      Future<void> runDueCalls() async {
        var futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withDiagnosticsService(diagnostics)
                .withSessionProvider((futureCallName, retryAttempt) {
                  if (futureCallName == callName) {
                    retryAttemptsOfSessions.add(retryAttempt);
                  }
                  return sessionBuilder.build();
                })
                .build();
        futureCallManager.registerFutureCall(testCall, callName);
        await futureCallManager.runScheduledFutureCalls();
      }

      Future<void> schedule({
        FutureCallRetryPolicy? retryPolicy,
        FutureCallScheduling? scheduling,
      }) async {
        var futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).build();
        await futureCallManager.scheduleFutureCall(
          callName,
          null,
          DateTime.now().toUtc(),
          'default',
          identifier,
          scheduling: scheduling,
          retryPolicy: retryPolicy,
        );
      }

      setUp(() {
        session = sessionBuilder.build();
        retryAttemptsOfSessions = [];
        diagnostics = RecordingDiagnosticsService();
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(callName),
        );
        await session.close();
      });

      group(
        'Given a future call that fails twice before it succeeds and is scheduled with a FixedDelayRetryPolicy without delay,',
        () {
          setUp(() async {
            testCall = FailingTestCall(failures: 2);
            await schedule(
              retryPolicy: const FixedDelayRetryPolicy(
                maxAttempts: 3,
                delay: Duration.zero,
              ),
            );
          });

          group(
            'when the due future calls are run once,',
            () {
              late DateTime runTime;

              setUp(() async {
                runTime = DateTime.now().toUtc();
                await runDueCalls();
              });

              test(
                'then the call ran once.',
                () {
                  expect(testCall.runs, 1);
                },
              );

              test(
                'then the entry is kept with one failed attempt.',
                () async {
                  var entries = await findEntries();
                  expect(entries, hasLength(1));
                  expect(entries.single.failedAttempts, 1);
                },
              );

              test(
                'then the entry is due again after the run.',
                () async {
                  var entries = await findEntries();
                  expect(
                    entries.single.time.isBefore(
                      runTime.subtract(const Duration(seconds: 1)),
                    ),
                    isFalse,
                  );
                },
              );

              test(
                'then the claim of the entry is released.',
                () async {
                  var entries = await findEntries();
                  var claims = await FutureCallClaimEntry.db.find(
                    session,
                    where: (claim) =>
                        claim.futureCallId.equals(entries.single.id),
                  );
                  expect(claims, isEmpty);
                },
              );
            },
          );

          group(
            'when the due future calls are run three times,',
            () {
              setUp(() async {
                await runDueCalls();
                await runDueCalls();
                await runDueCalls();
              });

              test(
                'then the call ran three times.',
                () {
                  expect(testCall.runs, 3);
                },
              );

              test(
                'then the sessions of the runs were built with retry attempts 0, 1 and 2.',
                () {
                  expect(retryAttemptsOfSessions, [0, 1, 2]);
                },
              );

              test(
                'then the entry is deleted because the last run succeeded.',
                () async {
                  expect(await findEntries(), isEmpty);
                },
              );
            },
          );
        },
      );

      group(
        'Given a future call that always fails and is scheduled with a FixedDelayRetryPolicy with maxAttempts 2,',
        () {
          setUp(() async {
            testCall = FailingTestCall(failures: 100);
            await schedule(
              retryPolicy: const FixedDelayRetryPolicy(
                maxAttempts: 2,
                delay: Duration.zero,
              ),
            );
          });

          group(
            'when the due future calls are run four times,',
            () {
              setUp(() async {
                for (var i = 0; i < 4; i++) {
                  await runDueCalls();
                }
              });

              test('then the call ran three times.', () {
                expect(testCall.runs, 3);
              });

              test('then the entry is deleted.', () async {
                expect(await findEntries(), isEmpty);
              });
            },
          );
        },
      );

      group(
        'Given a future call that always fails and is scheduled without a retry policy,',
        () {
          setUp(() async {
            testCall = FailingTestCall(failures: 100);
            await schedule();
          });

          group(
            'when the due future calls are run twice,',
            () {
              setUp(() async {
                await runDueCalls();
                await runDueCalls();
              });

              test(
                'then the call ran once.',
                () {
                  expect(testCall.runs, 1);
                },
              );

              test(
                'then the entry is deleted.',
                () async {
                  expect(await findEntries(), isEmpty);
                },
              );
            },
          );
        },
      );

      group(
        'Given a future call that always fails and is scheduled with a FixedDelayRetryPolicy with a delay of one hour,',
        () {
          late DateTime runTime;

          setUp(() async {
            testCall = FailingTestCall(failures: 100);
            await schedule(
              retryPolicy: const FixedDelayRetryPolicy(
                maxAttempts: 3,
                delay: Duration(hours: 1),
              ),
            );
          });

          group(
            'when the due future calls are run twice,',
            () {
              setUp(() async {
                runTime = DateTime.now().toUtc();
                await runDueCalls();
                await runDueCalls();
              });

              test(
                'then the call ran once.',
                () {
                  expect(testCall.runs, 1);
                },
              );

              test(
                'then the entry is due one hour after the failed run.',
                () async {
                  var entries = await findEntries();
                  expect(entries, hasLength(1));
                  expect(
                    entries.single.time.difference(runTime),
                    allOf(
                      greaterThanOrEqualTo(const Duration(minutes: 59)),
                      lessThanOrEqualTo(const Duration(minutes: 61)),
                    ),
                  );
                },
              );
            },
          );
        },
      );

      group(
        'Given a future call that is cancelled while it runs and then fails,',
        () {
          setUp(() async {
            testCall = FailingTestCall(
              failures: 100,
              onRun: (session) async {
                await FutureCallEntry.db.deleteWhere(
                  session,
                  where: (entry) => entry.identifier.equals(identifier),
                );
              },
            );
            await schedule(
              retryPolicy: const FixedDelayRetryPolicy(
                maxAttempts: 3,
                delay: Duration.zero,
              ),
            );
          });

          group(
            'when the due future calls are run twice,',
            () {
              setUp(() async {
                await runDueCalls();
                await runDueCalls();
              });

              test(
                'then the call ran once.',
                () {
                  expect(testCall.runs, 1);
                },
              );

              test(
                'then no entry is left.',
                () async {
                  expect(await findEntries(), isEmpty);
                },
              );
            },
          );
        },
      );

      group(
        'Given a recurring future call that always fails and is scheduled with a FixedDelayRetryPolicy with maxAttempts 1,',
        () {
          setUp(() async {
            testCall = FailingTestCall(failures: 100);
            await schedule(
              scheduling: IntervalFutureCallScheduling(
                interval: const Duration(hours: 1),
              ),
              retryPolicy: const FixedDelayRetryPolicy(
                maxAttempts: 1,
                delay: Duration.zero,
              ),
            );
          });

          test(
            'when the due future calls are run once,'
            'then the retry and the next occurrence are both stored.',
            () async {
              await runDueCalls();

              var entries = await findEntries();
              expect(
                entries.map((entry) => entry.failedAttempts),
                [1, 0],
              );
            },
          );

          group(
            'when the due future calls are run twice,',
            () {
              setUp(() async {
                await runDueCalls();
                await runDueCalls();
              });

              test(
                'then the call ran twice.',
                () {
                  expect(testCall.runs, 2);
                },
              );

              test(
                'then only the next occurrence is left.',
                () async {
                  var entries = await findEntries();
                  expect(entries, hasLength(1));
                  expect(entries.single.failedAttempts, 0);
                },
              );

              test(
                'then the next occurrence still holds the retry policy.',
                () async {
                  var entries = await findEntries();
                  expect(
                    protocol.decodeWithType(
                      entries.single.serializedRetryPolicy!,
                    ),
                    isA<FixedDelayRetryPolicy>(),
                  );
                },
              );
            },
          );
        },
      );

      group(
        'Given a future call that always fails and is scheduled with a retry policy that keeps state,',
        () {
          setUp(() async {
            testCall = FailingTestCall(failures: 100);
            await schedule(
              retryPolicy: TestCountingRetryPolicy(maxAttempts: 5),
            );
          });

          test(
            'when the due future calls are run twice,'
            'then the stored policy has the state of both failed runs.',
            () async {
              await runDueCalls();
              await runDueCalls();

              var entries = await findEntries();
              expect(
                protocol.decodeWithType(entries.single.serializedRetryPolicy!),
                isA<TestCountingRetryPolicy>().having(
                  (policy) => policy.timesAsked,
                  'timesAsked',
                  2,
                ),
              );
            },
          );
        },
      );

      group(
        'Given a future call that always fails and is scheduled with a retry policy that throws,',
        () {
          setUp(() async {
            testCall = FailingTestCall(failures: 100);
            await schedule(retryPolicy: TestThrowingRetryPolicy());
          });

          group(
            'when the due future calls are run twice,',
            () {
              setUp(() async {
                await runDueCalls();
                await runDueCalls();
              });

              test(
                'then the call ran once.',
                () {
                  expect(testCall.runs, 1);
                },
              );

              test(
                'then the entry is deleted.',
                () async {
                  expect(await findEntries(), isEmpty);
                },
              );

              test(
                'then the error of the call and the error of the policy are reported.',
                () {
                  expect(diagnostics.callExceptions, [
                    isA<Exception>().having(
                      (e) => e.toString(),
                      'toString',
                      'Exception: FailingTestCall failed on run 1.',
                    ),
                    isA<StateError>().having(
                      (e) => e.message,
                      'message',
                      'TestThrowingRetryPolicy always throws.',
                    ),
                  ]);
                },
              );
            },
          );
        },
      );
    },
  );
}
