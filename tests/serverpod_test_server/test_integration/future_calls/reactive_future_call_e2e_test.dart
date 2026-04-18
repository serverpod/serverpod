import 'dart:async';

import 'package:serverpod/protocol.dart' show ReactiveDatabaseCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

/// End-to-end coverage for reactive future calls. Exercises the full chain:
/// real DB insert -> real Postgres trigger fires -> outbox row written ->
/// scanner claims -> FutureCallEntry created -> _runFutureCall invokes react.
///
/// Complements the scenario-focused reactive_future_call_test.dart by
/// validating pieces that are otherwise only exercised in production:
/// trigger SQL actually parses and executes in Postgres, row_to_json(NEW)
/// output deserializes back into a typed model, and the outbox is emptied
/// after a completed batch.
class _E2EReactiveCall extends SimpleDataReactiveFutureCall {
  final Completer<List<SimpleData>> firstBatch = Completer<List<SimpleData>>();
  final List<List<SimpleData>> receivedBatches = [];

  @override
  WhereExpressionBuilder<SimpleDataTable> get where =>
      (t) => const Expression('TRUE');

  @override
  Future<void> react(Session session, List<SimpleData> objects) async {
    receivedBatches.add(objects);
    if (!firstBatch.isCompleted) {
      firstBatch.complete(objects);
    }
  }
}

void main() {
  withServerpod(
    'Given a reactive future call registered with a real trigger manager',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _E2EReactiveCall reactiveCall;

      setUp(() async {
        session = sessionBuilder.build();
        reactiveCall = _E2EReactiveCall();

        futureCallManager =
            FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                .withConfig(
                  FutureCallConfig(
                    scanInterval: const Duration(milliseconds: 50),
                  ),
                )
                .build();

        futureCallManager.registerFutureCall(
          reactiveCall,
          'e2eReactiveSimpleData',
        );
        await futureCallManager.start();
      });

      tearDown(() async {
        await futureCallManager.stop(unregisterAll: true);
        await SimpleData.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
        await ReactiveDatabaseCallEntry.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
      });

      group('when a row is inserted into the watched table', () {
        setUp(() async {
          await SimpleData.db.insertRow(session, SimpleData(num: 1337));
        });

        test('then react is invoked with the inserted data', () async {
          final batch = await reactiveCall.firstBatch.future.timeout(
            const Duration(seconds: 5),
          );

          expect(batch, hasLength(1));
          expect(batch.first.num, 1337);
        });

        test('then the outbox is cleaned up after execution', () async {
          await reactiveCall.firstBatch.future.timeout(
            const Duration(seconds: 5),
          );

          // Allow the FutureCallEntry cascade delete to propagate.
          await Future.delayed(const Duration(milliseconds: 300));

          final remaining = await ReactiveDatabaseCallEntry.db.find(
            session,
            where: (t) => t.handlerName.equals('e2eReactiveSimpleData'),
          );
          expect(remaining, isEmpty);
        });
      });

      group('when multiple rows are inserted before a scan completes', () {
        setUp(() async {
          for (var i = 0; i < 3; i++) {
            await SimpleData.db.insertRow(session, SimpleData(num: i));
          }
        });

        test('then react is invoked once with all rows batched', () async {
          final batch = await reactiveCall.firstBatch.future.timeout(
            const Duration(seconds: 5),
          );

          expect(batch, hasLength(3));
          expect(batch.map((d) => d.num).toSet(), {0, 1, 2});
          expect(reactiveCall.receivedBatches, hasLength(1));
        });
      });
    },
  );
}
