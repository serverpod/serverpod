import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a database entry',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      group('when updating by id for a single column', () {
        const originalBool = true;
        const originalInt = 1;
        const updatedInt = 42;

        late Types existingEntry;
        late Types? updated;

        setUp(() async {
          existingEntry = await Types.db.insertRow(
            session,
            Types(
              aBool: originalBool,
              anInt: originalInt,
            ),
          );

          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [t.anInt(updatedInt)],
          );
        });

        test('then the updated result returns the updated row', () {
          expect(updated, isNotNull);
          expect(updated!.anInt, updatedInt);
          expect(updated!.aBool, originalBool);
          expect(updated!.aString, isNull);
        });

        test(
          'then only that column is updated',
          () async {
            var dbRow = await Types.db.findById(session, existingEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.anInt, updatedInt);
          },
        );

        test(
          'then other columns are not updated',
          () async {
            var dbRow = await Types.db.findById(session, existingEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.aBool, originalBool);
            expect(dbRow.aString, isNull);
          },
        );
      });

      group('when updating by id for multiple columns', () {
        const originalBool = true;
        const originalInt = 1;
        const originalString = 'original';
        const updatedInt = 42;
        const updatedString = 'updated';

        late Types existingEntry;
        late Types? updated;

        setUp(() async {
          existingEntry = await Types.db.insertRow(
            session,
            Types(
                aBool: originalBool,
                anInt: originalInt,
                aString: originalString),
          );

          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) =>
                [t.anInt(updatedInt), t.aString(updatedString)],
          );
        });

        test('then the updated result returns the updated row', () {
          expect(updated, isNotNull);
          expect(updated!.anInt, updatedInt);
          expect(updated!.aBool, originalBool);
          expect(updated!.aString, updatedString);
        });

        test(
          'then only the selected columns are updated',
          () async {
            var dbRow = await Types.db.findById(session, existingEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.anInt, updatedInt);
            expect(dbRow.aString, updatedString);
          },
        );

        test(
          'then other columns are not updated',
          () async {
            var dbRow = await Types.db.findById(session, existingEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.aBool, originalBool);
          },
        );
      });

      group('when updating non-null columns to null values', () {
        const originalInt = 1;
        const originalString = 'original';

        late Types existingEntry;
        late Types? updated;

        setUp(() async {
          existingEntry = await Types.db.insertRow(
            session,
            Types(anInt: originalInt, aString: originalString),
          );

          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [t.anInt(null), t.aString(null)],
          );
        });

        test('then the column is set to null', () async {
          expect(updated, isNotNull);
          expect(updated!.anInt, isNull);
          expect(updated!.aString, isNull);
        });

        test('then the column is null in the database', () async {
          var dbRow = await Types.db.findById(session, existingEntry.id!);
          expect(dbRow, isNotNull);
          expect(dbRow!.anInt, isNull);
          expect(dbRow.aString, isNull);
        });
      });

      group('when updating null columns to non-null values', () {
        const updatedInt = 1;
        const updatedString = 'updated';

        late Types existingEntry;
        late Types? updated;

        setUp(() async {
          existingEntry = await Types.db.insertRow(
            session,
            Types(anInt: null, aString: null),
          );

          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) =>
                [t.anInt(updatedInt), t.aString(updatedString)],
          );
        });

        test('then the columns are set to the new values', () {
          expect(updated, isNotNull);
          expect(updated!.anInt, updatedInt);
          expect(updated!.aString, updatedString);
        });
      });

      group('when updating all supported data types', () {
        // Note: The following data types are not supported for database updates:
        // - aVector, aHalfVector, aSparseVector, aBit (vector types)
        // - aList, aMap, aSet, aRecord (complex collection types)
        late Types existingEntry;
        late Types? updated;

        setUp(() async {
          existingEntry = await Types.db.insertRow(
            session,
            Types(
              anInt: 1,
              aBool: true,
              aDouble: 1.5,
              aDateTime: DateTime(2024, 1, 1),
              aString: 'original',
              aByteData: ByteData.view(Uint8List.fromList([1, 2, 3]).buffer),
              aDuration: Duration(seconds: 30),
              aUuid:
                  UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
              aUri: Uri.parse('https://serverpod.dev'),
              aBigInt: BigInt.from(123456789),
              anEnum: TestEnum.one,
              aStringifiedEnum: TestEnumStringified.one,
            ),
          );

          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [
              t.anInt(42),
              t.aBool(false),
              t.aDouble(3.14),
              t.aDateTime(DateTime.utc(2024, 12, 31)),
              t.aString('updated'),
              t.aByteData(ByteData.view(Uint8List.fromList([4, 5, 6]).buffer)),
              t.aDuration(Duration(minutes: 5)),
              t.aUuid(
                  UuidValue.fromString('123e4567-e89b-12d3-a456-426614174000')),
              t.aUri(Uri.parse('https://example.com')),
              t.aBigInt(BigInt.from(987654321)),
              t.anEnum(TestEnum.two),
              t.aStringifiedEnum(TestEnumStringified.two),
            ],
          );
        });

        test('then all data types are updated correctly', () {
          expect(updated, isNotNull);
          expect(updated!.anInt, 42);
          expect(updated!.aBool, false);
          expect(updated!.aDouble, 3.14);
          expect(updated!.aDateTime, DateTime.utc(2024, 12, 31));
          expect(updated!.aString, 'updated');
          expect(
              Uint8List.view(
                updated!.aByteData!.buffer,
                updated!.aByteData!.offsetInBytes,
                updated!.aByteData!.lengthInBytes,
              ).toList(),
              [4, 5, 6]);
          expect(updated!.aDuration, Duration(minutes: 5));
          expect(updated!.aUuid,
              UuidValue.fromString('123e4567-e89b-12d3-a456-426614174000'));
          expect(updated!.aUri, Uri.parse('https://example.com'));
          expect(updated!.aBigInt, BigInt.from(987654321));
          expect(updated!.anEnum, TestEnum.two);
          expect(updated!.aStringifiedEnum, TestEnumStringified.two);
        });

        test('then all data types are updated in the database', () async {
          var dbRow = await Types.db.findById(session, existingEntry.id!);
          expect(dbRow, isNotNull);
          expect(dbRow!.anInt, 42);
          expect(dbRow.aBool, false);
          expect(dbRow.aDouble, 3.14);
          expect(dbRow.aDateTime, DateTime.utc(2024, 12, 31));
          expect(dbRow.aString, 'updated');
          expect(
              Uint8List.view(
                dbRow.aByteData!.buffer,
                dbRow.aByteData!.offsetInBytes,
                dbRow.aByteData!.lengthInBytes,
              ).toList(),
              [4, 5, 6]);
          expect(dbRow.aDuration, Duration(minutes: 5));
          expect(dbRow.aUuid,
              UuidValue.fromString('123e4567-e89b-12d3-a456-426614174000'));
          expect(dbRow.aUri, Uri.parse('https://example.com'));
          expect(dbRow.aBigInt, BigInt.from(987654321));
          expect(dbRow.anEnum, TestEnum.two);
          expect(dbRow.aStringifiedEnum, TestEnumStringified.two);
        });
      });

      group('when updating within an aborted transaction', () {
        const originalInt = 1;
        const transactionUpdatedInt = 42;

        late Types existingEntry;

        setUp(() async {
          existingEntry = await Types.db.insertRow(
            session,
            Types(anInt: originalInt),
          );

          await session.db.transaction((transaction) async {
            var savepoint = await transaction.createSavepoint();

            await Types.db.updateById(
              session,
              existingEntry.id!,
              columnValues: (t) => [t.anInt(transactionUpdatedInt)],
              transaction: transaction,
            );

            await savepoint.rollback();
          });
        });

        test('then update is reverted as part of transaction', () async {
          var result = await Types.db.findById(session, existingEntry.id!);
          expect(result!.anInt, originalInt);
        });
      });
    },
  );

  withServerpod(
    'Given a non-existent database entry',
    (testSession, endpoints) {
      var session = testSession.build();

      test('when updating by non-existent id then null is returned', () async {
        var updated = await Types.db.updateById(
          session,
          999999,
          columnValues: (t) => [t.anInt(123)],
        );

        expect(updated, isNull);
      });
    },
  );
}
