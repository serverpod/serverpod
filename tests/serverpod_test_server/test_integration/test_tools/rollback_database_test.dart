import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no explicit rollbackDatabase configuration when having multiple test cases',
    (endpoints, session) {
      test(
          'then first test creates objects in the database that should be rolled back due to default rollbackDatabase.afterEach configuration',
          () async {
        await SimpleData.db.insert(
          session,
          [
            SimpleData(num: 111),
            SimpleData(num: 222),
          ],
        );
        final result = await SimpleData.db.find(session);

        expect(result.length, 2);
        expect(result[0].num, 111);
        expect(result[1].num, 222);
      });

      test(
          'then database is rolled back in the second test due to default rollbackDatabase.afterEach configuration',
          () async {
        final result = await SimpleData.db.find(session);

        expect(result.length, 0);
      });
    },
    runMode: ServerpodRunMode.production,
  );

  group('Given rollbackDatabase set to afterEach', () {
    group('when creating objects in a setUpAll', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUpAll(() async {
            await SimpleData.db.insert(
              session,
              [
                SimpleData(num: 111),
                SimpleData(num: 222),
              ],
            );
          });

          test('then finds the objects in the database according to setUpAll',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 2);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
          });

          test('then database is rolled back in the second test', () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
        rollbackDatabase: RollbackDatabase.afterEach,
        runMode: ServerpodRunMode.production,
      );

      withServerpod(
        '',
        (endpoints, session) {
          test('then the database is rolled back after the first withServerpod',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
        runMode: ServerpodRunMode.production,
      );
    });

    group('when creating objects in a setUp', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUp(() async {
            await SimpleData.db.insert(session, [
              SimpleData(num: 111),
              SimpleData(num: 222),
            ]);
          });

          test('then finds the objects in the database according to setUp',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 2);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
          });

          test(
              'then automatically rolls back the transaction so that subsequent tests get the same setUp',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 2);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
          });
        },
        rollbackDatabase: RollbackDatabase.afterEach,
        runMode: ServerpodRunMode.production,
      );

      withServerpod('', (endpoints, session) {
        test('then the database is rolled back after the first withServerpod',
            () async {
          final result = await SimpleData.db.find(session);

          expect(result.length, 0);
        });
      }, runMode: ServerpodRunMode.production);
    });

    group('when creating a transaction in the test', () {
      withServerpod(
        '',
        (endpoints, session) {
          test('then the database is updated according to the change',
              () async {
            await session.db.transaction((transaction) async {
              await SimpleData.db.insert(session, [SimpleData(num: 111)],
                  transaction: transaction);
            });

            final result = await SimpleData.db.find(session);

            expect(result.length, 1);

            expect(result.first.num, 111);
          });

          test('then the change is not rolled back', () async {
            final result = await SimpleData.db.find(session);
            expect(result.length, 1);
          });
        },
        rollbackDatabase: RollbackDatabase.afterEach,
        runMode: ServerpodRunMode.production,
      );

      withServerpod(
        'then the database has to be cleaned up in the next `withServerpod` by setting rollbackDatabase to never',
        (endpoints, session) {
          tearDownAll(() async {
            await SimpleData.db
                .deleteWhere(session, where: (_) => Constant.bool(true));
          });
        },
        rollbackDatabase: RollbackDatabase.never,
        runMode: ServerpodRunMode.production,
      );
    });

    withServerpod(
      'when creating a copy of the session and creating new objects in the database in setUp',
      (endpoints, session) {
        late TestSession newSession;
        setUp(() async {
          newSession = session.copyWith();
          await SimpleData.db
              .insert(newSession, [SimpleData(num: 111), SimpleData(num: 222)]);
        });

        test('then finds the objects in the database according to setUp',
            () async {
          final result = await SimpleData.db.find(newSession);

          expect(result.length, 2);
          expect(result[0].num, 111);
          expect(result[1].num, 222);
        });

        test(
            'then automatically rolls back the transaction for the new session so that subsequent tests get the same setUp',
            () async {
          final result = await SimpleData.db.find(newSession);

          expect(result.length, 2);
          expect(result[0].num, 111);
          expect(result[1].num, 222);
        });

        test('then shares database state with the original session', () async {
          final resultFromOriginalSession = await SimpleData.db.find(session);

          expect(resultFromOriginalSession.length, 2);
          expect(resultFromOriginalSession[0].num, 111);
          expect(resultFromOriginalSession[1].num, 222);
        });
      },
      rollbackDatabase: RollbackDatabase.afterEach,
      runMode: ServerpodRunMode.production,
    );
  });

  group('Given rollbackDatabase set to afterAll', () {
    group('when creating objects in a setUpAll', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUpAll(() async {
            await SimpleData.db.insert(session, [
              SimpleData(num: 111),
              SimpleData(num: 222),
            ]);
          });

          test('then finds the objects in the database according to setUpAll',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 2);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
          });

          test(
              'then does not roll back the transaction so that the second test can fetch the same data',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 2);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
          });
        },
        rollbackDatabase: RollbackDatabase.afterAll,
        runMode: ServerpodRunMode.production,
      );

      withServerpod(
        '',
        (endpoints, session) {
          test('then the database is rolled back after the first withServerpod',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
        runMode: ServerpodRunMode.production,
      );
    });

    group('when creating objects in a setUp', () {
      withServerpod(
        '',
        (endpoints, session) {
          setUp(() async {
            await SimpleData.db.insert(session, [
              SimpleData(num: 111),
              SimpleData(num: 222),
            ]);
          });

          test('then finds the objects in the database according to setUp',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 2);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
          });

          test(
              'then does not roll back the transaction so that the second test can fetch all the data',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 4);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
            expect(result[2].num, 111);
            expect(result[3].num, 222);
          });
        },
        rollbackDatabase: RollbackDatabase.afterAll,
        runMode: ServerpodRunMode.production,
      );

      withServerpod('', (endpoints, session) {
        test('then the database is rolled back after the first withServerpod',
            () async {
          final result = await SimpleData.db.find(session);

          expect(result.length, 0);
        });
      }, runMode: ServerpodRunMode.production);
    });

    group(
        'when creating SimpleData in in one test and fetching it in the other',
        () {
      withServerpod(
        '',
        (endpoints, session) {
          test('then creates SimpleData in the first test', () async {
            await SimpleData.db
                .insert(session, [SimpleData(num: 111), SimpleData(num: 222)]);
          });

          test(
              'then does not roll back the transaction so that the second test can fetch the data',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 2);
            expect(result[0].num, 111);
            expect(result[1].num, 222);
          });
        },
        rollbackDatabase: RollbackDatabase.afterAll,
        runMode: ServerpodRunMode.production,
      );

      withServerpod(
        '',
        (endpoints, session) {
          test(
              'when fetching SimpleData after the first withServerpod then the database is rolled back',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
        runMode: ServerpodRunMode.production,
      );
    });
  });

  group('Given rollbackDatabase set to never', () {
    withServerpod(
      'when creating SimpleData in in one test and fetching it in the other',
      (endpoints, session) {
        test('then creates SimpleData in the first test', () async {
          await SimpleData.db
              .insert(session, [SimpleData(num: 111), SimpleData(num: 222)]);
        });

        test(
            'then does not roll back the transaction so that the second test can fetch the data',
            () async {
          final result = await SimpleData.db.find(session);

          expect(result.length, 2);
          expect(result[0].num, 111);
          expect(result[1].num, 222);
        });
      },
      rollbackDatabase: RollbackDatabase.never,
      runMode: ServerpodRunMode.production,
    );

    withServerpod(
      'when fetching SimpleData after the first withServerpod',
      (endpoints, session) {
        tearDownAll(() async {
          await SimpleData.db.deleteWhere(
            session,
            where: (t) => Constant.bool(true),
          );
        });

        test('then the database is not rolled back', () async {
          final result = await SimpleData.db.find(session);

          expect(result.length, 2);
          expect(result[0].num, 111);
          expect(result[1].num, 222);
        });
      },
      rollbackDatabase: RollbackDatabase.never,
      runMode: ServerpodRunMode.production,
    );
  });
}
