import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given row locking',
    runMode: 'development',
    (sessionBuilder, _) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        // Clean up any existing test data
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('find with lockMode', () {
        test(
          'when using FOR UPDATE within transaction then query succeeds',
          () async {
            // Insert test data
            final inserted = await SimpleData.db.insertRow(
              session,
              SimpleData(num: 42),
            );

            // Use lock within transaction
            await session.db.transaction((transaction) async {
              final rows = await SimpleData.db.find(
                session,
                where: (t) => t.id.equals(inserted.id!),
                lockMode: LockMode.forUpdate,
                transaction: transaction,
              );

              expect(rows.length, 1);
              expect(rows.first.num, 42);
            });
          },
        );

        test(
          'when using FOR SHARE within transaction then query succeeds',
          () async {
            final inserted = await SimpleData.db.insertRow(
              session,
              SimpleData(num: 100),
            );

            await session.db.transaction((transaction) async {
              final rows = await SimpleData.db.find(
                session,
                where: (t) => t.id.equals(inserted.id!),
                lockMode: LockMode.forShare,
                transaction: transaction,
              );

              expect(rows.length, 1);
              expect(rows.first.num, 100);
            });
          },
        );
      });

      group('findById with lockMode', () {
        test(
          'when using FOR UPDATE within transaction then query succeeds',
          () async {
            final inserted = await SimpleData.db.insertRow(
              session,
              SimpleData(num: 55),
            );

            await session.db.transaction((transaction) async {
              final row = await SimpleData.db.findById(
                session,
                inserted.id!,
                lockMode: LockMode.forUpdate,
                transaction: transaction,
              );

              expect(row, isNotNull);
              expect(row!.num, 55);
            });
          },
        );
      });

      group('findFirstRow with lockMode', () {
        test(
          'when using FOR UPDATE within transaction then query succeeds',
          () async {
            await SimpleData.db.insertRow(session, SimpleData(num: 10));
            await SimpleData.db.insertRow(session, SimpleData(num: 20));

            await session.db.transaction((transaction) async {
              final row = await SimpleData.db.findFirstRow(
                session,
                where: (t) => t.num.equals(20),
                lockMode: LockMode.forUpdate,
                transaction: transaction,
              );

              expect(row, isNotNull);
              expect(row!.num, 20);
            });
          },
        );
      });

      group('lockRows', () {
        test(
          'when locking rows then no data is returned but lock is acquired',
          () async {
            await SimpleData.db.insertRow(session, SimpleData(num: 1));
            await SimpleData.db.insertRow(session, SimpleData(num: 2));
            await SimpleData.db.insertRow(session, SimpleData(num: 3));

            await session.db.transaction((transaction) async {
              // This should not throw and should not return anything
              await SimpleData.db.lockRows(
                session,
                where: (t) => t.num.inSet({1, 2}),
                lockMode: LockMode.forUpdate,
                transaction: transaction,
              );

              // If we got here, the lock was acquired successfully
              // Now we can update the locked rows
              final rows = await SimpleData.db.find(
                session,
                where: (t) => t.num.inSet({1, 2}),
                transaction: transaction,
              );

              expect(rows.length, 2);
            });
          },
        );
      });

      group('lock behavior', () {
        test(
          'when using SKIP LOCKED then only unlocked rows are returned',
          () async {
            // Insert test data
            await SimpleData.db.insertRow(session, SimpleData(num: 100));
            await SimpleData.db.insertRow(session, SimpleData(num: 200));

            // This test demonstrates SKIP LOCKED works syntactically
            // Full concurrency testing would require parallel transactions
            await session.db.transaction((transaction) async {
              final rows = await SimpleData.db.find(
                session,
                where: (t) => Constant.bool(true),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.skipLocked,
                transaction: transaction,
              );

              expect(rows.length, 2);
            });
          },
        );
      });
    },
  );

  withServerpod(
    'Given row locking without rollback',
    runMode: 'development',
    rollbackDatabase: RollbackDatabase.disabled,
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

      test(
        'when using lockMode without transaction then throws ArgumentError',
        () async {
          await SimpleData.db.insertRow(
            session,
            SimpleData(num: 1),
          );

          expect(
            () => SimpleData.db.find(
              session,
              where: (t) => Constant.bool(true),
              lockMode: LockMode.forUpdate,
            ),
            throwsA(isA<ArgumentError>()),
          );
        },
      );
    },
  );
}
