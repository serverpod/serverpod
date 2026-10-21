// A future call entry is deleted after the scanner has fetched it but before
// it is claimed. Claiming such an entry violates the foreign key constraint
// of the claim table, which must not be reported as an exception.
import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

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

void main() {
  withServerpod(
    'Given a FutureCallManager with a due FutureCall queued behind a running FutureCall,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      const testCallName = 'sqlite-deleted-while-queued';
      const queuedIdentifier = 'sqlite-deleted-while-queued-id';
      const blockerNum = 1;
      const queuedNum = 2;

      late Session session;
      late FutureCallManager futureCallManager;
      late _GatedFutureCall testCall;
      late _RecordingDiagnosticsService diagnostics;

      setUp(() async {
        session = sessionBuilder.build();
        diagnostics = _RecordingDiagnosticsService();

        futureCallManager = FutureCallManager(
          FutureCallConfig(
            concurrencyLimit: 1,
            scanInterval: const Duration(milliseconds: 20),
          ),
          Protocol(),
          diagnosticsService: diagnostics,
          internalSession: sessionBuilder.build(),
          logSession: sessionBuilder.build(),
          sessionProvider: (_, _) => sessionBuilder.build(),
          initializeFutureCall: (_, _) {},
        );

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
    },
  );
}
