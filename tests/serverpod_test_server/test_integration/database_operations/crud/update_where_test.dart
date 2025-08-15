import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/concepts/order.dart' as db_order;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

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

    tearDown(() async {
      await UniqueData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
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

      expect(updated.length, 2);
      expect(updated.every((row) => row.number == 42), isTrue);
      // Emails should remain unchanged
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

      expect(updated.length, 2);
      expect(updated.every((row) => row.number == 200), isTrue);
      // Emails should remain unchanged
      var emails = updated.map((e) => e.email).toSet();
      expect(
          emails, containsAll(['second@serverpod.dev', 'third@serverpod.dev']));
    });

    test(
        'when updating within a transaction then update is part of transaction',
        () async {
      try {
        await session.db.transaction((transaction) async {
          var updated = await UniqueData.db.updateWhere(
            session,
            columnValues: (t) => [t.number(999)],
            where: (t) => t.number.equals(1),
            transaction: transaction,
          );

          expect(updated.length, 2);
          expect(updated.every((row) => row.number == 999), isTrue);

          // Throw to rollback the transaction
          throw Exception('Rollback');
        });
      } catch (e) {
        // Expected error for rollback
      }

      // Verify the updates were rolled back
      var results = await UniqueData.db.find(
        session,
        where: (t) => t.number.equals(1),
      );
      expect(results.length, 2);
      expect(results.every((row) => row.number == 1), isTrue);
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

    tearDown(() async {
      await UniqueData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
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

    tearDown(() async {
      await Types.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
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

    tearDown(() async {
      await Types.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
    });

    test('when updating where anInt is null then only null entries are updated',
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

    test('when updating a column to null then the column is set to null',
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

      expect(updated.length, 1);
      expect(updated.first.anInt, isNull);
      expect(updated.first.aString, isNull);
      // Other fields should remain unchanged
      expect(updated.first.aBool, true);
      expect(updated.first.aDouble, 1.5);
    });

    test(
        'when using limit parameter then only specified number of rows are updated',
        () async {
      // Only the limited number of rows are updated
      var updated = await Types.db.updateWhere(
        session,
        columnValues: (t) => [t.aString('limited_update')],
        where: (t) => t.anInt.equals(null),
        limit: 1,
      );

      expect(updated.length, 1);
      expect(updated.first.aString, 'limited_update');

      // Verify that only 1 row was updated, not all matching rows
      var allNullRows = await Types.db.find(
        session,
        where: (t) => t.anInt.equals(null),
      );
      var updatedCount =
          allNullRows.where((r) => r.aString == 'limited_update').length;
      expect(updatedCount, 1);
    });

    test(
        'when using orderBy parameter then only ordered limited rows are updated',
        () async {
      // Insert more test data with different values
      await Types.db.insert(
        session,
        [
          Types(
              anInt: 5,
              aBool: false,
              aDouble: 5.5,
              aString: 'fifth',
              aDateTime: DateTime(2024, 5, 1)),
          Types(
              anInt: 4,
              aBool: true,
              aDouble: 4.5,
              aString: 'fourth',
              aDateTime: DateTime(2024, 4, 1)),
        ],
      );

      // Only the top 2 rows (ordered by anInt descending) are updated
      var updated = await Types.db.updateWhere(
        session,
        columnValues: (t) => [t.aString('top_two_updated')],
        where: (t) => t.anInt.notEquals(null),
        orderBy: (t) => t.anInt,
        orderDescending: true,
        limit: 2,
      );

      expect(updated.length, 2);
      expect(updated[0].anInt, 5); // Highest value first
      expect(updated[1].anInt, 4); // Second highest
      expect(updated.every((r) => r.aString == 'top_two_updated'), isTrue);

      // Verify only the top 2 rows were updated, not all matching rows
      var allRows = await Types.db.find(
        session,
        where: (t) => t.anInt.notEquals(null),
      );
      var updatedCount =
          allRows.where((r) => r.aString == 'top_two_updated').length;
      expect(updatedCount, 2);

      // Verify rows with anInt 1 and 2 were NOT updated
      var notUpdatedRows = await Types.db.find(
        session,
        where: (t) => t.anInt.equals(1) | t.anInt.equals(2),
      );
      expect(
          notUpdatedRows.any((r) => r.aString == 'top_two_updated'), isFalse);

      // Clean up additional test data
      await Types.db.deleteWhere(
        session,
        where: (t) => t.anInt.equals(4) | t.anInt.equals(5),
      );
    });

    test(
        'when using offset parameter then specified number of rows are skipped',
        () async {
      // Insert more test data with different values
      await Types.db.insert(
        session,
        [
          Types(
              anInt: 3,
              aBool: false,
              aDouble: 3.5,
              aString: 'third_new',
              aDateTime: DateTime(2024, 3, 1)),
          Types(
              anInt: 4,
              aBool: true,
              aDouble: 4.5,
              aString: 'fourth',
              aDateTime: DateTime(2024, 4, 1)),
          Types(
              anInt: 5,
              aBool: false,
              aDouble: 5.5,
              aString: 'fifth',
              aDateTime: DateTime(2024, 5, 1)),
        ],
      );

      // Update with offset - skip first 2 rows (when ordered by anInt ascending)
      // From setup we have anInt=1, we're adding 3,4,5
      // When ordered: 1, 3, 4, 5 - skip 2 means update 4, 5
      var updated = await Types.db.updateWhere(
        session,
        columnValues: (t) => [t.aString('offset_update')],
        where: (t) => t.anInt.notEquals(null),
        orderBy: (t) => t.anInt,
        offset: 2,
      );

      // Should update rows after offset
      expect(updated.every((r) => r.aString == 'offset_update'), isTrue);
      expect(updated.map((r) => r.anInt).toSet(), {4, 5});

      // Verify first 2 rows (anInt 1 and 3) were NOT updated
      var notUpdatedRows = await Types.db.find(
        session,
        where: (t) => t.anInt.equals(1) | t.anInt.equals(3),
      );
      expect(notUpdatedRows.any((r) => r.aString == 'offset_update'), isFalse);

      // Clean up additional test data
      await Types.db.deleteWhere(
        session,
        where: (t) => t.anInt.equals(3) | t.anInt.equals(4) | t.anInt.equals(5),
      );
    });

    test(
        'when using limit and offset together then correct window of rows is updated',
        () async {
      // Insert more test data
      await Types.db.insert(
        session,
        [
          Types(
              anInt: 3,
              aBool: false,
              aDouble: 3.5,
              aString: 'third_new',
              aDateTime: DateTime(2024, 3, 1)),
          Types(
              anInt: 4,
              aBool: true,
              aDouble: 4.5,
              aString: 'fourth',
              aDateTime: DateTime(2024, 4, 1)),
          Types(
              anInt: 5,
              aBool: false,
              aDouble: 5.5,
              aString: 'fifth',
              aDateTime: DateTime(2024, 5, 1)),
          Types(
              anInt: 6,
              aBool: true,
              aDouble: 6.5,
              aString: 'sixth',
              aDateTime: DateTime(2024, 6, 1)),
        ],
      );

      // Update with limit and offset - skip 1, take 2 (when ordered by anInt)
      var updated = await Types.db.updateWhere(
        session,
        columnValues: (t) => [t.aString('window_update')],
        where: (t) => t.anInt.notEquals(null),
        orderBy: (t) => t.anInt,
        limit: 2,
        offset: 1,
      );

      // Should update exactly 2 rows: anInt 3 and 4
      expect(updated.length, 2);
      expect(updated.every((r) => r.aString == 'window_update'), isTrue);
      expect(updated.map((r) => r.anInt).toSet(), {3, 4});

      // Verify other rows were NOT updated
      var notUpdatedRows = await Types.db.find(
        session,
        where: (t) => t.anInt.equals(1) | t.anInt.equals(5) | t.anInt.equals(6),
      );
      expect(notUpdatedRows.any((r) => r.aString == 'window_update'), isFalse);

      // Clean up
      await Types.db.deleteWhere(
        session,
        where: (t) => t.anInt.inSet({3, 4, 5, 6}),
      );
    });

    test(
        'when using orderByList with multiple columns then rows are ordered correctly',
        () async {
      // Insert test data with specific patterns for multi-column sorting
      await Types.db.insert(
        session,
        [
          Types(
              anInt: 2,
              aBool: true,
              aDouble: 1.0,
              aString: 'group2_first',
              aDateTime: DateTime(2024, 1, 1)),
          Types(
              anInt: 2,
              aBool: false,
              aDouble: 2.0,
              aString: 'group2_second',
              aDateTime: DateTime(2024, 1, 2)),
          Types(
              anInt: 3,
              aBool: true,
              aDouble: 1.0,
              aString: 'group3_first',
              aDateTime: DateTime(2024, 1, 3)),
        ],
      );

      // Update with orderByList - order by anInt desc, then aDouble asc
      var updated = await Types.db.updateWhere(
        session,
        columnValues: (t) => [t.aString('multi_order_update')],
        where: (t) => t.anInt.inSet({2, 3}),
        orderByList: (t) => [
          db_order.Order(column: t.anInt, orderDescending: true),
          db_order.Order(column: t.aDouble, orderDescending: false),
        ],
        limit: 2,
      );

      // Should update group3_first (anInt=3) and group2_first (anInt=2, aDouble=1.0)
      expect(updated.length, 2);
      // Check that we got the right rows (with anInt 2 and 3)
      var sortedByInt = updated.toList()
        ..sort((a, b) => a.anInt!.compareTo(b.anInt!));
      expect(sortedByInt[0].anInt, 2);
      expect(sortedByInt[0].aDouble, 1.0);
      expect(sortedByInt[1].anInt, 3);
      expect(sortedByInt[1].aDouble, 1.0);

      // Verify group2_second was NOT updated
      var notUpdated = await Types.db.findFirstRow(
        session,
        where: (t) => t.anInt.equals(2) & t.aDouble.equals(2.0),
      );
      expect(notUpdated!.aString, 'group2_second');

      // Clean up
      await Types.db.deleteWhere(
        session,
        where: (t) => t.anInt.inSet({2, 3}),
      );
    });

    test('when offset is larger than result set then no rows are updated',
        () async {
      // Try to update with offset larger than available rows
      var updated = await Types.db.updateWhere(
        session,
        columnValues: (t) => [t.aString('should_not_update')],
        where: (t) => t.anInt.notEquals(null),
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
        where: (t) => t.anInt.notEquals(null),
        limit: 0,
      );

      expect(updated, isEmpty);
    });

    test('when using all parameters together then correct subset is updated',
        () async {
      // Insert comprehensive test data
      await Types.db.insert(
        session,
        [
          Types(
              anInt: 10,
              aBool: true,
              aDouble: 10.5,
              aString: 'ten',
              aDateTime: DateTime(2024, 10, 1)),
          Types(
              anInt: 11,
              aBool: false,
              aDouble: 11.5,
              aString: 'eleven',
              aDateTime: DateTime(2024, 11, 1)),
          Types(
              anInt: 12,
              aBool: true,
              aDouble: 12.5,
              aString: 'twelve',
              aDateTime: DateTime(2024, 12, 1)),
          Types(
              anInt: 13,
              aBool: false,
              aDouble: 13.5,
              aString: 'thirteen',
              aDateTime: DateTime(2025, 1, 1)),
        ],
      );

      // Complex update with all parameters
      var updated = await Types.db.updateWhere(
        session,
        columnValues: (t) => [t.aString('complex_update')],
        where: (t) => t.anInt > 0,
        orderByList: (t) => [
          db_order.Order(column: t.anInt, orderDescending: true),
        ],
        limit: 2,
        offset: 1,
      );

      // Should update anInt 12 and 11 (skip 13, take 2)
      expect(updated.length, 2);
      expect(updated.map((r) => r.anInt).toSet(), {11, 12});
      expect(updated.every((r) => r.aString == 'complex_update'), isTrue);

      // Clean up
      await Types.db.deleteWhere(
        session,
        where: (t) => t.anInt.inSet({10, 11, 12, 13}),
      );
    });
  });
}
