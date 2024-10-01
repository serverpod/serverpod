import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given TestToolsEndpoint',
    (endpoints, session) {
      test(
          'when calling createSimpleData then creates a SimpleData in the database',
          () async {
        await endpoints.testTools.createSimpleData(session, 123);

        final result = await SimpleData.db.find(session);
        expect(result.length, 1);
        expect(result.first.num, 123);
      });

      group('when two calls to createSimpleData with different sessions', () {
        late TestSession firstSession;
        late TestSession secondSession;
        setUp(() async {
          firstSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              111,
              {},
            ),
          );
          secondSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              222,
              {},
            ),
          );

          await endpoints.testTools.createSimpleData(firstSession, 111);
          await endpoints.testTools.createSimpleData(secondSession, 222);
        });

        test('then the first session can see the created data', () async {
          var fetchedSimpleDatas =
              await endpoints.testTools.getAllSimpleData(firstSession);
          expect(fetchedSimpleDatas.length, 2);
          expect(fetchedSimpleDatas[0].num, 111);
          expect(fetchedSimpleDatas[1].num, 222);
        });
        test('then the second session can see the created data', () async {
          var fetchedSimpleDatas =
              await endpoints.testTools.getAllSimpleData(secondSession);
          expect(fetchedSimpleDatas.length, 2);
          expect(fetchedSimpleDatas[0].num, 111);
          expect(fetchedSimpleDatas[1].num, 222);
        });
        test('then the original session can see the created data', () async {
          var fetchedSimpleDatas =
              await endpoints.testTools.getAllSimpleData(session);
          expect(fetchedSimpleDatas.length, 2);
          expect(fetchedSimpleDatas[0].num, 111);
          expect(fetchedSimpleDatas[1].num, 222);
        });
      });

      group('when calling getAllSimpleData', () {
        setUp(() async {
          await SimpleData.db.insert(session, [
            SimpleData(num: 111),
            SimpleData(num: 222),
          ]);
        });

        test('then returns all SimpleData in the database', () async {
          var result = await endpoints.testTools.getAllSimpleData(session);

          expect(result.length, 2);

          var nums = result.map((e) => e.num).toList();
          expect(nums, containsAll([111, 222]));
        });
      });
    },
    runMode: ServerpodRunMode.production,
  );

  withServerpod(
    'Given TestToolsEndpoint and rollbackDatabase afterEach',
    (endpoints, session) {
      group('when calling createSimpleDatasInsideTransactions', () {
        setUpAll(() async {
          await endpoints.testTools
              .createSimpleDatasInsideTransactions(session, 123);
        });

        test("then finds SimpleDatas", () async {
          final simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas.length, 2);
          expect(simpleDatas[0].num, 123);
          expect(simpleDatas[1].num, 123);
        });

        test('then should have been rolled back in the next test', () async {
          var simpleDatas = await SimpleData.db.find(session);

          expect(simpleDatas, hasLength(0));
        });
      });

      group('when calling createSimpleDataAndThrowInsideTransaction', () {
        setUpAll(() async {
          try {
            await endpoints.testTools
                .createSimpleDataAndThrowInsideTransaction(session, 123);
          } catch (e) {}
        });

        test('then only one transaction should have been comitted', () async {
          var simpleDatas = await SimpleData.db.find(session);

          expect(simpleDatas, hasLength(1));
          expect(simpleDatas.first.num, 123);
        });

        test('then should have been rolled back in the next test', () async {
          var simpleDatas = await SimpleData.db.find(session);

          expect(simpleDatas, hasLength(0));
        });
      });

      group('when calling createSimpleDatasInParallelTransactionCalls', () {
        late Future endpointCall;
        setUpAll(() async {
          endpointCall = endpoints.testTools
              .createSimpleDatasInParallelTransactionCalls(session);
        });

        test('then should enter invariant state and throw', () async {
          await expectLater(
            endpointCall,
            throwsA(
              allOf(
                isA<InvalidConfigurationException>(),
                predicate<InvalidConfigurationException>(
                  (e) => e.message.contains(
                      'Several calls to `transaction` was made concurrently which is not supported with the current database test configuration. '
                      'Disable rolling back the database by setting `databaseTestConfig` to `RollbackDatabase.disabled`.'),
                ),
              ),
            ),
          );
        });

        test('then should have been rolled back in the next test', () async {
          var simpleDatas = await SimpleData.db.find(session);

          expect(simpleDatas, hasLength(0));
        });
      });
    },
    runMode: ServerpodRunMode.production,
    rollbackDatabase: RollbackDatabase.afterEach,
  );

  group('Given TestToolsEndpoint and rollbackDatabase afterAll', () {
    group('when calling createSimpleDatasInsideTransactions', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUpAll(() async {
            await endpoints.testTools
                .createSimpleDatasInsideTransactions(session, 123);
          });

          test("then finds SimpleDatas", () async {
            final simpleDatas = await SimpleData.db.find(session);
            expect(simpleDatas.length, 2);
            expect(simpleDatas[0].num, 123);
            expect(simpleDatas[1].num, 123);
          });

          test('then should not have been rolled back in the next test',
              () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(2));
            expect(simpleDatas[0].num, 123);
            expect(simpleDatas[1].num, 123);
          });
        },
        runMode: ServerpodRunMode.production,
        rollbackDatabase: RollbackDatabase.afterAll,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (endpoints, session) {
          test('then should have been rolled back', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(0));
          });
        },
        runMode: ServerpodRunMode.production,
      );
    });

    group('when calling createSimpleDataAndThrowInsideTransaction', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUpAll(() async {
            try {
              await endpoints.testTools
                  .createSimpleDataAndThrowInsideTransaction(session, 123);
            } catch (e) {}
          });

          test('then only one transaction should have been comitted', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(1));
            expect(simpleDatas.first.num, 123);
          });
        },
        rollbackDatabase: RollbackDatabase.afterAll,
        runMode: ServerpodRunMode.production,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (endpoints, session) {
          test('then should have been rolled back', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(0));
          });
        },
        runMode: ServerpodRunMode.production,
      );
    });

    group('when calling createSimpleDatasInParallelTransactionCalls', () {
      withServerpod(
        '',
        (endpoints, session) {
          test('then should enter invariant state and throw', () async {
            await expectLater(
              endpoints.testTools
                  .createSimpleDatasInParallelTransactionCalls(session),
              throwsA(
                allOf(
                  isA<InvalidConfigurationException>(),
                  predicate<InvalidConfigurationException>(
                    (e) => e.message.contains(
                      'Several calls to `transaction` was made concurrently which is not supported with the current database test configuration. '
                      'Disable rolling back the database by setting `databaseTestConfig` to `RollbackDatabase.disabled`.',
                    ),
                  ),
                ),
              ),
            );
          });
        },
        rollbackDatabase: RollbackDatabase.afterAll,
        runMode: ServerpodRunMode.production,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (endpoints, session) {
          test('then should have been rolled back', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(0));
          });
        },
        runMode: ServerpodRunMode.production,
      );
    });
  });

  group('Given TestToolsEndpoint and rollbackDatabase disabled', () {
    group('when calling createSimpleDatasInsideTransactions', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUpAll(() async {
            await endpoints.testTools
                .createSimpleDatasInsideTransactions(session, 123);
          });

          test("then finds SimpleDatas in the test", () async {
            final simpleDatas = await SimpleData.db.find(session);
            expect(simpleDatas.length, 2);
            expect(simpleDatas[0].num, 123);
            expect(simpleDatas[1].num, 123);
          });

          test('then should not have been rolled back in the next test',
              () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(2));
            expect(simpleDatas[0].num, 123);
            expect(simpleDatas[1].num, 123);
          });
        },
        runMode: ServerpodRunMode.production,
        rollbackDatabase: RollbackDatabase.disabled,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (endpoints, session) {
          tearDownAll(() async {
            await SimpleData.db.deleteWhere(
              session,
              where: (_) => Constant.bool(true),
            );
          });

          test(
              'then should not have been rolled back and has to be deleted manually',
              () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(2));
            expect(simpleDatas[0].num, 123);
            expect(simpleDatas[1].num, 123);
          });
        },
        runMode: ServerpodRunMode.production,
        rollbackDatabase: RollbackDatabase.disabled,
      );
    });

    group('when calling createSimpleDataAndThrowInsideTransaction', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUpAll(() async {
            try {
              await endpoints.testTools
                  .createSimpleDataAndThrowInsideTransaction(session, 123);
            } catch (e) {}
          });

          test('then only one transaction should have been comitted', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(1));
            expect(simpleDatas.first.num, 123);
          });
        },
        rollbackDatabase: RollbackDatabase.disabled,
        runMode: ServerpodRunMode.production,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (endpoints, session) {
          tearDownAll(() async {
            await SimpleData.db.deleteWhere(
              session,
              where: (_) => Constant.bool(true),
            );
          });

          test('then only committed data should have persisted', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(1));
          });
        },
        rollbackDatabase: RollbackDatabase.disabled,
        runMode: ServerpodRunMode.production,
      );
    });

    withServerpod(
      'when calling createSimpleDatasInParallelTransactionCalls',
      (endpoints, session) {
        setUpAll(() async {
          await endpoints.testTools
              .createSimpleDatasInParallelTransactionCalls(session);
        });

        tearDownAll(() async {
          await SimpleData.db.deleteWhere(
            session,
            where: (_) => Constant.bool(true),
          );
        });

        test('then should execute and commit all transactions', () async {
          var simpleDatas = await SimpleData.db.find(session);

          expect(simpleDatas, hasLength(4));
        });
      },
      rollbackDatabase: RollbackDatabase.disabled,
      runMode: ServerpodRunMode.production,
    );
  });
}
