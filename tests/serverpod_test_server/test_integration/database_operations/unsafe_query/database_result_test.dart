import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group(
      'Given a simple data object in database when fetching with unsafe query',
      () {
    late SimpleData data;
    late DatabaseResult result;
    setUpAll(() async {
      data = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      result = await session.db.unsafeQuery(
        'SELECT * FROM simple_data;',
      );
    });

    tearDownAll(() async {
      await SimpleData.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test('then schema contains column descriptions.', () async {
      var columnDescriptions = result.schema.columns.toList();
      expect(columnDescriptions.length, 2);
      expect(columnDescriptions.map((e) => e.columnName), ['id', 'num']);
    });

    test('then result reports affected rows.', () async {
      expect(result.affectedRowCount, 1);
    });

    test('then result row can be converted to column map.', () async {
      var resultRow = result.firstOrNull;
      expect(resultRow?.toColumnMap(), {'id': data.id, 'num': 1});
    });
  });

  group(
      'Given an object with a relation in database when fetching with unsafe join query',
      () {
    late Town town;
    late Company company;
    late DatabaseResult result;
    setUp(() async {
      town = await Town.db.insertRow(
        session,
        Town(name: 'Stockholm'),
      );
      company = await Company.db.insertRow(
        session,
        Company(name: 'Serverpod', townId: town.id!),
      );
      result = await session.db.unsafeQuery('''
SELECT
 "company"."id" AS "company.id",
 "company"."name" AS "company.name",
 "company"."townId" AS "company.townId",
 "company_town_town"."id" AS "company_town_town.id",
 "company_town_town"."name" AS "company_town_town.name",
 "company_town_town"."mayorId" AS "company_town_town.mayorId"
FROM
 "company"
LEFT JOIN
 "town" AS "company_town_town" ON "company"."townId" = "company_town_town"."id"
ORDER BY
 "company"."name"
      ''');
    });

    tearDown(() async {
      await Company.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Town.db.deleteWhere(session, where: (_) => Constant.bool(true));
    });

    test('then schema contains all column descriptions.', () async {
      var columnDescriptions = result.schema.columns.toList();
      expect(columnDescriptions.length, 6);
      expect(columnDescriptions.map((e) => e.columnName), [
        'company.id',
        'company.name',
        'company.townId',
        'company_town_town.id',
        'company_town_town.name',
        'company_town_town.mayorId',
      ]);
    });

    test('then result reports affected rows.', () async {
      expect(result.affectedRowCount, 1);
    });

    test('then result row can be converted to column map.', () async {
      var resultRow = result.firstOrNull;
      expect(resultRow?.toColumnMap(), {
        'company.id': company.id,
        'company.name': 'Serverpod',
        'company.townId': town.id,
        'company_town_town.id': town.id,
        'company_town_town.name': 'Stockholm',
        'company_town_town.mayorId': null,
      });
    });
  });
}
