import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  });

  group('Given an empty database', () {
    test(
      'when batch upserting then all the entries are created in the database.',
      () async {
        var data = <UniqueData>[
          UniqueData(number: 1, email: 'a@serverpod.dev'),
          UniqueData(number: 2, email: 'b@serverpod.dev'),
        ];

        var result = await UniqueData.db.upsert(
          session,
          data,
          conflictColumns: (t) => [t.email],
        );

        expect(result, hasLength(2));
        expect(result.first.id, isNotNull);
        expect(result.last.id, isNotNull);
        expect(result.first.email, 'a@serverpod.dev');
        expect(result.last.email, 'b@serverpod.dev');

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));
      },
    );

    test(
      'when batch upserting with one failing row then no entries are created in the database.',
      () async {
        var data = <UniqueData>[
          UniqueData(number: 2, email: 'info@serverpod.dev'),
          UniqueData(number: 2, email: 'dev@serverpod.dev'),
          UniqueData(number: 2, email: 'dev@serverpod.dev'),
        ];

        expect(
          UniqueData.db.upsert(
            session,
            data,
            conflictColumns: (t) => [t.email],
          ),
          throwsA(
            isA<DatabaseQueryException>().having(
              (e) => e.code,
              'code',
              PgErrorCode.cardinalityViolation,
            ),
          ),
        );

        var first = await UniqueData.db.findFirstRow(
          session,
          where: (t) => t.email.equals('info@serverpod.dev'),
        );
        expect(first, isNull);

        var second = await UniqueData.db.findFirstRow(
          session,
          where: (t) => t.email.equals('dev@serverpod.dev'),
        );
        expect(second, isNull);
      },
    );

    test(
      'when batch upserting with an id defined then the id is not ignored.',
      () async {
        const int id = 999;

        var data = <UniqueData>[
          UniqueData(id: id, number: 1, email: 'info@serverpod.dev'),
        ];

        var inserted = await UniqueData.db.upsert(
          session,
          data,
          conflictColumns: (t) => [t.email],
        );

        expect(inserted.first.id, id);
      },
    );

    test(
      'when batch upserting with an id defined and other undefined then both are created in the database.',
      () async {
        const int id = 1999;

        var data = <UniqueData>[
          UniqueData(id: id, number: 10, email: 'info@serverpod.dev'),
          UniqueData(number: 20, email: 'dev@serverpod.dev'),
        ];

        var inserted = await UniqueData.db.upsert(
          session,
          data,
          conflictColumns: (t) => [t.email],
        );

        expect(inserted, hasLength(2));

        var first = inserted
            .where((e) => e.email == 'info@serverpod.dev')
            .single;
        var second = inserted
            .where((e) => e.email == 'dev@serverpod.dev')
            .single;

        expect(first.id, id);
        expect(second.id, isNot(id));
        expect(first.number, 10);
        expect(second.number, 20);
      },
    );

    test(
      'when upserting a single row with upsertRow then the row is inserted.',
      () async {
        var result = (await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 1, email: 'single@serverpod.dev'),
          conflictColumns: (t) => [t.email],
        ))!;

        expect(result.id, isNotNull);
        expect(result.email, 'single@serverpod.dev');
        expect(result.number, 1);

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(1));
      },
    );
  });

  group('Given a row with a unique constraint already exists', () {
    late UniqueData existingRow;

    setUp(() async {
      existingRow = await UniqueData.db.insertRow(
        session,
        UniqueData(number: 1, email: 'existing@serverpod.dev'),
      );
    });

    test(
      'when upserting a row with the same unique value then the existing row is updated.',
      () async {
        var result = (await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 42, email: 'existing@serverpod.dev'),
          conflictColumns: (t) => [t.email],
        ))!;

        expect(result.id, existingRow.id);
        expect(result.email, 'existing@serverpod.dev');
        expect(result.number, 42);

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(1));
        expect(allRows.first.number, 42);
      },
    );

    test(
      'when upserting a row with a new unique value then a new row is inserted.',
      () async {
        var result = (await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 2, email: 'new@serverpod.dev'),
          conflictColumns: (t) => [t.email],
        ))!;

        expect(result.id, isNotNull);
        expect(result.id, isNot(existingRow.id));
        expect(result.email, 'new@serverpod.dev');

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));
      },
    );

    test(
      'when upserting a row with an updateWhere clause that matches '
      'then the existing row is updated.',
      () async {
        var result = await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 17, email: 'existing@serverpod.dev'),
          conflictColumns: (t) => [t.email],
          updateWhere: (t) => t.number.equals(1),
        );

        expect(result, isNotNull);
        expect(result!.email, 'existing@serverpod.dev');
        expect(result.number, 17);
      },
    );

    test(
      'when upserting a row with an updateWhere clause that does not match '
      'then returns null and existing row is unchanged.',
      () async {
        var result = await UniqueData.db.upsertRow(
          session,
          UniqueData(number: 17, email: 'existing@serverpod.dev'),
          conflictColumns: (t) => [t.email],
          updateWhere: (t) => t.number.equals(99),
        );

        expect(result, isNull);

        var stored = await UniqueData.db.findFirstRow(session);
        expect(stored, isNotNull);
        expect(stored!.email, 'existing@serverpod.dev');
        expect(stored.number, 1);
      },
    );

    test(
      'when batch upserting a mix of new and conflicting rows then both inserts and updates happen.',
      () async {
        var data = <UniqueData>[
          UniqueData(number: 99, email: 'existing@serverpod.dev'),
          UniqueData(number: 3, email: 'new@serverpod.dev'),
        ];

        var result = await UniqueData.db.upsert(
          session,
          data,
          conflictColumns: (t) => [t.email],
        );

        expect(result, hasLength(2));

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));

        var updatedExisting = allRows.firstWhere(
          (r) => r.email == 'existing@serverpod.dev',
        );
        expect(updatedExisting.number, 99);
        expect(updatedExisting.id, existingRow.id);

        var newRow = allRows.firstWhere(
          (r) => r.email == 'new@serverpod.dev',
        );
        expect(newRow.number, 3);
      },
    );

    test(
      'when upserting within a transaction then the upsert is atomic.',
      () async {
        final completer = Completer<void>();

        final transactionFuture = session.db.transaction((transaction) async {
          var result = (await UniqueData.db.upsertRow(
            session,
            UniqueData(number: 77, email: 'existing@serverpod.dev'),
            conflictColumns: (t) => [t.email],
            transaction: transaction,
          ))!;

          expect(result.id, existingRow.id);
          expect(result.number, 77);

          await completer.future;
        });

        final beforeTransactionRows = await UniqueData.db.findFirstRow(session);
        expect(beforeTransactionRows?.number, 1);

        completer.complete();
        await transactionFuture;

        final afterTransactionRows = await UniqueData.db.find(session);
        expect(afterTransactionRows, hasLength(1));
        expect(afterTransactionRows.first.number, 77);
      },
    );
  });

  group(
    'Given a table model with non-persistent fields and a check constraint on the table',
    () {
      setUp(() async {
        await session.db.unsafeExecute(
          'ALTER TABLE unique_data_with_non_persist '
          'ADD CONSTRAINT check_number_not_99 CHECK (number != 99)',
        );
      });

      tearDown(() async {
        await session.db.unsafeExecute(
          'ALTER TABLE unique_data_with_non_persist '
          'DROP CONSTRAINT IF EXISTS check_number_not_99',
        );
        await UniqueDataWithNonPersist.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test(
        'when batch upserting without a transaction where one row violates the check constraint '
        'then no rows are upserted (atomic rollback).',
        () async {
          var data = <UniqueDataWithNonPersist>[
            UniqueDataWithNonPersist(
              number: 1,
              email: 'a@serverpod.dev',
              extra: 'extra-a',
            ),
            UniqueDataWithNonPersist(
              number: 99,
              email: 'b@serverpod.dev',
              extra: 'extra-b',
            ),
            UniqueDataWithNonPersist(
              number: 3,
              email: 'c@serverpod.dev',
              extra: 'extra-c',
            ),
          ];

          await expectLater(
            UniqueDataWithNonPersist.db.upsert(
              session,
              data,
              conflictColumns: (t) => [t.email],
            ),
            throwsA(
              isA<DatabaseQueryException>().having(
                (e) => e.code,
                'code',
                PgErrorCode.checkViolation,
              ),
            ),
          );

          var allRows = await UniqueDataWithNonPersist.db.find(session);
          expect(
            allRows,
            isEmpty,
            reason:
                'The upsert without a transaction should be atomic: '
                'a mid-batch failure must roll back all previously '
                'upserted rows.',
          );
        },
      );
    },
  );

  group('Given a model with multiple unique indexes and an existing row', () {
    late UpsertTestModel existingRow;

    setUp(() async {
      existingRow = await UpsertTestModel.db.insertRow(
        session,
        UpsertTestModel(code: 'A', category: 'cat1', value: 1),
      );
    });

    tearDown(() async {
      await UpsertTestModel.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    test(
      'when upserting with a single conflictColumn then uses single unique index.',
      () async {
        var updated = (await UpsertTestModel.db.upsertRow(
          session,
          UpsertTestModel(code: 'A', category: 'catX', value: 1),
          conflictColumns: (t) => [t.code],
        ))!;

        expect(updated.id, existingRow.id);
        expect(updated.code, 'A');
        expect(updated.value, 1);
      },
    );

    test(
      'when upserting with multiple conflictColumns then uses composite unique index.',
      () async {
        var updated = (await UpsertTestModel.db.upsertRow(
          session,
          UpsertTestModel(code: 'B', category: 'cat1', value: 1),
          conflictColumns: (t) => [t.category, t.value],
        ))!;

        expect(updated.id, existingRow.id);
        expect(updated.code, 'B');
      },
    );

    test(
      'when upserting with updateColumns then excluded columns are not modified.',
      () async {
        var updated = (await UpsertTestModel.db.upsertRow(
          session,
          UpsertTestModel(code: 'A', category: 'c2', value: 2),
          conflictColumns: (t) => [t.code],
          updateColumns: (t) => [t.value],
        ))!;

        expect(updated.id, existingRow.id);
        expect(updated.category, 'cat1');
        expect(updated.value, 2);
      },
    );
  });

  test(
    'Given an upsert operation with a conflictColumn on a non-unique column '
    'when executing it '
    'then it throws a DatabaseQueryException.',
    () async {
      await expectLater(
        UpsertTestModel.db.upsertRow(
          session,
          UpsertTestModel(code: 'A', category: 'c1', value: 1),
          conflictColumns: (t) => [t.code, t.category],
        ),
        throwsA(isA<DatabaseQueryException>()),
      );
    },
  );

  test(
    'Given an upsert operation with empty conflictColumns '
    'when executing it '
    'then it throws an ArgumentError.',
    () async {
      await expectLater(
        UpsertTestModel.db.upsert(
          session,
          [UpsertTestModel(code: 'A', category: 'c1', value: 1)],
          conflictColumns: (t) => [],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given an upsert operation with id as conflictColumn '
    'when executing it '
    'then it throws an ArgumentError.',
    () async {
      await expectLater(
        UpsertTestModel.db.upsert(
          session,
          [UpsertTestModel(code: 'A', category: 'c1', value: 1)],
          conflictColumns: (t) => [t.id],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given an upsert operation with column from different table '
    'when executing it '
    'then it throws an ArgumentError.',
    () async {
      await expectLater(
        UpsertTestModel.db.upsert(
          session,
          [UpsertTestModel(code: 'A', category: 'c1', value: 1)],
          conflictColumns: (t) => [UniqueData.t.email],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );
}
