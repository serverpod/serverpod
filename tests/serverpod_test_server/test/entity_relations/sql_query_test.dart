import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';
import '../../../../packages/serverpod/lib/src/database/database_query.dart';

void main() {
  group('Given nested relations when building shallow include sql query', () {
    test('then query only joins what is included.', () {
      var query = SelectQueryBuilder(table: Citizen.t.tableName)
          .withSelectFields(Citizen.t.columns)
          .withInclude(
            Citizen.include(
              company: Company.include(),
            ),
          )
          .build();

      expect(
          query,
          '''
SELECT
 citizen."id" AS "citizen.id",
 citizen."name" AS "citizen.name",
 citizen."companyId" AS "citizen.companyId",
 citizen."oldCompanyId" AS "citizen.oldCompanyId",
 citizen."_companyEmployeesCompanyId" AS "citizen._companyEmployeesCompanyId",
 citizen_company_company."id" AS "citizen_company_company.id",
 citizen_company_company."name" AS "citizen_company_company.name",
 citizen_company_company."townId" AS "citizen_company_company.townId" 
FROM "citizen" 
LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id"
'''
              .replaceAll("\n", ""));
    });
  });

  group('Given many relation when using many relation in select query builder',
      () {
    var where = Posts.t.author.blockedBy((b) => b.blockeeId.notEquals(5));
    var query = SelectQueryBuilder(table: Posts.t.tableName)
        .withSelectFields(Posts.t.columns)
        .withWhere(where)
        .build();
    test('then query is formatted with group by but not having.', () {
      expect(
          query,
          '''
SELECT
 posts."id" AS "posts.id",
 posts."text" AS "posts.text",
 posts."authorId" AS "posts.authorId" 
FROM "posts" 
LEFT JOIN "author" AS posts_author_author
 ON posts."authorId" = posts_author_author."id" 
LEFT JOIN "blocked" AS posts_author_author_blockedBy_blocked
 ON posts_author_author."id" = posts_author_author_blockedBy_blocked."blockerId" 
WHERE (posts_author_author_blockedBy_blocked."blockeeId" != 5 OR posts_author_author_blockedBy_blocked."blockeeId" IS NULL) 
GROUP BY "posts.id", "posts.text", "posts.authorId"
'''
              .replaceAll("\n", ""));
    });
  });
}
