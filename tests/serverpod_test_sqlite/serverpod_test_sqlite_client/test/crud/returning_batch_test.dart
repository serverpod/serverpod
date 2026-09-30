import 'dart:async';
import 'dart:typed_data';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../test_util.dart';

void main() {
  initTestClientSession();

  test(
    'Given an active query watch on an empty table, '
    'when a returning insert batch commits, '
    'then the watch receives the complete persisted batch.',
    () async {
      final watch = StreamIterator(
        SimpleData.db.watch(session, orderBy: (table) => table.id),
      );
      addTearDown(watch.cancel);
      expect(await watch.moveNext(), isTrue);
      expect(watch.current, isEmpty);
      final changed = watch.moveNext();

      final returned = await SimpleData.db.insert(session, [
        for (var index = 0; index < 300; index++) SimpleData(num: index),
      ]);
      final emitted = await changed.timeout(const Duration(seconds: 10));

      expect(emitted, isTrue);
      expect(
        watch.current.map((row) => (row.id, row.num)),
        returned.map((row) => (row.id, row.num)),
      );
      expect(watch.current, hasLength(300));
    },
  );

  test(
    'Given interleaved explicit and generated IDs across a batch boundary, '
    'when inserting with returned rows, '
    'then generated IDs and returned values follow input order.',
    () async {
      final inputs = [
        for (var index = 0; index < 300; index++)
          SimpleData(id: index.isEven ? 1000 + index : null, num: index),
      ];

      final returned = await SimpleData.db.insert(session, inputs);

      expect(returned.map((row) => (row.id, row.num)), [
        for (var index = 0; index < 300; index++) (1000 + index, index),
      ]);
    },
  );

  test(
    'Given a skipped conflict between inputs with non-persisted fields, '
    'when inserting with ignored conflicts, '
    'then each returned model keeps its own fields and input position.',
    () async {
      await UniqueDataWithNonPersist.db.insertRow(
        session,
        UniqueDataWithNonPersist(number: 1, email: 'existing'),
      );

      final returned = await UniqueDataWithNonPersist.db.insert(session, [
        UniqueDataWithNonPersist(number: 2, email: 'second', extra: 'first'),
        UniqueDataWithNonPersist(number: 1, email: 'existing', extra: 'wrong'),
        UniqueDataWithNonPersist(number: 3, email: 'third', extra: 'last'),
      ], ignoreConflicts: true);

      expect(returned.map((row) => (row.number, row.extra)), [
        (2, 'first'),
        (3, 'last'),
      ]);
    },
  );

  test(
    'Given repeated update targets and a missing row between them, '
    'when updating with returned rows, '
    'then each successful input returns its own snapshot in input order.',
    () async {
      await UniqueDataWithNonPersist.db.insert(session, [
        UniqueDataWithNonPersist(id: 1, number: 1, email: 'one'),
        UniqueDataWithNonPersist(id: 2, number: 2, email: 'two'),
      ]);

      final returned = await UniqueDataWithNonPersist.db.update(session, [
        UniqueDataWithNonPersist(id: 2, number: 20, email: 'two', extra: 'a'),
        UniqueDataWithNonPersist(
          id: 99,
          number: 99,
          email: 'missing',
          extra: 'skip',
        ),
        UniqueDataWithNonPersist(id: 1, number: 10, email: 'one', extra: 'b'),
        UniqueDataWithNonPersist(id: 2, number: 21, email: 'two', extra: 'c'),
      ]);

      expect(returned.map((row) => (row.id, row.number, row.extra)), [
        (2, 20, 'a'),
        (1, 10, 'b'),
        (2, 21, 'c'),
      ]);
    },
  );

  test(
    'Given unique values released by an earlier input, '
    'when updating in reverse primary key order, '
    'then later inputs can claim the released values.',
    () async {
      await UniqueData.db.insert(session, [
        UniqueData(id: 1, number: 1, email: 'a'),
        UniqueData(id: 2, number: 2, email: 'b'),
      ]);

      final returned = await UniqueData.db.update(session, [
        UniqueData(id: 2, number: 2, email: 'c'),
        UniqueData(id: 1, number: 1, email: 'b'),
      ]);

      expect(returned.map((row) => (row.id, row.email)), [(2, 'c'), (1, 'b')]);
    },
  );

  test(
    'Given an AFTER INSERT trigger that changes stored values, '
    'when inserting a returning batch, '
    'then returned values retain the SQLite statement snapshots.',
    () async {
      await session.db.unsafeExecute('''
CREATE TRIGGER batch_after_insert AFTER INSERT ON simple_data BEGIN
  UPDATE simple_data SET num = NEW.num + 100 WHERE id = NEW.id;
END''');
      addTearDown(
        () => session.db.unsafeExecute('DROP TRIGGER batch_after_insert'),
      );

      final returned = await SimpleData.db.insert(session, [
        SimpleData(num: 1),
        SimpleData(num: 2),
      ]);
      final stored = await SimpleData.db.find(
        session,
        orderBy: (table) => table.id,
      );

      expect(returned.map((row) => row.num), [1, 2]);
      expect(stored.map((row) => row.num), [101, 102]);
    },
  );

  test(
    'Given an outer write and a duplicate after a returning batch boundary, '
    'when the insert batch fails, '
    'then its savepoint rolls back all chunks and preserves the outer write.',
    () async {
      await session.db.transaction((transaction) async {
        await SimpleData.db.insertRow(
          session,
          SimpleData(id: 10000, num: 7),
          transaction: transaction,
        );

        await expectLater(
          SimpleData.db.insert(session, [
            for (var id = 1; id <= 300; id++) SimpleData(id: id, num: id),
            SimpleData(id: 1, num: -1),
          ], transaction: transaction),
          throwsA(
            isA<DatabaseQueryException>().having((e) => e.code, 'code', '1555'),
          ),
        );
        final stored = await SimpleData.db.find(
          session,
          transaction: transaction,
        );

        expect(stored.map((row) => (row.id, row.num)), [(10000, 7)]);
      });
      expect(await SimpleData.db.count(session), 1);
    },
  );

  test(
    'Given binary views, UUIDs, booleans, JSON and quoted text, '
    'when inserting a returning batch, '
    'then typed values survive the worker round trip.',
    () async {
      final first = Types(
        aBool: true,
        aDouble: 3.0,
        aString: "quoted'; SELECT '☃'",
        aByteData: ByteData.sublistView(
          Uint8List.fromList([9, 0, 255, 8]),
          1,
          3,
        ),
        aUuid: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        aList: [1, 2],
        aMap: {1: 2},
        aBigInt: BigInt.parse('123456789012345678901234567890'),
      );

      final returned = await Types.db.insert(session, [
        first,
        first.copyWith(aBool: false),
      ]);

      expect(returned.map((row) => row.toJson()), [
        first.copyWith(id: returned[0].id).toJson(),
        first.copyWith(id: returned[1].id, aBool: false).toJson(),
      ]);
    },
  );
}
