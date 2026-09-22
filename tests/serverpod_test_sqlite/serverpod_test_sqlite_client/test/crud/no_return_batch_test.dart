import 'dart:typed_data';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../test_util.dart';

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

    test(
      'when inserting without returning rows, '
      'then all values round trip as data.',
      () async {
        final returned = await Types.db.insert(session, rows, noReturn: true);
        final stored = await Types.db.find(session, orderBy: (t) => t.id);

        expect(returned, isEmpty);
        expect(stored.map((r) => r.toJson()), rows.map((r) => r.toJson()));
      },
    );

    test(
      'when updating without returning rows, '
      'then all values round trip as data.',
      () async {
        await Types.db.insert(session, [Types(id: 1), Types(id: 2)]);

        final returned = await Types.db.update(session, rows, noReturn: true);
        final stored = await Types.db.find(session, orderBy: (t) => t.id);

        expect(returned, isEmpty);
        expect(stored.map((r) => r.toJson()), rows.map((r) => r.toJson()));
      },
    );
  });

  test(
    'Given interleaved explicit and generated ids, '
    'when inserting without returning rows, '
    'then ids are assigned in input order.',
    () async {
      final returned = await SimpleData.db.insert(session, [
        SimpleData(id: 10, num: 1),
        SimpleData(num: 2),
        SimpleData(id: 12, num: 3),
        SimpleData(num: 4),
      ], noReturn: true);
      final stored = await SimpleData.db.find(session, orderBy: (t) => t.id);

      expect(returned, isEmpty);
      expect(stored.map((r) => (r.id, r.num)), [
        (10, 1),
        (11, 2),
        (12, 3),
        (13, 4),
      ]);
    },
  );

  test(
    'Given a caller transaction with a previously inserted row, '
    'when a large no-return insert fails after earlier rows succeeded, '
    'then only the batch is rolled back.',
    () async {
      await session.db.transaction((transaction) async {
        await SimpleData.db.insertRow(
          session,
          SimpleData(id: 10000, num: 7),
          transaction: transaction,
        );

        await expectLater(
          SimpleData.db.insert(
            session,
            [
              for (var id = 1; id <= 300; id++) SimpleData(id: id, num: id),
              SimpleData(id: 1, num: -1),
            ],
            noReturn: true,
            transaction: transaction,
          ),
          throwsA(
            isA<DatabaseQueryException>().having((e) => e.code, 'code', '1555'),
          ),
        );
        final stored = await SimpleData.db.find(
          session,
          transaction: transaction,
        );
        expect(stored.map((r) => (r.id, r.num)), [(10000, 7)]);
      });
      expect(await SimpleData.db.count(session), 1);
    },
  );

  test(
    'Given two upserts targeting the same new row, '
    'when upserting without returning rows, '
    'then the duplicate target is rejected and the batch rolls back.',
    () async {
      await expectLater(
        SimpleData.db.upsert(
          session,
          [
            SimpleData(id: 1, num: 1),
            SimpleData(id: 1, num: 2),
          ],
          conflictColumns: (t) => [t.id],
          noReturn: true,
        ),
        throwsA(
          isA<DatabaseQueryException>().having(
            (e) => e.message,
            'message',
            'ON CONFLICT DO UPDATE command cannot affect row a second time',
          ),
        ),
      );
      expect(await SimpleData.db.count(session), 0);
    },
  );

  test(
    'Given an existing row targeted twice by filtered upserts, '
    'when upserting without returning rows and neither update qualifies, '
    'then the original row remains and no duplicate-target error is raised.',
    () async {
      await SimpleData.db.insertRow(session, SimpleData(id: 1, num: 1));

      final returned = await SimpleData.db.upsert(
        session,
        [
          SimpleData(id: 1, num: 2),
          SimpleData(id: 1, num: 3),
        ],
        conflictColumns: (t) => [t.id],
        updateWhere: (t) => t.num.equals(99),
        noReturn: true,
      );
      final stored = await SimpleData.db.find(session);

      expect(returned, isEmpty);
      expect(stored.map((r) => (r.id, r.num)), [(1, 1)]);
    },
  );
}
