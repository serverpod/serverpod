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

  group('Given models with relations when filtering on relation attributes',
      () {
    setUpAll(() async {
      await _createTestDatabase(session);
    });

    tearDownAll(() async => await deleteAll(session));

    test('then expected models are returned.', () async {
      var citizens = await Citizen.db.find(
        session,
        where: (t) => t.company.name.equals('Serverpod'),
      );
      var citizenNames = citizens.map((e) => e.name);
      expect(citizenNames, ['Alex', 'Isak']);
    });
  });

  group(
      'Given models with nested relations when filtering on nested relation attributes',
      () {
    late List<Citizen> citizensWithCompanyTownStockholm;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensWithCompanyTownStockholm = await Citizen.db.find(
        session,
        where: (t) => t.company.town.name.equals('Stockholm'),
      );
    });

    tearDownAll(() async => await deleteAll(session));

    test('then expected models are returned.', () {
      var citizenNames = citizensWithCompanyTownStockholm.map((e) => e.name);
      expect(citizenNames, ['Alex', 'Isak', 'Theo', 'Haris']);
    });
  });
}
