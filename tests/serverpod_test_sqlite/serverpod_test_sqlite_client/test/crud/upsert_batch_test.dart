import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../test_util.dart';

void main() {
  initTestClientSession();

  test(
    'Given inserts, updates and skipped conflicts across a batch boundary, '
    'when upserting with returned rows, '
    'then successful inputs retain their order and non-persisted fields.',
    () async {
      await UniqueDataWithNonPersist.db.insert(session, [
        UniqueDataWithNonPersist(id: 1, number: -1, email: 'update'),
        UniqueDataWithNonPersist(id: 2, number: -2, email: 'skip'),
      ]);
      final inputs = [
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

      final returned = await UniqueDataWithNonPersist.db.upsert(
        session,
        inputs,
        conflictColumns: (table) => [table.email],
        updateWhere: (table) => table.number.notEquals(-2),
      );
      final skipped = await UniqueDataWithNonPersist.db.findById(session, 2);

      expect(returned.map((row) => (row.number, row.email, row.extra)), [
        for (final input in inputs)
          if (input.email != 'skip') (input.number, input.email, input.extra),
      ]);
      expect(returned[1].id, 1);
      expect(skipped!.number, -2);
    },
  );

  test(
    'Given repeated conflicts skipped after the first update, '
    'when upserting with a conditional update, '
    'then skipped inputs do not count as duplicate affected targets.',
    () async {
      await UniqueDataWithNonPersist.db.insertRow(
        session,
        UniqueDataWithNonPersist(number: 0, email: 'same'),
      );

      final returned = await UniqueDataWithNonPersist.db.upsert(
        session,
        [
          UniqueDataWithNonPersist(number: 1, email: 'same', extra: 'first'),
          UniqueDataWithNonPersist(number: 2, email: 'same', extra: 'skip'),
          UniqueDataWithNonPersist(number: 3, email: 'new', extra: 'last'),
        ],
        conflictColumns: (table) => [table.email],
        updateWhere: (table) => table.number.equals(0),
      );

      expect(returned.map((row) => (row.number, row.extra)), [
        (1, 'first'),
        (3, 'last'),
      ]);
    },
  );

  test(
    'Given a caller write and duplicate upsert targets in different chunks, '
    'when requesting returned rows, '
    'then every batch chunk rolls back and the caller write survives.',
    () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: -1, email: 'outer'),
          transaction: transaction,
        );

        await expectLater(
          UniqueData.db.upsert(
            session,
            [
              for (var index = 0; index < 300; index++)
                UniqueData(number: index, email: 'row$index'),
              UniqueData(number: 999, email: 'row0'),
            ],
            conflictColumns: (table) => [table.email],
            transaction: transaction,
          ),
          throwsA(
            isA<DatabaseQueryException>().having(
              (error) => error.code,
              'code',
              SqliteErrorCode.integrityConstraintViolation,
            ),
          ),
        );
        final stored = await UniqueData.db.find(
          session,
          transaction: transaction,
        );

        expect(stored.map((row) => (row.number, row.email)), [(-1, 'outer')]);
      });
    },
  );

  test(
    'Given duplicate upsert targets in different chunks, '
    'when upserting without returning rows, '
    'then duplicate detection rolls back every chunk.',
    () async {
      await expectLater(
        UniqueData.db.upsert(
          session,
          [
            for (var index = 0; index < 300; index++)
              UniqueData(number: index, email: 'row$index'),
            UniqueData(number: 999, email: 'row0'),
          ],
          conflictColumns: (table) => [table.email],
          noReturn: true,
        ),
        throwsA(
          isA<DatabaseQueryException>().having(
            (error) => error.message,
            'message',
            'ON CONFLICT DO UPDATE command cannot affect row a second time',
          ),
        ),
      );

      expect(await UniqueData.db.count(session), 0);
    },
  );

  test(
    'Given a model containing only its generated integer id, '
    'when inserting with ignored conflicts and upserting, '
    'then every input receives its own generated id.',
    () async {
      final inserted = await EmptyModelWithTable.db.insert(session, [
        EmptyModelWithTable(),
        EmptyModelWithTable(),
      ], ignoreConflicts: true);
      final upserted = await EmptyModelWithTable.db.upsert(
        session,
        [EmptyModelWithTable(), EmptyModelWithTable()],
        conflictColumns: (table) => [table.id],
      );

      expect(inserted, hasLength(2));
      expect(upserted, hasLength(2));
      expect(
        {...inserted, ...upserted}.map((row) => row.id).toSet(),
        hasLength(4),
      );
      expect(await EmptyModelWithTable.db.count(session), 4);
    },
  );
}
