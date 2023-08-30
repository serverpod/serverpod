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
 citizen_company_company."id" AS "citizen_company_company.id",
 citizen_company_company."name" AS "citizen_company_company.name",
 citizen_company_company."townId" AS "citizen_company_company.townId" 
FROM "citizen" 
LEFT JOIN "company" AS citizen_company_company ON citizen."companyId" = citizen_company_company."id"
'''
              .replaceAll("\n", ""));
    });
  });
}
