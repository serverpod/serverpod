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
      name: 'Alex', companyId: serverpod.id!, oldCompanyId: systemair.id!);
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
  var addressDeletions = await AddressUuid.db
      .deleteWhere(session, where: (_) => Constant.bool(true));
  var citizenDeletions = await CitizenInt.db
      .deleteWhere(session, where: (_) => Constant.bool(true));
  var companyDeletions = await CompanyUuid.db
      .deleteWhere(session, where: (_) => Constant.bool(true));
  var townDeletions =
      await TownInt.db.deleteWhere(session, where: (_) => Constant.bool(true));

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
      var citizens = await CitizenInt.db.find(
        session,
        where: (t) => t.company.name.equals('Serverpod'),
      );
      var citizenNames = citizens.map((e) => e.name);
      expect(citizenNames, unorderedEquals(['Alex', 'Isak']));
    });
  });

  group(
      'Given models with nested relations when filtering on nested relation attributes',
      () {
    late List<CitizenInt> citizensWithCompanyTownStockholm;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensWithCompanyTownStockholm = await CitizenInt.db.find(
        session,
        where: (t) => t.company.town.name.equals('Stockholm'),
      );
    });

    tearDownAll(() async => await deleteAll(session));

    test('then expected models are returned.', () {
      var citizenNames = citizensWithCompanyTownStockholm.map((e) => e.name);
      expect(citizenNames, unorderedEquals(['Alex', 'Isak', 'Theo', 'Haris']));
    });
  });
}
