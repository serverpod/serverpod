import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/sql_query_builder.dart';
import 'package:serverpod/test_util/many_relation_builder.dart';
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
  var manyRelation = ManyRelationBuilder(relationTable).build();

  group('Given SelectQueryBuilder', () {
    group('when ordering by list relation with a long field name', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withOrderBy([Order(column: manyRelation.count())]).build();
      var expectedTruncatedName =
          'order_by_citizen_thisFieldIsExactly61CharactersLongAndIsThee498';

      test('then sub query alias name is truncated.', () {
        expect(query, contains('WITH "$expectedTruncatedName" AS'));
      });

      test('then sub query is referenced using truncated name.', () {
        expect(query, contains('ORDER BY "$expectedTruncatedName"."count"'));
      });
    });
  });
}
