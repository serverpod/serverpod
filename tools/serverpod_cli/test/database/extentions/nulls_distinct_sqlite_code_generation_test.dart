import 'package:serverpod_cli/src/database/dialects/sqlite.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/index_definition_builder.dart';

void main() {
  final uniqueIndex = IndexDefinitionBuilder()
      .withIndexName('product_unique_idx')
      .withElements([
        IndexElementDefinition(
          type: IndexElementDefinitionType.column,
          definition: 'archivedAt',
        ),
      ])
      .withIsUnique(true)
      .build();

  test(
    'Given a unique index that treats nulls as distinct, '
    'when generating SQLite SQL, '
    'then a native unique index is created.',
    () {
      var index = uniqueIndex.copyWith(nullsDistinct: true);

      var sql = index.toSql(tableName: 'product');

      expect(
        sql,
        'CREATE UNIQUE INDEX "product_unique_idx" ON "product" '
        '("archivedAt");\n',
      );
    },
  );

  test(
    'Given a unique index without configured null handling, '
    'when generating SQLite SQL, '
    'then a native unique index is created.',
    () {
      var index = uniqueIndex.copyWith(nullsDistinct: null);
      var sql = index.toSql(tableName: 'product');

      expect(
        sql,
        'CREATE UNIQUE INDEX "product_unique_idx" ON "product" ("archivedAt");\n',
      );
    },
  );

  test(
    'Given a unique index that treats nulls as not distinct, '
    'when generating SQLite SQL, '
    'then the unsupported configuration is rejected.',
    () {
      var index = uniqueIndex.copyWith(nullsDistinct: false);

      expect(
        () => index.toSql(tableName: 'product'),
        throwsA(
          isA<MigrationUnsupportedByDialectException>()
              .having((error) => error.dialect, 'dialect', 'sqlite')
              .having(
                (error) => error.reason,
                'reason',
                'Index "product_unique_idx" on table "product" treats null '
                    'values as equal, which "sqlite" cannot express.',
              ),
        ),
      );
    },
  );
}
