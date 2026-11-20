import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../test_util.dart';
import '../utils/test_transaction.dart';

void main() {
  initTestClientSession();

  group(
    'Given inserts, updates and skipped conflicts across a batch boundary, ',
    () {
      late List<UniqueDataWithNonPersist> inputs;

      setUp(() async {
        await UniqueDataWithNonPersist.db.insert(session, [
          UniqueDataWithNonPersist(id: 1, number: -1, email: 'update'),
          UniqueDataWithNonPersist(id: 2, number: -2, email: 'skip'),
        ]);
        inputs = [
          UniqueDataWithNonPersist(number: 0, email: 'new', extra: 'first'),
          UniqueDataWithNonPersist(number: 1, email: 'update', extra: 'second'),
          UniqueDataWithNonPersist(number: 2, email: 'skip', extra: 'wrong'),
          for (var index = 3; index < 300; index++)
            UniqueDataWithNonPersist(
              number: index,
              email: 'new$index',
              extra: '$index',
            ),
        ];
      });

      group('when upserting with returned rows, ', () {
        late List<UniqueDataWithNonPersist> returned;
        late UniqueDataWithNonPersist? skipped;

        setUp(() async {
          returned = await UniqueDataWithNonPersist.db.upsert(
            session,
            inputs,
            conflictColumns: (table) => [table.email],
            updateWhere: (table) => table.number.notEquals(-2),
          );
          skipped = await UniqueDataWithNonPersist.db.findById(session, 2);
        });

        test(
          'then successful inputs retain their order and non-persisted fields.',
          () {
            expect(returned.map((row) => (row.number, row.email, row.extra)), [
              for (final input in inputs)
                if (input.email != 'skip')
                  (input.number, input.email, input.extra),
            ]);
            expect(returned[1].id, 1);
          },
        );

        test('then the skipped conflict keeps its stored value.', () {
          expect(skipped!.number, -2);
        });
      });
    },
  );

  group('Given repeated conflicts skipped after the first update, ', () {
    late List<UniqueDataWithNonPersist> inputs;

    setUp(() async {
      await UniqueDataWithNonPersist.db.insertRow(
        session,
        UniqueDataWithNonPersist(number: 0, email: 'same'),
      );
      inputs = [
        UniqueDataWithNonPersist(number: 1, email: 'same', extra: 'first'),
        UniqueDataWithNonPersist(number: 2, email: 'same', extra: 'skip'),
        UniqueDataWithNonPersist(number: 3, email: 'new', extra: 'last'),
      ];
    });

    group('when upserting with a conditional update, ', () {
      late List<UniqueDataWithNonPersist> returned;

      setUp(() async {
        returned = await UniqueDataWithNonPersist.db.upsert(
          session,
          inputs,
          conflictColumns: (table) => [table.email],
          updateWhere: (table) => table.number.equals(0),
        );
      });

      test(
        'then skipped inputs do not count as duplicate affected targets.',
        () {
          expect(returned.map((row) => (row.number, row.extra)), [
            (1, 'first'),
            (3, 'last'),
          ]);
        },
      );
    });
  });

  group(
    'Given a caller write and duplicate upsert targets in different chunks, ',
    () {
      late TestTransaction caller;
      late List<UniqueData> inputs;

      setUp(() async {
        caller = await TestTransaction.start(session.db);
        addTearDown(caller.commit);
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: -1, email: 'outer'),
          transaction: caller.transaction,
        );
        inputs = [
          for (var index = 0; index < 300; index++)
            UniqueData(number: index, email: 'row$index'),
          UniqueData(number: 999, email: 'row0'),
        ];
      });

      group('when requesting returned rows, ', () {
        Object? failure;
        late List<UniqueData> stored;

        setUp(() async {
          failure = null;
          try {
            await UniqueData.db.upsert(
              session,
              inputs,
              conflictColumns: (table) => [table.email],
              transaction: caller.transaction,
            );
          } catch (error) {
            failure = error;
          }
          stored = await UniqueData.db.find(
            session,
            transaction: caller.transaction,
          );
          await caller.commit();
        });

        test('then the duplicate-target error is reported.', () {
          expect(
            failure,
            isA<DatabaseQueryException>().having(
              (error) => error.code,
              'code',
              SqliteErrorCode.integrityConstraintViolation,
            ),
          );
        });

        test(
          'then every batch chunk rolls back and the caller write survives.',
          () {
            expect(stored.map((row) => (row.number, row.email)), [
              (-1, 'outer'),
            ]);
          },
        );
      });
    },
  );

  group('Given duplicate upsert targets in different chunks, ', () {
    late List<UniqueData> inputs;

    setUp(() {
      inputs = [
        for (var index = 0; index < 300; index++)
          UniqueData(number: index, email: 'row$index'),
        UniqueData(number: 999, email: 'row0'),
      ];
    });

    group('when upserting without returning rows, ', () {
      Object? failure;
      late int storedCount;

      setUp(() async {
        failure = null;
        try {
          await UniqueData.db.upsert(
            session,
            inputs,
            conflictColumns: (table) => [table.email],
            noReturn: true,
          );
        } catch (error) {
          failure = error;
        }
        storedCount = await UniqueData.db.count(session);
      });

      test('then the duplicate-target error is reported.', () {
        expect(
          failure,
          isA<DatabaseQueryException>().having(
            (error) => error.message,
            'message',
            'ON CONFLICT DO UPDATE command cannot affect row a second time',
          ),
        );
      });

      test('then duplicate detection rolls back every chunk.', () {
        expect(storedCount, 0);
      });
    });
  });

  group('Given a model containing only its generated integer id, ', () {
    late List<EmptyModelWithTable> insertInputs;
    late List<EmptyModelWithTable> upsertInputs;

    setUp(() {
      insertInputs = [EmptyModelWithTable(), EmptyModelWithTable()];
      upsertInputs = [EmptyModelWithTable(), EmptyModelWithTable()];
    });

    group('when inserting with ignored conflicts and upserting, ', () {
      late List<EmptyModelWithTable> inserted;
      late List<EmptyModelWithTable> upserted;
      late int storedCount;

      setUp(() async {
        inserted = await EmptyModelWithTable.db.insert(
          session,
          insertInputs,
          ignoreConflicts: true,
        );
        upserted = await EmptyModelWithTable.db.upsert(
          session,
          upsertInputs,
          conflictColumns: (table) => [table.id],
        );
        storedCount = await EmptyModelWithTable.db.count(session);
      });

      test('then every input receives its own generated id.', () {
        expect(inserted, hasLength(2));
        expect(upserted, hasLength(2));
        expect(
          {...inserted, ...upserted}.map((row) => row.id).toSet(),
          hasLength(4),
        );
      });

      test('then every input is persisted.', () {
        expect(storedCount, 4);
      });
    });
  });
}
