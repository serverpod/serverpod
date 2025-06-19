import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() async {
  withServerpod(
    'Given `withServerpod` with rollback after each test,`',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        // ignore: invalid_use_of_visible_for_testing_member
        assert(session.transaction != null);
      });

      test(
          'when creating a transaction with `transactionOrSavepoint` without passing in the test transaction, '
          'then the data is visible inside and outside of the transaction.',
          () async {
        await DatabaseUtil.runInTransactionOrSavepoint(
          session.db,
          null,
          (final transaction) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            );

            expect(
              await SimpleData.db.count(session, transaction: transaction),
              1,
            );
            expect(
              await SimpleData.db.count(session),
              1,
            );
          },
        );

        expect(
          await SimpleData.db.count(session),
          1,
        );
      });

      test(
          'when creating a transaction with `transactionOrSavepoint` based upon the test transaction, '
          'then the data is visible inside and outside of the explicitly passed transaction.',
          () async {
        await DatabaseUtil.runInTransactionOrSavepoint(
          session.db,
          // ignore: invalid_use_of_visible_for_testing_member
          session.transaction!,
          (final transaction) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            );

            expect(
              await SimpleData.db.count(session, transaction: transaction),
              1,
            );
            expect(
              await SimpleData.db.count(session),
              1,
            );
          },
        );

        expect(
          await SimpleData.db.count(session),
          1,
        );
      });

      test(
          'when throwing inside the `transactionOrSavepoint` (without the test transaction) callback after a write, '
          'then the write is not observable outside.', () async {
        try {
          await DatabaseUtil.runInTransactionOrSavepoint(
            session.db,
            null,
            (final transaction) async {
              await SimpleData.db.insertRow(
                session,
                SimpleData(num: 1),
                transaction: transaction,
              );

              expect(
                await SimpleData.db.count(session, transaction: transaction),
                1,
              );

              throw _ForcedTestException();
            },
          );
        } on _ForcedTestException catch (_) {}

        expect(
          await SimpleData.db.count(session),
          0,
        );
      });

      test(
          'when throwing inside the `transactionOrSavepoint` (with the test transaction) callback after a write, '
          'then the write is not observable outside.', () async {
        try {
          await DatabaseUtil.runInTransactionOrSavepoint(
            session.db,
            // ignore: invalid_use_of_visible_for_testing_member
            session.transaction!,
            (final transaction) async {
              await SimpleData.db.insertRow(
                session,
                SimpleData(num: 1),
                transaction: transaction,
              );

              expect(
                await SimpleData.db.count(session, transaction: transaction),
                1,
              );

              throw _ForcedTestException();
            },
          );
        } on _ForcedTestException catch (_) {}

        expect(
          await SimpleData.db.count(session),
          0,
        );
      });

      test(
          'when throwing inside the `transactionOrSavepoint` (with the transaction from db.transaction) callback after a write, '
          'then the write is not observable outside.', () async {
        try {
          await session.db.transaction((transaction) async {
            await DatabaseUtil.runInTransactionOrSavepoint(
              session.db,
              transaction,
              (final transaction) async {
                await SimpleData.db.insertRow(
                  session,
                  SimpleData(num: 1),
                  transaction: transaction,
                );

                expect(
                  await SimpleData.db.count(session, transaction: transaction),
                  1,
                );

                throw _ForcedTestException();
              },
            );
          });
        } on _ForcedTestException catch (_) {}

        expect(
          await SimpleData.db.count(session),
          0,
        );
      });
    },
    rollbackDatabase: RollbackDatabase.afterEach,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
  );

  withServerpod(
    'Given `withServerpod` with rollback disabled,`',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();

        // ignore: invalid_use_of_visible_for_testing_member
        expect(session.transaction, isNull);
      });

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
      });

      test(
          'when creating a transaction with `transactionOrSavepoint`, '
          'then the data is visible only on the transaction until the closure completes.',
          () async {
        await DatabaseUtil.runInTransactionOrSavepoint(
          session.db,
          null,
          (final transaction) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            );

            expect(
              await SimpleData.db.count(session, transaction: transaction),
              1,
            );
            expect(
              await SimpleData.db.count(session),
              0,
            );
          },
        );

        expect(
          await SimpleData.db.count(session),
          1,
        );
      });

      test(
          'when creating two independent transactions with `transactionOrSavepoint`, '
          'then the data is visible only to each transaction that wrote it.',
          () async {
        await DatabaseUtil.runInTransactionOrSavepoint(
          session.db,
          null,
          (final transaction1) async {
            await DatabaseUtil.runInTransactionOrSavepoint(
              session.db,
              null,
              (final transaction2) async {
                await SimpleData.db.insertRow(
                  session,
                  SimpleData(num: 1),
                  transaction: transaction2,
                );
                await SimpleData.db.insertRow(
                  session,
                  SimpleData(num: 2),
                  transaction: transaction1,
                );

                expect(
                  await SimpleData.db.count(session, transaction: transaction1),
                  1,
                );
                expect(
                  await SimpleData.db.count(session, transaction: transaction2),
                  1,
                );
              },
            );
          },
        );

        expect(
          await SimpleData.db.count(session),
          2,
        );
      });

      test(
        'when creating savepoint under an existing transaction with `transactionOrSavepoint`, '
        'then both closures work on the exact same transaction.',
        () async {
          await DatabaseUtil.runInTransactionOrSavepoint(
            session.db,
            null,
            (final transaction1) async {
              await SimpleData.db.insertRow(
                session,
                SimpleData(num: 1),
                transaction: transaction1,
              );

              await DatabaseUtil.runInTransactionOrSavepoint(
                session.db,
                transaction1,
                (final transaction2) async {
                  expect(identical(transaction1, transaction2), isTrue);
                },
              );
            },
          );
        },
      );

      test(
          'when creating savepoint under an existing transaction with `transactionOrSavepoint`, '
          'then the data is visible in both closures (as they use the same underlying transaction).',
          () async {
        await DatabaseUtil.runInTransactionOrSavepoint(
          session.db,
          null,
          (final transaction1) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction1,
            );

            await DatabaseUtil.runInTransactionOrSavepoint(
              session.db,
              transaction1,
              (final transaction2) async {
                await SimpleData.db.insertRow(
                  session,
                  SimpleData(num: 2),
                  transaction: transaction2,
                );

                expect(
                  await SimpleData.db.count(session, transaction: transaction1),
                  2,
                );
                expect(
                  await SimpleData.db.count(session, transaction: transaction2),
                  2,
                );
              },
            );

            expect(
              await SimpleData.db.count(session, transaction: transaction1),
              2,
            );
          },
        );

        expect(
          await SimpleData.db.count(session),
          2,
        );
      });

      test(
          'when throwing in a nested savepoint callback, '
          'then the parent transaction can still be completed and its data be visible on the outside.',
          () async {
        await DatabaseUtil.runInTransactionOrSavepoint(
          session.db,
          null,
          (final transaction1) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction1,
            );

            try {
              await DatabaseUtil.runInTransactionOrSavepoint(
                session.db,
                transaction1,
                (final transaction2) async {
                  await SimpleData.db.insertRow(
                    session,
                    SimpleData(num: 2),
                    transaction: transaction1,
                  );

                  expect(
                    await SimpleData.db
                        .count(session, transaction: transaction2),
                    2,
                  );

                  throw _ForcedTestException();
                },
              );
            } on _ForcedTestException catch (_) {}
          },
        );

        expect(
          await SimpleData.db.count(session),
          1,
        );
      });

      test(
          'when throwing in a nested transaction callback, '
          'then the data written with the transaction is not visible on the outside.',
          () async {
        try {
          await DatabaseUtil.runInTransactionOrSavepoint(
            session.db,
            null,
            (final transaction) async {
              await SimpleData.db.insertRow(
                session,
                SimpleData(num: 1),
                transaction: transaction,
              );
              await SimpleData.db.insertRow(
                session,
                SimpleData(num: 2),
              );

              expect(
                await SimpleData.db.count(session, transaction: transaction),
                2,
              );

              throw _ForcedTestException();
            },
          );
        } on _ForcedTestException catch (_) {}

        expect(
          await SimpleData.db.count(session),
          1,
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
  );
}

class _ForcedTestException implements Exception {}
