import 'dart:async';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() async {
  withServerpod(
    'Given read committed transaction isolation level and single row in database',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      var session = sessionBuilder.build();

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group(
        'Given read committed transaction isolation level and single row in database',
        () {
          var settings = TransactionSettings(
            isolationLevel: IsolationLevel.readCommitted,
          );

          late SimpleData testData;
          setUp(() async {
            testData = await SimpleData.db.insertRow(
              session,
              SimpleData(num: 1),
            );
          });

          test('when row is modified after first statement in transaction '
              'then transaction observes the updated value.', () async {
            var c1 = Completer();
            var c2 = Completer();
            var transactionFuture = session.db.transaction(
              (t) async {
                await SimpleData.db.findById(
                  session,
                  testData.id!,
                  transaction: t,
                );

                c1.complete();
                await c2.future;

                return await SimpleData.db.findById(
                  session,
                  testData.id!,
                  transaction: t,
                );
              },
              settings: settings,
            );

            await c1.future;
            await SimpleData.db.updateRow(
              session,
              testData.copyWith(num: 2),
            );
            c2.complete();

            var transactionResult = await transactionFuture;
            expect(transactionResult?.num, 2);
          });
        },
      );
    },
  );

  withServerpod(
    'Given repeatable read transaction isolation level',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      var session = sessionBuilder.build();

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      var settings = TransactionSettings(
        isolationLevel: IsolationLevel.repeatableRead,
      );

      test('when row is modified after first statement in transaction '
          'then transaction does NOT observe the updated value.', () async {
        var testData = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 1),
        );

        var c1 = Completer();
        var c2 = Completer();
        var transactionFuture = session.db.transaction(
          (t) async {
            await SimpleData.db.findById(
              session,
              testData.id!,
              transaction: t,
            );

            c1.complete();
            await c2.future;

            return await SimpleData.db.findById(
              session,
              testData.id!,
              transaction: t,
            );
          },
          settings: settings,
        );

        await c1.future;
        await SimpleData.db.updateRow(
          session,
          testData.copyWith(num: 2),
        );
        c2.complete();

        var result = await transactionFuture;
        expect(result?.num, 1);
      });

      test('when read row is concurrently modified by other transaction '
          'then modifications are preserved', () async {
        var testData1 = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 1),
        );
        var testData2 = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 2),
        );
        var c1 = Completer();
        var c2 = Completer();

        var transaction1 = session.db.transaction(
          (t) async {
            var data1 = await SimpleData.db.findById(
              session,
              testData1.id!,
              transaction: t,
            );

            c1.complete();
            await c2.future;

            await SimpleData.db.updateRow(
              session,
              testData2.copyWith(num: data1!.num + 10),
              transaction: t,
            );
          },
          settings: settings,
        );

        var transaction2 = session.db.transaction(
          (t) async {
            var data2 = await SimpleData.db.findById(
              session,
              testData2.id!,
              transaction: t,
            );

            await c1.future;

            await SimpleData.db.updateRow(
              session,
              testData1.copyWith(num: data2!.num + 20),
              transaction: t,
            );
            c2.complete();
          },
          settings: settings,
        );

        await Future.wait([transaction1, transaction2]);
        var data1AfterTransaction = await SimpleData.db.findById(
          session,
          testData1.id!,
        );
        expect(data1AfterTransaction?.num, 22);
        var data2AfterTransaction = await SimpleData.db.findById(
          session,
          testData2.id!,
        );
        expect(data2AfterTransaction?.num, 11);
      });
    },
  );

  withServerpod(
    'Given serializable transaction isolation level',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    (sessionBuilder, _) {
      var session = sessionBuilder.build();

      tearDown(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      var settings = TransactionSettings(
        isolationLevel: IsolationLevel.serializable,
      );

      test('when row is modified after first statement in transaction '
          'then transaction does NOT observe the updated value.', () async {
        var testData = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 1),
        );
        var c1 = Completer();
        var c2 = Completer();
        var transactionFuture = session.db.transaction(
          (t) async {
            await SimpleData.db.findById(
              session,
              testData.id!,
              transaction: t,
            );

            c1.complete();
            await c2.future;

            return await SimpleData.db.findById(
              session,
              testData.id!,
              transaction: t,
            );
          },
          settings: settings,
        );

        await c1.future;
        await SimpleData.db.updateRow(
          session,
          testData.copyWith(num: 2),
        );
        c2.complete();

        var result = await transactionFuture;
        expect(result?.num, 1);
      });

      test('when read row is concurrently modified by other transaction '
          'then database exception is thrown for one transaction', () async {
        var testData1 = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 1),
        );
        var testData2 = await SimpleData.db.insertRow(
          session,
          SimpleData(num: 2),
        );
        var c1 = Completer();
        var c2 = Completer();

        var transaction1 = session.db.transaction(
          (t) async {
            var data1 = await SimpleData.db.findById(
              session,
              testData1.id!,
              transaction: t,
            );

            await Future.delayed(Duration(milliseconds: 100));

            c1.complete();
            await c2.future;

            await SimpleData.db.updateRow(
              session,
              testData2.copyWith(num: data1!.num + 10),
              transaction: t,
            );
          },
          settings: settings,
        );

        var transaction2 = session.db.transaction(
          (t) async {
            var data2 = await SimpleData.db.findById(
              session,
              testData2.id!,
              transaction: t,
            );

            await c1.future;

            await SimpleData.db.updateRow(
              session,
              testData1.copyWith(num: data2!.num + 20),
              transaction: t,
            );
            c2.complete();
          },
          settings: settings,
        );

        expectLater(
          transaction1,
          throwsA(
            isA<DatabaseQueryException>().having(
              (e) => e.code,
              'code',
              PgErrorCode.serializationFailure,
            ),
          ),
        );
        await transaction2;
        var data1AfterTransaction = await SimpleData.db.findById(
          session,
          testData1.id!,
        );
        expect(data1AfterTransaction?.num, 22);
        var data2AfterTransaction = await SimpleData.db.findById(
          session,
          testData2.id!,
        );
        expect(data2AfterTransaction?.num, 2);
      });
    },
  );
}
