import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no explicit rollbackDatabase configuration when having multiple test cases',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

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
  );

  group('Given rollbackDatabase set to afterEach', () {
    group('when creating objects in a setUpAll', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
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
      );

      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

          test('then the database is rolled back after the first withServerpod',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
      );
    });

    group('when creating objects in a setUp', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

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
      );

      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

          test('then the database is rolled back after the first withServerpod',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
      );
    });

    withServerpod(
      'when creating a copy of the session builder and creating new objects in the database in setUp',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();
        var newSessionBuilder = sessionBuilder.copyWith();
        var newSession = newSessionBuilder.build();
        setUp(() async {
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
    );
  });

  group('Given rollbackDatabase set to afterAll', () {
    group('when creating objects in a setUpAll', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
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
      );

      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
          test('then the database is rolled back after the first withServerpod',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
      );
    });

    group('when creating objects in a setUp', () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
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
      );

      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();

          test('then the database is rolled back after the first withServerpod',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
      );
    });

    group(
        'when creating SimpleData in in one test and fetching it in the other',
        () {
      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
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
      );

      withServerpod(
        '',
        (sessionBuilder, endpoints) {
          var session = sessionBuilder.build();
          test(
              'when fetching SimpleData after the first withServerpod then the database is rolled back',
              () async {
            final result = await SimpleData.db.find(session);

            expect(result.length, 0);
          });
        },
      );
    });
  });

  group('Given rollbackDatabase set to never', () {
    withServerpod(
      'when creating SimpleData in in one test and fetching it in the other',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();
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
      rollbackDatabase: RollbackDatabase.disabled,
    );

    withServerpod(
      'when fetching SimpleData after the first withServerpod',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();

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
      rollbackDatabase: RollbackDatabase.disabled,
    );
  });
}
