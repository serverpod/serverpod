import 'dart:typed_data';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../test_util.dart';
import '../utils/test_transaction.dart';

void main() {
  initTestClientSession();

  group('Given rows containing typed values and SQL punctuation, ', () {
    late List<Types> rows;

    setUp(() {
      final row = Types(
        id: 1,
        anInt: 42,
        aBool: true,
        aDouble: 1.5,
        aDateTime: DateTime.utc(2024),
        aString: "quoted'; DELETE FROM types; -- unicode ☃",
        aByteData: ByteData.sublistView(
          Uint8List.fromList([9, 0, 255, 8]),
          1,
          3,
        ),
        aDuration: const Duration(milliseconds: 321),
        aUuid: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        aUri: Uri.parse('https://example.com'),
        aBigInt: BigInt.parse('123456789012345678901234567890'),
        aVector: Vector([1.0, 2.0, 3.0]),
        aHalfVector: HalfVector([1.0, 2.0, 3.0]),
        aSparseVector: SparseVector([1.0, 2.0, 3.0]),
        aBit: Bit([true, false, true]),
        anEnum: TestEnum.one,
        aStringifiedEnum: TestEnumStringified.two,
        aList: [1, 2],
        aMap: {1: 2},
        aSet: {1, 2},
        aRecord: ('quoted\'', optionalUri: Uri.parse('https://example.com')),
      );
      rows = [row, row.copyWith(id: 2, aBool: false)];
    });

    group('when inserting without returning rows, ', () {
      late List<Types> returned;
      late List<Types> stored;

      setUp(() async {
        returned = await Types.db.insert(session, rows, noReturn: true);
        stored = await Types.db.find(
          session,
          where: (t) => t.aString.equals(rows.first.aString),
          orderBy: (t) => t.id,
        );
      });

      test('then no models are returned.', () {
        expect(returned, isEmpty);
      });

      test('then all values round trip as data.', () {
        expect(stored.map((r) => r.toJson()), rows.map((r) => r.toJson()));
      });
    });
  });

  group(
    'Given stored rows and replacements containing typed values and SQL punctuation, ',
    () {
      late List<Types> rows;

      setUp(() async {
        final row = Types(
          id: 1,
          anInt: 42,
          aBool: true,
          aDouble: 1.5,
          aDateTime: DateTime.utc(2024),
          aString: "quoted'; DELETE FROM types; -- unicode ☃",
          aByteData: ByteData.sublistView(
            Uint8List.fromList([9, 0, 255, 8]),
            1,
            3,
          ),
          aDuration: const Duration(milliseconds: 321),
          aUuid: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
          aUri: Uri.parse('https://example.com'),
          aBigInt: BigInt.parse('123456789012345678901234567890'),
          aVector: Vector([1.0, 2.0, 3.0]),
          aHalfVector: HalfVector([1.0, 2.0, 3.0]),
          aSparseVector: SparseVector([1.0, 2.0, 3.0]),
          aBit: Bit([true, false, true]),
          anEnum: TestEnum.one,
          aStringifiedEnum: TestEnumStringified.two,
          aList: [1, 2],
          aMap: {1: 2},
          aSet: {1, 2},
          aRecord: ('quoted\'', optionalUri: Uri.parse('https://example.com')),
        );
        rows = [row, row.copyWith(id: 2, aBool: false)];
        await Types.db.insert(session, [Types(id: 1), Types(id: 2)]);
      });

      group('when updating without returning rows, ', () {
        late List<Types> returned;
        late List<Types> stored;

        setUp(() async {
          returned = await Types.db.update(session, rows, noReturn: true);
          stored = await Types.db.find(session, orderBy: (t) => t.id);
        });

        test('then no models are returned.', () {
          expect(returned, isEmpty);
        });

        test('then all values round trip as data.', () {
          expect(stored.map((r) => r.toJson()), rows.map((r) => r.toJson()));
        });
      });
    },
  );

  group('Given interleaved explicit and generated ids, ', () {
    late List<SimpleData> inputs;

    setUp(() {
      inputs = [
        SimpleData(id: 10, num: 1),
        SimpleData(num: 2),
        SimpleData(id: 12, num: 3),
        SimpleData(num: 4),
      ];
    });

    group('when inserting without returning rows, ', () {
      late List<SimpleData> returned;
      late List<SimpleData> stored;

      setUp(() async {
        returned = await SimpleData.db.insert(session, inputs, noReturn: true);
        stored = await SimpleData.db.find(session, orderBy: (t) => t.id);
      });

      test('then no models are returned.', () {
        expect(returned, isEmpty);
      });

      test('then ids are assigned in input order.', () {
        expect(stored.map((r) => (r.id, r.num)), [
          (10, 1),
          (11, 2),
          (12, 3),
          (13, 4),
        ]);
      });
    });
  });

  group('Given a caller transaction with a previously inserted row, ', () {
    late TestTransaction caller;
    late List<SimpleData> inputs;

    setUp(() async {
      caller = await TestTransaction.start(session.db);
      addTearDown(caller.commit);
      await SimpleData.db.insertRow(
        session,
        SimpleData(id: 10000, num: 7),
        transaction: caller.transaction,
      );
      inputs = [
        for (var id = 1; id <= 300; id++) SimpleData(id: id, num: id),
        SimpleData(id: 1, num: -1),
      ];
    });

    group(
      'when a large no-return insert fails after earlier rows succeeded, ',
      () {
        Object? failure;
        late List<SimpleData> stored;
        late int committedCount;

        setUp(() async {
          failure = null;
          try {
            await SimpleData.db.insert(
              session,
              inputs,
              noReturn: true,
              transaction: caller.transaction,
            );
          } catch (error) {
            failure = error;
          }
          stored = await SimpleData.db.find(
            session,
            transaction: caller.transaction,
          );
          await caller.commit();
          committedCount = await SimpleData.db.count(session);
        });

        test('then the primary-key conflict is reported.', () {
          expect(
            failure,
            isA<DatabaseQueryException>().having((e) => e.code, 'code', '1555'),
          );
        });

        test('then only the batch is rolled back.', () {
          expect(stored.map((r) => (r.id, r.num)), [(10000, 7)]);
          expect(committedCount, 1);
        });
      },
    );
  });

  group('Given two upserts targeting the same new row, ', () {
    late List<SimpleData> inputs;

    setUp(() {
      inputs = [SimpleData(id: 1, num: 1), SimpleData(id: 1, num: 2)];
    });

    group('when upserting without returning rows, ', () {
      Object? failure;
      late int storedCount;

      setUp(() async {
        failure = null;
        try {
          await SimpleData.db.upsert(
            session,
            inputs,
            conflictColumns: (t) => [t.id],
            noReturn: true,
          );
        } catch (error) {
          failure = error;
        }
        storedCount = await SimpleData.db.count(session);
      });

      test('then the duplicate target is rejected.', () {
        expect(
          failure,
          isA<DatabaseQueryException>().having(
            (e) => e.message,
            'message',
            'ON CONFLICT DO UPDATE command cannot affect row a second time',
          ),
        );
      });

      test('then the batch rolls back.', () {
        expect(storedCount, 0);
      });
    });
  });

  group('Given an existing row targeted twice by filtered upserts, ', () {
    late List<SimpleData> inputs;

    setUp(() async {
      await SimpleData.db.insertRow(session, SimpleData(id: 1, num: 1));
      inputs = [SimpleData(id: 1, num: 2), SimpleData(id: 1, num: 3)];
    });

    group(
      'when upserting without returning rows and neither update qualifies, ',
      () {
        late List<SimpleData> returned;
        late List<SimpleData> stored;

        setUp(() async {
          returned = await SimpleData.db.upsert(
            session,
            inputs,
            conflictColumns: (t) => [t.id],
            updateWhere: (t) => t.num.equals(99),
            noReturn: true,
          );
          stored = await SimpleData.db.find(session);
        });

        test(
          'then no models are returned and no duplicate-target error is raised.',
          () {
            expect(returned, isEmpty);
          },
        );

        test('then the original row remains.', () {
          expect(stored.map((r) => (r.id, r.num)), [(1, 1)]);
        });
      },
    );
  });
}
