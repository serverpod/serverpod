import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given updateById operations',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test(
        'when updating by id for a single column then only that column is updated',
        () async {
          const originalNumber = 1;
          const originalEmail = 'original@serverpod.dev';
          const updatedNumber = 42;

          var existingEntry = await UniqueData.db.insertRow(
            session,
            UniqueData(number: originalNumber, email: originalEmail),
          );

          var updated = await UniqueData.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [t.number(updatedNumber)],
          );

          expect(updated, isNotNull);
          expect(updated!.number, updatedNumber);
          expect(updated.email, originalEmail);

          var dbRow = await UniqueData.db.findById(session, existingEntry.id!);
          expect(dbRow, isNotNull);
          expect(dbRow!.number, updatedNumber);
          expect(dbRow.email, originalEmail);
        },
      );

      test('when updating by non-existent id then null is returned', () async {
        const nonExistentId = 999999;
        const testNumber = 123;

        var updated = await UniqueData.db.updateById(
          session,
          nonExistentId,
          columnValues: (t) => [t.number(testNumber)],
        );

        expect(updated, isNull);
      });

      group('Given a Types entry', () {
        late Types existingEntry;

        setUp(() async {
          existingEntry = await Types.db.insertRow(
            session,
            Types(
              anInt: 1,
              aBool: true,
              aDouble: 1.5,
              aString: 'original',
              aDateTime: DateTime.utc(2024, 1, 1),
            ),
          );
        });

        test(
          'when updating specific columns by id then only those columns are updated and others remain unchanged',
          () async {
            const updatedInt = 42;
            const updatedString = 'updated';
            var updated = await Types.db.updateById(
              session,
              existingEntry.id!,
              columnValues: (t) =>
                  [t.anInt(updatedInt), t.aString(updatedString)],
            );

            expect(updated, isNotNull);
            expect(updated!.anInt, updatedInt);
            expect(updated.aString, updatedString);
            expect(updated.aBool, existingEntry.aBool);
            expect(updated.aDouble, existingEntry.aDouble);
            expect(updated.aDateTime, existingEntry.aDateTime);

            var dbRow = await Types.db.findById(session, existingEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.anInt, updatedInt);
            expect(dbRow.aString, updatedString);
            expect(dbRow.aBool, existingEntry.aBool);
            expect(dbRow.aDouble, existingEntry.aDouble);
            expect(dbRow.aDateTime, existingEntry.aDateTime);
          },
        );

        test(
          'when updating a column to null then the column is set to null',
          () async {
            var updated = await Types.db.updateById(
              session,
              existingEntry.id!,
              columnValues: (t) => [t.anInt(null), t.aString(null)],
            );

            expect(updated, isNotNull);
            expect(updated!.anInt, isNull);
            expect(updated.aString, isNull);
            expect(updated.aBool, existingEntry.aBool);
            expect(updated.aDouble, existingEntry.aDouble);
            expect(updated.aDateTime, existingEntry.aDateTime);

            var dbRow = await Types.db.findById(session, existingEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.anInt, isNull);
            expect(dbRow.aString, isNull);
            expect(dbRow.aBool, existingEntry.aBool);
            expect(dbRow.aDouble, existingEntry.aDouble);
            expect(dbRow.aDateTime, existingEntry.aDateTime);
          },
        );
      });

      group('Given a Types entry with null values', () {
        late Types existingNullEntry;

        setUp(() async {
          existingNullEntry = await Types.db.insertRow(
            session,
            Types(
              anInt: null,
              aBool: null,
              aDouble: null,
              aString: null,
              aDateTime: null,
            ),
          );
        });

        test(
          'when updating null columns to non-null values then the columns are set correctly',
          () async {
            const updatedIntFromNull = 99;
            const updatedStringFromNull = 'was_null';

            var updated = await Types.db.updateById(
              session,
              existingNullEntry.id!,
              columnValues: (t) => [
                t.anInt(updatedIntFromNull),
                t.aString(updatedStringFromNull)
              ],
            );

            expect(updated, isNotNull);
            expect(updated!.anInt, updatedIntFromNull);
            expect(updated.aString, updatedStringFromNull);
            expect(updated.aBool, existingNullEntry.aBool);
            expect(updated.aDouble, existingNullEntry.aDouble);
            expect(updated.aDateTime, existingNullEntry.aDateTime);

            var dbRow = await Types.db.findById(session, existingNullEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.anInt, updatedIntFromNull);
            expect(dbRow.aString, updatedStringFromNull);
            expect(dbRow.aBool, existingNullEntry.aBool);
            expect(dbRow.aDouble, existingNullEntry.aDouble);
            expect(dbRow.aDateTime, existingNullEntry.aDateTime);
          },
        );
      });

      test(
        'when updating by id within an aborted transaction then update reverted as part of transaction',
        () async {
          const originalNumber = 1;
          const originalEmail = 'original@serverpod.dev';
          const transactionUpdatedNumber = 42;

          var existingEntry = await UniqueData.db.insertRow(
            session,
            UniqueData(number: originalNumber, email: originalEmail),
          );

          await session.db.transaction((transaction) async {
            var savepoint = await transaction.createSavepoint();

            var updated = await UniqueData.db.updateById(
              session,
              existingEntry.id!,
              columnValues: (t) => [t.number(transactionUpdatedNumber)],
              transaction: transaction,
            );

            expect(updated, isNotNull);
            expect(updated!.number, transactionUpdatedNumber);

            await savepoint.rollback();
          });

          var result = await UniqueData.db.findById(session, existingEntry.id!);
          expect(result!.number, originalNumber);
        },
      );
    },
  );
}
