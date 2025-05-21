import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() async {
  group('Given a non-test `Session` implementation,', () {
    late Session session;

    setUp(() async {
      session = await IntegrationTestServer().session();
    });

    tearDown(() async {
      await SimpleData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
    });

    test(
        'when inspecting the session, '
        'then it does not have an implicit transaction attached to it.',
        () async {
      // ignore: invalid_use_of_visible_for_testing_member
      expect(session.transaction, isNull);
    });

    test(
        'when creating a transaction with `transactionOrSavepoint`, '
        'then the data is visible only on the transaction until the closure completes.',
        () async {
      await DatabaseUtil.transactionOrSavepoint(
        session.db,
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
        transaction: null,
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
      await DatabaseUtil.transactionOrSavepoint(
        session.db,
        (final transaction1) async {
          await DatabaseUtil.transactionOrSavepoint(
            session.db,
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
            transaction: null,
          );
        },
        transaction: null,
      );

      expect(
        await SimpleData.db.count(session),
        2,
      );
    });

    test(
        'when creating savepoint under an existing transaction with `transactionOrSavepoint`, '
        'then the data is visible only to each transaction argument given to the callback.',
        () async {
      await DatabaseUtil.transactionOrSavepoint(
        session.db,
        (final transaction1) async {
          await SimpleData.db.insertRow(
            session,
            SimpleData(num: 1),
            transaction: transaction1,
          );

          await DatabaseUtil.transactionOrSavepoint(
            session.db,
            (final transaction2) async {
              expect(identical(transaction1, transaction2), isTrue);

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
            transaction: transaction1,
          );

          expect(
            await SimpleData.db.count(session, transaction: transaction1),
            2,
          );
        },
        transaction: null,
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
      await DatabaseUtil.transactionOrSavepoint(
        session.db,
        (final transaction1) async {
          await SimpleData.db.insertRow(
            session,
            SimpleData(num: 1),
            transaction: transaction1,
          );

          try {
            await DatabaseUtil.transactionOrSavepoint(
              session.db,
              (final transaction2) async {
                await SimpleData.db.insertRow(
                  session,
                  SimpleData(num: 2),
                  transaction: transaction1,
                );

                expect(
                  await SimpleData.db.count(session, transaction: transaction2),
                  2,
                );

                throw _ForcedTestException();
              },
              transaction: transaction1,
            );
          } on _ForcedTestException catch (_) {}
        },
        transaction: null,
      );

      expect(
        await SimpleData.db.count(session),
        1,
      );
    });

    test(
        'when throwing in a nested transaction callback, '
        'then the the data written with the transaction is not visible on the outside.',
        () async {
      try {
        await DatabaseUtil.transactionOrSavepoint(
          session.db,
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
          transaction: null,
        );
      } on _ForcedTestException catch (_) {}

      expect(
        await SimpleData.db.count(session),
        1,
      );
    });
  });

  withServerpod(
    'Given `withServerpod` with rollback after each test,`',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

      test(
          'when inspecting the session, '
          'then it does have an implicit transaction attached to it.',
          () async {
        // ignore: invalid_use_of_visible_for_testing_member
        expect(session.transaction, isNotNull);
      });

      test(
          'when creating a transaction with `transactionOrSavepoint` without passing in the test transaction, '
          'then the data is visible inside and outside of the transaction.',
          () async {
        await DatabaseUtil.transactionOrSavepoint(
          session.db,
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
          transaction: null,
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
        await DatabaseUtil.transactionOrSavepoint(
          session.db,
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
          // ignore: invalid_use_of_visible_for_testing_member
          transaction: session.transaction!,
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
          await DatabaseUtil.transactionOrSavepoint(
            session.db,
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
            transaction: null,
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
          await DatabaseUtil.transactionOrSavepoint(
            session.db,
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
            // ignore: invalid_use_of_visible_for_testing_member
            transaction: session.transaction!,
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
            await DatabaseUtil.transactionOrSavepoint(
              session.db,
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
              transaction: transaction,
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
  );

  withServerpod(
    'Given `withServerpod` with rollback disabled,`',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
      });

      test(
          'when inspecting the session, '
          'then it does not have an implicit transaction attached to it.',
          () async {
        // ignore: invalid_use_of_visible_for_testing_member
        expect(session.transaction, isNull);
      });

      test(
          'when creating a transaction with `transactionOrSavepoint`, '
          'then the data is visible only on the transaction until the closure completes.',
          () async {
        await DatabaseUtil.transactionOrSavepoint(
          session.db,
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
          transaction: null,
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
        await DatabaseUtil.transactionOrSavepoint(
          session.db,
          (final transaction1) async {
            await DatabaseUtil.transactionOrSavepoint(
              session.db,
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
              transaction: null,
            );
          },
          transaction: null,
        );

        expect(
          await SimpleData.db.count(session),
          2,
        );
      });

      test(
          'when creating savepoint under an existing transaction with `transactionOrSavepoint`, '
          'then the data is visible only to each transaction argument given to the callback.',
          () async {
        await DatabaseUtil.transactionOrSavepoint(
          session.db,
          (final transaction1) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction1,
            );

            await DatabaseUtil.transactionOrSavepoint(
              session.db,
              (final transaction2) async {
                expect(identical(transaction1, transaction2), isTrue);

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
              transaction: transaction1,
            );

            expect(
              await SimpleData.db.count(session, transaction: transaction1),
              2,
            );
          },
          transaction: null,
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
        await DatabaseUtil.transactionOrSavepoint(
          session.db,
          (final transaction1) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction1,
            );

            try {
              await DatabaseUtil.transactionOrSavepoint(session.db,
                  (final transaction2) async {
                await SimpleData.db.insertRow(
                  session,
                  SimpleData(num: 2),
                  transaction: transaction1,
                );

                expect(
                  await SimpleData.db.count(session, transaction: transaction2),
                  2,
                );

                throw _ForcedTestException();
              }, transaction: transaction1);
            } on _ForcedTestException catch (_) {}
          },
          transaction: null,
        );

        expect(
          await SimpleData.db.count(session),
          1,
        );
      });

      test(
          'when throwing in a nested transaction callback, '
          'then the the data written with the transaction is not visible on the outside.',
          () async {
        try {
          await DatabaseUtil.transactionOrSavepoint(
            session.db,
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
            transaction: null,
          );
        } on _ForcedTestException catch (_) {}

        expect(
          await SimpleData.db.count(session),
          1,
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

class _ForcedTestException implements Exception {}
