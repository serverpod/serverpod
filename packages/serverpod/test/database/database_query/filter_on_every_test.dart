import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/database_query.dart';
import 'package:serverpod/src/database/table_relation.dart';
import 'package:test/test.dart';

void main() {
  var citizenTable = Table(tableName: 'citizen');
  var companyTable = Table(tableName: 'company');
  var relationTable = Table(
    tableName: companyTable.tableName,
    tableRelation: TableRelation([
      TableRelationEntry(
        relationAlias: 'company',
        field: ColumnInt('id', citizenTable),
        foreignField: ColumnInt('id', companyTable),
      )
    ]),
  );

  var manyRelation = ManyRelation(
    tableWithRelations: relationTable,
    table: Table(
        tableName: companyTable.tableName,
        tableRelation: relationTable.tableRelation!.lastRelation),
  );

  group('Given SelectQueryBuilder', () {
    group('when filtering on filtered every many relation', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.every((t) => t.id.equals(1)))
          .build();
      test('then a sub query is created for the filter.', () {
        expect(
            query,
            contains(
                'WITH "where_every_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE NOT "citizen_company_company"."id" = 1 OR "citizen_company_company"."id" IS NULL GROUP BY "citizen"."id"'));
      });
      test('then a sub query is joined with a not in where in main query.', () {
        expect(
            query,
            contains(
                'WHERE "citizen"."id" NOT IN (SELECT "where_every_citizen_company_company_0"."citizen.id" FROM "where_every_citizen_company_company_0")'));
      });
    });

    group('when filtering on advanced filtered every many relation', () {
      var query = SelectQueryBuilder(table: citizenTable)
          .withWhere(manyRelation.every((t) => t.id.equals(1) | t.id.equals(2)))
          .build();
      test('then a sub query is created for the filter.', () {
        expect(
            query,
            contains(
                'WITH "where_every_citizen_company_company_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE NOT ("citizen_company_company"."id" = 1 OR "citizen_company_company"."id" = 2) OR "citizen_company_company"."id" IS NULL GROUP BY "citizen"."id"'));
      });
      test('then a sub query is joined with a not in where in main query.', () {
        expect(
            query,
            contains(
                'WHERE "citizen"."id" NOT IN (SELECT "where_every_citizen_company_company_0"."citizen.id" FROM "where_every_citizen_company_company_0")'));
      });
    });

    group('when filtering on multiple every many relation', () {
      var where = manyRelation.every((t) => t.id.equals(1)) |
          manyRelation.every((t) => t.id.equals(2));
      var query =
          SelectQueryBuilder(table: citizenTable).withWhere(where).build();

      test('then a sub query is created for the first many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_every_citizen_company_company_1" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE NOT "citizen_company_company"."id" = 1 OR "citizen_company_company"."id" IS NULL GROUP BY "citizen"."id")'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" NOT IN (SELECT "where_every_citizen_company_company_1"."citizen.id" FROM "where_every_citizen_company_company_1")'));
      });

      test('then a sub query is created for the second many relation filter.',
          () {
        expect(
            query,
            contains(
                '"where_every_citizen_company_company_2" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."id" = "citizen_company_company"."id" WHERE NOT "citizen_company_company"."id" = 2 OR "citizen_company_company"."id" IS NULL GROUP BY "citizen"."id")'));
      });

      test('then a sub query is joined with a where in main query.', () {
        expect(
            query,
            contains(
                '"citizen"."id" NOT IN (SELECT "where_every_citizen_company_company_2"."citizen.id" FROM "where_every_citizen_company_company_2"'));
      });
    });
  });
}
