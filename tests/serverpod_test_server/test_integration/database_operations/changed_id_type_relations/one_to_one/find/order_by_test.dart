import 'package:serverpod/database.dart' as db;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Session session) async {
  // Towns
  var stockholm = TownInt(name: 'Stockholm');
  var skinnskatteberg = TownInt(name: 'Skinnskatteberg');
  stockholm = await TownInt.db.insertRow(session, stockholm);
  skinnskatteberg = await TownInt.db.insertRow(session, skinnskatteberg);

  // Companies
  var serverpod = CompanyUuid(name: 'Serverpod', townId: stockholm.id!);
  var systemair = CompanyUuid(name: 'Systemair', townId: skinnskatteberg.id!);
  var pantor = CompanyUuid(name: 'Pantor', townId: stockholm.id!);
  serverpod = await CompanyUuid.db.insertRow(session, serverpod);
  systemair = await CompanyUuid.db.insertRow(session, systemair);
  pantor = await CompanyUuid.db.insertRow(session, pantor);

  // Citizens
  var alex = CitizenInt(
    name: 'Alex',
    companyId: serverpod.id!,
    oldCompanyId: systemair.id!,
  );
  var isak = CitizenInt(name: 'Isak', companyId: serverpod.id!);
  var lina = CitizenInt(name: 'Lina', companyId: systemair.id!);
  var joanna = CitizenInt(name: 'Joanna', companyId: systemair.id!);
  var theo = CitizenInt(name: 'Theo', companyId: pantor.id!);
  var haris = CitizenInt(name: 'Haris', companyId: pantor.id!);
  alex = await CitizenInt.db.insertRow(session, alex);
  isak = await CitizenInt.db.insertRow(session, isak);
  lina = await CitizenInt.db.insertRow(session, lina);
  joanna = await CitizenInt.db.insertRow(session, joanna);
  theo = await CitizenInt.db.insertRow(session, theo);
  haris = await CitizenInt.db.insertRow(session, haris);

  // Addresses
  var alexAddress = AddressUuid(street: 'Götgatan 3', inhabitantId: alex.id!);
  var isakAddress = AddressUuid(street: 'Kungsgatan 4', inhabitantId: isak.id!);

  await AddressUuid.db.insertRow(session, alexAddress);
  await AddressUuid.db.insertRow(session, isakAddress);

  var post3 = Post(content: 'third post');
  post3 = await Post.db.insertRow(session, post3);
  var post2 = Post(content: 'second post', nextId: post3.id!);
  post2 = await Post.db.insertRow(session, post2);
  var post1 = Post(content: 'first post', nextId: post2.id!);
  post1 = await Post.db.insertRow(session, post1);
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

  group('Given models with one to one relation', () {
    tearDown(() async {
      await CompanyUuid.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
      await TownInt.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
    });

    test(
      'when fetching models ordered by relation attributes then result is as expected.',
      () async {
        var towns = await TownInt.db.insert(session, [
          TownInt(name: 'Stockholm'),
          TownInt(name: 'San Francisco'),
        ]);
        await CompanyUuid.db.insert(session, [
          CompanyUuid(name: 'Serverpod', townId: towns[0].id!),
          CompanyUuid(name: 'Apple', townId: towns[1].id!),
          CompanyUuid(name: 'Google', townId: towns[1].id!),
        ]);

        var companiesFetched = await CompanyUuid.db.find(
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
      },
    );
  });

  group('Given models with nested one to one relations', () {
    tearDown(() async {
      await CitizenInt.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
      await CompanyUuid.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
      await TownInt.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
    });

    test(
      'when fetching models ordered by nested relation attributes then result is as expected.',
      () async {
        var towns = await TownInt.db.insert(session, [
          TownInt(name: 'Stockholm'),
          TownInt(name: 'San Francisco'),
          TownInt(name: 'Tokyo'),
        ]);
        var companies = await CompanyUuid.db.insert(session, [
          CompanyUuid(name: 'Serverpod', townId: towns[0].id!),
          CompanyUuid(name: 'Apple', townId: towns[1].id!),
          CompanyUuid(name: 'Honda', townId: towns[2].id!),
        ]);
        await CitizenInt.db.insert(session, [
          CitizenInt(name: 'Alex', companyId: companies[0].id!),
          CitizenInt(name: 'Isak', companyId: companies[0].id!),
          CitizenInt(name: 'Lina', companyId: companies[1].id!),
          CitizenInt(name: 'Marc', companyId: companies[1].id!),
          CitizenInt(name: 'Yuko', companyId: companies[2].id!),
        ]);

        var citizens = await CitizenInt.db.find(
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
      },
    );
  });

  group('Given models with relations when ordering on relation attributes', () {
    late List<CitizenInt> citizensOrderedByCompanyName;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensOrderedByCompanyName = await CitizenInt.db.find(
        session,
        orderBy: (t) => t.company.name,
      );
    });

    tearDownAll(() async => await deleteAll(session));

    test('then models returned are in expected order.', () {
      var citizenNames = citizensOrderedByCompanyName.map((e) => e.name);
      expect(citizenNames, ['Theo', 'Haris', 'Alex', 'Isak', 'Lina', 'Joanna']);
    });
  });

  group(
    'Given models with relations when ordering on nested relation attributes',
    () {
      late List<CitizenInt> citizensOrderedByCompanyTownName;
      setUpAll(() async {
        await _createTestDatabase(session);
        citizensOrderedByCompanyTownName = await CitizenInt.db.find(
          session,
          orderBy: (t) => t.company.town.name,
        );
      });

      tearDownAll(() async => await deleteAll(session));

      test('then models returned are in expected order.', () {
        var citizenNames = citizensOrderedByCompanyTownName
            .map((e) => e.name)
            .toList();

        expect(citizenNames, hasLength(6));
        expect(
          citizenNames.take(2),
          // both at Systemair in Skinnskatteberg
          unorderedEquals([
            'Lina',
            'Joanna',
          ]),
        );
        expect(
          citizenNames.skip(2),
          // all at Serverpod or Pantor in Stockholm
          unorderedEquals(['Alex', 'Isak', 'Haris', 'Theo']),
        );
      });
    },
  );
}
