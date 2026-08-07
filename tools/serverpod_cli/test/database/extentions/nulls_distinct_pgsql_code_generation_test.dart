import 'package:serverpod_cli/src/database/dialects/postgres.dart';
import 'package:serverpod_database/serverpod_database.dart';
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
    'Given a unique index without configured null handling, '
    'when generating PostgreSQL, '
    'then the database default is used.',
    () {
      var index = uniqueIndex.copyWith(nullsDistinct: null);

      var sql = index.toPgSql(tableName: 'product');

      expect(
        sql,
        'CREATE UNIQUE INDEX "product_unique_idx" ON "product" '
        'USING btree ("archivedAt");\n',
      );
    },
  );

  test(
    'Given a unique index that treats nulls as distinct, '
    'when generating PostgreSQL, '
    'then NULLS DISTINCT is included.',
    () {
      var index = uniqueIndex.copyWith(nullsDistinct: true);

      var sql = index.toPgSql(tableName: 'product');

      expect(
        sql,
        'CREATE UNIQUE INDEX "product_unique_idx" ON "product" '
        'USING btree ("archivedAt") NULLS DISTINCT;\n',
      );
    },
  );

  test(
    'Given a unique index that treats nulls as not distinct, '
    'when generating PostgreSQL, '
    'then NULLS NOT DISTINCT is included.',
    () {
      var index = uniqueIndex.copyWith(nullsDistinct: false);

      var sql = index.toPgSql(tableName: 'product');

      expect(
        sql,
        'CREATE UNIQUE INDEX "product_unique_idx" ON "product" '
        'USING btree ("archivedAt") NULLS NOT DISTINCT;\n',
      );
    },
  );
}
