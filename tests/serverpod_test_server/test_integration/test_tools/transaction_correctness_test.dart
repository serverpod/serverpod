import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given transaction call in test and rollbacks are enabled',
    rollbackDatabase: RollbackDatabase.afterEach,
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test('when inserting an object '
          'then should be persisted if transaction completes', () async {
        await session.db.transaction((transaction) async {
          await SimpleData.db.insertRow(
            session,
            SimpleData(num: 1),
            transaction: transaction,
          );
        });

        var simpleDatas = await SimpleData.db.find(session);
        expect(simpleDatas, hasLength(1));
        expect(simpleDatas.first.num, 1);
      });

      test(
        'when inserting an object '
        'then should be possible to observe the object inside transaction but not after if aborted',
        () async {
          var numberOfSimpleDatasInsideTransaction = 0;
          try {
            await session.db.transaction((transaction) async {
              await SimpleData.db.insertRow(
                session,
                SimpleData(num: 1),
                transaction: transaction,
              );

              var simpleDatas = await SimpleData.db.find(
                session,
                transaction: transaction,
              );
              numberOfSimpleDatasInsideTransaction = simpleDatas.length;

              throw Exception('Abort transaction');
            });
          } catch (_) {}

          var simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas, hasLength(0));
          expect(numberOfSimpleDatasInsideTransaction, 1);
        },
      );

      test('when inserting objects in parallel '
          'then should be persisted if transaction completes', () async {
        await session.db.transaction((transaction) async {
          await Future.wait([
            SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            ),
            SimpleData.db.insertRow(
              session,
              SimpleData(num: 2),
              transaction: transaction,
            ),
            SimpleData.db.insertRow(
              session,
              SimpleData(num: 3),
              transaction: transaction,
            ),
          ]);
        });

        var simpleDatas = await SimpleData.db.find(session);

        expect(simpleDatas, hasLength(3));
        expect(simpleDatas.map((s) => s.num), containsAll([1, 2, 3]));
      });

      test('when inserting an object in parallel to a transaction'
          'then should throw exception due to concurrent operations', () async {
        var future = Future.wait([
          session.db.transaction((transaction) {
            return SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            );
          }),
          SimpleData.db.insertRow(session, SimpleData(num: 2)),
        ]);

        await expectLater(
          future,
          throwsA(
            allOf(
              isA<InvalidConfigurationException>(),
              (e) =>
                  e.message ==
                  'Concurrent database calls outside an already active transaction '
                      'are not supported when database rollbacks are enabled. '
                      'If this is intended, disable rolling back the '
                      'database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
            ),
          ),
        );
      });

      test('when inserting an object without transaction but is executed inside a transaction'
          'then should throw exception due to concurrent operations', () async {
        var future = session.db.transaction((tx) async {
          await SimpleData.db.insertRow(
            session,
            SimpleData(num: 1),
            transaction: null,
          );
        });

        await expectLater(
          future,
          throwsA(
            allOf(
              isA<InvalidConfigurationException>(),
              (e) =>
                  e.message ==
                  'Concurrent database calls outside an already active transaction '
                      'are not supported when database rollbacks are enabled. '
                      'If this is intended, disable rolling back the '
                      'database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
            ),
          ),
        );
      });

      test('when executing transactions in parallel'
          'then should throw exception due to concurrent operations', () async {
        var future = Future.wait([
          session.db.transaction((tx) async {}),
          session.db.transaction((tx) async {}),
        ]);

        await expectLater(
          future,
          throwsA(
            allOf(
              isA<InvalidConfigurationException>(),
              (e) =>
                  e.message ==
                  'Concurrent calls to transaction are not supported when database rollbacks are enabled. '
                      'Disable rolling back the database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
            ),
          ),
        );
      });

      test('when database exception occurs '
          'then should not fail `dart test` by leaking exceptions', () async {
        var future = session.db.transaction((transaction) async {
          var data = UniqueData(number: 1, email: 'test@test.com');
          await UniqueData.db.insertRow(
            session,
            data,
            transaction: transaction,
          );
          await UniqueData.db.insertRow(
            session,
            data,
            transaction: transaction,
          );
        });

        // Even though this exception is caught in this test, due to how transactions work
        // the exception will be re-thrown when the top level test transaction is canceled.
        // If the top level transaction error is not caught this test will fail.
        // Therefore, this test validates that the exception is caught on the top level
        // and does not fail the dart test runner.
        await expectLater(
          future,
          throwsA(
            isA<DatabaseQueryException>().having(
              (e) => e.code,
              'code',
              PgErrorCode.uniqueViolation,
            ),
          ),
        );
      });

      group('when non-database exception occurs', () {
        late Future<Never> throwingTransactionFuture;

        setUp(() {
          throwingTransactionFuture = session.db.transaction((
            transaction,
          ) async {
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            );

            throw ArgumentError('Custom error that is not a DatabaseException');
          });
        });

        test('then the non-database exception should be thrown', () async {
          await expectLater(
            throwingTransactionFuture,
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Custom error that is not a DatabaseException',
              ),
            ),
          );
        });

        test('then subsequent queries should work correctly', () async {
          // We need to wait for the transaction to complete and rollback
          // before executing another query to the database.
          // This expectLater is used for that purpose and is not supposed to
          // actually test anything since we already tested this above.
          await expectLater(
            throwingTransactionFuture,
            throwsA(isA<ArgumentError>()),
          );

          await expectLater(
            SimpleData.db.insertRow(session, SimpleData(num: 10)),
            completes,
          );
        });
      });

      test('when next test is run '
          'then database operations should still work', () async {
        await SimpleData.db.insertRow(session, SimpleData(num: 1));

        expect(await SimpleData.db.find(session), hasLength(1));
      });
    },
  );

  withServerpod(
    'Given transaction calls when rollbacks are disabled',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        );
      });

      test('when inserting an object in parallel to a transaction'
          'then should persist both', () async {
        await Future.wait([
          session.db.transaction((transaction) {
            return SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            );
          }),
          SimpleData.db.insertRow(session, SimpleData(num: 2)),
        ]);
        var simpleDatas = await SimpleData.db.find(session);
        expect(simpleDatas, hasLength(2));
        expect(simpleDatas.map((s) => s.num), containsAll([1, 2]));
      });

      test(
        'when inserting an object without transaction but is executed inside a transaction'
        'then should persist object',
        () async {
          await session.db.transaction((tx) async {
            // This is a theoretical scenario that would likely be
            // considered erroneous in real code
            await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: null,
            );
          });

          var simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas, hasLength(1));
          expect(simpleDatas.first.num, 1);
        },
      );

      test('when inserting objects inside transactions in parallel'
          'then should persist objects', () async {
        await Future.wait([
          session.db.transaction(
            (transaction) => SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
              transaction: transaction,
            ),
          ),
          session.db.transaction(
            (transaction) => SimpleData.db.insertRow(
              session,
              SimpleData(num: 2),
              transaction: transaction,
            ),
          ),
        ]);

        var simpleDatas = await SimpleData.db.find(session);
        expect(simpleDatas, hasLength(2));
        expect(simpleDatas.map((s) => s.num), containsAll([1, 2]));
      });
    },
  );

  group('Demontrate transaction difference between prod and test tools', () {
    withServerpod(
      'Given transaction call in test with database rollbacks enabled (default)',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();
        test(
          'when database exception occurs '
          'then transaction WILL NOT throw exception if it was caught in the transaction',
          () async {
            var future = session.db.transaction((tx) async {
              var data = UniqueData(number: 1, email: 'test@test.com');
              try {
                await UniqueData.db.insertRow(session, data);
                await UniqueData.db.insertRow(session, data);
              } catch (_) {}
            });

            // ATTENTION: This does not throw in test tools when rollbacks are enabled,
            // but does throw in production environment where rollbacks are disabled!
            await expectLater(future, completes);
          },
        );
      },
    );

    withServerpod(
      'Given transaction call in test with database rollbacks disabled',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();

        test(
          'when database exception occurs '
          'then transaction WILL throw exception even if it was caught in the transaction',
          () async {
            var future = session.db.transaction((tx) async {
              var data = UniqueData(number: 1, email: 'test@test.com');
              try {
                await UniqueData.db.insertRow(session, data, transaction: tx);
                await UniqueData.db.insertRow(session, data, transaction: tx);
              } catch (_) {}
            });

            // ATTENTION: This does not throw in test tools when rollbacks are enabled,
            // but does throw in production environment where rollbacks are disabled!
            await expectLater(future, throwsA(isA<Exception>()));
          },
        );
      },
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    );
  });
}
