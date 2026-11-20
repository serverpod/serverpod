// Scenarios where a future call entry is deleted after the scanner has fetched
// it but before it is claimed. Claiming such an entry violates the foreign key
// constraint of the claim table, which must not be reported as an exception.
import 'dart:async';
import 'dart:math';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

/// A future call where each invocation is identified by [SimpleData.num].
///
/// An invocation that has a gate waits for [release] before it returns.
class _GatedFutureCall extends FutureCall<SimpleData>
    implements InvokableFutureCall<SimpleData> {
  final _gates = <int, Completer<void>>{};
  final started = <int>[];
  final completed = <int>[];

  void gate(int num) => _gates[num] = Completer<void>();

  void release(int num) {
    final gate = _gates[num];
    if (gate != null && !gate.isCompleted) gate.complete();
  }

  void releaseAll() => _gates.keys.forEach(release);

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    final num = object!.num;
    started.add(num);
    await _gates[num]?.future;
    completed.add(num);
  }
}

/// A future call that runs for a random duration of up to [maxDuration].
class _RandomDurationFutureCall extends FutureCall<SimpleData>
    implements InvokableFutureCall<SimpleData> {
  final Duration maxDuration;
  final _random = Random(1);
  final completed = <int>[];

  _RandomDurationFutureCall(this.maxDuration);

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    if (maxDuration > Duration.zero) {
      await Future.delayed(
        Duration(
          microseconds: _random.nextInt(maxDuration.inMicroseconds),
        ),
      );
    }
    completed.add(object!.num);
  }
}

class _RecordingDiagnosticsService implements FutureCallDiagnosticsService {
  final frameworkExceptions = <Object>[];
  final callExceptions = <Object>[];

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

Future<void> waitUntil(
  FutureOr<bool> Function() condition, {
  required String description,
  Duration timeout = const Duration(seconds: 20),
  Duration pollInterval = const Duration(milliseconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);

  while (!await condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out after $timeout waiting for $description.');
    }

    await Future.delayed(pollInterval);
  }
}

Future<FutureCallEntry> _insertDueEntry(
  Session session, {
  required String name,
  required int num,
  required Duration overdueBy,
  String? identifier,
}) {
  return FutureCallEntry.db.insertRow(
    session,
    FutureCallEntry(
      name: name,
      serializedObject: SerializationManager.encode(
        SimpleData(num: num).toJson(),
      ),
      time: DateTime.now().toUtc().subtract(overdueBy),
      serverId: '1',
      identifier: identifier,
    ),
  );
}

Future<bool> _entryExists(Session session, FutureCallEntry entry) async {
  return await FutureCallEntry.db.findById(session, entry.id!) != null;
}

void main() {
  withServerpod(
    'Given two FutureCallManagers with the default concurrency limit '
    'where the first has a due FutureCall queued behind a running FutureCall '
    'and the second has executed the queued FutureCall,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      const testCallName = 'debug-two-instances-queued';
      const blockerNum = 1;
      const queuedNum = 2;

      late Session session;
      late FutureCallManager busyManager;
      late FutureCallManager idleManager;
      late _GatedFutureCall testCall;
      late _RecordingDiagnosticsService busyDiagnostics;
      late _RecordingDiagnosticsService idleDiagnostics;

      setUp(() async {
        session = sessionBuilder.build();
        final config = FutureCallConfig(
          concurrencyLimit: 1,
          scanInterval: const Duration(milliseconds: 20),
        );

        busyDiagnostics = _RecordingDiagnosticsService();
        idleDiagnostics = _RecordingDiagnosticsService();

        busyManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).withConfig(config).withDiagnosticsService(busyDiagnostics).build();
        idleManager = FutureCallManagerBuilder.fromTestSessionBuilder(
          sessionBuilder,
        ).withConfig(config).withDiagnosticsService(idleDiagnostics).build();

        testCall = _GatedFutureCall()..gate(blockerNum);
        busyManager.registerFutureCall(testCall, testCallName);
        idleManager.registerFutureCall(testCall, testCallName);

        await _insertDueEntry(
          session,
          name: testCallName,
          num: blockerNum,
          overdueBy: const Duration(seconds: 10),
        );
        final queuedEntry = await _insertDueEntry(
          session,
          name: testCallName,
          num: queuedNum,
          overdueBy: const Duration(seconds: 1),
        );

        // The busy instance fetches both entries in one scan, runs the
        // blocker and keeps the other entry in its in-memory queue.
        await busyManager.start();
        await waitUntil(
          () => testCall.started.contains(blockerNum),
          description: 'the busy instance to start the blocker',
        );

        // The idle instance executes and deletes the queued entry.
        await idleManager.start();
        await waitUntil(
          () async => !await _entryExists(session, queuedEntry),
          description: 'the idle instance to execute the queued future call',
        );
      });

      tearDown(() async {
        testCall.releaseAll();
        await busyManager.stop(unregisterAll: true);
        await idleManager.stop(unregisterAll: true);
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      test(
        'when the running FutureCall completes on the first manager,'
        'then no exception is reported for the queued FutureCall.',
        () async {
          testCall.release(blockerNum);

          await busyManager.stop();

          expect(busyDiagnostics.frameworkExceptions, isEmpty);
          expect(idleDiagnostics.frameworkExceptions, isEmpty);
          expect(testCall.completed.where((n) => n == queuedNum), hasLength(1));
        },
      );
    },
  );

  withServerpod(
    'Given a FutureCallManager with a concurrency limit of 2 '
    'where a running FutureCall has been fetched again by a later scan '
    'and is queued behind an older FutureCall,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      const testCallName = 'debug-single-instance-refetch';
      const longRunningNum = 1;
      const olderNum = 2;

      late Session session;
      late FutureCallManager futureCallManager;
      late _GatedFutureCall testCall;
      late _RecordingDiagnosticsService diagnostics;

      setUp(() async {
        session = sessionBuilder.build();
        diagnostics = _RecordingDiagnosticsService();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(
                  sessionBuilder,
                )
                .withConfig(
                  FutureCallConfig(
                    concurrencyLimit: 2,
                    scanInterval: const Duration(milliseconds: 20),
                  ),
                )
                .withDiagnosticsService(diagnostics)
                .build();

        testCall = _GatedFutureCall()
          ..gate(longRunningNum)
          ..gate(olderNum);
        futureCallManager.registerFutureCall(testCall, testCallName);

        await _insertDueEntry(
          session,
          name: testCallName,
          num: longRunningNum,
          overdueBy: const Duration(seconds: 1),
        );

        await futureCallManager.start();
        await waitUntil(
          () => testCall.started.contains(longRunningNum),
          description: 'the long running future call to start',
        );

        // One slot is still free so the scanner keeps scanning. The next
        // scan returns the older entry and the entry that is already running.
        // The older entry takes the free slot and the duplicate is queued.
        await _insertDueEntry(
          session,
          name: testCallName,
          num: olderNum,
          overdueBy: const Duration(seconds: 10),
        );
        await waitUntil(
          () => testCall.started.contains(olderNum),
          description: 'the older future call to start',
        );
      });

      tearDown(() async {
        testCall.releaseAll();
        await futureCallManager.stop(unregisterAll: true);
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      test(
        'when the running FutureCall completes,'
        'then no exception is reported for its queued duplicate.',
        () async {
          testCall.release(longRunningNum);
          await waitUntil(
            () => testCall.completed.contains(longRunningNum),
            description: 'the long running future call to complete',
          );

          // The duplicate is claimed once the slot is free. Stopping waits
          // for it and for the older future call.
          testCall.release(olderNum);
          await futureCallManager.stop();

          expect(diagnostics.frameworkExceptions, isEmpty);
          expect(
            testCall.completed.where((n) => n == longRunningNum),
            hasLength(1),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a FutureCallManager with a due FutureCall queued behind a running FutureCall',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      const testCallName = 'debug-deleted-while-queued';
      const queuedIdentifier = 'debug-deleted-while-queued-id';
      const blockerNum = 1;
      const queuedNum = 2;

      late Session session;
      late FutureCallManager futureCallManager;
      late _GatedFutureCall testCall;
      late _RecordingDiagnosticsService diagnostics;

      setUp(() async {
        session = sessionBuilder.build();
        diagnostics = _RecordingDiagnosticsService();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(
                  sessionBuilder,
                )
                .withConfig(
                  FutureCallConfig(
                    concurrencyLimit: 1,
                    scanInterval: const Duration(milliseconds: 20),
                  ),
                )
                .withDiagnosticsService(diagnostics)
                .build();

        testCall = _GatedFutureCall()..gate(blockerNum);
        futureCallManager.registerFutureCall(testCall, testCallName);

        await _insertDueEntry(
          session,
          name: testCallName,
          num: blockerNum,
          overdueBy: const Duration(seconds: 10),
        );
        await _insertDueEntry(
          session,
          name: testCallName,
          num: queuedNum,
          overdueBy: const Duration(seconds: 1),
          identifier: queuedIdentifier,
        );

        await futureCallManager.start();
        await waitUntil(
          () => testCall.started.contains(blockerNum),
          description: 'the blocker to start',
        );
      });

      tearDown(() async {
        testCall.releaseAll();
        await futureCallManager.stop(unregisterAll: true);
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      test(
        'when the queued FutureCall is cancelled before the running FutureCall completes,'
        'then no exception is reported for the queued FutureCall.',
        () async {
          await futureCallManager.cancelFutureCall(queuedIdentifier);
          testCall.release(blockerNum);

          await futureCallManager.stop();

          expect(diagnostics.frameworkExceptions, isEmpty);
          expect(testCall.completed, isNot(contains(queuedNum)));
        },
      );

      test(
        'when another FutureCallManager that deletes broken calls is started without the FutureCall registered,'
        'then no exception is reported for the queued FutureCall.',
        () async {
          final cleaningManager =
              FutureCallManagerBuilder.fromTestSessionBuilder(
                    sessionBuilder,
                  )
                  .withConfig(
                    FutureCallConfig(
                      checkBrokenCalls: true,
                      deleteBrokenCalls: true,
                    ),
                  )
                  .withDiagnosticsService(_RecordingDiagnosticsService())
                  .build();
          await cleaningManager.start();
          await cleaningManager.stop();

          testCall.release(blockerNum);

          await futureCallManager.stop();

          expect(diagnostics.frameworkExceptions, isEmpty);
          expect(testCall.completed, isNot(contains(queuedNum)));
        },
      );
    },
  );

  // The scenarios below do not control the interleaving. They run a workload
  // that repeatedly hits the window.

  withServerpod(
    'Given two FutureCallManagers with the default concurrency limit and a backlog of due FutureCalls,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      const testCallName = 'debug-two-instances-backlog';
      const backlog = 200;

      late Session session;
      late List<FutureCallManager> managers;
      late List<_RecordingDiagnosticsService> diagnostics;
      late _RandomDurationFutureCall testCall;

      setUp(() async {
        session = sessionBuilder.build();
        testCall = _RandomDurationFutureCall(Duration.zero);
        diagnostics = [
          _RecordingDiagnosticsService(),
          _RecordingDiagnosticsService(),
        ];

        managers = [
          for (final service in diagnostics)
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(
                    concurrencyLimit: 1,
                    scanInterval: const Duration(milliseconds: 20),
                  ),
                )
                .withDiagnosticsService(service)
                .build()
              ..registerFutureCall(testCall, testCallName),
        ];

        for (var i = 0; i < backlog; i++) {
          await _insertDueEntry(
            session,
            name: testCallName,
            num: i,
            overdueBy: Duration(seconds: backlog - i),
          );
        }
      });

      tearDown(() async {
        for (final manager in managers) {
          await manager.stop(unregisterAll: true);
        }
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      test(
        'when both managers are started,'
        'then no exceptions are reported.',
        () async {
          await Future.wait(managers.map((manager) => manager.start()));

          await waitUntil(
            () async =>
                await FutureCallEntry.db.count(
                  session,
                  where: (entry) => entry.name.equals(testCallName),
                ) ==
                0,
            description: 'the backlog to be processed',
            timeout: const Duration(seconds: 60),
          );
          // Let queued duplicates of the last entries reach their claim.
          for (final manager in managers) {
            await manager.stop();
          }

          expect(
            diagnostics.expand((service) => service.frameworkExceptions),
            isEmpty,
          );
          expect(testCall.completed, hasLength(backlog));
        },
      );
    },
  );

  withServerpod(
    'Given a FutureCallManager without a concurrency limit and due FutureCalls that run longer than the scan interval,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      const testCallName = 'debug-unlimited-refetch';
      const backlog = 200;

      late Session session;
      late FutureCallManager futureCallManager;
      late _RecordingDiagnosticsService diagnostics;
      late _RandomDurationFutureCall testCall;

      setUp(() async {
        session = sessionBuilder.build();
        diagnostics = _RecordingDiagnosticsService();
        testCall = _RandomDurationFutureCall(const Duration(milliseconds: 300));

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(
                  sessionBuilder,
                )
                .withConfig(
                  FutureCallConfig(
                    concurrencyLimit: null,
                    scanInterval: const Duration(milliseconds: 1),
                  ),
                )
                .withDiagnosticsService(diagnostics)
                .build();
        futureCallManager.registerFutureCall(testCall, testCallName);

        for (var i = 0; i < backlog; i++) {
          await _insertDueEntry(
            session,
            name: testCallName,
            num: i,
            overdueBy: Duration(seconds: backlog - i),
          );
        }
      });

      tearDown(() async {
        await futureCallManager.stop(unregisterAll: true);
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (entry) => entry.name.equals(testCallName),
        );
        await session.close();
      });

      test(
        'when the manager is started,'
        'then no exceptions are reported.',
        () async {
          await futureCallManager.start();

          await waitUntil(
            () async =>
                await FutureCallEntry.db.count(
                  session,
                  where: (entry) => entry.name.equals(testCallName),
                ) ==
                0,
            description: 'the backlog to be processed',
            timeout: const Duration(seconds: 60),
          );
          // Let duplicates of the last entries reach their claim.
          await futureCallManager.stop();

          expect(diagnostics.frameworkExceptions, isEmpty);
          expect(testCall.completed, hasLength(backlog));
        },
      );
    },
  );
}
