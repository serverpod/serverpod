import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given an existing UniqueData entry', () {
    late UniqueData existingEntry;

    setUp(() async {
      existingEntry = await UniqueData.db.insertRow(
        session,
        UniqueData(number: 1, email: 'original@serverpod.dev'),
      );
    });

    tearDown(() async {
      await UniqueData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
    });

    test(
        'when updating by id with a single column then only that column is updated',
        () async {
      var updated = await UniqueData.db.updateById(
        session,
        existingEntry.id!,
        (t) => [t.number(42)],
      );

      expect(updated, isNotNull);
      expect(updated!.number, 42);
      expect(updated.email, 'original@serverpod.dev');
    });

    test(
        'when updating by id with multiple columns then all specified columns are updated',
        () async {
      var updated = await UniqueData.db.updateById(
        session,
        existingEntry.id!,
        (t) => [t.number(100), t.email('updated@serverpod.dev')],
      );

      expect(updated, isNotNull);
      expect(updated!.number, 100);
      expect(updated.email, 'updated@serverpod.dev');
    });

    test(
        'when updating by id within a transaction then update is part of transaction',
        () async {
      try {
        await session.db.transaction((transaction) async {
          var updated = await UniqueData.db.updateById(
            session,
            existingEntry.id!,
            (t) => [t.number(42)],
            transaction: transaction,
          );

          expect(updated, isNotNull);
          expect(updated!.number, 42);

          // Throw to rollback the transaction
          throw Exception('Rollback');
        });
      } catch (e) {
        // Expected error for rollback
      }

      // Verify the update was rolled back
      var result = await UniqueData.db.findById(session, existingEntry.id!);
      expect(result!.number, 1);
    });
  });

  group('Given no existing data', () {
    tearDown(() async {
      await UniqueData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
    });

    test('when updating by non-existent id then null is returned', () async {
      var updated = await UniqueData.db.updateById(
        session,
        999999,
        (t) => [t.number(123)],
      );

      expect(updated, isNull);
    });
  });

  group('Given a Types entry with values', () {
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

    tearDown(() async {
      await Types.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
    });

    test(
        'when updating specific columns by id then only those columns are updated and others remain unchanged',
        () async {
      var updated = await Types.db.updateById(
        session,
        existingEntry.id!,
        (t) => [t.anInt(42), t.aString('updated')],
      );

      expect(updated, isNotNull);
      expect(updated!.anInt, 42);
      expect(updated.aString, 'updated');
      expect(updated.aBool, true);
      expect(updated.aDouble, 1.5);
      expect(updated.aDateTime, DateTime.utc(2024, 1, 1));
    });
  });

  group('Given a Types entry with null values', () {
    late Types existingEntry;

    setUp(() async {
      existingEntry = await Types.db.insertRow(
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

    tearDown(() async {
      await Types.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
    });

    test(
        'when updating specific columns by id then only those columns are updated',
        () async {
      var updated = await Types.db.updateById(
        session,
        existingEntry.id!,
        (t) => [t.anInt(42), t.aBool(true), t.aString('value')],
      );

      expect(updated, isNotNull);
      expect(updated!.anInt, 42);
      expect(updated.aBool, true);
      expect(updated.aString, 'value');
      expect(updated.aDouble, isNull);
      expect(updated.aDateTime, isNull);
    });

    test('when updating a column to null then the column is set to null',
        () async {
      // First set some values
      var firstUpdate = await Types.db.updateById(
        session,
        existingEntry.id!,
        (t) => [t.anInt(42), t.aString('test')],
      );
      expect(firstUpdate!.anInt, 42);
      expect(firstUpdate.aString, 'test');

      // Now set them back to null
      var updated = await Types.db.updateById(
        session,
        existingEntry.id!,
        (t) => [t.anInt(null), t.aString(null)],
      );

      expect(updated, isNotNull);
      expect(updated!.anInt, isNull);
      expect(updated.aString, isNull);
    });
  });
}
