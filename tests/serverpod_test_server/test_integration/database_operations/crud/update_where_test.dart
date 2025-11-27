import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given database entries with basic matching criteria',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      setUp(() async {
        await Types.db.insert(
          session,
          [
            Types(anInt: 1, aString: 'first', aBool: true, aDouble: 1.5),
            Types(anInt: 2, aString: 'second', aBool: false, aDouble: 2.5),
            Types(anInt: 3, aString: 'third', aBool: true, aDouble: 3.5),
            Types(anInt: 1, aString: 'duplicate', aBool: false, aDouble: 4.5),
          ],
        );
      });

      group('when updating where with no columns specified', () {
        test('then ArgumentError is thrown', () {
          expect(
            () => Types.db.updateWhere(
              session,
              columnValues: (t) => [],
              where: (t) => t.anInt.equals(1),
            ),
            throwsA(isA<ArgumentError>()),
          );
        });

        test('then the rows remain unchanged in the database', () async {
          var dbRow = await Types.db.findFirstRow(
            session,
            where: (t) => t.anInt.equals(1),
          );
          expect(dbRow, isNotNull);
          expect(dbRow!.anInt, 1);
          expect(dbRow.aString, 'first');
        });
      });

      group(
        'when updating where number equals specific value for a single column',
        () {
          const updatedNumber = 42;
          late List<Types> updated;

          setUp(() async {
            updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.anInt(updatedNumber)],
              where: (t) => t.anInt.equals(1),
            );
          });

          test('then the updated result returns all matching updated rows', () {
            expect(updated, hasLength(2));
            var numbers = updated.map((row) => row.anInt);
            expect(numbers, everyElement(updatedNumber));
          });

          test('then all matching rows are updated in the database', () async {
            var dbRows = await Types.db.find(
              session,
              where: (t) => t.anInt.equals(updatedNumber),
            );
            expect(dbRows, hasLength(2));
            var dbNumbers = dbRows.map((row) => row.anInt);
            expect(dbNumbers, everyElement(updatedNumber));
          });

          test('then non-selected columns remain unchanged', () {
            var emails = updated.map((e) => e.aString);
            expect(
              emails,
              containsAll(['first', 'duplicate']),
            );
          });
        },
      );

      group(
        'when updating where number matches complex criteria for a single column',
        () {
          const updatedComplexNumber = 200;
          late List<Types> updated;

          setUp(() async {
            updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.anInt(updatedComplexNumber)],
              where: (t) => t.anInt.equals(2) | t.anInt.equals(3),
            );
          });

          test('then the updated result returns only matching rows', () {
            expect(updated, hasLength(2));
            var numbers = updated.map((row) => row.anInt);
            expect(numbers, everyElement(updatedComplexNumber));
          });

          test('then only matching rows are updated in the database', () async {
            var dbRows = await Types.db.find(
              session,
              where: (t) => t.anInt.equals(updatedComplexNumber),
            );
            expect(dbRows, hasLength(2));
            var emails = dbRows.map((e) => e.aString);
            expect(
              emails,
              containsAll(['second', 'third']),
            );
          });

          test('then non-selected columns remain unchanged', () {
            var emails = updated.map((e) => e.aString);
            expect(
              emails,
              containsAll(['second', 'third']),
            );
          });
        },
      );

      group('when updating where criteria matches for multiple columns', () {
        const updatedInt = 42;
        const updatedString = 'updated';
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [
              t.anInt(updatedInt),
              t.aString(updatedString),
            ],
            where: (t) => t.anInt.equals(1),
          );
        });

        test(
          'then the updated result returns updated rows with new values',
          () {
            expect(updated, hasLength(2));
            var updatedNumbers = updated.map((row) => row.anInt);
            expect(updatedNumbers, everyElement(updatedInt));
            var updatedStrings = updated.map((row) => row.aString);
            expect(updatedStrings, everyElement(updatedString));
          },
        );

        test(
          'then only selected columns are updated in the database',
          () async {
            var dbUpdatedRows = await Types.db.find(
              session,
              where: (t) => t.anInt.equals(updatedInt),
            );
            expect(dbUpdatedRows, hasLength(2));
            var dbUpdatedNumbers = dbUpdatedRows.map((row) => row.anInt);
            expect(dbUpdatedNumbers, everyElement(updatedInt));
            var dbUpdatedStrings = dbUpdatedRows.map((row) => row.aString);
            expect(dbUpdatedStrings, everyElement(updatedString));
          },
        );

        test('then non-matching rows remain unchanged', () async {
          var nonMatching = await Types.db.findFirstRow(
            session,
            where: (t) => t.anInt.equals(2),
          );
          expect(nonMatching!.aString, 'second');
        });
      });
    },
  );

  withServerpod(
    'Given database entries for transaction testing',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      setUp(() async {
        await Types.db.insert(
          session,
          [
            Types(anInt: 1, aString: 'first'),
            Types(anInt: 2, aString: 'second'),
            Types(anInt: 1, aString: 'duplicate'),
          ],
        );
      });

      group('when updating within an aborted transaction', () {
        const transactionUpdatedInt = 999;

        setUp(() async {
          await session.db.transaction((transaction) async {
            var savepoint = await transaction.createSavepoint();

            var updated = await Types.db.updateWhere(
              session,
              columnValues: (t) => [t.anInt(transactionUpdatedInt)],
              where: (t) => t.anInt.equals(1),
              transaction: transaction,
            );

            expect(updated, hasLength(2));
            expect(
              updated.every((row) => row.anInt == transactionUpdatedInt),
              isTrue,
            );

            await savepoint.rollback();
          });
        });

        test('then update is reverted as part of transaction', () async {
          var results = await Types.db.find(
            session,
            where: (t) => t.anInt.equals(1),
          );
          expect(results, hasLength(2));
          expect(results.every((row) => row.anInt == 1), isTrue);
        });
      });
    },
  );

  withServerpod(
    'Given no matching database entries',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      setUp(() async {
        await Types.db.insert(
          session,
          [
            Types(anInt: 1, aString: 'test'),
          ],
        );
      });

      test(
        'when updating where no rows match then empty list is returned',
        () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.anInt(999)],
            where: (t) => t.anInt.equals(999),
          );

          expect(updated, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given database entries with null values',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      setUp(() async {
        await Types.db.insertRow(
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

      group('when updating where column to non-null value', () {
        const updatedIntFromNull = 99;
        const updatedStringFromNull = 'was_null';
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [
              t.anInt(updatedIntFromNull),
              t.aString(updatedStringFromNull),
            ],
            where: (t) => t.anInt.equals(null),
          );
        });

        test('then null entries are updated to new values', () {
          expect(updated, hasLength(1));
          expect(updated.first.anInt, updatedIntFromNull);
          expect(updated.first.aString, updatedStringFromNull);
        });

        test('then null entries are updated in the database', () async {
          var dbRow = await Types.db.findFirstRow(
            session,
            where: (t) => t.anInt.equals(updatedIntFromNull),
          );
          expect(dbRow, isNotNull);
          expect(dbRow!.anInt, updatedIntFromNull);
          expect(dbRow.aString, updatedStringFromNull);
        });
      });
    },
  );

  withServerpod(
    'Given database entries with non-null values',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      const originalInt = 1;
      const originalString = 'value';
      const originalBool = true;
      const originalDouble = 1.5;

      setUp(() async {
        await Types.db.insertRow(
          session,
          Types(
            anInt: originalInt,
            aBool: originalBool,
            aDouble: originalDouble,
            aString: originalString,
            aDateTime: DateTime(2024, 1, 1),
          ),
        );
      });

      group('when updating non-null values to null values', () {
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.anInt(null), t.aString(null)],
            where: (t) => t.anInt.equals(originalInt),
          );
        });

        test('then selected columns are set to null', () {
          expect(updated, hasLength(1));
          expect(updated.first.anInt, isNull);
          expect(updated.first.aString, isNull);
        });

        test('then selected columns are set to null in the database', () async {
          var dbRow = await Types.db.findFirstRow(
            session,
            where: (t) => t.aBool.equals(originalBool),
          );
          expect(dbRow, isNotNull);
          expect(dbRow!.anInt, isNull);
          expect(dbRow.aString, isNull);
        });

        test('then other columns remain unchanged', () {
          expect(updated.first.aBool, originalBool);
          expect(updated.first.aDouble, originalDouble);
        });

        test('then other columns remain unchanged in the database', () async {
          var dbRow = await Types.db.findFirstRow(
            session,
            where: (t) => t.aBool.equals(originalBool),
          );
          expect(dbRow, isNotNull);
          expect(dbRow!.aBool, originalBool);
          expect(dbRow.aDouble, originalDouble);
        });
      });
    },
  );

  withServerpod(
    'Given database entries for pagination operations',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      const matchingInt = 100;

      setUp(() async {
        await Types.db.insert(
          session,
          [
            Types(
              anInt: matchingInt,
              aBool: true,
              aDouble: 1.0,
              aString: 'entry1',
              aDateTime: DateTime(2024, 1, 1),
            ),
            Types(
              anInt: matchingInt,
              aBool: false,
              aDouble: 2.0,
              aString: 'entry2',
              aDateTime: DateTime(2024, 1, 2),
            ),
            Types(
              anInt: matchingInt,
              aBool: true,
              aDouble: 3.0,
              aString: 'entry3',
              aDateTime: DateTime(2024, 1, 3),
            ),
            Types(
              anInt: matchingInt,
              aBool: false,
              aDouble: 4.0,
              aString: 'entry4',
              aDateTime: DateTime(2024, 1, 4),
            ),
            Types(
              anInt: matchingInt,
              aBool: true,
              aDouble: 5.0,
              aString: 'entry5',
              aDateTime: DateTime(2024, 1, 5),
            ),
          ],
        );
      });

      group('when updating with limit', () {
        const limitedUpdateString = 'limited_update';
        const limit = 3;
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString(limitedUpdateString)],
            where: (t) => t.anInt.equals(matchingInt),
            orderBy: (t) => t.aDouble,
            limit: limit,
          );
        });

        test('then limited number of rows are updated', () {
          expect(updated, hasLength(limit));
          var updatedStrings = updated.map((r) => r.aString);
          expect(updatedStrings, everyElement(limitedUpdateString));
        });

        test('then remaining rows are unaffected', () async {
          var allRows = await Types.db.find(
            session,
            where: (t) => t.anInt.equals(matchingInt),
          );
          var unchangedRows = allRows
              .where((r) => r.aString != limitedUpdateString)
              .toList();
          expect(unchangedRows, hasLength(2));
          expect(
            unchangedRows.map((r) => r.aString).toSet(),
            containsAll(['entry4', 'entry5']),
          );
        });

        test('then limit 0 updates no rows', () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('zero_limit_update')],
            where: (t) => t.anInt.equals(matchingInt),
            limit: 0,
          );

          expect(updated, isEmpty);
        });
      });

      group('when updating with orderDescending', () {
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('ordered_update')],
            where: (t) => t.anInt.equals(matchingInt),
            orderBy: (t) => t.aDouble,
            orderDescending: true,
            limit: 2,
          );
        });

        test('then rows are ordered correctly in descending order', () {
          expect(updated, hasLength(2));
          expect(updated[0].aDouble, 5.0);
          expect(updated[1].aDouble, 4.0);
        });
      });

      group('when updating with offset', () {
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('offset_update')],
            where: (t) => t.anInt.equals(matchingInt),
            orderBy: (t) => t.aDouble,
            offset: 2,
          );
        });

        test('then first offset rows are skipped', () {
          expect(updated, hasLength(3));
          expect(updated.map((r) => r.aDouble).toSet(), {3.0, 4.0, 5.0});
        });

        test('then skipped rows remain unchanged', () async {
          var allRows = await Types.db.find(
            session,
            where: (t) => t.anInt.equals(matchingInt),
            orderBy: (t) => t.aDouble,
          );

          expect(allRows[0].aString, 'entry1');
          expect(allRows[1].aString, 'entry2');
        });

        test('then large offset beyond result set updates no rows', () async {
          var updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('should_not_update')],
            where: (t) => t.anInt.equals(matchingInt),
            offset: 1000,
          );

          expect(updated, isEmpty);

          var allRows = await Types.db.find(
            session,
            where: (t) => t.aString.equals('should_not_update'),
          );
          expect(allRows, isEmpty);
        });
      });

      group('when updating with limit and offset', () {
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aString('window_update')],
            where: (t) => t.anInt.equals(matchingInt),
            orderBy: (t) => t.aDouble,
            limit: 2,
            offset: 1,
          );
        });

        test('then windowed rows are updated', () {
          expect(updated, hasLength(2));
          expect(updated.map((r) => r.aDouble).toSet(), {2.0, 3.0});
        });
      });
    },
  );

  withServerpod(
    'Given database entries with all supported data types',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      setUp(() async {
        await Types.db.insert(
          session,
          [
            Types(
              anInt: 1,
              aBool: true,
              aDouble: 1.5,
              aDateTime: DateTime(2024, 1, 1),
              aString: 'first',
              aByteData: ByteData.view(Uint8List.fromList([1, 2, 3]).buffer),
              aDuration: Duration(seconds: 30),
              aUuid: UuidValue.fromString(
                '550e8400-e29b-41d4-a716-446655440000',
              ),
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
            Types(
              anInt: 2,
              aBool: false,
              aDouble: 2.5,
              aDateTime: DateTime(2024, 2, 1),
              aString: 'second',
              aByteData: ByteData.view(Uint8List.fromList([7, 8, 9]).buffer),
              aDuration: Duration(minutes: 1),
              aUuid: UuidValue.fromString(
                '456e7890-e12b-34c5-a678-901234567890',
              ),
              aUri: Uri.parse('https://example.com'),
              aBigInt: BigInt.from(987654321),
              aVector: Vector([7.0, 8.0, 9.0]),
              aHalfVector: HalfVector([7.0, 8.0, 9.0]),
              aSparseVector: SparseVector([7.0, 8.0, 9.0]),
              aBit: Bit([false, true, false]),
              anEnum: TestEnum.two,
              aStringifiedEnum: TestEnumStringified.two,
              aList: [7, 8, 9],
              aMap: {7: 70, 8: 80},
              aSet: {7, 8, 9},
              aRecord: ('second', optionalUri: Uri.parse('https://second.com')),
            ),
          ],
        );
      });

      group('when updating all supported data types', () {
        late List<Types> updated;

        setUp(() async {
          updated = await Types.db.updateWhere(
            session,
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
              t.aUri(Uri.parse('https://updated.com')),
              t.aBigInt(BigInt.from(555666777)),
              t.aVector(Vector([4.0, 5.0, 6.0])),
              t.aHalfVector(HalfVector([4.0, 5.0, 6.0])),
              t.aSparseVector(SparseVector([4.0, 5.0, 6.0])),
              t.aBit(Bit([false, true, false])),
              t.anEnum(TestEnum.three),
              t.aStringifiedEnum(TestEnumStringified.three),
              t.aList([4, 5, 6]),
              t.aMap({3: 30, 4: 40}),
              t.aSet({4, 5, 6}),
              t.aRecord(
                ('updated', optionalUri: Uri.parse('https://updated.com')),
              ),
            ],
            where: (t) => t.anInt.equals(1),
          );
        });

        test('then all data types are updated correctly', () {
          expect(updated, hasLength(1));
          expect(updated.first.anInt, 42);
          expect(updated.first.aBool, false);
          expect(updated.first.aDouble, 3.14);
          expect(updated.first.aDateTime, DateTime.utc(2024, 12, 31));
          expect(updated.first.aString, 'updated');
          expect(
            Uint8List.view(
              updated.first.aByteData!.buffer,
              updated.first.aByteData!.offsetInBytes,
              updated.first.aByteData!.lengthInBytes,
            ).toList(),
            [4, 5, 6],
          );
          expect(updated.first.aDuration, Duration(minutes: 5));
          expect(
            updated.first.aUuid,
            UuidValue.fromString('123e4567-e89b-12d3-a456-426614174000'),
          );
          expect(updated.first.aUri, Uri.parse('https://updated.com'));
          expect(updated.first.aBigInt, BigInt.from(555666777));
          expect(updated.first.aVector, Vector([4.0, 5.0, 6.0]));
          expect(updated.first.aHalfVector, HalfVector([4.0, 5.0, 6.0]));
          expect(updated.first.aSparseVector, SparseVector([4.0, 5.0, 6.0]));
          expect(updated.first.aBit, Bit([false, true, false]));
          expect(updated.first.anEnum, TestEnum.three);
          expect(updated.first.aStringifiedEnum, TestEnumStringified.three);
          expect(updated.first.aList, [4, 5, 6]);
          expect(updated.first.aMap, {3: 30, 4: 40});
          expect(updated.first.aSet, {4, 5, 6});
          expect(updated.first.aRecord, (
            'updated',
            optionalUri: Uri.parse('https://updated.com'),
          ));
        });

        test('then all data types are updated in the database', () async {
          var dbRow = await Types.db.findFirstRow(
            session,
            where: (t) => t.anInt.equals(42),
          );
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
          expect(dbRow.aUri, Uri.parse('https://updated.com'));
          expect(dbRow.aBigInt, BigInt.from(555666777));
          expect(dbRow.aVector, Vector([4.0, 5.0, 6.0]));
          expect(dbRow.aHalfVector, HalfVector([4.0, 5.0, 6.0]));
          expect(dbRow.aSparseVector, SparseVector([4.0, 5.0, 6.0]));
          expect(dbRow.aBit, Bit([false, true, false]));
          expect(dbRow.anEnum, TestEnum.three);
          expect(dbRow.aStringifiedEnum, TestEnumStringified.three);
          expect(dbRow.aList, [4, 5, 6]);
          expect(dbRow.aMap, {3: 30, 4: 40});
          expect(dbRow.aSet, {4, 5, 6});
          expect(dbRow.aRecord, (
            'updated',
            optionalUri: Uri.parse('https://updated.com'),
          ));
        });

        test('then non-matching rows remain unchanged', () async {
          var unchangedRow = await Types.db.findFirstRow(
            session,
            where: (t) => t.anInt.equals(2),
          );
          expect(unchangedRow, isNotNull);
          expect(unchangedRow!.aString, 'second');
          expect(unchangedRow.aBool, false);
          expect(unchangedRow.anEnum, TestEnum.two);
        });
      });
    },
  );
}
