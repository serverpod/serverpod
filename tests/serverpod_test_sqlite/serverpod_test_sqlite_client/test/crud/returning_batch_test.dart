import 'dart:async';
import 'dart:typed_data';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../test_util.dart';
import '../utils/test_transaction.dart';

void main() {
  initTestClientSession();

  group('Given an active query watch on an empty table, ', () {
    late StreamIterator<List<SimpleData>> watch;
    late bool initialEmitted;
    late List<SimpleData> initialRows;

    setUp(() async {
      watch = StreamIterator(
        SimpleData.db.watch(session, orderBy: (table) => table.id),
      );
      addTearDown(watch.cancel);
      initialEmitted = await watch.moveNext();
      initialRows = initialEmitted ? watch.current.toList() : [];
    });

    group('when a returning insert batch commits, ', () {
      late List<SimpleData> returned;
      late bool emitted;
      late List<SimpleData> watchedRows;

      setUp(() async {
        final changed = watch.moveNext();
        returned = await SimpleData.db.insert(session, [
          for (var index = 0; index < 300; index++) SimpleData(num: index),
        ]);
        emitted = await changed.timeout(const Duration(seconds: 10));
        watchedRows = emitted ? watch.current.toList() : [];
      });

      test('then the watch started with an empty snapshot.', () {
        expect(initialEmitted, isTrue);
        expect(initialRows, isEmpty);
      });

      test('then the watch receives the complete persisted batch.', () {
        expect(emitted, isTrue);
        expect(
          watchedRows.map((row) => (row.id, row.num)),
          returned.map((row) => (row.id, row.num)),
        );
        expect(watchedRows, hasLength(300));
      });
    });
  });

  group(
    'Given interleaved explicit and generated IDs across a batch boundary, ',
    () {
      late List<SimpleData> inputs;

      setUp(() {
        inputs = [
          for (var index = 0; index < 300; index++)
            SimpleData(id: index.isEven ? 1000 + index : null, num: index),
        ];
      });

      group('when inserting with returned rows, ', () {
        late List<SimpleData> returned;

        setUp(() async {
          returned = await SimpleData.db.insert(session, inputs);
        });

        test('then generated IDs and returned values follow input order.', () {
          expect(returned.map((row) => (row.id, row.num)), [
            for (var index = 0; index < 300; index++) (1000 + index, index),
          ]);
        });
      });
    },
  );

  group(
    'Given a skipped conflict between inputs with non-persisted fields, ',
    () {
      late List<UniqueDataWithNonPersist> inputs;

      setUp(() async {
        await UniqueDataWithNonPersist.db.insertRow(
          session,
          UniqueDataWithNonPersist(number: 1, email: 'existing'),
        );
        inputs = [
          UniqueDataWithNonPersist(number: 2, email: 'second', extra: 'first'),
          UniqueDataWithNonPersist(
            number: 1,
            email: 'existing',
            extra: 'wrong',
          ),
          UniqueDataWithNonPersist(number: 3, email: 'third', extra: 'last'),
        ];
      });

      group('when inserting with ignored conflicts, ', () {
        late List<UniqueDataWithNonPersist> returned;

        setUp(() async {
          returned = await UniqueDataWithNonPersist.db.insert(
            session,
            inputs,
            ignoreConflicts: true,
          );
        });

        test(
          'then each returned model keeps its own fields and input position.',
          () {
            expect(returned.map((row) => (row.number, row.extra)), [
              (2, 'first'),
              (3, 'last'),
            ]);
          },
        );
      });
    },
  );

  group('Given repeated update targets and a missing row between them, ', () {
    late List<UniqueDataWithNonPersist> inputs;

    setUp(() async {
      await UniqueDataWithNonPersist.db.insert(session, [
        UniqueDataWithNonPersist(id: 1, number: 1, email: 'one'),
        UniqueDataWithNonPersist(id: 2, number: 2, email: 'two'),
      ]);
      inputs = [
        UniqueDataWithNonPersist(id: 2, number: 20, email: 'two', extra: 'a'),
        UniqueDataWithNonPersist(
          id: 99,
          number: 99,
          email: 'missing',
          extra: 'skip',
        ),
        UniqueDataWithNonPersist(id: 1, number: 10, email: 'one', extra: 'b'),
        UniqueDataWithNonPersist(id: 2, number: 21, email: 'two', extra: 'c'),
      ];
    });

    group('when updating with returned rows, ', () {
      late List<UniqueDataWithNonPersist> returned;

      setUp(() async {
        returned = await UniqueDataWithNonPersist.db.update(session, inputs);
      });

      test(
        'then each successful input returns its own snapshot in input order.',
        () {
          expect(returned.map((row) => (row.id, row.number, row.extra)), [
            (2, 20, 'a'),
            (1, 10, 'b'),
            (2, 21, 'c'),
          ]);
        },
      );
    });
  });

  group('Given unique values released by an earlier input, ', () {
    late List<UniqueData> inputs;

    setUp(() async {
      await UniqueData.db.insert(session, [
        UniqueData(id: 1, number: 1, email: 'a'),
        UniqueData(id: 2, number: 2, email: 'b'),
      ]);
      inputs = [
        UniqueData(id: 2, number: 2, email: 'c'),
        UniqueData(id: 1, number: 1, email: 'b'),
      ];
    });

    group('when updating in reverse primary key order, ', () {
      late List<UniqueData> returned;

      setUp(() async {
        returned = await UniqueData.db.update(session, inputs);
      });

      test('then later inputs can claim the released values.', () {
        expect(returned.map((row) => (row.id, row.email)), [
          (2, 'c'),
          (1, 'b'),
        ]);
      });
    });
  });

  group('Given an AFTER INSERT trigger that changes stored values, ', () {
    setUp(() async {
      await session.db.unsafeExecute('''
CREATE TRIGGER batch_after_insert AFTER INSERT ON simple_data BEGIN
  UPDATE simple_data SET num = NEW.num + 100 WHERE id = NEW.id;
END''');
      addTearDown(
        () => session.db.unsafeExecute('DROP TRIGGER batch_after_insert'),
      );
    });

    group('when inserting a returning batch, ', () {
      late List<SimpleData> returned;
      late List<SimpleData> stored;

      setUp(() async {
        returned = await SimpleData.db.insert(session, [
          SimpleData(num: 1),
          SimpleData(num: 2),
        ]);
        stored = await SimpleData.db.find(
          session,
          orderBy: (table) => table.id,
        );
      });

      test('then returned values retain the SQLite statement snapshots.', () {
        expect(returned.map((row) => row.num), [1, 2]);
      });

      test('then stored values include the trigger changes.', () {
        expect(stored.map((row) => row.num), [101, 102]);
      });
    });
  });

  group(
    'Given an outer write and a duplicate after a returning batch boundary, ',
    () {
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

      group('when the insert batch fails, ', () {
        Object? failure;
        late List<SimpleData> stored;
        late int committedCount;

        setUp(() async {
          failure = null;
          try {
            await SimpleData.db.insert(
              session,
              inputs,
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

        test(
          'then its savepoint rolls back all chunks and preserves the outer write.',
          () {
            expect(stored.map((row) => (row.id, row.num)), [(10000, 7)]);
            expect(committedCount, 1);
          },
        );
      });
    },
  );

  group('Given binary views, UUIDs, booleans, JSON and quoted text, ', () {
    late Types first;

    setUp(() {
      first = Types(
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
    });

    group('when inserting a returning batch, ', () {
      late List<Types> returned;

      setUp(() async {
        returned = await Types.db.insert(session, [
          first,
          first.copyWith(aBool: false),
        ]);
      });

      test('then typed values survive the worker round trip.', () {
        expect(returned.map((row) => row.toJson()), [
          first.copyWith(id: returned[0].id).toJson(),
          first.copyWith(id: returned[1].id, aBool: false).toJson(),
        ]);
      });
    });
  });
}
