import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given updateWhere operations',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      group('Given multiple UniqueData entries', () {
        setUp(() async {
          await UniqueData.db.insert(
            session,
            [
              UniqueData(number: 1, email: 'first@serverpod.dev'),
              UniqueData(number: 2, email: 'second@serverpod.dev'),
              UniqueData(number: 3, email: 'third@serverpod.dev'),
              UniqueData(number: 1, email: 'duplicate@serverpod.dev'),
            ],
          );
        });

        test(
          'when updating a single column where number equals 1 then all matching rows are updated',
          () async {
            const updatedNumber = 42;

            var updated = await UniqueData.db.updateWhere(
              session,
              columnValues: (t) => [t.number(updatedNumber)],
              where: (t) => t.number.equals(1),
            );

            expect(updated, hasLength(2));
            var numbers = updated.map((row) => row.number);
            expect(numbers, everyElement(updatedNumber));

            var dbRows = await UniqueData.db.find(
              session,
              where: (t) => t.number.equals(updatedNumber),
            );
            expect(dbRows, hasLength(2));
            var dbNumbers = dbRows.map((row) => row.number);
            expect(dbNumbers, everyElement(updatedNumber));
          },
        );

        test(
          'when updating a single column then non-selected columns remain unchanged',
          () async {
            const updatedNumber = 42;

            var updated = await UniqueData.db.updateWhere(
              session,
              columnValues: (t) => [t.number(updatedNumber)],
              where: (t) => t.number.equals(1),
            );

            expect(updated, hasLength(2));
            var numbers = updated.map((row) => row.number);
            expect(numbers, everyElement(updatedNumber));

            var emails = updated.map((e) => e.email);
            expect(
              emails,
              containsAll(['first@serverpod.dev', 'duplicate@serverpod.dev']),
            );
          },
        );

        test(
          'when updating a single column with complex where clause '
          'then only matching rows are updated',
          () async {
            const updatedComplexNumber = 200;

            var updated = await UniqueData.db.updateWhere(
              session,
              columnValues: (t) => [t.number(updatedComplexNumber)],
              where: (t) => t.number.equals(2) | t.number.equals(3),
            );

            expect(updated, hasLength(2));
            var numbers = updated.map((row) => row.number);
            expect(numbers, everyElement(updatedComplexNumber));

            var dbRows = await UniqueData.db.find(
              session,
              where: (t) => t.number.equals(updatedComplexNumber),
            );
            expect(dbRows, hasLength(2));
            var emails = dbRows.map((e) => e.email);
            expect(
              emails,
              containsAll(['second@serverpod.dev', 'third@serverpod.dev']),
            );
          },
        );

        test(
          'when updating a single column with complex where clause '
          'then non-selected columns remain unchanged',
          () async {
            const updatedComplexNumber = 200;

            var updated = await UniqueData.db.updateWhere(
              session,
              columnValues: (t) => [t.number(updatedComplexNumber)],
              where: (t) => t.number.equals(2) | t.number.equals(3),
            );

            var emails = updated.map((e) => e.email);
            expect(
              emails,
              containsAll(['second@serverpod.dev', 'third@serverpod.dev']),
            );
          },
        );
      });

      group('Given no matching entries', () {
        setUp(() async {
          await UniqueData.db.insert(
            session,
            [
              UniqueData(number: 1, email: 'test@serverpod.dev'),
            ],
          );
        });

        test(
          'when updating where no rows match then empty list is returned',
          () async {
            const nonExistingNumber = 999;

            var updated = await UniqueData.db.updateWhere(
              session,
              columnValues: (t) => [t.number(nonExistingNumber)],
              where: (t) => t.number.equals(nonExistingNumber),
            );

            expect(updated, isEmpty);
          },
        );
      });

      group('Given Types entries with different values', () {
        setUp(() async {
          await Types.db.insert(
            session,
            [
              Types(
                anInt: 1,
                aBool: true,
                aDouble: 1.5,
                aString: 'first',
                aDateTime: DateTime(2024, 1, 1),
              ),
              Types(
                anInt: 2,
                aBool: false,
                aDouble: 2.5,
                aString: 'second',
                aDateTime: DateTime(2024, 2, 1),
              ),
              Types(
                anInt: 1,
                aBool: true,
                aDouble: 3.5,
                aString: 'third',
                aDateTime: DateTime(2024, 3, 1),
              ),
            ],
          );
        });

        test(
          'when updating multiple specific columns then only those columns are updated and others remain unchanged',
          () async {
            const updatedInt = 42;
            const updatedString = 'updated';

            var updated = await Types.db.updateWhere(
              session,
              columnValues: (t) =>
                  [t.anInt(updatedInt), t.aString(updatedString)],
              where: (t) => t.anInt.equals(1),
            );

            expect(updated, hasLength(2));
            var updatedNumbers = updated.map((row) => row.anInt);
            expect(updatedNumbers, everyElement(updatedInt));
            var updatedStrings = updated.map((row) => row.aString);
            expect(updatedStrings, everyElement(updatedString));

            var dbUpdatedRows = await Types.db.find(
              session,
              where: (t) => t.anInt.equals(updatedInt),
            );
            expect(dbUpdatedRows, hasLength(2));
            var dbUpdatedNumbers = dbUpdatedRows.map((row) => row.anInt);
            expect(dbUpdatedNumbers, everyElement(updatedInt));
            var dbUpdatedStrings = dbUpdatedRows.map((row) => row.aString);
            expect(dbUpdatedStrings, everyElement(updatedString));

            var nonMatching = await Types.db.findFirstRow(
              session,
              where: (t) => t.anInt.equals(2),
            );
            expect(nonMatching!.aString, 'second');
          },
        );
      });

      group('Given Types entries with null values', () {
        setUp(() async {
          await Types.db.insert(
            session,
            [
              Types(
                anInt: null,
                aBool: null,
                aDouble: null,
                aString: null,
                aDateTime: null,
              ),
            ],
          );
        });

        test(
          'when updating where anInt is null then only null entries are updated',
          () async {
            const updatedIntFromNull = 99;
            const updatedStringFromNull = 'was_null';

            var updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [
                t.anInt(updatedIntFromNull),
                t.aString(updatedStringFromNull)
              ],
              where: (t) => t.anInt.equals(null),
            );

            expect(updated, hasLength(1));
            expect(updated.first.anInt, updatedIntFromNull);
            expect(updated.first.aString, updatedStringFromNull);
          },
        );
      });

      group('Given Types entries with non-null values', () {
        setUp(() async {
          await Types.db.insert(
            session,
            [
              Types(
                anInt: 1,
                aBool: true,
                aDouble: 1.5,
                aString: 'value',
                aDateTime: DateTime(2024, 1, 1),
              ),
            ],
          );
        });

        test(
          'when updating non-null values to null then the columns are set to null',
          () async {
            var initial = await Types.db.findFirstRow(
              session,
              where: (t) => t.anInt.equals(1),
            );
            expect(initial!.anInt, 1);
            expect(initial.aString, 'value');

            var updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.anInt(null), t.aString(null)],
              where: (t) => t.anInt.equals(1),
            );

            expect(updated, hasLength(1));
            expect(updated.first.anInt, isNull);
            expect(updated.first.aString, isNull);
            expect(updated.first.aBool, true);
            expect(updated.first.aDouble, 1.5);
          },
        );
      });

      group('Given 5 matching entries', () {
        setUp(() async {
          await Types.db.insert(
            session,
            [
              Types(
                  anInt: 100,
                  aBool: true,
                  aDouble: 1.0,
                  aString: 'entry1',
                  aDateTime: DateTime(2024, 1, 1)),
              Types(
                  anInt: 100,
                  aBool: false,
                  aDouble: 2.0,
                  aString: 'entry2',
                  aDateTime: DateTime(2024, 1, 2)),
              Types(
                  anInt: 100,
                  aBool: true,
                  aDouble: 3.0,
                  aString: 'entry3',
                  aDateTime: DateTime(2024, 1, 3)),
              Types(
                  anInt: 100,
                  aBool: false,
                  aDouble: 4.0,
                  aString: 'entry4',
                  aDateTime: DateTime(2024, 1, 4)),
              Types(
                  anInt: 100,
                  aBool: true,
                  aDouble: 5.0,
                  aString: 'entry5',
                  aDateTime: DateTime(2024, 1, 5)),
            ],
          );
        });

        test('when updating with limit 3 then 3 rows are updated', () async {
          const limitedUpdateString = 'limited_update';

          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString(limitedUpdateString)],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            limit: 3,
          );

          expect(updated, hasLength(3));
          var updatedStrings = updated.map((r) => r.aString);
          expect(updatedStrings, everyElement(limitedUpdateString));
        });

        test(
          'when updating with limit 3 then remaining rows are unaffected',
          () async {
            const limitedUpdateString = 'limited_update';

            await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.aString(limitedUpdateString)],
              where: (t) => t.anInt.equals(100),
              orderBy: (t) => t.aDouble,
              limit: 3,
            );

            var allRows = await Types.db.find(
              session,
              where: (t) => t.anInt.equals(100),
            );
            var unchangedRows =
                allRows.where((r) => r.aString != limitedUpdateString).toList();
            expect(unchangedRows, hasLength(2));
            expect(unchangedRows.map((r) => r.aString).toSet(),
                containsAll(['entry4', 'entry5']));
          },
        );

        test(
          'when using orderDescending then rows are ordered correctly',
          () async {
            const orderedUpdateString = 'ordered_update';

            var updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.aString(orderedUpdateString)],
              where: (t) => t.anInt.equals(100),
              orderBy: (t) => t.aDouble,
              orderDescending: true,
              limit: 2,
            );

            expect(updated, hasLength(2));
            expect(updated[0].aDouble, 5.0);
            expect(updated[1].aDouble, 4.0);
          },
        );

        test('when using offset 2 then first 2 rows are skipped', () async {
          const offsetUpdateString = 'offset_update';

          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString(offsetUpdateString)],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            offset: 2,
          );

          expect(updated, hasLength(3));
          expect(updated.map((r) => r.aDouble).toSet(), {3.0, 4.0, 5.0});
        });

        test(
          'when using offset 2 then skipped rows remain unchanged',
          () async {
            const offsetUpdateString = 'offset_update';

            await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.aString(offsetUpdateString)],
              where: (t) => t.anInt.equals(100),
              orderBy: (t) => t.aDouble,
              offset: 2,
            );

            var allRows = await Types.db.find(
              session,
              where: (t) => t.anInt.equals(100),
              orderBy: (t) => t.aDouble,
            );

            expect(allRows[0].aString, 'entry1');
            expect(allRows[1].aString, 'entry2');
          },
        );

        test(
          'when using limit 2 and offset 1 then rows 2-3 are updated',
          () async {
            const windowUpdateString = 'window_update';

            var updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.aString(windowUpdateString)],
              where: (t) => t.anInt.equals(100),
              orderBy: (t) => t.aDouble,
              limit: 2,
              offset: 1,
            );

            expect(updated, hasLength(2));
            expect(updated.map((r) => r.aDouble).toSet(), {2.0, 3.0});
          },
        );

        test(
          'when offset is larger than result set then no rows are updated',
          () async {
            const shouldNotUpdateString = 'should_not_update';

            var updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.aString(shouldNotUpdateString)],
              where: (t) => t.anInt.equals(100),
              offset: 1000,
            );

            expect(updated, isEmpty);

            var allRows = await Types.db.find(
              session,
              where: (t) => t.aString.equals(shouldNotUpdateString),
            );
            expect(allRows, isEmpty);
          },
        );

        test('when limit is 0 then no rows are updated', () async {
          const zeroLimitUpdateString = 'zero_limit_update';

          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString(zeroLimitUpdateString)],
            where: (t) => t.anInt.equals(100),
            limit: 0,
          );

          expect(updated, isEmpty);
        });
      });

      test(
        'when updating within an aborted transaction then update reverted as part of transaction',
        () async {
          const transactionUpdatedNumber = 999;
          const originalNumber = 1;

          await UniqueData.db.insert(
            session,
            [
              UniqueData(number: originalNumber, email: 'first@serverpod.dev'),
              UniqueData(number: 2, email: 'second@serverpod.dev'),
              UniqueData(
                  number: originalNumber, email: 'duplicate@serverpod.dev'),
            ],
          );

          await session.db.transaction((transaction) async {
            var savepoint = await transaction.createSavepoint();

            var updated = await UniqueData.db.updateWhere(
              session,
              columnValues: (t) => [t.number(transactionUpdatedNumber)],
              where: (t) => t.number.equals(originalNumber),
              transaction: transaction,
            );

            expect(updated, hasLength(2));
            expect(
                updated.every((row) => row.number == transactionUpdatedNumber),
                isTrue);

            await savepoint.rollback();
          });

          var results = await UniqueData.db.find(
            session,
            where: (t) => t.number.equals(originalNumber),
          );
          expect(results, hasLength(2));
          expect(results.every((row) => row.number == originalNumber), isTrue);
        },
      );
    },
  );
}
