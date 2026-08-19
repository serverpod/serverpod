import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  // The table carries one unique index per null handling. Rows below always
  // pin the column of the index that is not under test to distinct non-null
  // values, so only the index being exercised can be violated.
  withServerpod('Given an empty table indexed with both null handlings,', (
    sessionBuilder,
    endpoints,
  ) {
    var session = sessionBuilder.build();

    test(
      'when rows with the same null-distinct values and a null are inserted, '
      'then both rows are stored.',
      () async {
        await NullsDistinctData.db.insert(
          session,
          [
            NullsDistinctData(
              tenantId: 1,
              category: 'books',
              archivedAt: null,
              deletedAt: '2026-07-30',
            ),
            NullsDistinctData(
              tenantId: 1,
              category: 'books',
              archivedAt: null,
              deletedAt: '2026-07-31',
            ),
          ],
        );

        var rows = await NullsDistinctData.db.find(session);

        expect(rows, hasLength(2));
      },
    );

    test(
      'when rows with the same null-not-distinct values and a null are inserted, '
      'then the second insert violates the unique index.',
      () async {
        await NullsDistinctData.db.insertRow(
          session,
          NullsDistinctData(
            tenantId: 1,
            category: 'books',
            archivedAt: '2026-07-30',
            deletedAt: null,
          ),
        );

        var duplicateInsert = NullsDistinctData.db.insertRow(
          session,
          NullsDistinctData(
            tenantId: 1,
            category: 'books',
            archivedAt: '2026-07-31',
            deletedAt: null,
          ),
        );

        await expectLater(
          duplicateInsert,
          throwsA(isA<DatabaseUniqueViolationException>()),
        );
      },
    );

    test(
      'when rows with a null-not-distinct null differ in another indexed value, '
      'then both rows are stored.',
      () async {
        await NullsDistinctData.db.insert(
          session,
          [
            NullsDistinctData(
              tenantId: 1,
              category: 'books',
              archivedAt: '2026-07-30',
              deletedAt: null,
            ),
            NullsDistinctData(
              tenantId: 2,
              category: 'books',
              archivedAt: '2026-07-31',
              deletedAt: null,
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
            deletedAt: '2026-07-31',
          ),
        );

        var duplicateInsert = NullsDistinctData.db.insertRow(
          session,
          NullsDistinctData(
            tenantId: 1,
            category: 'books',
            archivedAt: '2026-07-31',
            deletedAt: '2026-07-31',
          ),
        );

        await expectLater(
          duplicateInsert,
          throwsA(isA<DatabaseUniqueViolationException>()),
        );
      },
    );
  });

  withServerpod('Given indexes declared with both null handlings,', (
    sessionBuilder,
    endpoints,
  ) {
    var session = sessionBuilder.build();

    test(
      'when the PostgreSQL schema is analyzed, '
      'then each index reports its configured null handling.',
      () async {
        var databaseDefinition = await session.db.analyzer.analyze();
        var table = databaseDefinition.tables.singleWhere(
          (table) => table.name == 'nulls_distinct_data',
        );

        var nullsDistinct = table.indexes.singleWhere(
          (index) => index.indexName == 'nulls_distinct_data_unique_idx',
        );
        var nullsNotDistinct = table.indexes.singleWhere(
          (index) => index.indexName == 'nulls_distinct_data_not_distinct_idx',
        );

        expect(nullsDistinct.nullsDistinct, isTrue);
        expect(nullsNotDistinct.nullsDistinct, isFalse);
      },
    );

    test(
      'when the live schema is compared to the target definition, '
      'then the table is reported as matching.',
      () async {
        var databaseDefinition = await session.db.analyzer.analyze();
        var liveTable = databaseDefinition.tables.singleWhere(
          (table) => table.name == 'nulls_distinct_data',
        );
        var targetTable = session.db.analyzer
            .getTargetTableDefinitions()
            .singleWhere((table) => table.name == 'nulls_distinct_data');

        var mismatches = liveTable.like(targetTable);

        expect(mismatches.map((mismatch) => mismatch.toString()), isEmpty);
      },
    );
  });
}
