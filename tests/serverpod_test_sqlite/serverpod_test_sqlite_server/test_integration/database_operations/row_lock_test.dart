import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
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

  // NOTE: SQLite has no row-level locking and does not allow recursive locks,
  // so there is no point in testing the lock modes and behaviors. For SQLite,
  // passing such options will be no-op and the query will succeed. We'll only
  // test the warnings that are logged when these options are used.

  withServerpod(
    'Given a database session with logging enabled and a table with existing data',
    enableSessionLogging: true,
    configOverride: (config) => config.copyWith(
      sessionLogs: config.sessionLogs.copyWith(
        consoleEnabled: true,
        consoleLogFormat: ConsoleLogFormat.text,
      ),
    ),
    (sessionBuilder, _) {
      late Session session;
      late MockStdout record;
      late SimpleData insertedRow;

      setUp(() async {
        session = sessionBuilder.build();
        record = MockStdout();
        insertedRow = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 42),
        );
      });

      tearDown(() async {
        await session.close();
      });

      test('when finding rows with lock behavior wait, '
          'then the query succeeds and no warning is logged.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              final rows = await SimpleData.db.find(
                session,
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.wait,
                transaction: transaction,
              );

              expect(rows, hasLength(1));
              expect(rows.first.id, insertedRow.id);
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(record.output, isEmpty);
      });

      test('when finding a row by id with lock behavior wait, '
          'then the query succeeds and no warning is logged.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              final row = await SimpleData.db.findById(
                session,
                insertedRow.id!,
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.wait,
                transaction: transaction,
              );

              expect(row, isNotNull);
              expect(row!.id, insertedRow.id);
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(record.output, isEmpty);
      });

      test('when finding first row with lock behavior wait, '
          'then the query succeeds and no warning is logged.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              final row = await SimpleData.db.findFirstRow(
                session,
                where: (t) => t.num.equals(42),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.wait,
                transaction: transaction,
              );

              expect(row, isNotNull);
              expect(row!.num, 42);
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(record.output, isEmpty);
      });

      test('when locking rows with lock behavior wait, '
          'then the operation succeeds and no warning is logged.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.lockRows(
                session,
                where: (t) => t.id.equals(insertedRow.id!),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.wait,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(record.output, isEmpty);
      });

      test('when finding rows with lock behavior noWait, '
          'then a warning is logged that the lock behavior is ignored.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.find(
                session,
                where: (t) => t.id.equals(insertedRow.id!),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.noWait,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(
          record.output,
          contains(
            'The lock behavior "LockBehavior.noWait" has no effect when finding rows '
            'on SQLite because SQLite does not support concurrent writes and the '
            'transaction will acquire a lock implicitly. To suppress this warning, '
            'either skip locking or use "LockBehavior.wait".',
          ),
        );
      });

      test('when finding a row by id with lock behavior noWait, '
          'then a warning is logged that the lock behavior is ignored.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.findById(
                session,
                insertedRow.id!,
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.noWait,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(
          record.output,
          contains(
            'The lock behavior "LockBehavior.noWait" has no effect when finding rows '
            'on SQLite because SQLite does not support concurrent writes and the '
            'transaction will acquire a lock implicitly. To suppress this warning, '
            'either skip locking or use "LockBehavior.wait".',
          ),
        );
      });

      test('when finding first row with lock behavior noWait, '
          'then a warning is logged that the lock behavior is ignored.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.findFirstRow(
                session,
                where: (t) => t.num.equals(42),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.noWait,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(
          record.output,
          contains(
            'The lock behavior "LockBehavior.noWait" has no effect when finding rows '
            'on SQLite because SQLite does not support concurrent writes and the '
            'transaction will acquire a lock implicitly. To suppress this warning, '
            'either skip locking or use "LockBehavior.wait".',
          ),
        );
      });

      test('when locking rows with lock behavior noWait, '
          'then a warning is logged that the lock behavior is ignored.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.lockRows(
                session,
                where: (t) => t.id.equals(insertedRow.id!),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.noWait,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(
          record.output,
          contains(
            'The lock behavior "LockBehavior.noWait" has no effect when locking rows '
            'on SQLite because SQLite does not support concurrent writes and the '
            'transaction will acquire a lock implicitly. To suppress this warning, '
            'either skip locking or use "LockBehavior.wait".',
          ),
        );
      });

      test('when locking rows with lock behavior skipLocked, '
          'then a warning is logged that the lock behavior is ignored.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.lockRows(
                session,
                where: (t) => t.id.equals(insertedRow.id!),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.skipLocked,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(
          record.output,
          contains(
            'The lock behavior "LockBehavior.skipLocked" has no effect when locking rows '
            'on SQLite because SQLite does not support concurrent writes and the '
            'transaction will acquire a lock implicitly. To suppress this warning, '
            'either skip locking or use "LockBehavior.wait".',
          ),
        );
      });

      test('when finding rows with lock behavior skipLocked, '
          'then a warning is logged that the lock behavior is ignored.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.find(
                session,
                where: (t) => t.id.equals(insertedRow.id!),
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.skipLocked,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(
          record.output,
          contains(
            'The lock behavior "LockBehavior.skipLocked" has no effect when finding rows '
            'on SQLite because SQLite does not support concurrent writes and the '
            'transaction will acquire a lock implicitly. To suppress this warning, '
            'either skip locking or use "LockBehavior.wait".',
          ),
        );
      });

      test('when finding a row by id with lock behavior skipLocked, '
          'then a warning is logged that the lock behavior is ignored.', () async {
        await IOOverrides.runZoned(
          () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.findById(
                session,
                insertedRow.id!,
                lockMode: LockMode.forUpdate,
                lockBehavior: LockBehavior.skipLocked,
                transaction: transaction,
              );
            });
            await session.close();
          },
          stdout: () => record,
        );

        expect(
          record.output,
          contains(
            'The lock behavior "LockBehavior.skipLocked" has no effect when finding rows '
            'on SQLite because SQLite does not support concurrent writes and the '
            'transaction will acquire a lock implicitly. To suppress this warning, '
            'either skip locking or use "LockBehavior.wait".',
          ),
        );
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
