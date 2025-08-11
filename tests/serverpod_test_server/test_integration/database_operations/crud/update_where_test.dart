import 'package:serverpod/serverpod.dart';
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
  });
}
