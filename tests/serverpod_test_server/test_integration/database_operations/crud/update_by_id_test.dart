import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a database entry with all basic fields',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      const originalBool = true;
      const originalInt = 1;
      const originalString = 'original';

      late Types existingEntry;

      setUp(() async {
        existingEntry = await Types.db.insertRow(
          session,
          Types(
            aBool: originalBool,
            anInt: originalInt,
            aString: originalString,
          ),
        );
      });

      group('when updating by id with no columns specified', () {
        test('then ArgumentError is thrown', () {
          expect(
            () => Types.db.updateById(
              session,
              existingEntry.id!,
              columnValues: (t) => [],
            ),
            throwsA(isA<ArgumentError>()),
          );
        });

        test(
          'then the row remains unchanged in the database',
          () async {
            var dbRow = await Types.db.findById(session, existingEntry.id!);
            expect(dbRow, isNotNull);
            expect(dbRow!.anInt, originalInt);
            expect(dbRow.aBool, originalBool);
            expect(dbRow.aString, originalString);
          },
        );
      });

      group('when updating by id for a single column', () {
        const updatedInt = 42;
        late Types? updated;

        setUp(() async {
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
          expect(updated!.aString, originalString);
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
            expect(dbRow.aString, originalString);
          },
        );
      });

      group('when updating by id for multiple columns', () {
        const updatedInt = 42;
        const updatedString = 'updated';
        late Types? updated;

        setUp(() async {
          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [
              t.anInt(updatedInt),
              t.aString(updatedString),
            ],
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

      group('when updating within an aborted transaction', () {
        const transactionUpdatedInt = 42;

        setUp(() async {
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
    'Given a database entry with non-null values',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      const originalInt = 1;
      const originalString = 'original';

      late Types existingEntry;

      setUp(() async {
        existingEntry = await Types.db.insertRow(
          session,
          Types(anInt: originalInt, aString: originalString),
        );
      });

      group('when updating non-null columns to null values', () {
        late Types? updated;

        setUp(() async {
          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [t.anInt(null), t.aString(null)],
          );
        });

        test('then the column is set to null', () {
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
    },
  );

  withServerpod(
    'Given a database entry with null values',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      late Types existingEntry;

      setUp(() async {
        existingEntry = await Types.db.insertRow(
          session,
          Types(anInt: null, aString: null),
        );
      });

      group('when updating null columns to non-null values', () {
        const updatedInt = 1;
        const updatedString = 'updated';
        late Types? updated;

        setUp(() async {
          updated = await Types.db.updateById(
            session,
            existingEntry.id!,
            columnValues: (t) => [
              t.anInt(updatedInt),
              t.aString(updatedString),
            ],
          );
        });

        test('then the columns are set to the new values', () {
          expect(updated, isNotNull);
          expect(updated!.anInt, updatedInt);
          expect(updated!.aString, updatedString);
        });
      });
    },
  );

  withServerpod(
    'Given a database entry with all supported data types',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      late Types existingEntry;

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
            aUuid: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
            aUri: Uri.parse('https://serverpod.dev'),
            aBigInt: BigInt.from(123456789),
            aVector: Vector([1.0, 2.0, 3.0]),
            aHalfVector: HalfVector([1.0, 2.0, 3.0]),
            aSparseVector: SparseVector([1.0, 2.0, 3.0]),
            aBit: Bit([true, false, true]),
            anEnum: TestEnum.one,
            aStringifiedEnum: TestEnumStringified.one,
            aList: [1, 2, 3],
            aMap: {1: 10, 2: 20},
            aSet: {1, 2, 3},
            aRecord: (
              'original',
              optionalUri: Uri.parse('https://example.com'),
            ),
          ),
        );
      });

      group('when updating all supported data types', () {
        late Types? updated;

        setUp(() async {
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
                UuidValue.fromString('123e4567-e89b-12d3-a456-426614174000'),
              ),
              t.aUri(Uri.parse('https://example.com')),
              t.aBigInt(BigInt.from(987654321)),
              t.aVector(Vector([4.0, 5.0, 6.0])),
              t.aHalfVector(HalfVector([4.0, 5.0, 6.0])),
              t.aSparseVector(SparseVector([4.0, 5.0, 6.0])),
              t.aBit(Bit([false, true, false])),
              t.anEnum(TestEnum.two),
              t.aStringifiedEnum(TestEnumStringified.two),
              t.aList([4, 5, 6]),
              t.aMap({3: 30, 4: 40}),
              t.aSet({4, 5, 6}),
              t.aRecord(
                ('updated', optionalUri: Uri.parse('https://updated.com')),
              ),
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
            [4, 5, 6],
          );
          expect(updated!.aDuration, Duration(minutes: 5));
          expect(
            updated!.aUuid,
            UuidValue.fromString('123e4567-e89b-12d3-a456-426614174000'),
          );
          expect(updated!.aUri, Uri.parse('https://example.com'));
          expect(updated!.aBigInt, BigInt.from(987654321));
          expect(updated!.aVector, Vector([4.0, 5.0, 6.0]));
          expect(updated!.aHalfVector, HalfVector([4.0, 5.0, 6.0]));
          expect(updated!.aSparseVector, SparseVector([4.0, 5.0, 6.0]));
          expect(updated!.aBit, Bit([false, true, false]));
          expect(updated!.anEnum, TestEnum.two);
          expect(updated!.aStringifiedEnum, TestEnumStringified.two);
          expect(updated!.aList, [4, 5, 6]);
          expect(updated!.aMap, {3: 30, 4: 40});
          expect(updated!.aSet, {4, 5, 6});
          expect(updated!.aRecord, (
            'updated',
            optionalUri: Uri.parse('https://updated.com'),
          ));
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
            [4, 5, 6],
          );
          expect(dbRow.aDuration, Duration(minutes: 5));
          expect(
            dbRow.aUuid,
            UuidValue.fromString('123e4567-e89b-12d3-a456-426614174000'),
          );
          expect(dbRow.aUri, Uri.parse('https://example.com'));
          expect(dbRow.aBigInt, BigInt.from(987654321));
          expect(dbRow.aVector, Vector([4.0, 5.0, 6.0]));
          expect(dbRow.aHalfVector, HalfVector([4.0, 5.0, 6.0]));
          expect(dbRow.aSparseVector, SparseVector([4.0, 5.0, 6.0]));
          expect(dbRow.aBit, Bit([false, true, false]));
          expect(dbRow.anEnum, TestEnum.two);
          expect(dbRow.aStringifiedEnum, TestEnumStringified.two);
          expect(dbRow.aList, [4, 5, 6]);
          expect(dbRow.aMap, {3: 30, 4: 40});
          expect(dbRow.aSet, {4, 5, 6});
          expect(dbRow.aRecord, (
            'updated',
            optionalUri: Uri.parse('https://updated.com'),
          ));
        });
      });
    },
  );

  withServerpod(
    'Given a non-existent database entry',
    (testSession, endpoints) {
      var session = testSession.build();

      test(
        'when updating by non-existent id then DatabaseUpdateRowException is thrown',
        () async {
          var updated = Types.db.updateById(
            session,
            999999,
            columnValues: (t) => [t.anInt(123)],
          );

          expect(updated, throwsA(isA<DatabaseUpdateRowException>()));
        },
      );
    },
  );
}
