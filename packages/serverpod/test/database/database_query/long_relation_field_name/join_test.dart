import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/sql_query_builder.dart';
import 'package:serverpod/test_util/table_relation_builder.dart';
import 'package:test/test.dart';

void main() {
  var citizenTable = Table(tableName: 'citizen');
  var companyTable = Table(tableName: 'company');
  var relationTable = TableRelationBuilder(companyTable).withRelationsFrom([
    BuilderRelation(
      citizenTable,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
    ),
  ]).build();

  group('Given SelectQueryBuilder', () {
    group('when filtering causes a long join name.', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(relationTable.id.equals(1))
          .build();
      var expectedTruncatedName =
          'citizen_thisFieldIsExactly61CharactersLongAndIsThereforeVale9b4';

      test('then join query name is truncated.', () {
        expect(
          query,
          contains('LEFT JOIN "company" AS "$expectedTruncatedName"'),
        );
      });

      test('then join query uses the truncated join name.', () {
        expect(
          query,
          contains('"citizen"."id" = "$expectedTruncatedName"."id"'),
        );
      });

      test('then uses truncated name in where statements in for join.', () {
        expect(
          query,
          contains('"$expectedTruncatedName"."id" = 1'),
        );
      });
    });
  });
}
