import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an empty table with a null-distinct unique index,', (
    sessionBuilder,
    endpoints,
  ) {
    late Session session;
    setUp(() => session = sessionBuilder.build());

    test(
      'when rows with the same indexed values and a null are inserted, '
      'then both rows are stored.',
      () async {
        await NullsDistinctData.db.insert(
          session,
          [
            NullsDistinctData(
              tenantId: 1,
              category: 'books',
              archivedAt: null,
            ),
            NullsDistinctData(
              tenantId: 1,
              category: 'books',
              archivedAt: null,
            ),
          ],
        );

        var rows = await NullsDistinctData.db.find(session);

        expect(rows, hasLength(2));
      },
    );

    test(
      'when rows with identical non-null indexed values are inserted, '
      'then the second insert violates the unique index.',
      () async {
        await NullsDistinctData.db.insertRow(
          session,
          NullsDistinctData(
            tenantId: 1,
            category: 'books',
            archivedAt: '2026-07-31',
          ),
        );

        var duplicateInsert = NullsDistinctData.db.insertRow(
          session,
          NullsDistinctData(
            tenantId: 1,
            category: 'books',
            archivedAt: '2026-07-31',
          ),
        );

        await expectLater(
          duplicateInsert,
          throwsA(
            isA<DatabaseUniqueViolationException>().having(
              (error) => error.code,
              'code',
              SqliteErrorCode.uniqueViolation,
            ),
          ),
        );
      },
    );
  });

  withServerpod('Given a declared null-distinct unique index,', (
    sessionBuilder,
    endpoints,
  ) {
    late Session session;
    setUp(() => session = sessionBuilder.build());

    test(
      'when the SQLite schema is analyzed, '
      'then the index reports nulls as distinct.',
      () async {
        var databaseDefinition = await session.db.analyzer.analyze();
        var table = databaseDefinition.tables.singleWhere(
          (table) => table.name == 'nulls_distinct_data',
        );
        var index = table.indexes.singleWhere(
          (index) => index.indexName == 'nulls_distinct_data_unique_idx',
        );

        expect(index.nullsDistinct, isTrue);
      },
    );
  });
}
