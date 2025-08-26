import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given updateById operations',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      group('Given an existing UniqueData entry', () {
        late UniqueData existingEntry;

        setUp(() async {
          existingEntry = await UniqueData.db.insertRow(
            session,
            UniqueData(number: 1, email: 'original@serverpod.dev'),
          );
        });

        test(
            'when updating by id for a single column then only that column is updated',
            () async {
          var updated = await UniqueData.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [t.number(42)],
          );

          expect(updated, isNotNull);
          expect(updated!.number, 42);
          expect(updated.email, 'original@serverpod.dev');
        });
      });

      test('when updating by non-existent id then null is returned', () async {
        var updated = await UniqueData.db.updateById(
          session,
          999999,
          columnValues: (t) => [t.number(123)],
        );

        expect(updated, isNull);
      });

      group('Given a Types entry', () {
        late Types existingEntry;
        late Types existingNullEntry;

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
            'when updating specific columns by id then only those columns are updated and others remain unchanged',
            () async {
          var updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [t.anInt(42), t.aString('updated')],
          );

          expect(updated, isNotNull);
          expect(updated!.anInt, 42);
          expect(updated.aString, 'updated');
          expect(updated.aBool, true);
          expect(updated.aDouble, 1.5);
          expect(updated.aDateTime, DateTime.utc(2024, 1, 1));
        });

        test('when updating a column to null then the column is set to null',
            () async {
          var updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [t.anInt(null), t.aString(null)],
          );

          expect(updated, isNotNull);
          expect(updated!.anInt, isNull);
          expect(updated.aString, isNull);
          // Other fields should remain unchanged
          expect(updated.aBool, true);
          expect(updated.aDouble, 1.5);
          expect(updated.aDateTime, DateTime.utc(2024, 1, 1));
        });

        test(
            'when updating null columns to non-null values then the columns are set correctly',
            () async {
          var updated = await Types.db.updateById(
            session,
            existingNullEntry.id!,
            columnValues: (t) => [t.anInt(99), t.aString('was_null')],
          );

          expect(updated, isNotNull);
          expect(updated!.anInt, 99);
          expect(updated.aString, 'was_null');
          // Other fields should remain null
          expect(updated.aBool, isNull);
          expect(updated.aDouble, isNull);
          expect(updated.aDateTime, isNull);
        });
      });

      test(
          'when updating by id within an aborted transaction then update reverted as part of transaction',
          () async {
        var existingEntry = await UniqueData.db.insertRow(
          session,
          UniqueData(number: 1, email: 'original@serverpod.dev'),
        );

        await expectLater(
          session.db.transaction((transaction) async {
            var updated = await UniqueData.db.updateById(
              session,
              existingEntry.id!,
              columnValues: (t) => [t.number(42)],
              transaction: transaction,
            );

            expect(updated, isNotNull);
            expect(updated!.number, 42);

            // Note: We use an exception to rollback the transaction instead of
            // transaction.cancel() because the withServerpod test framework
            // wraps all tests in a transaction for automatic rollback.
            // Using transaction.cancel() causes the underlying connection to close,
            // which conflicts with the test framework's transaction management.
            throw Exception('Rollback transaction');
          }),
          throwsA(isA<Exception>()),
        );

        var result = await UniqueData.db.findById(session, existingEntry.id!);
        expect(result!.number, 1);
      });
    },
  );
}
