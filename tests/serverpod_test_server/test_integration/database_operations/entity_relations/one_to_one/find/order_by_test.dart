import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given entities with one to one relation', () {
    tearDown(() async {
      await Company.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Town.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching entities ordered by relation attributes then result is as expected.',
        () async {
      var towns = await Town.db.insert(session, [
        Town(name: 'Stockholm'),
        Town(name: 'San Francisco'),
      ]);
      await Company.db.insert(session, [
        Company(name: 'Serverpod', townId: towns[0].id!),
        Company(name: 'Apple', townId: towns[1].id!),
        Company(name: 'Google', townId: towns[1].id!),
      ]);

      var companiesFetched = await Company.db.find(
        session,
        // Order by company town name and then company name
        orderByList: (t) => [
          db.Order(column: t.town.name),
          db.Order(column: t.name),
        ],
      );

      var companyNames = companiesFetched.map((c) => c.name);
      expect(companyNames, [
        'Apple',
        'Google',
        'Serverpod',
      ]);
    });
  });

  group('Given entities with nested one to one relations', () {
    tearDown(() async {
      await Citizen.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Company.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Town.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching entities ordered by nested relation attributes then result is as expected.',
        () async {
      var towns = await Town.db.insert(session, [
        Town(name: 'Stockholm'),
        Town(name: 'San Francisco'),
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

      var citizens = await Citizen.db.find(
        session,
        // Order by citizen company town name and then citizen name
        orderByList: (t) => [
          db.Order(column: t.company.town.name),
          db.Order(column: t.name),
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
