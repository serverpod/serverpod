import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a table with existing data',
    (sessionBuilder, _) {
      late Session session;
      late SimpleData insertedRow;

      setUp(() async {
        session = sessionBuilder.build();
        insertedRow = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 42),
        );
      });

      test('when finding rows with lock mode forUpdate '
          'then the query succeeds and returns the locked rows.', () async {
        await session.db.transaction((transaction) async {
          final rows = await SimpleData.db.find(
            session,
            where: (t) => t.id.equals(insertedRow.id!),
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );

          expect(rows.length, 1);
          expect(rows.first.num, 42);
        });
      });

      test('when finding rows with lock mode forShare '
          'then the query succeeds and returns the locked rows.', () async {
        await session.db.transaction((transaction) async {
          final rows = await SimpleData.db.find(
            session,
            where: (t) => t.id.equals(insertedRow.id!),
            lockMode: LockMode.forShare,
            transaction: transaction,
          );

          expect(rows.length, 1);
          expect(rows.first.num, 42);
        });
      });

      test('when finding a row by id with lock mode forUpdate '
          'then the query succeeds and returns the locked row.', () async {
        await session.db.transaction((transaction) async {
          final row = await SimpleData.db.findById(
            session,
            insertedRow.id!,
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );

          expect(row, isNotNull);
          expect(row!.num, 42);
        });
      });

      test('when finding first row with lock mode forUpdate '
          'then the query succeeds and returns the locked row.', () async {
        await session.db.transaction((transaction) async {
          final row = await SimpleData.db.findFirstRow(
            session,
            where: (t) => t.num.equals(42),
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );

          expect(row, isNotNull);
          expect(row!.num, 42);
        });
      });

      test('when locking rows without returning data '
          'then the query succeeds and the row is still accessible.', () async {
        await session.db.transaction((transaction) async {
          await SimpleData.db.lockRows(
            session,
            where: (t) => t.id.equals(insertedRow.id!),
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );

          // Verify the row is still accessible within the same transaction
          final rows = await SimpleData.db.find(
            session,
            where: (t) => t.id.equals(insertedRow.id!),
            transaction: transaction,
          );

          expect(rows.length, 1);
        });
      });
    },
  );

  withServerpod(
    'Given a table with existing data and a forUpdate lock in place that holds all rows acquired using find method',
    // Concurrency tests require real parallel transactions, which are not
    // compatible with the test framework's database rollback mechanism.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late Session session;
      late Completer<void> lockAcquired;
      late Completer<void> testDone;
      late Future<void> t1;

      setUp(() async {
        session = sessionBuilder.build();

        await SimpleData.db.insertRow(session, SimpleData(num: 1));
        await SimpleData.db.insertRow(session, SimpleData(num: 2));

        lockAcquired = Completer<void>();
        testDone = Completer<void>();

        // Transaction 1: acquire an exclusive lock
        t1 = session.db.transaction((transaction) async {
          await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );
          lockAcquired.complete();
          await testDone.future;
        });

        await lockAcquired.future;
      });

      tearDown(() async {
        testDone.complete();
        await t1;

        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test('when finding matching rows with no lock '
          'then all rows are returned.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 2);
        expect(rows.first.num, 1);
        expect(rows.last.num, 2);
      });

      test('when finding matching rows with noWait '
          'then the operation throws due to rows being locked.', () async {
        final t2 = session.db.transaction((transaction) async {
          await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, throwsA(isA<Exception>()));
      });

      test('when finding matching rows with skipLocked '
          'then all rows are skipped.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.skipLocked,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows, isEmpty);
      });
    },
  );

  withServerpod(
    'Given a table with existing data and a forUpdate lock in place that holds part of the rows acquired using find method',
    // Concurrency tests require real parallel transactions, which are not
    // compatible with the test framework's database rollback mechanism.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late Session session;
      late Completer<void> lockAcquired;
      late Completer<void> testDone;
      late Future<void> t1;

      setUp(() async {
        session = sessionBuilder.build();

        await SimpleData.db.insertRow(session, SimpleData(num: 1));
        await SimpleData.db.insertRow(session, SimpleData(num: 2));

        lockAcquired = Completer<void>();
        testDone = Completer<void>();

        // Transaction 1: acquire an exclusive lock
        t1 = session.db.transaction((transaction) async {
          await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(1),
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );
          lockAcquired.complete();
          await testDone.future;
        });

        await lockAcquired.future;
      });

      tearDown(() async {
        testDone.complete();
        await t1;

        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test('when finding matching rows with noWait '
          'then the operation throws due to rows being locked.', () async {
        final t2 = session.db.transaction((transaction) async {
          await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(1),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, throwsA(isA<Exception>()));
      });

      test('when finding not matching rows with noWait '
          'then the rows are returned.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(2),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });

      test('when finding all rows with skipLocked '
          'then only matching rows are skipped.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.skipLocked,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });
    },
  );

  withServerpod(
    'Given a table with existing data and a forUpdate lock in place that holds part of the rows acquired using findById method',
    // Concurrency tests require real parallel transactions, which are not
    // compatible with the test framework's database rollback mechanism.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late Session session;
      late Completer<void> lockAcquired;
      late Completer<void> testDone;
      late Future<void> t1;

      setUp(() async {
        session = sessionBuilder.build();

        final row1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
        await SimpleData.db.insertRow(session, SimpleData(num: 2));

        lockAcquired = Completer<void>();
        testDone = Completer<void>();

        // Transaction 1: acquire an exclusive lock
        t1 = session.db.transaction((transaction) async {
          await SimpleData.db.findById(
            session,
            row1.id!,
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );
          lockAcquired.complete();
          await testDone.future;
        });

        await lockAcquired.future;
      });

      tearDown(() async {
        testDone.complete();
        await t1;

        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test('when finding matching rows with noWait '
          'then the operation throws due to rows being locked.', () async {
        final t2 = session.db.transaction((transaction) async {
          await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(1),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, throwsA(isA<Exception>()));
      });

      test('when finding not matching rows with noWait '
          'then the rows are returned.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(2),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });

      test('when finding all rows with skipLocked '
          'then only matching rows are skipped.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.skipLocked,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });
    },
  );

  withServerpod(
    'Given a table with existing data and a forUpdate lock in place that holds part of the rows acquired using findFirstRow method',
    // Concurrency tests require real parallel transactions, which are not
    // compatible with the test framework's database rollback mechanism.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late Session session;
      late Completer<void> lockAcquired;
      late Completer<void> testDone;
      late Future<void> t1;

      setUp(() async {
        session = sessionBuilder.build();

        await SimpleData.db.insertRow(session, SimpleData(num: 1));
        await SimpleData.db.insertRow(session, SimpleData(num: 2));

        lockAcquired = Completer<void>();
        testDone = Completer<void>();

        // Transaction 1: acquire an exclusive lock
        t1 = session.db.transaction((transaction) async {
          await SimpleData.db.findFirstRow(
            session,
            where: (t) => t.num.equals(1),
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );
          lockAcquired.complete();
          await testDone.future;
        });

        await lockAcquired.future;
      });

      tearDown(() async {
        testDone.complete();
        await t1;

        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test('when finding matching rows with noWait '
          'then the operation throws due to rows being locked.', () async {
        final t2 = session.db.transaction((transaction) async {
          await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(1),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, throwsA(isA<Exception>()));
      });

      test('when finding not matching rows with noWait '
          'then the rows are returned.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(2),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });

      test('when finding all rows with skipLocked '
          'then only matching rows are skipped.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.skipLocked,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });
    },
  );

  withServerpod(
    'Given a table with existing data and a forUpdate lock in place that holds part of the rows acquired using lockRows method',
    // Concurrency tests require real parallel transactions, which are not
    // compatible with the test framework's database rollback mechanism.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late Session session;
      late Completer<void> lockAcquired;
      late Completer<void> testDone;
      late Future<void> t1;

      setUp(() async {
        session = sessionBuilder.build();

        await SimpleData.db.insertRow(session, SimpleData(num: 1));
        await SimpleData.db.insertRow(session, SimpleData(num: 2));

        lockAcquired = Completer<void>();
        testDone = Completer<void>();

        // Transaction 1: acquire an exclusive lock
        t1 = session.db.transaction((transaction) async {
          await SimpleData.db.lockRows(
            session,
            where: (t) => t.num.equals(1),
            lockMode: LockMode.forUpdate,
            transaction: transaction,
          );
          lockAcquired.complete();
          await testDone.future;
        });

        await lockAcquired.future;
      });

      tearDown(() async {
        testDone.complete();
        await t1;

        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test('when finding matching rows with noWait '
          'then the operation throws due to rows being locked.', () async {
        final t2 = session.db.transaction((transaction) async {
          await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(1),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, throwsA(isA<Exception>()));
      });

      test('when finding not matching rows with noWait '
          'then the rows are returned.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(2),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.noWait,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });

      test('when finding all rows with skipLocked '
          'then only matching rows are skipped.', () async {
        final t2 = session.db.transaction((transaction) async {
          return await SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
            lockBehavior: LockBehavior.skipLocked,
            transaction: transaction,
          );
        });

        await expectLater(t2, completes);
        final rows = await t2;

        expect(rows.length, 1);
        expect(rows.first.num, 2);
      });
    },
  );

  withServerpod(
    'Given a table with existing data and a lock attempt with no transaction',
    // Testing that lockMode without a transaction throws requires rollback to
    // be disabled since the test framework wraps calls in a transaction.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        await SimpleData.db.insertRow(session, SimpleData(num: 1));
      });

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test('when using find with lockMode '
          'then throws ArgumentError.', () async {
        expect(
          () => SimpleData.db.find(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('when using findById with lockMode '
          'then throws ArgumentError.', () async {
        expect(
          () => SimpleData.db.findById(
            session,
            1,
            lockMode: LockMode.forUpdate,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('when using findFirstRow with lockMode '
          'then throws ArgumentError.', () async {
        expect(
          () => SimpleData.db.findFirstRow(
            session,
            where: (t) => Constant.bool(true),
            lockMode: LockMode.forUpdate,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    },
  );
}
