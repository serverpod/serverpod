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

      group('when finding rows with lock mode forUpdate', () {
        test('then the query succeeds and returns the locked rows', () async {
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
      });

      group('when finding rows with lock mode forShare', () {
        test('then the query succeeds and returns the locked rows', () async {
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
      });

      group('when finding a row by id with lock mode forUpdate', () {
        test('then the query succeeds and returns the locked row', () async {
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
      });

      group('when finding first row with lock mode forUpdate', () {
        test('then the query succeeds and returns the locked row', () async {
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
      });

      group('when locking rows without returning data', () {
        test('then the lock is acquired successfully', () async {
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
      });
    },
  );

  withServerpod(
    'Given a table with existing data and a forUpdate lock in place',
    // Concurrency tests require real parallel transactions, which are not
    // compatible with the test framework's database rollback mechanism.
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when finding matching rows with no lock', () {
        test('then the operation completes normally', () async {
          await SimpleData.db.insertRow(session, SimpleData(num: 1));

          var lockAcquired = Completer<void>();
          var testDone = Completer<void>();

          // Transaction 1: acquire an exclusive lock
          var t1 = session.db.transaction((transaction) async {
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

          // Transaction 2: read without lock should succeed immediately
          await session.db.transaction((transaction) async {
            final rows = await SimpleData.db.find(
              session,
              where: (t) => Constant.bool(true),
              transaction: transaction,
            );

            expect(rows.length, 1);
            expect(rows.first.num, 1);
          });

          testDone.complete();
          await t1;
        });
      });

      group('when finding matching rows with noWait', () {
        test('then the operation throws due to rows being locked', () async {
          await SimpleData.db.insertRow(session, SimpleData(num: 1));

          var lockAcquired = Completer<void>();
          var testDone = Completer<void>();

          // Transaction 1: acquire lock and hold it
          var t1 = session.db.transaction((transaction) async {
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

          // Transaction 2: try to lock the same rows with noWait
          await expectLater(
            session.db.transaction((transaction) async {
              await SimpleData.db.find(
                session,
                where: (t) => Constant.bool(true),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.noWait,
                transaction: transaction,
              );
            }),
            throwsA(isA<Exception>()),
          );

          testDone.complete();
          await t1;
        });
      });

      group('when finding matching rows with skipLocked', () {
        test('then only unlocked rows are returned', () async {
          await SimpleData.db.insertRow(session, SimpleData(num: 1));
          await SimpleData.db.insertRow(session, SimpleData(num: 2));

          var lockAcquired = Completer<void>();
          var testDone = Completer<void>();

          // Transaction 1: lock only the first row
          var t1 = session.db.transaction((transaction) async {
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

          // Transaction 2: find with skipLocked should skip the locked row
          await session.db.transaction((transaction) async {
            final rows = await SimpleData.db.find(
              session,
              where: (t) => Constant.bool(true),
              lockMode: LockMode.forUpdate,
              lockBehavior: LockBehavior.skipLocked,
              transaction: transaction,
            );

            expect(rows.length, 1);
            expect(rows.first.num, 2);
          });

          testDone.complete();
          await t1;
        });
      });
    },
  );

  withServerpod(
    'Given a table with existing data and no transaction',
    // Testing that lockMode without a transaction throws requires
    // rollback to be disabled since the test framework wraps calls
    // in a transaction.
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

      group('when using find with lockMode', () {
        test('then throws ArgumentError', () async {
          expect(
            () => SimpleData.db.find(
              session,
              where: (t) => Constant.bool(true),
              lockMode: LockMode.forUpdate,
            ),
            throwsA(isA<ArgumentError>()),
          );
        });
      });

      group('when using findById with lockMode', () {
        test('then throws ArgumentError', () async {
          expect(
            () => SimpleData.db.findById(
              session,
              1,
              lockMode: LockMode.forUpdate,
            ),
            throwsA(isA<ArgumentError>()),
          );
        });
      });

      group('when using findFirstRow with lockMode', () {
        test('then throws ArgumentError', () async {
          expect(
            () => SimpleData.db.findFirstRow(
              session,
              where: (t) => Constant.bool(true),
              lockMode: LockMode.forUpdate,
            ),
            throwsA(isA<ArgumentError>()),
          );
        });
      });
    },
  );
}
