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
            'when updating where number equals 1 then all matching rows are updated',
            () async {
          var updated = await UniqueData.db.updateWhere(
            session,
            columnValues: (t) => [t.number(42)],
            where: (t) => t.number.equals(1),
          );

          expect(updated, hasLength(2));
          var numbers = updated.map((row) => row.number).toList();
          expect(numbers, everyElement(42));
        });

        test(
            'when updating where number equals 1 then non-selected columns remain unchanged',
            () async {
          var updated = await UniqueData.db.updateWhere(
            session,
            columnValues: (t) => [t.number(42)],
            where: (t) => t.number.equals(1),
          );

          var emails = updated.map((e) => e.email).toSet();
          expect(emails,
              containsAll(['first@serverpod.dev', 'duplicate@serverpod.dev']));
        });

        test(
            'when updating with complex where clause then only matching rows are updated',
            () async {
          var updated = await UniqueData.db.updateWhere(
            session,
            columnValues: (t) => [t.number(200)],
            where: (t) => t.number.equals(2) | t.number.equals(3),
          );

          expect(updated, hasLength(2));
          var numbers = updated.map((row) => row.number).toList();
          expect(numbers, everyElement(200));
        });

        test(
            'when updating with complex where clause then non-selected columns remain unchanged',
            () async {
          var updated = await UniqueData.db.updateWhere(
            session,
            columnValues: (t) => [t.number(200)],
            where: (t) => t.number.equals(2) | t.number.equals(3),
          );

          var emails = updated.map((e) => e.email).toSet();
          expect(emails,
              containsAll(['second@serverpod.dev', 'third@serverpod.dev']));
        });
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

        test('when updating where no rows match then empty list is returned',
            () async {
          var updated = await UniqueData.db.updateWhere(
            session,
            columnValues: (t) => [t.number(999)],
            where: (t) => t.number.equals(999),
          );

          expect(updated, isEmpty);
        });
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
            'when updating specific columns then only those columns are updated and others remain unchanged',
            () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.anInt(42), t.aString('updated')],
            where: (t) => t.anInt.equals(1),
          );

          expect(updated.length, 2);
          expect(updated.every((row) => row.anInt == 42), isTrue);
          expect(updated.every((row) => row.aString == 'updated'), isTrue);

          // Verify non-matching row was not updated
          var nonMatching = await Types.db.findFirstRow(
            session,
            where: (t) => t.anInt.equals(2),
          );
          expect(nonMatching!.aString, 'second');
        });
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
            'when updating where anInt is null then only null entries are updated',
            () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.anInt(99), t.aString('was_null')],
            where: (t) => t.anInt.equals(null),
          );

          expect(updated.length, 1);
          expect(updated.first.anInt, 99);
          expect(updated.first.aString, 'was_null');
        });

        test(
            'when updating non-null values to null then the columns are set to null',
            () async {
          // First verify we have a row with values
          var initial = await Types.db.findFirstRow(
            session,
            where: (t) => t.anInt.equals(1),
          );
          expect(initial!.anInt, 1);
          expect(initial.aString, 'value');

          // Now set them to null
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.anInt(null), t.aString(null)],
            where: (t) => t.anInt.equals(1),
          );

          expect(updated, hasLength(1));
          expect(updated.first.anInt, isNull);
          expect(updated.first.aString, isNull);
          // Other fields should remain unchanged
          expect(updated.first.aBool, true);
          expect(updated.first.aDouble, 1.5);
        });
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
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('limited_update')],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            limit: 3,
          );

          expect(updated, hasLength(3));
          expect(updated.every((r) => r.aString == 'limited_update'), isTrue);
        });

        test('when updating with limit 3 then remaining rows are unaffected',
            () async {
          await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('limited_update')],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            limit: 3,
          );

          var allRows = await Types.db.find(
            session,
            where: (t) => t.anInt.equals(100),
          );
          var unchangedRows =
              allRows.where((r) => r.aString != 'limited_update').toList();
          expect(unchangedRows, hasLength(2));
          expect(unchangedRows.map((r) => r.aString).toSet(),
              containsAll(['entry4', 'entry5']));
        });

        test('when using orderDescending then rows are ordered correctly',
            () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('ordered_update')],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            orderDescending: true,
            limit: 2,
          );

          expect(updated, hasLength(2));
          expect(updated[0].aDouble, 5.0); // Highest value first
          expect(updated[1].aDouble, 4.0); // Second highest
        });

        test('when using offset 2 then first 2 rows are skipped', () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('offset_update')],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            offset: 2,
          );

          // Should update rows after offset (entry3, entry4, entry5)
          expect(updated, hasLength(3));
          expect(updated.map((r) => r.aDouble).toSet(), {3.0, 4.0, 5.0});
        });

        test('when using offset 2 then skipped rows remain unchanged',
            () async {
          await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('offset_update')],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            offset: 2,
          );

          var allRows = await Types.db.find(
            session,
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
          );

          // First 2 rows should be unchanged
          expect(allRows[0].aString, 'entry1');
          expect(allRows[1].aString, 'entry2');
        });

        test('when using limit 2 and offset 1 then rows 2-3 are updated',
            () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('window_update')],
            where: (t) => t.anInt.equals(100),
            orderBy: (t) => t.aDouble,
            limit: 2,
            offset: 1,
          );

          // Should update exactly 2 rows: entry2 and entry3 (skip entry1)
          expect(updated, hasLength(2));
          expect(updated.map((r) => r.aDouble).toSet(), {2.0, 3.0});
        });

        test('when offset is larger than result set then no rows are updated',
            () async {
          // Try to update with offset larger than available rows
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('should_not_update')],
            where: (t) => t.anInt.equals(100),
            offset: 1000,
          );

          expect(updated, isEmpty);

          // Verify no rows were updated
          var allRows = await Types.db.find(
            session,
            where: (t) => t.aString.equals('should_not_update'),
          );
          expect(allRows, isEmpty);
        });

        test('when limit is 0 then no rows are updated', () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('zero_limit_update')],
            where: (t) => t.anInt.equals(100),
            limit: 0,
          );

          expect(updated, isEmpty);
        });
      });

      test(
          'when updating within an aborted transaction then update reverted as part of transaction',
          () async {
        await UniqueData.db.insert(
          session,
          [
            UniqueData(number: 1, email: 'first@serverpod.dev'),
            UniqueData(number: 2, email: 'second@serverpod.dev'),
            UniqueData(number: 1, email: 'duplicate@serverpod.dev'),
          ],
        );

        await expectLater(
          session.db.transaction((transaction) async {
            var updated = await UniqueData.db.updateWhere(
              session,
              columnValues: (t) => [t.number(999)],
              where: (t) => t.number.equals(1),
              transaction: transaction,
            );

            expect(updated, hasLength(2));
            expect(updated.every((row) => row.number == 999), isTrue);

            // Note: We use an exception to rollback the transaction instead of
            // transaction.cancel() because the withServerpod test framework
            // wraps all tests in a transaction for automatic rollback.
            // Using transaction.cancel() causes the underlying connection to close,
            // which conflicts with the test framework's transaction management.
            throw Exception('Rollback transaction');
          }),
          throwsA(isA<Exception>()),
        );

        // Verify the updates were rolled back
        var results = await UniqueData.db.find(
          session,
          where: (t) => t.number.equals(1),
        );
        expect(results, hasLength(2));
        expect(results.every((row) => row.number == 1), isTrue);
      });
    },
  );
}
