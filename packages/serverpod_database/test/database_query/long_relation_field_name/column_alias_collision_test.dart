import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:test/test.dart';

import '../../test_util/table_relation_builder.dart';

/// Reproduces https://github.com/serverpod/serverpod/issues/5287
///
/// When a query selects columns from two different relations that point at the
/// same table, and the relation field names are long enough to be truncated,
/// the truncated column aliases can collide. When that happens the database
/// returns both columns under the same key, so one relation's value bleeds into
/// the other relation's field on deserialization.
///
/// The two relation field names below are chosen so that the relations get
/// distinct join aliases (they are genuinely separate joins), but the `id`
/// column of each truncates to the *same* select alias.
void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  var citizenTable = Table<int?>(tableName: 'citizen');
  var companyTable = Table<int?>(tableName: 'company');

  // Two distinct relations from `citizen` to `company` with long field names.
  var firstRelation = TableRelationBuilder(companyTable).withRelationsFrom([
    BuilderRelation(
      citizenTable,
      'companyRelationWithAVeryLongFieldNameForcingTruncatio412',
    ),
  ]).build();
  var secondRelation = TableRelationBuilder(companyTable).withRelationsFrom([
    BuilderRelation(
      citizenTable,
      'companyRelationWithAVeryLongFieldNameForcingTruncatio129',
    ),
  ]).build();

  group(
      'Given a query selecting columns from two long-named relations to the same table',
      () {
    var query = SelectQueryBuilder(table: citizenTable).withSelectFields([
      citizenTable.id,
      firstRelation.id,
      secondRelation.id,
    ]).build();

    test('then each selected column has a unique alias.', () {
      var aliases = RegExp(r'AS "([^"]+)"')
          .allMatches(query)
          .map((match) => match.group(1))
          .toList();

      expect(
        aliases,
        equals(aliases.toSet().toList()),
        reason: 'Column aliases collide, causing one relation\'s value to '
            'bleed into another relation\'s field. Query: $query',
      );
    });
  });
}
