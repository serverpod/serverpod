import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import 'config.dart';

Future<void> _createTestDatabase(Client client) async {
  // Towns
  var stockholm = Town(name: 'Stockholm');
  var skinnskatteberg = Town(name: 'Skinnskatteberg');
  stockholm.id = await client.town.insert(stockholm);
  skinnskatteberg.id = await client.town.insert(skinnskatteberg);

  // Companies
  var serverpod = Company(name: 'Serverpod', townId: stockholm.id!);
  var systemair = Company(name: 'Systemair', townId: skinnskatteberg.id!);
  serverpod.id = await client.company.insert(serverpod);
  systemair.id = await client.company.insert(systemair);

  // Citizens
  var alex = Citizen(
      name: 'Alex', companyId: serverpod.id!, oldCompanyId: systemair.id!);
  var isak = Citizen(name: 'Isak', companyId: serverpod.id!);
  alex.id = await client.citizen.insert(alex);
  isak.id = await client.citizen.insert(isak);
}

void main() async {
  var client = Client(serverUrl);

  await _createTestDatabase(client);

  var citizensWithDeepIncludes = await client.citizen.getAllWithDeepIncludes();
  var citizensShallow = await client.citizen.getAllShallow();

  tearDownAll(() async {
    await client.citizen.deleteAll();
    await client.company.deleteAll();
    await client.town.deleteAll();
  });

  group(
      'Given entities with nested relations when fetching all citizens including related data ordered by id',
      () {
    test('then predefined number of citizens are returned.', () {
      expect(citizensWithDeepIncludes.length, 2);
    });

    group('then first citizen fetched', () {
      test('has Alex as name.', () {
        expect(citizensWithDeepIncludes[0].name, 'Alex');
      });

      test('has Serverpod as company.', () {
        expect(citizensWithDeepIncludes[0].company?.name, 'Serverpod');
      });

      test('has Stockholm as company town.', () {
        expect(citizensWithDeepIncludes[0].company?.town?.name, 'Stockholm');
      });

      test('has Systemair as oldCompany.', () {
        expect(citizensWithDeepIncludes[0].oldCompany?.name, 'Systemair');
      });

      test('has Skinnskatteberg as oldCompany town.', () {
        expect(citizensWithDeepIncludes[0].oldCompany?.town?.name,
            'Skinnskatteberg');
      });
    },
        skip: citizensWithDeepIncludes.length != 2
            ? 'Unexpected number of citizens.'
            : false);

    group('then second citizen fetched', () {
      test('has Isak as name.', () {
        expect(citizensWithDeepIncludes[1].name, 'Isak');
      });

      test('has Serverpod as company.', () {
        expect(citizensWithDeepIncludes[1].company?.name, 'Serverpod');
      });

      test('has Stockholm as company town.', () {
        expect(citizensWithDeepIncludes[1].company?.town?.name, 'Stockholm');
      });

      test('does NOT have oldCompany.', () {
        expect(citizensWithDeepIncludes[1].oldCompany, isNull);
      });
    },
        skip: citizensWithDeepIncludes.length != 2
            ? 'Unexpected number of citizens.'
            : false);
  });

  group(
      'Given entities with nested relations when shallow fetching all citizens ordered by id',
      () {
    test('then predefined number of citizens are returned.', () {
      expect(citizensShallow.length, 2);
    });

    group('then first citizen fetched', () {
      test('has Alex as name.', () {
        expect(citizensShallow[0].name, 'Alex');
      });

      test('does NOT have company.', () {
        expect(citizensShallow[0].company, isNull);
      });

      test('does NOT have oldCompany.', () {
        expect(citizensShallow[0].oldCompany, isNull);
      });
    },
        skip: citizensShallow.length != 2
            ? 'Unexpected number of citizens.'
            : false);

    group('then second citizen fetched', () {
      test('has Isak as name.', () {
        expect(citizensShallow[1].name, 'Isak');
      });

      test('does NOT have company.', () {
        expect(citizensShallow[1].company, isNull);
      });

      test('does NOT have oldCompany.', () {
        expect(citizensShallow[1].oldCompany, isNull);
      });
    },
        skip: citizensShallow.length != 2
            ? 'Unexpected number of citizens.'
            : false);
  });
}
