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
      expect(citizensWithCompanyServerpod.length, 2);
    });

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
    test('then expected entities are returned.', () {
      expect(citizensOrderedByCompanyName.length, 6);
    });

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
    test('then expected number of entities are returned.', () {
      expect(citizensOrderedByCompanyTownName.length, 6);
    });

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
    test('then expected number of entities are returned.', () {
      expect(citizensWithCompanyTownStockholm.length, 4);
    });

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
    test('then expected number of entities are removed.', () async {
      var removedRows = await client.relation.citizenCountWhereCompanyNameIs(
        companyName: 'Serverpod',
      );
      expect(removedRows, 2);
    });
  });

  group(
      'Given entities with nested relation when counting on nested relation attributes',
      () {
    setUp(() async => await _createTestDatabase(client));

    tearDown(() async => await client.relation.deleteAll());
    test('then expected number of entities are removed.', () async {
      var removedRows =
          await client.relation.citizenCountWhereCompanyTownNameIs(
        townName: 'Stockholm',
      );
      expect(removedRows, 4);
    });
  });
}
