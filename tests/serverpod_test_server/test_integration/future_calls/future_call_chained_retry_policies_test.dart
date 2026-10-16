import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_retry_policy_serialization.dart';
import 'package:serverpod_test_server/src/futureCalls/test_retry_policies.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart'
    as test_server;
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';
import '../utils/recording_future_call_diagnostics_service.dart';

const _callName = 'chained-retry-policies-test-call';

/// A future call that always fails.
class AlwaysFailingTestCall extends FutureCall<test_server.SimpleData>
    implements InvokableFutureCall<test_server.SimpleData> {
  /// How many times the call ran.
  int runs = 0;

  @override
  Future<void> invoke(Session session, test_server.SimpleData? object) async {
    runs++;
    throw Exception('AlwaysFailingTestCall failed on run $runs.');
  }
}

/// A retry policy that is not registered in the protocol, because it is not
/// declared in the server project's `lib` directory.
class _UnregisteredRetryPolicy extends FutureCallRetryPolicy {
  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}

/// Schedules the future call of these tests and runs it with new future call
/// managers.
class _ChainTestHarness {
  final TestSessionBuilder _sessionBuilder;

  /// The session used to read and clean up the entries of the future call.
  final Session session;

  /// Records the errors the future call managers report.
  final diagnostics = RecordingFutureCallDiagnosticsService();

  final _protocol = test_server.Protocol();

  _ChainTestHarness(this._sessionBuilder) : session = _sessionBuilder.build();

  /// Returns the entries of the future call.
  Future<List<FutureCallEntry>> findEntries() {
    return FutureCallEntry.db.find(
      session,
      where: (entry) => entry.name.equals(_callName),
    );
  }

  /// Loads the retry policy stored with [entry] the way the future call
  /// manager does.
  FutureCallRetryPolicy storedPolicy(FutureCallEntry entry) {
    return runWithRetryPolicySerialization(
      _protocol,
      () =>
          _protocol.decodeWithType(entry.serializedRetryPolicy!)
              as FutureCallRetryPolicy,
    );
  }

  FutureCallManager _buildManager({FutureCallConfig? config}) {
    var builder = FutureCallManagerBuilder.fromTestSessionBuilder(
      _sessionBuilder,
    ).withDiagnosticsService(diagnostics);
    if (config != null) builder = builder.withConfig(config);
    return builder.build();
  }

  /// Schedules the future call to run after [delay].
  Future<void> schedule(
    FutureCallRetryPolicy retryPolicy, {
    Duration delay = Duration.zero,
  }) async {
    await _buildManager().scheduleFutureCall(
      _callName,
      null,
      DateTime.now().toUtc().add(delay),
      'default',
      null,
      retryPolicy: retryPolicy,
    );
  }

  /// Runs the due future calls once, with a new future call manager that runs
  /// [testCall] for the future call.
  Future<void> runDueCalls(
    AlwaysFailingTestCall testCall, {
    FutureCallConfig? config,
  }) async {
    var futureCallManager = _buildManager(config: config);
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
  withServerpod(
    'Given a failing future call scheduled with a ChainedRetryPolicies of a built-in policy and a policy declared in the project,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ChainTestHarness harness;
      late AlwaysFailingTestCall testCall;

      setUp(() async {
        harness = _ChainTestHarness(sessionBuilder);
        testCall = AlwaysFailingTestCall();
        await harness.schedule(
          ChainedRetryPolicies([
            const FixedDelayRetryPolicy(
              maxAttempts: 1,
              delay: Duration.zero,
            ),
            TestRetryPolicy(maxAttempts: 1, delay: Duration.zero),
          ]),
        );
      });

      tearDown(() => harness.dispose());

      test(
        'when the due future calls are run once,'
        'then the stored policy is a chain of the same policy classes.',
        () async {
          await harness.runDueCalls(testCall);

          var entries = await harness.findEntries();
          expect(
            harness.storedPolicy(entries.single),
            isA<ChainedRetryPolicies>().having(
              (chain) => chain.policies.map((policy) => policy.runtimeType),
              'policies',
              [FixedDelayRetryPolicy, TestRetryPolicy],
            ),
          );
        },
      );

      group(
        'when the due future calls are run four times,',
        () {
          setUp(() async {
            for (var i = 0; i < 4; i++) {
              await harness.runDueCalls(testCall);
            }
          });

          test(
            'then the call ran three times.',
            () {
              expect(testCall.runs, 3);
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
    'Given a failing future call scheduled with a ChainedRetryPolicies of a policy that keeps state,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ChainTestHarness harness;
      late AlwaysFailingTestCall testCall;

      setUp(() async {
        harness = _ChainTestHarness(sessionBuilder);
        testCall = AlwaysFailingTestCall();
        await harness.schedule(
          ChainedRetryPolicies([TestCountingRetryPolicy(maxAttempts: 5)]),
        );
      });

      tearDown(() => harness.dispose());

      test(
        'when the due future calls are run twice,'
        'then the stored chain holds the state of its policy after both failed runs.',
        () async {
          await harness.runDueCalls(testCall);
          await harness.runDueCalls(testCall);

          var entries = await harness.findEntries();
          var chain =
              harness.storedPolicy(entries.single) as ChainedRetryPolicies;
          expect(
            chain.policies.single,
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
    'Given a future call scheduled in a day with a ChainedRetryPolicies of a policy declared in the project,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ChainTestHarness harness;
      late AlwaysFailingTestCall testCall;

      setUp(() async {
        harness = _ChainTestHarness(sessionBuilder);
        testCall = AlwaysFailingTestCall();
        await harness.schedule(
          ChainedRetryPolicies([
            TestRetryPolicy(maxAttempts: 1, delay: Duration.zero),
          ]),
          delay: const Duration(days: 1),
        );
      });

      tearDown(() => harness.dispose());

      test(
        'when the due future calls are run with the broken call check deleting broken calls,'
        'then the entry is kept because its retry policy can be loaded.',
        () async {
          await harness.runDueCalls(
            testCall,
            config: FutureCallConfig(
              checkBrokenCalls: true,
              deleteBrokenCalls: true,
            ),
          );

          expect(await harness.findEntries(), hasLength(1));
        },
      );
    },
  );

  withServerpod(
    'Given the future call manager,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late _ChainTestHarness harness;

      setUp(() {
        harness = _ChainTestHarness(sessionBuilder);
      });

      tearDown(() => harness.dispose());

      group(
        'when a future call is scheduled with a ChainedRetryPolicies of a policy that is not registered in the protocol,',
        () {
          Object? error;

          setUp(() async {
            try {
              await harness.schedule(
                ChainedRetryPolicies([_UnregisteredRetryPolicy()]),
              );
            } catch (e) {
              error = e;
            }
          });

          test(
            'then an ArgumentError naming the policy class is thrown.',
            () {
              expect(
                error,
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  'Could not find class name for _UnregisteredRetryPolicy in '
                      'serialization.',
                ),
              );
            },
          );

          test(
            'then no entry is stored.',
            () async {
              expect(await harness.findEntries(), isEmpty);
            },
          );
        },
      );
    },
  );
}
