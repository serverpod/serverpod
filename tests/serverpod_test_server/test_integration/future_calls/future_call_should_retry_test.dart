import 'dart:async';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/futureCalls/test_retry_call.dart';
import 'package:serverpod_test_server/src/generated/future_calls.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart'
    as test_server;
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';
import '../utils/recording_future_call_diagnostics_service.dart';

const _callName = 'should-retry-test-call';
const _generatedCallName = 'TestRetryCallFailFutureCall';
const _retryPolicy = FixedDelayRetryPolicy(
  maxAttempts: 3,
  delay: Duration.zero,
);

/// A future call that always fails and decides whether to be retried with the
/// function it is given.
class ShouldRetryTestCall extends FutureCall<test_server.SimpleData>
    implements InvokableFutureCall<test_server.SimpleData> {
  final FutureOr<bool> Function() _shouldRetry;

  /// How many times the call ran.
  int runs = 0;

  /// The sessions [shouldRetry] was called with, in order.
  final shouldRetrySessions = <Session>[];

  /// The contexts [shouldRetry] was called with, in order.
  final shouldRetryContexts = <FutureCallRetryContext>[];

  ShouldRetryTestCall(this._shouldRetry);

  @override
  Future<void> invoke(Session session, test_server.SimpleData? object) async {
    runs++;
    throw Exception('ShouldRetryTestCall failed on run $runs.');
  }

  @override
  FutureOr<bool> shouldRetry(Session session, FutureCallRetryContext context) {
    shouldRetrySessions.add(session);
    shouldRetryContexts.add(context);
    return _shouldRetry();
  }
}

/// Schedules the future calls of these tests and runs them with new future
/// call managers.
class _ShouldRetryTestHarness {
  final TestSessionBuilder _sessionBuilder;

  /// The session used to read and clean up the entries of the future calls.
  final Session session;

  /// Records the errors the future call managers report.
  final diagnostics = RecordingFutureCallDiagnosticsService();

  /// The sessions built for the runs, in order.
  final sessionsOfRuns = <Session>[];

  _ShouldRetryTestHarness(this._sessionBuilder)
    : session = _sessionBuilder.build();

  /// Returns the entries of the future call named [name].
  Future<List<FutureCallEntry>> findEntries(String name) {
    return FutureCallEntry.db.find(
      session,
      where: (entry) => entry.name.equals(name),
    );
  }

  FutureCallManager _buildManager() {
    return FutureCallManagerBuilder.fromTestSessionBuilder(_sessionBuilder)
        .withDiagnosticsService(diagnostics)
        .withSessionProvider((futureCallName, retryAttempt) {
          var runSession = _sessionBuilder.build();
          sessionsOfRuns.add(runSession);
          return runSession;
        })
        .build();
  }

  /// Schedules the future call that [runDueCalls] runs to run now.
  Future<void> schedule({FutureCallRetryPolicy? retryPolicy}) async {
    await _buildManager().scheduleFutureCall(
      _callName,
      null,
      DateTime.now().toUtc(),
      'default',
      null,
      retryPolicy: retryPolicy,
    );
  }

  /// Runs the due future calls once, with a new future call manager that runs
  /// [testCall] for the future call.
  Future<void> runDueCalls(ShouldRetryTestCall testCall) async {
    var futureCallManager = _buildManager();
    futureCallManager.registerFutureCall(testCall, _callName);
    await futureCallManager.runScheduledFutureCalls();
  }

  /// Initializes the generated future calls of [pod] with a new future call
  /// manager, so that they can be scheduled.
  void initializeGeneratedCalls(Serverpod pod) {
    pod.futureCalls.initialize(_buildManager(), 'default');
  }

  /// Runs the due future calls once, with a new future call manager that has
  /// the generated future calls of [pod] registered.
  Future<void> runDueGeneratedCalls(Serverpod pod) async {
    var futureCallManager = _buildManager();
    pod.futureCalls.initialize(futureCallManager, 'default');
    await futureCallManager.runScheduledFutureCalls();
  }

  /// Deletes the entries of the future calls and closes [session].
  Future<void> dispose() async {
    await FutureCallEntry.db.deleteWhere(
      session,
      where: (entry) =>
          entry.name.equals(_callName) | entry.name.equals(_generatedCallName),
    );
    await session.close();
  }
}

void main() {
  withServerpod(
    'Given a failing future call whose shouldRetry returns true and that is scheduled with a retry policy,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ShouldRetryTestHarness harness;
      late ShouldRetryTestCall testCall;

      setUp(() async {
        harness = _ShouldRetryTestHarness(sessionBuilder);
        testCall = ShouldRetryTestCall(() => true);
        await harness.schedule(retryPolicy: _retryPolicy);
      });

      tearDown(() => harness.dispose());

      group(
        'when the due future calls are run once,',
        () {
          setUp(() async {
            await harness.runDueCalls(testCall);
          });

          test(
            'then the entry is kept with one failed attempt.',
            () async {
              var entries = await harness.findEntries(_callName);
              expect(entries, hasLength(1));
              expect(entries.single.failedAttempts, 1);
            },
          );

          test(
            'then shouldRetry is called with the session of the run that failed.',
            () {
              expect(testCall.shouldRetrySessions, hasLength(1));
              expect(
                testCall.shouldRetrySessions.single,
                same(harness.sessionsOfRuns.single),
              );
            },
          );

          test(
            'then shouldRetry is called with the error of the run and retry attempt 0.',
            () {
              var context = testCall.shouldRetryContexts.single;
              expect(context.retryAttempt, 0);
              expect(
                '${context.error}',
                'Exception: ShouldRetryTestCall failed on run 1.',
              );
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a failing future call whose shouldRetry returns false and that is scheduled with a retry policy,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ShouldRetryTestHarness harness;
      late ShouldRetryTestCall testCall;

      setUp(() async {
        harness = _ShouldRetryTestHarness(sessionBuilder);
        testCall = ShouldRetryTestCall(() => false);
        await harness.schedule(retryPolicy: _retryPolicy);
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
              expect(await harness.findEntries(_callName), isEmpty);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a failing future call whose shouldRetry returns a future that completes with false and that is scheduled with a retry policy,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ShouldRetryTestHarness harness;
      late ShouldRetryTestCall testCall;

      setUp(() async {
        harness = _ShouldRetryTestHarness(sessionBuilder);
        testCall = ShouldRetryTestCall(() async => false);
        await harness.schedule(retryPolicy: _retryPolicy);
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
              expect(await harness.findEntries(_callName), isEmpty);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a failing future call whose shouldRetry throws and that is scheduled with a retry policy,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ShouldRetryTestHarness harness;
      late ShouldRetryTestCall testCall;

      setUp(() async {
        harness = _ShouldRetryTestHarness(sessionBuilder);
        testCall = ShouldRetryTestCall(
          () => throw StateError('shouldRetry failed.'),
        );
        await harness.schedule(retryPolicy: _retryPolicy);
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
              expect(await harness.findEntries(_callName), isEmpty);
            },
          );

          test(
            'then the error of the call and the error of shouldRetry are reported.',
            () {
              expect(harness.diagnostics.callExceptions, [
                isA<Exception>().having(
                  (e) => e.toString(),
                  'toString',
                  'Exception: ShouldRetryTestCall failed on run 1.',
                ),
                isA<StateError>().having(
                  (e) => e.message,
                  'message',
                  'shouldRetry failed.',
                ),
              ]);
            },
          );
        },
      );
    },
  );

  withServerpod(
    'Given a failing future call that is scheduled without a retry policy,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ShouldRetryTestHarness harness;
      late ShouldRetryTestCall testCall;

      setUp(() async {
        harness = _ShouldRetryTestHarness(sessionBuilder);
        testCall = ShouldRetryTestCall(() => true);
        await harness.schedule();
      });

      tearDown(() => harness.dispose());

      test(
        'when the due future calls are run once,'
        'then shouldRetry is not called.',
        () async {
          await harness.runDueCalls(testCall);

          expect(testCall.shouldRetryContexts, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given a generated future call whose class overrides shouldRetry,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ShouldRetryTestHarness harness;
      late Serverpod pod;

      setUp(() {
        harness = _ShouldRetryTestHarness(sessionBuilder);
        pod = harness.session.serverpod;
        harness.initializeGeneratedCalls(pod);
        TestRetryCall.runs.clear();
      });

      tearDown(() => harness.dispose());

      test(
        'when it fails with a reason its shouldRetry accepts and the due future calls are run,'
        'then the entry is kept with one failed attempt.',
        () async {
          await pod.futureCalls
              .callWithDelay(Duration.zero)
              .withRetryPolicy(_retryPolicy)
              .testRetryCall
              .fail('temporary');

          await harness.runDueGeneratedCalls(pod);

          var entries = await harness.findEntries(_generatedCallName);
          expect(TestRetryCall.runs, ['temporary']);
          expect(entries, hasLength(1));
          expect(entries.single.failedAttempts, 1);
        },
      );

      test(
        'when it fails with a reason its shouldRetry rejects and the due future calls are run,'
        'then the entry is deleted.',
        () async {
          await pod.futureCalls
              .callWithDelay(Duration.zero)
              .withRetryPolicy(_retryPolicy)
              .testRetryCall
              .fail('permanent');

          await harness.runDueGeneratedCalls(pod);

          expect(TestRetryCall.runs, ['permanent']);
          expect(await harness.findEntries(_generatedCallName), isEmpty);
        },
      );
    },
  );
}
