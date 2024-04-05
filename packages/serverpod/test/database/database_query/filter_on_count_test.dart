import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/sql_query_builder.dart';
import 'package:serverpod/test_util/many_relation_builder.dart';
import 'package:serverpod/test_util/table_relation_builder.dart';
import 'package:test/test.dart';

void main() {
  var citizenTable = Table(tableName: 'citizen');
  var companyTable = Table(tableName: 'company');
  var relationTable = TableRelationBuilder(companyTable).withRelationsFrom([
    BuilderRelation(citizenTable, 'company'),
  ]).build();
  var manyRelation = ManyRelationBuilder(relationTable).build();

  group('Given SelectQueryBuilder', () {
    group('when filtering on many relation count', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count() > 3)
          .build();
      test('then a sub query is created for the filter.', () {
        expect(
            query,
            contains(
                'WITH "where_count_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" GROUP BY "citizen"."id" HAVING COUNT("citizen_company_company"."id") > 3)'));
      });
      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                'WHERE "citizen"."id" IN (SELECT "where_count_citizen_company_company_0"."citizen.id" FROM "where_count_citizen_company_company_0")'));
      });
    });

    group('when filtering on filtered many relation count', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count((t) => t.id.equals(1)) > 3)
          .build();

      test('then having section is added.', () {
        expect(query,
            contains('HAVING COUNT("citizen_company_company"."id") > 3)'));
      });
    });

    group('when filtering on multiple many relation count', () {
      var where = (manyRelation.count() > 3) & (manyRelation.count() < 5);
      var query =
          SelectQueryBuilder(table: citizenTable).withWhere(where).build();

      test('then a sub query is created for the first many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_count_citizen_company_company_1" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" GROUP BY "citizen"."id" HAVING COUNT("citizen_company_company"."id") > 3)'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" IN (SELECT "where_count_citizen_company_company_1"."citizen.id" FROM "where_count_citizen_company_company_1"'));
      });

      test('then a sub query is created for the second many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_count_citizen_company_company_2" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" GROUP BY "citizen"."id" HAVING COUNT("citizen_company_company"."id") < 5)'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" IN (SELECT "where_count_citizen_company_company_2"."citizen.id" FROM "where_count_citizen_company_company_2"'));
      });
    });

    group('when ordering by and filtering on same filtered many relation count',
        () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count((t) => t.id.equals(1)) > 3)
          .withOrderBy([
        Order(column: manyRelation.count((t) => t.id.equals(1)))
      ]).build();

      test('then a sub query is created for the order by.', () {
        expect(
            query,
            contains(
                '"order_by_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id", COUNT("citizen_company_company"."id") AS "count" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" = 1 GROUP BY "citizen"."id")'));
      });
      test('then query is ordered by order by sub query treating null as 0.',
          () {
        expect(
            query,
            contains(
                'ORDER BY "order_by_citizen_company_company_0"."count" ASC NULLS FIRST'));
      });
      test('then a sub query is created for the filter.', () {
        expect(
            query,
            contains(
                '"where_count_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" = 1 GROUP BY "citizen"."id" HAVING COUNT("citizen_company_company"."id") > 3)'));
      });
      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                'WHERE "citizen"."id" IN (SELECT "where_count_citizen_company_company_0"."citizen.id" FROM "where_count_citizen_company_company_0")'));
      });
    });
  });

  group('Given DeleteQueryBuilder', () {
    group('when filtering on many relation count', () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count() > 3)
          .build();
      test('then a sub query is created for the filter.', () {
        expect(
            query,
            contains(
                'WITH "where_count_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" GROUP BY "citizen"."id" HAVING COUNT("citizen_company_company"."id") > 3)'));
      });
      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                'WHERE "citizen"."id" IN (SELECT "where_count_citizen_company_company_0"."citizen.id" FROM "where_count_citizen_company_company_0")'));
      });
    });

    group('when filtering on filtered many relation count', () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.count((t) => t.id.equals(1)) > 3)
          .build();

      test('then having section is added.', () {
        expect(query,
            contains('HAVING COUNT("citizen_company_company"."id") > 3)'));
      });
    });

    group('when filtering on multiple many relation count', () {
      var where = (manyRelation.count() > 3) & (manyRelation.count() < 5);
      var query =
          DeleteQueryBuilder(table: citizenTable).withWhere(where).build();

      test('then a sub query is created for the first many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_count_citizen_company_company_1" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" GROUP BY "citizen"."id" HAVING COUNT("citizen_company_company"."id") > 3)'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" IN (SELECT "where_count_citizen_company_company_1"."citizen.id" FROM "where_count_citizen_company_company_1"'));
      });

      test('then a sub query is created for the second many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_count_citizen_company_company_2" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" GROUP BY "citizen"."id" HAVING COUNT("citizen_company_company"."id") < 5)'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" IN (SELECT "where_count_citizen_company_company_2"."citizen.id" FROM "where_count_citizen_company_company_2"'));
      });
    });
  });
}
