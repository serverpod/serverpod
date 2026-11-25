import 'dart:async';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/futureCalls/test_retry_policies.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart'
    as test_server;
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';
import '../utils/recording_future_call_diagnostics_service.dart';

const _callName = 'retry-test-call';
const _identifier = 'retry-test-call-identifier';
const _blockingCallName = 'retry-test-blocking-call';

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

/// A future call that runs until it is released.
class _BlockingTestCall extends FutureCall<test_server.SimpleData>
    implements InvokableFutureCall<test_server.SimpleData> {
  /// Completes when the call starts running.
  final started = Completer<void>();

  final _released = Completer<void>();

  /// Lets the running call finish.
  void release() => _released.complete();

  @override
  Future<void> invoke(Session session, test_server.SimpleData? object) async {
    started.complete();
    await _released.future;
  }
}

/// Schedules the future call of these tests and runs it with new future call
/// managers, as other server instances or restarted servers would.
class _RetryTestHarness {
  final TestSessionBuilder _sessionBuilder;

  /// The session used to read and clean up the entries of the future call.
  final Session session;

  /// Records the errors the future call managers report.
  final diagnostics = RecordingFutureCallDiagnosticsService();

  /// The retry attempts that the sessions of the runs were built with.
  final retryAttemptsOfSessions = <int>[];

  _RetryTestHarness(this._sessionBuilder) : session = _sessionBuilder.build();

  /// Returns the entries of the future call, ordered by time.
  Future<List<FutureCallEntry>> findEntries() {
    return FutureCallEntry.db.find(
      session,
      where: (entry) => entry.name.equals(_callName),
      orderBy: (entry) => entry.time,
    );
  }

  /// Schedules the future call to run at [time], or now.
  Future<void> schedule({
    FutureCallRetryPolicy? retryPolicy,
    FutureCallScheduling? scheduling,
    DateTime? time,
  }) async {
    var futureCallManager = FutureCallManagerBuilder.fromTestSessionBuilder(
      _sessionBuilder,
    ).build();
    await futureCallManager.scheduleFutureCall(
      _callName,
      null,
      time ?? DateTime.now().toUtc(),
      'default',
      _identifier,
      scheduling: scheduling,
      retryPolicy: retryPolicy,
    );
  }

  /// Runs the due future calls once, with a new future call manager that runs
  /// [testCall] for the future call.
  Future<void> runDueCalls(FailingTestCall testCall) async {
    var futureCallManager =
        FutureCallManagerBuilder.fromTestSessionBuilder(_sessionBuilder)
            .withDiagnosticsService(diagnostics)
            .withSessionProvider((futureCallName, retryAttempt) {
              if (futureCallName == _callName) {
                retryAttemptsOfSessions.add(retryAttempt);
              }
              return _sessionBuilder.build();
            })
            .build();
    futureCallManager.registerFutureCall(testCall, _callName);
    await futureCallManager.runScheduledFutureCalls();
  }

  /// Deletes the entries of the future call and closes [session].
  Future<void> dispose() async {
    await FutureCallEntry.db.deleteWhere(
      session,
      where: (entry) => entry.name.equals(_callName),
    );
    await session.close();
  }
}

void main() {
  var protocol = test_server.Protocol();

  withServerpod(
    'Given a future call that fails twice before it succeeds and is scheduled with a FixedDelayRetryPolicy without delay,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 2);
        await harness.schedule(
          retryPolicy: const FixedDelayRetryPolicy(
            maxAttempts: 3,
            delay: Duration.zero,
          ),
        );
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run once,',
        () {
          late DateTime runTime;

          setUp(() async {
            runTime = DateTime.now().toUtc();
            await harness.runDueCalls(testCall);
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
              var entries = await harness.findEntries();
              expect(entries, hasLength(1));
              expect(entries.single.failedAttempts, 1);
            },
          );

          test(
            'then the entry is due again after the run.',
            () async {
              var entries = await harness.findEntries();
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
              var entries = await harness.findEntries();
              var claims = await FutureCallClaimEntry.db.find(
                harness.session,
                where: (claim) => claim.futureCallId.equals(entries.single.id),
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
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
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
              expect(harness.retryAttemptsOfSessions, [0, 1, 2]);
            },
          );

          test(
            'then the entry is deleted because the last run succeeded.',
            () async {
              expect(await harness.findEntries(), isEmpty);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a future call that always fails and is scheduled with a FixedDelayRetryPolicy with maxAttempts 2,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        await harness.schedule(
          retryPolicy: const FixedDelayRetryPolicy(
            maxAttempts: 2,
            delay: Duration.zero,
          ),
        );
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run four times,',
        () {
          setUp(() async {
            for (var i = 0; i < 4; i++) {
              await harness.runDueCalls(testCall);
            }
          });

          test('then the call ran three times.', () {
            expect(testCall.runs, 3);
          });

          test('then the entry is deleted.', () async {
            expect(await harness.findEntries(), isEmpty);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a future call that always fails and is scheduled without a retry policy,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        await harness.schedule();
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run twice,',
        () {
          setUp(() async {
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
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
              expect(await harness.findEntries(), isEmpty);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a future call that always fails and is scheduled with a FixedDelayRetryPolicy with a delay of one hour,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        await harness.schedule(
          retryPolicy: const FixedDelayRetryPolicy(
            maxAttempts: 3,
            delay: Duration(hours: 1),
          ),
        );
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run twice,',
        () {
          late DateTime runTime;

          setUp(() async {
            runTime = DateTime.now().toUtc();
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
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
              var entries = await harness.findEntries();
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

  withServerpod(
    'Given a future call that fails after it is cancelled while it runs,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(
          failures: 100,
          onRun: (session) async {
            await FutureCallEntry.db.deleteWhere(
              session,
              where: (entry) => entry.identifier.equals(_identifier),
            );
          },
        );
        await harness.schedule(
          retryPolicy: const FixedDelayRetryPolicy(
            maxAttempts: 3,
            delay: Duration.zero,
          ),
        );
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run twice,',
        () {
          setUp(() async {
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
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
              expect(await harness.findEntries(), isEmpty);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a recurring future call that always fails and is scheduled with a FixedDelayRetryPolicy with maxAttempts 1,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        await harness.schedule(
          scheduling: IntervalFutureCallScheduling(
            interval: const Duration(hours: 1),
          ),
          retryPolicy: const FixedDelayRetryPolicy(
            maxAttempts: 1,
            delay: Duration.zero,
          ),
        );
      });

      tearDown(() => harness.dispose());

      test(
        'when the due future calls are run once,'
        'then the retry and the next occurrence are both stored.',
        () async {
          await harness.runDueCalls(testCall);

          var entries = await harness.findEntries();
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
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
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
              var entries = await harness.findEntries();
              expect(entries, hasLength(1));
              expect(entries.single.failedAttempts, 0);
            },
          );

          test(
            'then the next occurrence still holds the retry policy.',
            () async {
              var entries = await harness.findEntries();
              expect(
                protocol.decodeWithType(entries.single.serializedRetryPolicy!),
                isA<FixedDelayRetryPolicy>(),
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a future call that always fails and is scheduled with a retry policy that keeps state,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        await harness.schedule(
          retryPolicy: TestCountingRetryPolicy(maxAttempts: 5),
        );
      });

      tearDown(() => harness.dispose());

      test(
        'when the due future calls are run twice,'
        'then the stored policy has the state of both failed runs.',
        () async {
          await harness.runDueCalls(testCall);
          await harness.runDueCalls(testCall);

          var entries = await harness.findEntries();
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

  withServerpod(
    'Given a future call that always fails and is scheduled with a retry policy that throws,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        await harness.schedule(retryPolicy: TestThrowingRetryPolicy());
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run twice,',
        () {
          setUp(() async {
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
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
              expect(await harness.findEntries(), isEmpty);
            },
          );

          test(
            'then the error of the call and the error of the policy are reported.',
            () {
              expect(harness.diagnostics.callExceptions, [
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

  withServerpod(
    'Given a future call that always fails and is scheduled with a retry policy that can no longer be saved after it was asked for a delay,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        await harness.schedule(retryPolicy: TestUnsavableRetryPolicy());
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run twice,',
        () {
          setUp(() async {
            await harness.runDueCalls(testCall);
            await harness.runDueCalls(testCall);
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
              expect(await harness.findEntries(), isEmpty);
            },
          );

          test(
            'then the error of the call and the error of saving the policy are reported.',
            () {
              expect(harness.diagnostics.callExceptions, [
                isA<Exception>().having(
                  (e) => e.toString(),
                  'toString',
                  'Exception: FailingTestCall failed on run 1.',
                ),
                isA<StateError>().having(
                  (e) => e.message,
                  'message',
                  'TestUnsavableRetryPolicy cannot be saved anymore.',
                ),
              ]);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a failing future call with a retry policy that one future call manager has queued behind a running future call,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _RetryTestHarness harness;
      late FailingTestCall testCall;
      late _BlockingTestCall blockingCall;
      late FutureCallManager queueingManager;
      late DateTime retryTime;

      setUp(() async {
        harness = _RetryTestHarness(sessionBuilder);
        testCall = FailingTestCall(failures: 100);
        blockingCall = _BlockingTestCall();

        var now = DateTime.now().toUtc();
        queueingManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withDiagnosticsService(harness.diagnostics)
                .withConfig(
                  FutureCallConfig(
                    concurrencyLimit: 1,
                    scanInterval: const Duration(milliseconds: 10),
                  ),
                )
                .build();
        queueingManager.registerFutureCall(blockingCall, _blockingCallName);
        queueingManager.registerFutureCall(testCall, _callName);

        // The blocking call is due first, so it runs first and the failing
        // call waits in the queue of this manager.
        await queueingManager.scheduleFutureCall(
          _blockingCallName,
          null,
          now.subtract(const Duration(seconds: 2)),
          'default',
          null,
        );
        await harness.schedule(
          retryPolicy: const FixedDelayRetryPolicy(
            maxAttempts: 3,
            delay: Duration(hours: 1),
          ),
          time: now.subtract(const Duration(seconds: 1)),
        );

        await queueingManager.start();
        await blockingCall.started.future;
      });

      tearDown(() async {
        await queueingManager.stop();
        await FutureCallEntry.db.deleteWhere(
          harness.session,
          where: (entry) => entry.name.equals(_blockingCallName),
        );
        await harness.dispose();
      });

      group(
        'when another future call manager runs the failing call before the first manager runs its queued copy,',
        () {
          setUp(() async {
            retryTime = DateTime.now().toUtc().add(const Duration(hours: 1));
            await harness.runDueCalls(testCall);
            blockingCall.release();
            await queueingManager.stop();
          });

          test(
            'then the call ran once.',
            () {
              expect(testCall.runs, 1);
            },
          );

          test(
            'then the entry keeps the retry with one failed attempt in an hour.',
            () async {
              var entries = await harness.findEntries();
              expect(entries, hasLength(1));
              expect(entries.single.failedAttempts, 1);
              expect(
                entries.single.time.difference(retryTime).abs(),
                lessThan(const Duration(minutes: 1)),
              );
            },
          );
        },
      );
    },
  );
}
