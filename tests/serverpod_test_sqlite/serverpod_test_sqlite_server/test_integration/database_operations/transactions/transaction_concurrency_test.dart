import 'dart:async';

import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a write transaction and a read operation made concurrently without a transaction from the same zone',
    // Rollbacks must be disabled or SQLite will have the test transaction.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      late Future<void> writeTransaction;
      late Completer<void> finishedWriting;
      late Completer<void> finishTransaction;

      setUp(() async {
        finishedWriting = Completer<void>();
        finishTransaction = Completer<void>();

        await SimpleData.db.insertRow(
          session,
          SimpleData(num: 117),
        );

        writeTransaction = session.db.transaction((transaction) async {
          await SimpleData.db.insertRow(
            session,
            SimpleData(num: 118),
            transaction: transaction,
          );

          // Operation made on the same zone as the active transaction.
          // This is forbidden by default on `sqlite_async` driver.
          final simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas, hasLength(1));
          expect(simpleDatas.first.num, 117);

          finishedWriting.complete();
          await finishTransaction.future;
        });
      });

      tearDown(() async {
        if (!finishTransaction.isCompleted) {
          finishTransaction.complete();

          // Await to ensure the transaction is finished. We can't use
          // await writeTransaction because, if it fails, the test will hang.
          // In success cases, this is a no-op, since the transaction will have
          // already completed.
          await Future.delayed(const Duration(milliseconds: 100));
        }

        await SimpleData.db.deleteWhere(
          session,
          where: (t) => t.num.inSet({117, 118}),
        );
      });

      test(
        'when awaiting the operation then the it succeeds.',
        () async {
          finishTransaction.complete();
          await expectLater(writeTransaction, completes);
        },
      );

      test(
        'when performing another read operation concurrently then both succeed.',
        () async {
          // This operation succeeds regardless of the transaction.
          final simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas, hasLength(1));
          expect(simpleDatas.first.num, 117);

          finishTransaction.complete();
          await finishedWriting.future;
          await expectLater(writeTransaction, completes);

          final newSimpleDatas = await SimpleData.db.find(session);
          expect(newSimpleDatas, hasLength(2));
          expect(newSimpleDatas.map((s) => s.num), containsAll([117, 118]));
        },
      );
    },
  );
}
