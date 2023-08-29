import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  // Towns
  var stockholm = Town(name: 'Stockholm');
  var skinnskatteberg = Town(name: 'Skinnskatteberg');
  stockholm.id = await client.relation.townInsert(stockholm);
  skinnskatteberg.id = await client.relation.townInsert(skinnskatteberg);

  // Companies
  var serverpod = Company(name: 'Serverpod', townId: stockholm.id!);
  var systemair = Company(name: 'Systemair', townId: skinnskatteberg.id!);
  var pantor = Company(name: 'Pantor', townId: stockholm.id!);
  serverpod.id = await client.relation.companyInsert(serverpod);
  systemair.id = await client.relation.companyInsert(systemair);
  pantor.id = await client.relation.companyInsert(pantor);

  // Citizens
  var alex = Citizen(
      name: 'Alex', companyId: serverpod.id!, oldCompanyId: systemair.id!);
  var isak = Citizen(name: 'Isak', companyId: serverpod.id!);
  var lina = Citizen(name: 'Lina', companyId: systemair.id!);
  var joanna = Citizen(name: 'Joanna', companyId: systemair.id!);
  var theo = Citizen(name: 'Theo', companyId: pantor.id!);
  var haris = Citizen(name: 'Haris', companyId: pantor.id!);
  alex.id = await client.relation.citizenInsert(alex);
  isak.id = await client.relation.citizenInsert(isak);
  lina.id = await client.relation.citizenInsert(lina);
  joanna.id = await client.relation.citizenInsert(joanna);
  theo.id = await client.relation.citizenInsert(theo);
  haris.id = await client.relation.citizenInsert(haris);
}

void main() async {
  var client = Client(serverUrl);

  group('Given entities with relations when filtering on relation attributes',
      () {
    late List<Citizen> citizensWithCompanyServerpod;
    setUpAll(() async {
      await _createTestDatabase(client);
      citizensWithCompanyServerpod =
          await client.relation.citizenFindWhereCompanyNameIs(
        companyName: 'Serverpod',
      );
    });

    tearDownAll(() async => await client.relation.deleteAll());

    test('then expected entities are returned.', () {
      var citizenNames = citizensWithCompanyServerpod.map((e) => e.name);
      expect(citizenNames, ['Alex', 'Isak']);
    });
  });

  group('Given entities with relations when ordering on relation attributes',
      () {
    late List<Citizen> citizensOrderedByCompanyName;
    setUpAll(() async {
      await _createTestDatabase(client);
      citizensOrderedByCompanyName =
          await client.relation.citizenFindOrderedByCompanyName();
    });

    tearDownAll(() async => await client.relation.deleteAll());

    test('then entities returned are in expected order.', () {
      var citizenNames = citizensOrderedByCompanyName.map((e) => e.name);
      expect(citizenNames, ['Theo', 'Haris', 'Alex', 'Isak', 'Lina', 'Joanna']);
    });
  });

  group(
      'Given entities with relations when ordering on nested relation attributes',
      () {
    late List<Citizen> citizensOrderedByCompanyTownName;
    setUpAll(() async {
      await _createTestDatabase(client);
      citizensOrderedByCompanyTownName =
          await client.relation.citizenFindOrderedByCompanyTownName();
    });

    tearDownAll(() async => await client.relation.deleteAll());

    test('then entities returned are in expected order.', () {
      var citizenNames = citizensOrderedByCompanyTownName.map((e) => e.name);
      expect(citizenNames, ['Lina', 'Joanna', 'Alex', 'Isak', 'Theo', 'Haris']);
    });
  });

  group(
      'Given entities with nested relations when filtering on nested relation attributes',
      () {
    late List<Citizen> citizensWithCompanyTownStockholm;
    setUpAll(() async {
      await _createTestDatabase(client);
      citizensWithCompanyTownStockholm =
          await client.relation.citizenFindWhereCompanyTownNameIs(
        townName: 'Stockholm',
      );
    });

    tearDownAll(() async => await client.relation.deleteAll());

    test('then expected entities are returned.', () {
      var citizenNames = citizensWithCompanyTownStockholm.map((e) => e.name);
      expect(citizenNames, ['Alex', 'Isak', 'Theo', 'Haris']);
    });
  });

  group('Given entities with relation when deleting on relation attributes',
      () {
    setUp(() async => await _createTestDatabase(client));

    tearDown(() async => await client.relation.deleteAll());

    test('then expected number of entities are removed.', () async {
      var removedRows = await client.relation.citizenDeleteWhereCompanyNameIs(
        companyName: 'Serverpod',
      );
      expect(removedRows, 2);
    });
  });

  group(
      'Given entities with nested relation when deleting on nested relation attributes',
      () {
    setUp(() async => await _createTestDatabase(client));

    tearDown(() async => await client.relation.deleteAll());

    test('then expected number of entities are removed.', () async {
      var removedRows =
          await client.relation.citizenDeleteWhereCompanyTownNameIs(
        townName: 'Stockholm',
      );

      expect(removedRows, 4);
    });
  });

  group('Given entities with relation when counting on relation attributes',
      () {
    setUp(() async => await _createTestDatabase(client));

    tearDown(() async => await client.relation.deleteAll());

    test('then expected number of entities are found.', () async {
      var entitiesFound = await client.relation.citizenCountWhereCompanyNameIs(
        companyName: 'Serverpod',
      );

      expect(entitiesFound, 2);
    });
  });

  group(
      'Given entities with nested relation when counting on nested relation attributes',
      () {
    setUp(() async => await _createTestDatabase(client));

    tearDown(() async => await client.relation.deleteAll());

    test('then expected number of entities are found.', () async {
      var entitiesFound =
          await client.relation.citizenCountWhereCompanyTownNameIs(
        townName: 'Stockholm',
      );

      expect(entitiesFound, 4);
    });
  });

  group(
      'Given entities with nested relations when fetching citizens with deep includes.',
      () {
    late List<Citizen> citizensWithDeepIncludes;
    setUpAll(() async {
      await _createTestDatabase(client);
      citizensWithDeepIncludes =
          await client.relation.citizenFindAllWithDeepIncludes();
    });

    tearDownAll(() async => await client.relation.deleteAll());

    test('then all citizens are returned.', () {
      expect(citizensWithDeepIncludes.length, 6);
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
    });

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
    });
  });

  group(
      'Given entities with nested relations when fetching all citizens without includes',
      () {
    late List<Citizen> citizensWithoutIncludes;
    setUpAll(() async {
      await _createTestDatabase(client);
      citizensWithoutIncludes = await client.relation.citizenFindAll();
    });

    tearDownAll(() async => await client.relation.deleteAll());

    test('then predefined number of citizens are returned.', () {
      expect(citizensWithoutIncludes.length, 6);
    });

    group('then first citizen fetched', () {
      test('has Alex as name.', () {
        expect(citizensWithoutIncludes[0].name, 'Alex');
      });

      test('does NOT have company.', () {
        expect(citizensWithoutIncludes[0].company, isNull);
      });

      test('does NOT have oldCompany.', () {
        expect(citizensWithoutIncludes[0].oldCompany, isNull);
      });
    });

    group('then second citizen fetched', () {
      test('has Isak as name.', () {
        expect(citizensWithoutIncludes[1].name, 'Isak');
      });

      test('does NOT have company.', () {
        expect(citizensWithoutIncludes[1].company, isNull);
      });

      test('does NOT have oldCompany.', () {
        expect(citizensWithoutIncludes[1].oldCompany, isNull);
      });
    });
  });

  group(
      'Given entities with nested relations when fetching all citizens with shallow includes',
      () {
    late List<Citizen> citizensWithShallowIncludes;
    setUpAll(() async {
      await _createTestDatabase(client);
      citizensWithShallowIncludes =
          await client.relation.citizenFindAllWithShallowIncludes();
    });

    tearDownAll(() async => await client.relation.deleteAll());

    test('then predefined number of citizens are returned.', () {
      expect(citizensWithShallowIncludes.length, 6);
    });

    group('then first citizen fetched', () {
      test('has Alex as name.', () {
        expect(citizensWithShallowIncludes[0].name, 'Alex');
      });

      test('has Serverpod as company.', () {
        expect(citizensWithShallowIncludes[0].company?.name, 'Serverpod');
      });

      test('does NOT have company town.', () {
        expect(citizensWithShallowIncludes[0].company?.town, isNull);
      });

      test('has Systemair as oldCompany.', () {
        expect(citizensWithShallowIncludes[0].oldCompany?.name, 'Systemair');
      });

      test('does NOT have oldCompany town.', () {
        expect(citizensWithShallowIncludes[0].oldCompany?.town, isNull);
      });
    });

    group('then second citizen fetched', () {
      test('has Isak as name.', () {
        expect(citizensWithShallowIncludes[1].name, 'Isak');
      });

      test('has Serverpod as company.', () {
        expect(citizensWithShallowIncludes[1].company?.name, 'Serverpod');
      });

      test('does NOT have company town.', () {
        expect(citizensWithShallowIncludes[1].company?.town, isNull);
      });

      test('does NOT have oldCompany.', () {
        expect(citizensWithShallowIncludes[1].oldCompany, isNull);
      });
    });
  });
}
