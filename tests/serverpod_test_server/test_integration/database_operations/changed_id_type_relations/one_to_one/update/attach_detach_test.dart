import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Session session) async {
  var town = TownInt(name: 'Stockholm');
  town = await TownInt.db.insertRow(session, town);

  var serverpod = CompanyUuid(name: 'Serverpod', town: town, townId: town.id!);
  serverpod = await CompanyUuid.db.insertRow(session, serverpod);

  var pods = CompanyUuid(name: 'The pod', town: town, townId: town.id!);
  pods = await CompanyUuid.db.insertRow(session, pods);

  var alice = CitizenInt(name: 'Alice', companyId: serverpod.id!);
  var bob = CitizenInt(name: 'Bob', companyId: serverpod.id!);
  alice = await CitizenInt.db.insertRow(session, alice);
  bob = await CitizenInt.db.insertRow(session, bob);

  var address = AddressUuid(street: 'Street', inhabitantId: bob.id);
  address = await AddressUuid.db.insertRow(session, address);
}

Future<int> deleteAll(Session session) async {
  var addressDeletions = await AddressUuid.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
  var citizenDeletions = await CitizenInt.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
  var companyDeletions = await CompanyUuid.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
  var townDeletions = await TownInt.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );

  var postDeletions = await Post.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );

  return townDeletions.length +
      companyDeletions.length +
      citizenDeletions.length +
      addressDeletions.length +
      postDeletions.length;
}

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given an address', () {
    late List<CitizenInt> citizens;

    setUp(() async {
      await _createTestDatabase(session);
      citizens = await CitizenInt.db.find(session, orderBy: (t) => t.id);
    });

    tearDown(() async => await deleteAll(session));
    test(
      'when attaching an address from the foreign key side the object holding the foreign key is updated in the database',
      () async {
        var alice = citizens.first;
        var address = AddressUuid(street: 'Street');
        address = await AddressUuid.db.insertRow(session, address);

        await AddressUuid.db.attachRow.inhabitant(session, address, alice);

        var updatedAddress = await AddressUuid.db.findById(session, address.id);

        expect(updatedAddress?.inhabitantId, alice.id);
      },
    );

    test(
      'when detaching an address from the foreign key side the object holding the foreign key has the foreign key set to null.',
      () async {
        var addresses = await AddressUuid.db.find(
          session,
          orderBy: (t) => t.id,
        );
        var address = addresses.first;

        await AddressUuid.db.detachRow.inhabitant(session, address);

        var updatedAddress = await AddressUuid.db.findById(session, address.id);

        expect(updatedAddress?.inhabitantId, null);
      },
    );

    test(
      'when attaching an address with modified values only the foreign key field is modified.',
      () async {
        var alice = citizens.first;
        var address = AddressUuid(street: 'Street');
        address = await AddressUuid.db.insertRow(session, address);

        var copy = address.copyWith(street: 'New street');

        AddressUuid.db.attachRow.inhabitant(session, copy, alice);

        var updatedAddress = await AddressUuid.db.findById(session, address.id);

        expect(updatedAddress?.street, 'Street');
      },
    );

    test(
      'when trying to attach a citizen to an address that is not stored in the database then an exception is thrown',
      () async {
        var alice = citizens.first;
        var address = AddressUuid(street: 'Street');

        try {
          await AddressUuid.db.attachRow.inhabitant(session, address, alice);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, isA<DatabaseUpdateRowException>());
        }
      },
    );

    test(
      'when trying to attach a citizen that is not stored in the db to an address then an exception is thrown',
      () async {
        var carol = CitizenInt(name: 'Carol', companyId: Uuid().v4obj());
        var address = AddressUuid(street: 'Street');
        address = await AddressUuid.db.insertRow(session, address);

        try {
          await AddressUuid.db.attachRow.inhabitant(session, address, carol);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, isA<ArgumentError>());
          expect((e as ArgumentError).name, 'inhabitant.id');
        }
      },
    );

    test(
      'when trying to detach a citizen from an address that is not stored in the database then an exception is thrown',
      () async {
        var address = AddressUuid(street: 'Street');

        try {
          await AddressUuid.db.detachRow.inhabitant(session, address);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, isA<DatabaseUpdateRowException>());
        }
      },
    );
  });

  group('Given a citizen ', () {
    late List<CitizenInt> citizens;
    late List<CompanyUuid> companies;

    setUp(() async {
      await _createTestDatabase(session);
      citizens = await CitizenInt.db.find(session, orderBy: (t) => t.id);
      companies = await CompanyUuid.db.find(session, orderBy: (t) => t.id);
    });

    tearDown(() async => await deleteAll(session));

    test(
      'when attaching an address from the non foreign key side the object holding the foreign key is updated in the database',
      () async {
        var alice = citizens.first;
        var address = AddressUuid(street: 'Street');
        address = await AddressUuid.db.insertRow(session, address);

        await CitizenInt.db.attachRow.address(session, alice, address);

        var updatedAddress = await AddressUuid.db.findById(session, address.id);

        expect(updatedAddress?.inhabitantId, alice.id);
      },
    );

    test(
      'when detaching an address from the non foreign key side the object holding the foreign key has the foreign key set to null.',
      () async {
        var bob = citizens.last;

        var addresses = await AddressUuid.db.find(
          session,
          orderBy: (t) => t.id,
          include: AddressUuid.include(
            inhabitant: CitizenInt.include(),
          ),
        );
        var address = addresses.first;

        var bobCopy = bob.copyWith(address: address);

        await CitizenInt.db.detachRow.address(session, bobCopy);

        var updatedAddress = await AddressUuid.db.findById(session, address.id);

        expect(updatedAddress?.inhabitantId, null);
      },
    );

    test(
      'when inside a transaction and attaching an address from the non foreign key side the object holding the foreign key is updated in the database',
      () async {
        var alice = citizens.first;
        var address = AddressUuid(street: 'Street');
        address = await AddressUuid.db.insertRow(session, address);

        await session.db.transaction((transaction) async {
          await CitizenInt.db.attachRow.address(
            session,
            alice,
            address,
            transaction: transaction,
          );
        });
        var updatedAddress = await AddressUuid.db.findById(session, address.id);

        expect(updatedAddress?.inhabitantId, alice.id);
      },
    );

    test(
      'when inside a transaction and detaching an address from the non foreign key side the object holding the foreign key has the foreign key set to null.',
      () async {
        var bob = citizens.last;

        var addresses = await AddressUuid.db.find(
          session,
          orderBy: (t) => t.id,
          include: AddressUuid.include(
            inhabitant: CitizenInt.include(),
          ),
        );
        var address = addresses.first;

        var bobCopy = bob.copyWith(address: address);

        await session.db.transaction((transaction) async {
          await CitizenInt.db.detachRow.address(
            session,
            bobCopy,
            transaction: transaction,
          );
        });

        var updatedAddress = await AddressUuid.db.findById(session, address.id);

        expect(updatedAddress?.inhabitantId, null);
      },
    );

    test(
      'when attaching to an object that already have an entry then the new value is set in the database',
      () async {
        var citizen = citizens.first;
        var company = companies.last;

        await CitizenInt.db.attachRow.company(session, citizen, company);

        var alice = await CitizenInt.db.findById(
          session,
          citizen.id!,
          include: CitizenInt.include(company: CompanyUuid.include()),
        );

        expect(alice?.companyId, company.id);
      },
    );

    test(
      'when trying to attach a citizen to an address that is not stored in the database then an exception is thrown',
      () async {
        var alice = citizens.first;
        var address = AddressUuid(street: 'Street');

        try {
          await CitizenInt.db.attachRow.address(session, alice, address);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, isA<DatabaseUpdateRowException>());
        }
      },
    );

    test(
      'when trying to attach a citizen that is not stored in the db to an address then an exception is thrown',
      () async {
        var carol = CitizenInt(name: 'Carol', companyId: Uuid().v4obj());
        var address = AddressUuid(street: 'Street');
        address = await AddressUuid.db.insertRow(session, address);

        try {
          await CitizenInt.db.attachRow.address(session, carol, address);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, isA<ArgumentError>());
          expect((e as ArgumentError).name, 'citizenInt.id');
        }
      },
    );

    test(
      'when trying to detach an address from a citizen that is not stored in the database then an exception is thrown',
      () async {
        var address = AddressUuid(street: 'Street');
        address = await AddressUuid.db.insertRow(session, address);

        var carol = CitizenInt(
          name: 'Carol',
          companyId: Uuid().v4obj(),
          address: address,
        );

        try {
          await CitizenInt.db.detachRow.address(session, carol);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, isA<ArgumentError>());
          expect((e as ArgumentError).name, 'citizenInt.id');
        }
      },
    );

    test(
      'when trying to detach an address from a citizen that has no address in the passed object then an exception is thrown',
      () async {
        var alice = citizens.first;

        try {
          await CitizenInt.db.detachRow.address(session, alice);
          fail('Expected an exception to be thrown');
        } catch (e) {
          expect(e, isA<ArgumentError>());
          expect((e as ArgumentError).name, 'citizenInt.address');
        }
      },
    );
  });
}
