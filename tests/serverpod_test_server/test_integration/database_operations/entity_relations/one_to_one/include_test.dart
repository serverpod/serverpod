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
        'when fetching entities including relation then result includes relation data.',
        () async {
      var towns = await Town.db.insert(session, [
        Town(name: 'Stockholm'),
        Town(name: 'San Francisco'),
      ]);
      await Company.db.insert(session, [
        Company(name: 'Serverpod', townId: towns[0].id!),
        Company(name: 'Apple', townId: towns[1].id!),
      ]);

      var companiesFetched = await Company.db.find(
        session,
        include: Company.include(town: Town.include()),
        orderBy: Company.t.name,
      );

      var companyNames = companiesFetched.map((c) => c.name);
      expect(companyNames, containsAll(['Serverpod', 'Apple']));
      var companyTownNames = companiesFetched.map((c) => c.town?.name);
      expect(companyTownNames, containsAll(['Stockholm', 'San Francisco']));
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
        'when fetching entities including nested relation then result includes nested relation data.',
        () async {
      var towns = await Town.db.insert(session, [
        Town(name: 'Stockholm'),
        Town(name: 'San Francisco'),
      ]);
      var companies = await Company.db.insert(session, [
        Company(name: 'Serverpod', townId: towns[0].id!),
        Company(name: 'Apple', townId: towns[1].id!),
      ]);
      await Citizen.db.insert(session, [
        Citizen(name: 'Alex', companyId: companies[0].id!),
        Citizen(name: 'Lina', companyId: companies[1].id!),
      ]);

      var citizensFetched = await Citizen.db.find(
        session,
        include:
            Citizen.include(company: Company.include(town: Town.include())),
        orderBy: Citizen.t.name,
      );

      var citizenNames = citizensFetched.map((c) => c.name);
      expect(citizenNames, ['Alex', 'Lina']);
      var citizenCompanyNames = citizensFetched.map((c) => c.company?.name);
      expect(citizenCompanyNames, ['Serverpod', 'Apple']);
      var citizenCompanyTownNames =
          citizensFetched.map((c) => c.company?.town?.name);
      expect(citizenCompanyTownNames, ['Stockholm', 'San Francisco']);
    });
  });
}
