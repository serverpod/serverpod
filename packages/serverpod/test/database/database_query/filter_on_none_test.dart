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
    group('when filtering on none many relation', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.none())
          .build();
      test('then a sub query is created for the filter.', () {
        expect(
            query,
            contains(
                'WITH "where_none_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" IS NOT NULL GROUP BY "citizen"."id"'));
      });
      test('then a sub query is joined with a not in where in main query.', () {
        expect(
            query,
            contains(
                'WHERE "citizen"."id" NOT IN (SELECT "where_none_citizen_company_company_0"."citizen.id" FROM "where_none_citizen_company_company_0")'));
      });
    });

    group('when filtering on filtered none many relation', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.none((t) => t.id.equals(1)))
          .build();

      test('then filter is added with an AND statement.', () {
        expect(
            query,
            contains(
                'WHERE "citizen_company_company"."id" = 1 AND "citizen_company_company"."id" IS NOT NULL'));
      });
    });

    group('when filtering on multiple none many relation', () {
      var where =
          manyRelation.none((t) => t.id.equals(1)) & manyRelation.none();
      var query =
          SelectQueryBuilder(table: citizenTable).withWhere(where).build();

      test('then a sub query is created for the first many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_none_citizen_company_company_1" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" = 1 AND "citizen_company_company"."id" IS NOT NULL GROUP BY "citizen"."id")'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" NOT IN (SELECT "where_none_citizen_company_company_1"."citizen.id" FROM "where_none_citizen_company_company_1")'));
      });

      test('then a sub query is created for the second many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_none_citizen_company_company_2" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" IS NOT NULL GROUP BY "citizen"."id")'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" NOT IN (SELECT "where_none_citizen_company_company_2"."citizen.id" FROM "where_none_citizen_company_company_2"'));
      });
    });
  });

  group('Given DeleteQueryBuilder', () {
    group('when filtering on none many relation', () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.none())
          .build();
      test('then a sub query is created for the filter.', () {
        expect(
            query,
            contains(
                'WITH "where_none_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" IS NOT NULL GROUP BY "citizen"."id"'));
      });
      test('then a sub query is joined with a not in where in main query.', () {
        expect(
            query,
            contains(
                'WHERE "citizen"."id" NOT IN (SELECT "where_none_citizen_company_company_0"."citizen.id" FROM "where_none_citizen_company_company_0")'));
      });
    });

    group('when filtering on filtered none many relation', () {
      var query = DeleteQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.none((t) => t.id.equals(1)))
          .build();

      test('then filter is added with an AND statement.', () {
        expect(
            query,
            contains(
                'WHERE "citizen_company_company"."id" = 1 AND "citizen_company_company"."id" IS NOT NULL'));
      });
    });

    group('when filtering on multiple none many relation', () {
      var where =
          manyRelation.none((t) => t.id.equals(1)) & manyRelation.none();
      var query =
          DeleteQueryBuilder(table: citizenTable).withWhere(where).build();

      test('then a sub query is created for the first many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_none_citizen_company_company_1" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" = 1 AND "citizen_company_company"."id" IS NOT NULL GROUP BY "citizen"."id")'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" NOT IN (SELECT "where_none_citizen_company_company_1"."citizen.id" FROM "where_none_citizen_company_company_1")'));
      });

      test('then a sub query is created for the second many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_none_citizen_company_company_2" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE "citizen_company_company"."id" IS NOT NULL GROUP BY "citizen"."id")'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" NOT IN (SELECT "where_none_citizen_company_company_2"."citizen.id" FROM "where_none_citizen_company_company_2"'));
      });
    });
  });
}
