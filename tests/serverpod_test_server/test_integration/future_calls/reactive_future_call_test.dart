import 'dart:async';

import 'package:serverpod/protocol.dart' show ReactiveDatabaseCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class _ReactiveCallWithCondition extends SimpleDataReactiveFutureCall {
  final Completer<List<SimpleData>> completer = Completer<List<SimpleData>>();

  @override
  WhereExpressionBuilder<SimpleDataTable> get where =>
      (t) => t.num > const Expression(0);

  @override
  Future<void> react(Session session, List<SimpleData> objects) async {
    if (!completer.isCompleted) {
      completer.complete(objects);
    }
  }
}

class _HasChangedCall extends UniqueDataReactiveFutureCall {
  final List<List<UniqueData>> receivedBatches = [];
  final Completer<void> firstBatch = Completer<void>();

  @override
  WhereExpressionBuilder<UniqueDataTable> get where =>
      (t) => t.number.hasChanged();

  @override
  Future<void> react(Session session, List<UniqueData> objects) async {
    receivedBatches.add(objects);
    if (!firstBatch.isCompleted) {
      firstBatch.complete();
    }
  }
}

class _TransactionSafetyCall extends SimpleDataReactiveFutureCall {
  final List<List<SimpleData>> receivedBatches = [];
  final Completer<void> firstBatch = Completer<void>();

  @override
  WhereExpressionBuilder<SimpleDataTable> get where =>
      (t) => const Expression('TRUE');

  @override
  Future<void> react(Session session, List<SimpleData> objects) async {
    receivedBatches.add(objects);
    if (!firstBatch.isCompleted) {
      firstBatch.complete();
    }
  }
}

class _ReactiveCallAll extends SimpleDataReactiveFutureCall {
  final List<List<SimpleData>> receivedBatches = [];
  final Completer<void> firstBatch = Completer<void>();

  @override
  WhereExpressionBuilder<SimpleDataTable> get where =>
      (t) => const Expression('TRUE');

  @override
  Future<void> react(Session session, List<SimpleData> objects) async {
    receivedBatches.add(objects);
    if (!firstBatch.isCompleted) {
      firstBatch.complete();
    }
  }
}

void main() {
  withServerpod(
    'Given a ReactiveFutureCall with a condition registered and started',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _ReactiveCallWithCondition reactiveCall;

      setUp(() async {
        session = sessionBuilder.build();
        reactiveCall = _ReactiveCallWithCondition();

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
          'testReactiveCondition',
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

      group('when inserting a row that matches the condition', () {
        setUp(() async {
          await SimpleData.db.insertRow(session, SimpleData(num: 42));
        });

        test('then react is called with the inserted data', () async {
          final result = await reactiveCall.completer.future.timeout(
            const Duration(seconds: 5),
          );

          expect(result, hasLength(1));
          expect(result.first.num, 42);
        });
      });

      group('when inserting a row that does not match the condition', () {
        setUp(() async {
          await SimpleData.db.insertRow(session, SimpleData(num: -1));
        });

        test('then react is not called', () async {
          await Future.delayed(const Duration(milliseconds: 300));

          expect(reactiveCall.completer.isCompleted, isFalse);
        });
      });
    },
  );

  withServerpod(
    'Given a ReactiveFutureCall without filtering registered and started',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _ReactiveCallAll reactiveCall;

      setUp(() async {
        session = sessionBuilder.build();
        reactiveCall = _ReactiveCallAll();

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
          'testReactiveAll',
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

      group('when inserting multiple rows', () {
        setUp(() async {
          await SimpleData.db.insert(session, [
            SimpleData(num: 1),
            SimpleData(num: 2),
            SimpleData(num: 3),
          ]);
        });

        test('then react is called with all inserted rows', () async {
          await reactiveCall.firstBatch.future.timeout(
            const Duration(seconds: 5),
          );

          final allObjects = reactiveCall.receivedBatches
              .expand((b) => b)
              .toList();

          expect(allObjects.length, greaterThanOrEqualTo(3));
        });
      });

      group('when deleting a row', () {
        setUp(() async {
          final insertedRow = await SimpleData.db.insertRow(
            session,
            SimpleData(num: 99),
          );
          // Wait for insert outbox entry to be processed
          await reactiveCall.firstBatch.future.timeout(
            const Duration(seconds: 5),
          );
          reactiveCall.receivedBatches.clear();

          await SimpleData.db.deleteRow(session, insertedRow);
          // Wait for delete outbox entry to be processed
          await Future.delayed(const Duration(milliseconds: 200));
        });

        test('then react is called for the delete operation', () async {
          expect(reactiveCall.receivedBatches, isNotEmpty);
        });
      });
    },
  );

  withServerpod(
    'Given a ReactiveFutureCall with hasChanged condition registered and started',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _HasChangedCall reactiveCall;

      setUp(() async {
        session = sessionBuilder.build();
        reactiveCall = _HasChangedCall();

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
          'testHasChanged',
        );
        await futureCallManager.start();
      });

      tearDown(() async {
        await futureCallManager.stop(unregisterAll: true);
        await UniqueData.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
        await ReactiveDatabaseCallEntry.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
      });

      group('when inserting a row', () {
        setUp(() async {
          await UniqueData.db.insertRow(
            session,
            UniqueData(number: 1, email: 'haschanged@test.com'),
          );
          // hasChanged trigger is UPDATE-only, so insert should not fire
          await Future.delayed(const Duration(milliseconds: 300));
        });

        test('then react is not called', () async {
          expect(reactiveCall.firstBatch.isCompleted, isFalse);
        });
      });

      group('when updating the watched column', () {
        setUp(() async {
          final row = await UniqueData.db.insertRow(
            session,
            UniqueData(number: 10, email: 'update-watched@test.com'),
          );
          // Insert does not fire hasChanged trigger
          await Future.delayed(const Duration(milliseconds: 100));

          await UniqueData.db.updateRow(
            session,
            row.copyWith(number: 20),
          );
        });

        test('then react is called with the updated data', () async {
          await reactiveCall.firstBatch.future.timeout(
            const Duration(seconds: 5),
          );

          final allObjects = reactiveCall.receivedBatches
              .expand((b) => b)
              .toList();

          expect(allObjects, isNotEmpty);
          expect(allObjects.first.number, 20);
        });
      });

      group('when updating only an unwatched column', () {
        setUp(() async {
          final row = await UniqueData.db.insertRow(
            session,
            UniqueData(number: 30, email: 'unwatched@test.com'),
          );
          await Future.delayed(const Duration(milliseconds: 100));

          // Update email but not number — hasChanged(number) should not fire
          await UniqueData.db.updateRow(
            session,
            row.copyWith(email: 'unwatched-changed@test.com'),
          );
          await Future.delayed(const Duration(milliseconds: 300));
        });

        test('then react is not called', () async {
          expect(reactiveCall.firstBatch.isCompleted, isFalse);
        });
      });
    },
  );

  withServerpod(
    'Given a ReactiveFutureCall registered and started when a transaction is committed',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late FutureCallManager futureCallManager;
      late Session session;
      late _TransactionSafetyCall reactiveCall;

      setUp(() async {
        session = sessionBuilder.build();
        reactiveCall = _TransactionSafetyCall();

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
          'testTransactionCommit',
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

      group('when inserting a row inside a committed transaction', () {
        setUp(() async {
          await session.db.transaction((transaction) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 888),
            );
          });
        });

        test('then react is called with the committed data', () async {
          await reactiveCall.firstBatch.future.timeout(
            const Duration(seconds: 5),
          );

          final allObjects = reactiveCall.receivedBatches
              .expand((b) => b)
              .toList();

          expect(allObjects, isNotEmpty);
          expect(allObjects.first.num, 888);
        });
      });
    },
  );
}
