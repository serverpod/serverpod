import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Session session) async {
  var town = Town(name: 'Stockholm');
  town = await Town.db.insertRow(session, town);

  var serverpod = Company(name: 'Serverpod', town: town, townId: town.id!);
  serverpod = await Company.db.insertRow(session, serverpod);

  var pods = Company(name: 'The pod', town: town, townId: town.id!);
  pods = await Company.db.insertRow(session, pods);

  var alice = Citizen(name: 'Alice', companyId: serverpod.id!);
  var bob = Citizen(name: 'Bob', companyId: serverpod.id!);
  alice = await Citizen.db.insertRow(session, alice);
  bob = await Citizen.db.insertRow(session, bob);

  var address = Address(street: 'Street', inhabitantId: bob.id);
  address = await Address.db.insertRow(session, address);
}

Future<int> deleteAll(Session session) async {
  var addressDeletions =
      await Address.db.deleteWhere(session, where: (_) => Constant.bool(true));
  var citizenDeletions =
      await Citizen.db.deleteWhere(session, where: (_) => Constant.bool(true));
  var companyDeletions =
      await Company.db.deleteWhere(session, where: (_) => Constant.bool(true));
  var townDeletions =
      await Town.db.deleteWhere(session, where: (_) => Constant.bool(true));

  var postDeletions =
      await Post.db.deleteWhere(session, where: (_) => Constant.bool(true));

  return townDeletions.length +
      companyDeletions.length +
      citizenDeletions.length +
      addressDeletions.length +
      postDeletions.length;
}

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given an address', () {
    late List<Citizen> citizens;

    setUp(() async {
      await _createTestDatabase(session);
      citizens = await Citizen.db.find(session, orderBy: (t) => t.id);
    });

    tearDown(() async => await deleteAll(session));
    test(
        'when attaching an address from the foreign key side the object holding the foreign key is updated in the database',
        () async {
      var alice = citizens.first;
      var address = Address(street: 'Street');
      address = await Address.db.insertRow(session, address);

      await Address.db.attachRow.inhabitant(session, address, alice);

      var updatedAddress = await Address.db.findById(session, address.id!);

      expect(updatedAddress?.inhabitantId, alice.id);
    });

    test(
        'when detaching an address from the foreign key side the object holding the foreign key has the foreign key set to null.',
        () async {
      var addresses = await Address.db.find(session, orderBy: (t) => t.id);
      var address = addresses.first;

      await Address.db.detachRow.inhabitant(session, address);

      var updatedAddress = await Address.db.findById(session, address.id!);

      expect(updatedAddress?.inhabitantId, null);
    });

    test(
        'when attaching an address with modified values only the foreign key field is modified.',
        () async {
      var alice = citizens.first;
      var address = Address(street: 'Street');
      address = await Address.db.insertRow(session, address);

      var copy = address.copyWith(street: 'New street');

      Address.db.attachRow.inhabitant(session, copy, alice);

      var updatedAddress = await Address.db.findById(session, address.id!);

      expect(updatedAddress?.street, 'Street');
    });

    test(
        'when trying to attach a citizen to an address that is not stored in the database then an exception is thrown',
        () async {
      var alice = citizens.first;
      var address = Address(street: 'Street');

      try {
        await Address.db.attachRow.inhabitant(session, address, alice);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect((e as ArgumentError).name, 'address.id');
      }
    });

    test(
        'when trying to attach a citizen that is not stored in the db to an address then an exception is thrown',
        () async {
      var carol = Citizen(name: 'Carol', companyId: 0);
      var address = Address(street: 'Street');
      address = await Address.db.insertRow(session, address);

      try {
        await Address.db.attachRow.inhabitant(session, address, carol);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect((e as ArgumentError).name, 'inhabitant.id');
      }
    });

    test(
        'when trying to detach a citizen from an address that is not stored in the database then an exception is thrown',
        () async {
      var address = Address(street: 'Street');

      try {
        await Address.db.detachRow.inhabitant(session, address);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect((e as ArgumentError).name, 'address.id');
      }
    });
  });

  group('Given a citizen ', () {
    late List<Citizen> citizens;
    late List<Company> companies;

    setUp(() async {
      await _createTestDatabase(session);
      citizens = await Citizen.db.find(session, orderBy: (t) => t.id);
      companies = await Company.db.find(session, orderBy: (t) => t.id);
    });

    tearDown(() async => await deleteAll(session));

    test(
        'when attaching an address from the none foreign key side the object holding the foreign key is updated in the database',
        () async {
      var alice = citizens.first;
      var address = Address(street: 'Street');
      address = await Address.db.insertRow(session, address);

      await Citizen.db.attachRow.address(session, alice, address);

      var updatedAddress = await Address.db.findById(session, address.id!);

      expect(updatedAddress?.inhabitantId, alice.id);
    });

    test(
        'when detaching an address from the none foreign key side the object holding the foreign key has the foreign key set to null.',
        () async {
      var bob = citizens.last;

      var addresses = await Address.db.find(
        session,
        orderBy: (t) => t.id,
        include: Address.include(
          inhabitant: Citizen.include(),
        ),
      );
      var address = addresses.first;

      var bobCopy = bob.copyWith(address: address);

      await Citizen.db.detachRow.address(session, bobCopy);

      var updatedAddress = await Address.db.findById(session, address.id!);

      expect(updatedAddress?.inhabitantId, null);
    });

    test(
        'when attaching to an object that already have an entry then the new value is set in the database',
        () async {
      var citizen = citizens.first;
      var company = companies.last;

      await Citizen.db.attachRow.company(session, citizen, company);

      var alice = await Citizen.db.findById(
        session,
        citizen.id!,
        include: Citizen.include(company: Company.include()),
      );

      expect(alice?.companyId, company.id);
    });

    test(
        'when trying to attach a citizen to an address that is not stored in the database then an exception is thrown',
        () async {
      var alice = citizens.first;
      var address = Address(street: 'Street');

      try {
        await Citizen.db.attachRow.address(session, alice, address);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect((e as ArgumentError).name, 'address.id');
      }
    });

    test(
        'when trying to attach a citizen that is not stored in the db to an address then an exception is thrown',
        () async {
      var carol = Citizen(name: 'Carol', companyId: 0);
      var address = Address(street: 'Street');
      address = await Address.db.insertRow(session, address);

      try {
        await Citizen.db.attachRow.address(session, carol, address);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect((e as ArgumentError).name, 'citizen.id');
      }
    });

    test(
        'when trying to detach an address from a citizen that is not stored in the database then an exception is thrown',
        () async {
      var address = Address(street: 'Street');
      address = await Address.db.insertRow(session, address);

      var carol = Citizen(name: 'Carol', companyId: 0, address: address);

      try {
        await Citizen.db.detachRow.address(session, carol);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect((e as ArgumentError).name, 'citizen.id');
      }
    });

    test(
        'when trying to detach an address from a citizen that has no address in the passed object then an exception is thrown',
        () async {
      var alice = citizens.first;

      try {
        await Citizen.db.detachRow.address(session, alice);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect((e as ArgumentError).name, 'citizen.address');
      }
    });
  });
}
