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

void main() {
  const callName = 'should-retry-test-call';
  const generatedCallName = 'TestRetryCallFailFutureCall';
  const retryPolicy = FixedDelayRetryPolicy(
    maxAttempts: 3,
    delay: Duration.zero,
  );

  withServerpod(
    'Given the future call manager,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late Session session;
      late ShouldRetryTestCall testCall;
      late List<Session> sessionsOfRuns;
      late RecordingFutureCallDiagnosticsService diagnostics;

      Future<List<FutureCallEntry>> findEntries(String name) {
        return FutureCallEntry.db.find(
          session,
          where: (entry) => entry.name.equals(name),
        );
      }

      FutureCallManager buildManager() {
        return FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
            .withDiagnosticsService(diagnostics)
            .withSessionProvider((futureCallName, retryAttempt) {
              var runSession = sessionBuilder.build();
              sessionsOfRuns.add(runSession);
              return runSession;
            })
            .build();
      }

      /// Runs the due future calls once, with a new future call manager.
      Future<void> runDueCalls() async {
        var futureCallManager = buildManager();
        futureCallManager.registerFutureCall(testCall, callName);
        await futureCallManager.runScheduledFutureCalls();
      }

      Future<void> schedule({FutureCallRetryPolicy? retryPolicy}) async {
        await buildManager().scheduleFutureCall(
          callName,
          null,
          DateTime.now().toUtc(),
          'default',
          null,
          retryPolicy: retryPolicy,
        );
      }

      setUp(() {
        session = sessionBuilder.build();
        sessionsOfRuns = [];
        diagnostics = RecordingFutureCallDiagnosticsService();
      });

      tearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) =>
              entry.name.equals(callName) |
              entry.name.equals(generatedCallName),
        );
        await session.close();
      });

      group(
        'Given a failing future call whose shouldRetry returns true and that is scheduled with a retry policy,',
        () {
          setUp(() async {
            testCall = ShouldRetryTestCall(() => true);
            await schedule(retryPolicy: retryPolicy);
          });

          group(
            'when the due future calls are run once,',
            () {
              setUp(() async {
                await runDueCalls();
              });

              test(
                'then the entry is kept with one failed attempt.',
                () async {
                  var entries = await findEntries(callName);
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
                    same(sessionsOfRuns.single),
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

      group(
        'Given a failing future call whose shouldRetry returns false and that is scheduled with a retry policy,',
        () {
          setUp(() async {
            testCall = ShouldRetryTestCall(() => false);
            await schedule(retryPolicy: retryPolicy);
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
                  expect(await findEntries(callName), isEmpty);
                },
              );
            },
          );
        },
      );

      group(
        'Given a failing future call whose shouldRetry returns a future that completes with false and that is scheduled with a retry policy,',
        () {
          setUp(() async {
            testCall = ShouldRetryTestCall(() async => false);
            await schedule(retryPolicy: retryPolicy);
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
                  expect(await findEntries(callName), isEmpty);
                },
              );
            },
          );
        },
      );

      group(
        'Given a failing future call whose shouldRetry throws and that is scheduled with a retry policy,',
        () {
          setUp(() async {
            testCall = ShouldRetryTestCall(
              () => throw StateError('shouldRetry failed.'),
            );
            await schedule(retryPolicy: retryPolicy);
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
                  expect(await findEntries(callName), isEmpty);
                },
              );

              test(
                'then the error of the call and the error of shouldRetry are reported.',
                () {
                  expect(diagnostics.callExceptions, [
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

      group(
        'Given a failing future call that is scheduled without a retry policy,',
        () {
          setUp(() async {
            testCall = ShouldRetryTestCall(() => true);
            await schedule();
          });

          test(
            'when the due future calls are run once,'
            'then shouldRetry is not called.',
            () async {
              await runDueCalls();

              expect(testCall.shouldRetryContexts, isEmpty);
            },
          );
        },
      );

      group(
        'Given a generated future call whose class overrides shouldRetry,',
        () {
          late Serverpod pod;

          /// Runs the due future calls once, with a new future call manager
          /// that has the generated future calls registered.
          Future<void> runDueGeneratedCalls() async {
            var futureCallManager = buildManager();
            pod.futureCalls.initialize(futureCallManager, 'default');
            await futureCallManager.runScheduledFutureCalls();
          }

          setUp(() {
            pod = session.serverpod;
            pod.futureCalls.initialize(buildManager(), 'default');
            TestRetryCall.runs.clear();
          });

          test(
            'when it fails with a reason its shouldRetry accepts and the due future calls are run,'
            'then the entry is kept with one failed attempt.',
            () async {
              await pod.futureCalls
                  .callWithDelay(Duration.zero)
                  .withRetryPolicy(retryPolicy)
                  .testRetryCall
                  .fail('temporary');

              await runDueGeneratedCalls();

              var entries = await findEntries(generatedCallName);
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
                  .withRetryPolicy(retryPolicy)
                  .testRetryCall
                  .fail('permanent');

              await runDueGeneratedCalls();

              expect(TestRetryCall.runs, ['permanent']);
              expect(await findEntries(generatedCallName), isEmpty);
            },
          );
        },
      );
    },
  );
}
