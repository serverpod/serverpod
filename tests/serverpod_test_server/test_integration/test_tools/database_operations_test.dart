import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given TestToolsEndpoint',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test(
        'when calling createSimpleData then creates a SimpleData in the database',
        () async {
          await endpoints.testTools.createSimpleData(sessionBuilder, 123);

          final result = await SimpleData.db.find(session);
          expect(result.length, 1);
          expect(result.first.num, 123);
        },
      );

      group(
        'when two calls to createSimpleData with different session builders',
        () {
          late TestSessionBuilder firstSessionBuilder;
          late TestSessionBuilder secondSessionBuilder;
          setUp(() async {
            firstSessionBuilder = sessionBuilder.copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                '111',
                {},
              ),
            );
            secondSessionBuilder = sessionBuilder.copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                '222',
                {},
              ),
            );

            await endpoints.testTools.createSimpleData(
              firstSessionBuilder,
              111,
            );
            await endpoints.testTools.createSimpleData(
              secondSessionBuilder,
              222,
            );
          });

          test(
            'then the first session builder can see the created data',
            () async {
              var fetchedSimpleDatas = await endpoints.testTools
                  .getAllSimpleData(firstSessionBuilder);
              expect(fetchedSimpleDatas.length, 2);
              expect(fetchedSimpleDatas[0].num, 111);
              expect(fetchedSimpleDatas[1].num, 222);
            },
          );
          test(
            'then the second session builder can see the created data',
            () async {
              var fetchedSimpleDatas = await endpoints.testTools
                  .getAllSimpleData(secondSessionBuilder);
              expect(fetchedSimpleDatas.length, 2);
              expect(fetchedSimpleDatas[0].num, 111);
              expect(fetchedSimpleDatas[1].num, 222);
            },
          );
          test(
            'then the original session builder can see the created data',
            () async {
              var fetchedSimpleDatas = await endpoints.testTools
                  .getAllSimpleData(sessionBuilder);
              expect(fetchedSimpleDatas.length, 2);
              expect(fetchedSimpleDatas[0].num, 111);
              expect(fetchedSimpleDatas[1].num, 222);
            },
          );
        },
      );

      group('when calling getAllSimpleData', () {
        setUp(() async {
          await SimpleData.db.insert(session, [
            SimpleData(num: 111),
            SimpleData(num: 222),
          ]);
        });

        test('then returns all SimpleData in the database', () async {
          var result = await endpoints.testTools.getAllSimpleData(
            sessionBuilder,
          );

          expect(result.length, 2);

          var nums = result.map((e) => e.num).toList();
          expect(nums, containsAll([111, 222]));
        });
      });
    },
  );

  withServerpod(
    'Given TestToolsEndpoint and rollbackDatabase afterEach',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();
      group('when calling createSimpleDatasInsideTransactions', () {
        setUpAll(() async {
          await endpoints.testTools.createSimpleDatasInsideTransactions(
            sessionBuilder,
            123,
          );
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
            await endpoints.testTools.createSimpleDataAndThrowInsideTransaction(
              sessionBuilder,
              123,
            );
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
              .createSimpleDatasInParallelTransactionCalls(sessionBuilder);
        });

        test('then should enter invariant state and throw', () async {
          await expectLater(
            endpointCall,
            throwsA(
              allOf(
                isA<InvalidConfigurationException>(),
                predicate<InvalidConfigurationException>(
                  (e) => e.message.contains(
                    'Concurrent calls to transaction are not supported when database rollbacks are enabled. '
                    'Disable rolling back the database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
                  ),
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
    rollbackDatabase: RollbackDatabase.afterEach,
  );

  group('Given TestToolsEndpoint and rollbackDatabase afterAll', () {
    group('when calling createSimpleDatasInsideTransactions', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

          setUpAll(() async {
            await endpoints.testTools.createSimpleDatasInsideTransactions(
              sessionBuilder,
              123,
            );
          });

          test("then finds SimpleDatas", () async {
            final simpleDatas = await SimpleData.db.find(session);
            expect(simpleDatas.length, 2);
            expect(simpleDatas[0].num, 123);
            expect(simpleDatas[1].num, 123);
          });

          test(
            'then should not have been rolled back in the next test',
            () async {
              var simpleDatas = await SimpleData.db.find(session);

              expect(simpleDatas, hasLength(2));
              expect(simpleDatas[0].num, 123);
              expect(simpleDatas[1].num, 123);
            },
          );
        },
        rollbackDatabase: RollbackDatabase.afterAll,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
          test('then should have been rolled back', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(0));
          });
        },
      );
    });

    group('when calling createSimpleDataAndThrowInsideTransaction', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

          setUpAll(() async {
            try {
              await endpoints.testTools
                  .createSimpleDataAndThrowInsideTransaction(
                    sessionBuilder,
                    123,
                  );
            } catch (e) {}
          });

          test('then only one transaction should have been comitted', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(1));
            expect(simpleDatas.first.num, 123);
          });
        },
        rollbackDatabase: RollbackDatabase.afterAll,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
          test('then should have been rolled back', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(0));
          });
        },
      );
    });

    group('when calling createSimpleDatasInParallelTransactionCalls', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          test('then should enter invariant state and throw', () async {
            await expectLater(
              endpoints.testTools.createSimpleDatasInParallelTransactionCalls(
                sessionBuilder,
              ),
              throwsA(
                allOf(
                  isA<InvalidConfigurationException>(),
                  predicate<InvalidConfigurationException>(
                    (e) => e.message.contains(
                      'Concurrent calls to transaction are not supported when database rollbacks are enabled. '
                      'Disable rolling back the database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
                    ),
                  ),
                ),
              ),
            );
          });
        },
        rollbackDatabase: RollbackDatabase.afterAll,
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

          test('then should have been rolled back', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(0));
          });
        },
      );
    });
  });

  group('Given TestToolsEndpoint and rollbackDatabase disabled', () {
    group('when calling createSimpleDatasInsideTransactions', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
          setUpAll(() async {
            await endpoints.testTools.createSimpleDatasInsideTransactions(
              sessionBuilder,
              123,
            );
          });

          test("then finds SimpleDatas in the test", () async {
            final simpleDatas = await SimpleData.db.find(session);
            expect(simpleDatas.length, 2);
            expect(simpleDatas[0].num, 123);
            expect(simpleDatas[1].num, 123);
          });

          test(
            'then should not have been rolled back in the next test',
            () async {
              var simpleDatas = await SimpleData.db.find(session);

              expect(simpleDatas, hasLength(2));
              expect(simpleDatas[0].num, 123);
              expect(simpleDatas[1].num, 123);
            },
          );
        },
        rollbackDatabase: RollbackDatabase.disabled,
        testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
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
            },
          );
        },
        rollbackDatabase: RollbackDatabase.disabled,
        testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
      );
    });

    group('when calling createSimpleDataAndThrowInsideTransaction', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
          setUpAll(() async {
            try {
              await endpoints.testTools
                  .createSimpleDataAndThrowInsideTransaction(
                    sessionBuilder,
                    123,
                  );
            } catch (e) {}
          });

          test('then only one transaction should have been comitted', () async {
            var simpleDatas = await SimpleData.db.find(session);

            expect(simpleDatas, hasLength(1));
            expect(simpleDatas.first.num, 123);
          });
        },
        rollbackDatabase: RollbackDatabase.disabled,
        testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
      );

      withServerpod(
        'when fetching SimpleData in the next withServerpod',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

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
        testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
      );
    });

    withServerpod(
      'when calling createSimpleDatasInParallelTransactionCalls',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();
        setUpAll(() async {
          await endpoints.testTools.createSimpleDatasInParallelTransactionCalls(
            sessionBuilder,
          );
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
      testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    );
  });

  withServerpod(
    'Given rollbackDatabase is not disabled (transaction active) ',
    rollbackDatabase: RollbackDatabase.afterEach,
    (sessionBuilder, _) {
      var session = sessionBuilder.build();

      group('when creating UniqueData with the same unique value', () {
        late Future failingInsert;
        setUp(() async {
          await UniqueData.db.insertRow(
            session,
            UniqueData(email: 'test@test.com', number: 1),
          );
          failingInsert = UniqueData.db.insertRow(
            session,
            UniqueData(email: 'test@test.com', number: 1),
          );
        });

        test('then should throw database exception', () async {
          await expectLater(
            failingInsert,
            throwsA(
              allOf(
                isA<DatabaseQueryException>().having(
                  (e) => e.code,
                  'code',
                  PgErrorCode.uniqueViolation,
                ),
              ),
            ),
          );
        });

        test(
          'then catching database exception should not prevent further database operations',
          () async {
            SimpleData? simpleData;
            try {
              await failingInsert;
            } on DatabaseException catch (_) {
              simpleData = await SimpleData.db.insertRow(
                session,
                SimpleData(num: 123),
              );
            }

            expect(simpleData, isNotNull);
            expect(simpleData?.num, 123);
          },
        );
      });

      test(
        'when creating multiple UniqueData with the same unique value in parallel '
        'then should throw database exception but still insert the one that was successful',
        () async {
          try {
            await Future.wait([
              UniqueData.db.insertRow(
                session,
                UniqueData(email: 'test@test2.com', number: 2),
              ),
              UniqueData.db.insertRow(
                session,
                UniqueData(email: 'test@test2.com', number: 2),
              ),
            ]);
          } on DatabaseException catch (_) {}

          var uniqueDatas = await UniqueData.db.find(session);

          expect(uniqueDatas, hasLength(1));
          expect(uniqueDatas.first.email, 'test@test2.com');
        },
      );

      test('when creating multiple SimpleData in parallel '
          'then should have inserted all', () async {
        await Future.wait([
          SimpleData.db.insertRow(
            session,
            SimpleData(num: 1),
          ),
          SimpleData.db.insertRow(
            session,
            SimpleData(num: 2),
          ),
          SimpleData.db.insertRow(
            session,
            SimpleData(num: 3),
          ),
        ]);

        var simpleDatas = await SimpleData.db.find(session);

        expect(simpleDatas, hasLength(3));
        expect(simpleDatas.map((s) => s.num), containsAll([1, 2, 3]));
      });

      group('when calling database operation insertRow', () {
        setUp(() async {
          await SimpleData.db.insertRow(
            session,
            SimpleData(num: 123),
          );
        });

        test('then should have inserted row', () async {
          var simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas.length, 1);
          expect(simpleDatas.first.num, 123);
        });
      });

      group('when calling database operation insert', () {
        setUp(() async {
          await SimpleData.db.insert(
            session,
            [
              SimpleData(num: 1),
              SimpleData(num: 2),
            ],
          );
        });

        test('then should have inserted rows', () async {
          var simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas.length, 2);
          expect(simpleDatas.map((s) => s.num), containsAll([1, 2]));
        });
      });

      group('and SimpleDatas exist', () {
        late List<SimpleData> insertedSimpleDatas;
        late SimpleData insertedSimpleData1;

        setUp(() async {
          insertedSimpleDatas = await SimpleData.db.insert(
            session,
            [
              SimpleData(num: 1),
              SimpleData(num: 2),
            ],
          );
          insertedSimpleData1 = insertedSimpleDatas.firstWhere(
            (s) => s.num == 1,
          );
        });

        test('when calling database operation updateRow '
            'then should update row', () async {
          insertedSimpleData1.num = 10;
          var updatedSimpleData = await SimpleData.db.updateRow(
            session,
            insertedSimpleData1,
          );
          expect(updatedSimpleData.num, 10);
        });

        test('when calling database operation update '
            'then should update rows', () async {
          var simpleDatas = await SimpleData.db.update(
            session,
            insertedSimpleDatas.map((s) => s..num = s.num + 10).toList(),
          );
          expect(simpleDatas.map((s) => s.num), containsAll([11, 12]));
        });

        test('when calling database operation findById'
            'then should find the saved row by id', () async {
          var simpleData = await SimpleData.db.findById(
            session,
            insertedSimpleData1.id!,
          );
          expect(simpleData, isNotNull);
          expect(simpleData?.num, 1);
        });

        test('when calling database operation findFirstRow'
            'then should be possible to find first row', () async {
          var simpleData = await SimpleData.db.findFirstRow(session);

          expect(simpleData, isNotNull);
          expect(simpleData?.num, 1);
        });

        test('when calling database operation find '
            'then should be possible to find all rows', () async {
          var simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas.length, 2);
        });

        test('when calling database operation deleteRow '
            'then should delete rows', () async {
          await SimpleData.db.deleteRow(session, insertedSimpleData1);
          var simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas.length, 1);
          expect(simpleDatas.first.num, 2);
        });

        test('when calling database operation deleteWhere'
            'then rows should be deleted', () async {
          await SimpleData.db.deleteWhere(
            session,
            where: (t) => t.num.equals(1),
          );

          var simpleDatas = await SimpleData.db.find(session);

          expect(simpleDatas.length, 1);
          expect(simpleDatas.first.num, 2);
        });

        test('when calling database operation delete '
            'then rows should be deleted', () async {
          await SimpleData.db.delete(
            session,
            insertedSimpleDatas,
          );

          var simpleDatas = await SimpleData.db.find(session);
          expect(simpleDatas.length, 0);
        });

        test('when calling database operation count'
            'then rows should be counted', () async {
          var count = await SimpleData.db.count(session);
          expect(count, 2);
        });

        test(
          'when calling database operation unsafeQuery with select statement '
          'then should find inserted row',
          () async {
            var result = await session.db.unsafeQuery(
              'SELECT num from simple_data where num = @num',
              parameters: QueryParameters.named({'num': 2}),
            );
            expect(result.length, 1);
            expect(result.first.first, 2);
          },
        );

        test(
          'when calling database operation unsafeExecute with delete statement '
          'then should delete row',
          () async {
            var rowsAffected = await session.db.unsafeExecute(
              'DELETE FROM simple_data WHERE num = @num',
              parameters: QueryParameters.named({'num': 2}),
            );

            expect(rowsAffected, 1);
          },
        );

        test(
          'when calling database operation unsafeSimpleQuery with select statement '
          'then should find inserted row',
          () async {
            var result = await session.db.unsafeSimpleQuery(
              'SELECT num from simple_data',
            );
            expect(result.length, 2);
            expect(
              result,
              containsAll([
                [1],
                [2],
              ]),
            );
          },
        );

        test(
          'when calling database operation unsafeSimpleExecute with delete statement '
          'then should delete row',
          () async {
            var rowsAffected = await session.db.unsafeSimpleExecute(
              'DELETE FROM simple_data WHERE num = 2',
            );

            expect(rowsAffected, 1);
          },
        );
      });
    },
  );
}
