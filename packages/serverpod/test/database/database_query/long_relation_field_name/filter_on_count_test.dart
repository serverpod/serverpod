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
  var expectedTruncatedName =
      'where_count_citizen_thisFieldIsExactly61CharactersLongAndIs89c7';

  group('Given SelectQueryBuilder', () {
    group('when "count" filtering on relation with a long field name', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count() > 1)
          .build();

      test('then sub query alias name is truncated.', () {
        expect(query, contains('WITH "$expectedTruncatedName" AS'));
      });

      test('then sub query is referenced using truncated name.', () {
        expect(
            query,
            contains(
                'SELECT "$expectedTruncatedName"."citizen.id" FROM "$expectedTruncatedName"'));
      });
    });
  });
  group('Given CountQueryBuilder', () {
    group('when "count" filtering on relation with a long field name', () {
      var query = CountQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count() > 1)
          .build();

      test('then sub query alias name is truncated.', () {
        expect(query, contains('WITH "$expectedTruncatedName" AS'));
      });

      test('then sub query is referenced using truncated name.', () {
        expect(
            query,
            contains(
                'SELECT "$expectedTruncatedName"."citizen.id" FROM "$expectedTruncatedName"'));
      });
    });
  });
  group('Given DeleteQueryBuilder', () {
    group('when "count" filtering on relation with a long field name', () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count() > 1)
          .build();

      test('then sub query alias name is truncated.', () {
        expect(query, contains('WITH "$expectedTruncatedName" AS'));
      });

      test('then sub query is referenced using truncated name.', () {
        expect(
            query,
            contains(
                'SELECT "$expectedTruncatedName"."citizen.id" FROM "$expectedTruncatedName"'));
      });
    });
  });
}
