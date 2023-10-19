import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given entities with nested one to one relations', () {
    setUpAll(() async {
      var towns = await Town.db.insert(session, [
        Town(name: 'Stockholm'),
        Town(name: 'San Fransisco'),
        Town(name: 'Tokyo'),
      ]);
      var companies = await Company.db.insert(session, [
        Company(name: 'Serverpod', townId: towns[0].id!),
        Company(name: 'Apple', townId: towns[1].id!),
        Company(name: 'Honda', townId: towns[2].id!),
      ]);
      await Citizen.db.insert(session, [
        Citizen(name: 'Alex', companyId: companies[0].id!),
        Citizen(name: 'Isak', companyId: companies[0].id!),
        Citizen(name: 'Lina', companyId: companies[1].id!),
        Citizen(name: 'Marc', companyId: companies[1].id!),
        Citizen(name: 'Yuko', companyId: companies[2].id!),
      ]);
    });

    tearDownAll(() async {
      await Citizen.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Company.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Town.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test('when ordering result by relation attributes', () async {
      var citizens = await Citizen.db.find(
        session,
        orderByList: [
          db.Order(column: Citizen.t.company.name),
          db.Order(column: Citizen.t.name),
        ],
      );

      var citizenNames = citizens.map((c) => c.name);
      expect(citizenNames, [
        'Lina',
        'Marc',
        'Yuko',
        'Alex',
        'Isak',
      ]);
    });

    test('when ordering result by nested relation attributes', () async {
      var citizens = await Citizen.db.find(
        session,
        orderByList: [
          db.Order(column: Citizen.t.company.town.name),
          db.Order(column: Citizen.t.name),
        ],
      );

      var citizenNames = citizens.map((c) => c.name);
      expect(citizenNames, [
        'Lina',
        'Marc',
        'Alex',
        'Isak',
        'Yuko',
      ]);
    });
  });
}
