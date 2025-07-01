import 'package:serverpod/database.dart' as db;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Session session) async {
  // Towns
  var stockholm = Town(name: 'Stockholm');
  var skinnskatteberg = Town(name: 'Skinnskatteberg');
  stockholm = await Town.db.insertRow(session, stockholm);
  skinnskatteberg = await Town.db.insertRow(session, skinnskatteberg);

  // Companies
  var serverpod = Company(name: 'Serverpod', townId: stockholm.id!);
  var systemair = Company(name: 'Systemair', townId: skinnskatteberg.id!);
  var pantor = Company(name: 'Pantor', townId: stockholm.id!);
  serverpod = await Company.db.insertRow(session, serverpod);
  systemair = await Company.db.insertRow(session, systemair);
  pantor = await Company.db.insertRow(session, pantor);

  // Citizens
  var alex = Citizen(
      name: 'Alex', companyId: serverpod.id!, oldCompanyId: systemair.id!);
  var isak = Citizen(name: 'Isak', companyId: serverpod.id!);
  var lina = Citizen(name: 'Lina', companyId: systemair.id!);
  var joanna = Citizen(name: 'Joanna', companyId: systemair.id!);
  var theo = Citizen(name: 'Theo', companyId: pantor.id!);
  var haris = Citizen(name: 'Haris', companyId: pantor.id!);
  alex = await Citizen.db.insertRow(session, alex);
  isak = await Citizen.db.insertRow(session, isak);
  lina = await Citizen.db.insertRow(session, lina);
  joanna = await Citizen.db.insertRow(session, joanna);
  theo = await Citizen.db.insertRow(session, theo);
  haris = await Citizen.db.insertRow(session, haris);

  // Addresses
  var alexAddress = Address(street: 'Götgatan 3', inhabitantId: alex.id!);
  var isakAddress = Address(street: 'Kungsgatan 4', inhabitantId: isak.id!);

  await Address.db.insertRow(session, alexAddress);
  await Address.db.insertRow(session, isakAddress);

  var post3 = Post(content: 'third post');
  post3 = await Post.db.insertRow(session, post3);
  var post2 = Post(content: 'second post', nextId: post3.id!);
  post2 = await Post.db.insertRow(session, post2);
  var post1 = Post(content: 'first post', nextId: post2.id!);
  post1 = await Post.db.insertRow(session, post1);
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

  group('Given models with one to one relation', () {
    tearDown(() async {
      await Company.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Town.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching models ordered by relation attributes then result is as expected.',
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

  group('Given models with nested one to one relations', () {
    tearDown(() async {
      await Citizen.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Company.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Town.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching models ordered by nested relation attributes then result is as expected.',
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

  group('Given models with relations when ordering on relation attributes', () {
    late List<Citizen> citizensOrderedByCompanyName;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensOrderedByCompanyName = await Citizen.db.find(
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
    late List<Citizen> citizensOrderedByCompanyTownName;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensOrderedByCompanyTownName = await Citizen.db.find(
        session,
        orderBy: (t) => t.company.town.name,
      );
    });

    tearDownAll(() async => await deleteAll(session));

    test('then models returned are in expected order.', () {
      var citizenNames = citizensOrderedByCompanyTownName.map((e) => e.name);
      expect(citizenNames, ['Lina', 'Joanna', 'Alex', 'Isak', 'Theo', 'Haris']);
    });
  });
}
