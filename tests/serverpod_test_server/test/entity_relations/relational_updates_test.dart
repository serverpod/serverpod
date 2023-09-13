import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  var town = Town(name: 'Stockholm');
  town.id = await client.relation.townInsert(town);

  var serverpod = Company(name: 'Serverpod', town: town, townId: town.id!);
  serverpod.id = await client.relation.companyInsert(serverpod);

  var pods = Company(name: 'The pod', town: town, townId: town.id!);
  pods.id = await client.relation.companyInsert(pods);

  var alice = Citizen(name: 'Alice', companyId: serverpod.id!);
  var bob = Citizen(name: 'Bob', companyId: serverpod.id!);
  alice.id = await client.relation.citizenInsert(alice);
  bob.id = await client.relation.citizenInsert(bob);

  var address = Address(street: 'Street', inhabitantId: bob.id);
  address.id = await client.relation.addressInsert(address);
}

void main() {
  var client = Client(serverUrl);

  group('Given a citizen ', () {
    late List<Citizen> citizens;
    late List<Company> companies;

    setUp(() async {
      await _createTestDatabase(client);
      citizens = await client.relation.citizenFindAll();
      companies = await client.relation.companyFindAll();
    });

    //tearDown(() async => await client.relation.deleteAll());

    group('group name', () {
      test('test name', () async {
        var citizen = citizens.first;
        var company = companies.last;

        await client.relation.citizenAttachCompany(citizen, company);

        var alice = await client.relation.citizenFindByIdWithIncludes(
          citizen.id!,
        );

        expect(alice?.companyId, company.id);
      });
    });

    test(
        'when attaching an address from the foreign key side the object holding the foreign key is updated in the database',
        () async {
      var alice = citizens.first;
      var address = Address(street: 'Street');
      address.id = await client.relation.addressInsert(address);

      await client.relation.addressAttachCitizen(address, alice);

      var updatedAddress = await client.relation.addressFindById(address.id!);

      expect(updatedAddress?.inhabitantId, alice.id);
    });

    test(
        'when attaching an address from the none foreign key side the object holding the foreign key is updated in the database',
        () async {
      var alice = citizens.first;
      var address = Address(street: 'Street');
      address.id = await client.relation.addressInsert(address);

      await client.relation.citizenAttachAddress(alice, address);

      var updatedAddress = await client.relation.addressFindById(address.id!);

      expect(updatedAddress?.inhabitantId, alice.id);
    });

    test(
        'when detaching an address from the foreign key side the object holding the foreign key has the foreign key set to null.',
        () async {
      var addresses = await client.relation.addressFindAll();
      var address = addresses.first;

      await client.relation.addressDetachCitizen(address);

      var updatedAddress = await client.relation.addressFindById(address.id!);

      expect(updatedAddress?.inhabitantId, null);
    });

    test(
        'when detaching an address from the none foreign key side the object holding the foreign key has the foreign key set to null.',
        () async {
      var bob = citizens.last;

      var addresses = await client.relation.addressFindAll();
      var address = addresses.first;

      var bobCopy = bob.copyWith(address: address);

      await client.relation.citizenDetachAddress(bobCopy);

      var updatedAddress = await client.relation.addressFindById(address.id!);

      expect(updatedAddress?.inhabitantId, null);
    });
  });
}
