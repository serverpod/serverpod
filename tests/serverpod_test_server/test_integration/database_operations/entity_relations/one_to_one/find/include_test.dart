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
        'when fetching models including relation then result includes relation data.',
        () async {
      var towns = await Town.db.insert(session, [
        Town(name: 'Stockholm'),
        Town(name: 'San Francisco'),
      ]);
      await Company.db.insert(session, [
        Company(name: 'Serverpod', townId: towns[0].id!),
        Company(name: 'Apple', townId: towns[1].id!),
      ]);

      var companiesFetched = await Company.db.find(
        session,
        include: Company.include(town: Town.include()),
        orderBy: (t) => t.name,
      );

      var companyNames = companiesFetched.map((c) => c.name);
      expect(companyNames, containsAll(['Serverpod', 'Apple']));
      var companyTownNames = companiesFetched.map((c) => c.town?.name);
      expect(companyTownNames, containsAll(['Stockholm', 'San Francisco']));
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
        'when fetching models including nested relation then result includes nested relation data.',
        () async {
      var towns = await Town.db.insert(session, [
        Town(name: 'Stockholm'),
        Town(name: 'San Francisco'),
      ]);
      var companies = await Company.db.insert(session, [
        Company(name: 'Serverpod', townId: towns[0].id!),
        Company(name: 'Apple', townId: towns[1].id!),
      ]);
      await Citizen.db.insert(session, [
        Citizen(name: 'Alex', companyId: companies[0].id!),
        Citizen(name: 'Lina', companyId: companies[1].id!),
      ]);

      var citizensFetched = await Citizen.db.find(
        session,
        include:
            Citizen.include(company: Company.include(town: Town.include())),
        orderBy: (t) => t.name,
      );

      var citizenNames = citizensFetched.map((c) => c.name);
      expect(citizenNames, ['Alex', 'Lina']);
      var citizenCompanyNames = citizensFetched.map((c) => c.company?.name);
      expect(citizenCompanyNames, ['Serverpod', 'Apple']);
      var citizenCompanyTownNames =
          citizensFetched.map((c) => c.company?.town?.name);
      expect(citizenCompanyTownNames, ['Stockholm', 'San Francisco']);
    });
  });

  group(
      'Given models with nested relations when fetching citizens with deep includes.',
      () {
    late List<Citizen> citizensWithDeepIncludes;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensWithDeepIncludes = await Citizen.db.find(
        session,
        orderBy: (t) => t.id,
        include: Citizen.include(
          company: Company.include(town: Town.include()),
          oldCompany: Company.include(town: Town.include()),
        ),
      );
    });

    tearDownAll(() async => await deleteAll(session));

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
      'Given models with nested relations when fetching all citizens without includes',
      () {
    late List<Citizen> citizensWithoutIncludes;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensWithoutIncludes = await Citizen.db.find(
        session,
        orderBy: (t) => t.id,
      );
    });

    tearDownAll(() async => await deleteAll(session));

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
      'Given models with nested relations when fetching all citizens with shallow includes',
      () {
    late List<Citizen> citizensWithShallowIncludes;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensWithShallowIncludes = await Citizen.db.find(
        session,
        orderBy: (t) => t.id,
        include: Citizen.include(
          company: Company.include(),
          oldCompany: Company.include(),
        ),
      );
    });

    tearDownAll(() async => await deleteAll(session));

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

  group('Given models with relations when finding by id with includes', () {
    late List<Citizen>? allCitizens;
    setUpAll(() async {
      await _createTestDatabase(session);
      allCitizens = await Citizen.db.find(session, orderBy: (t) => t.id);
    });

    tearDownAll(() async => await deleteAll(session));

    test('then retrieved citizen is same as expected.', () async {
      assert(allCitizens != null && allCitizens!.length > 1);
      var secondCitizen = allCitizens![1];

      var citizenById = await Citizen.db.findById(session, secondCitizen.id!,
          include: Citizen.include(company: Company.include()));

      expect(citizenById, isNotNull);
      expect(citizenById!.id, secondCitizen.id);
      expect(citizenById.name, secondCitizen.name);
      expect(citizenById.companyId, secondCitizen.companyId);
    });
  });

  group(
      'Given models with a named relation when fetching from the none origin side',
      () {
    late List<Citizen> citizensIncludingAddress;
    setUpAll(() async {
      await _createTestDatabase(session);
      citizensIncludingAddress = await Citizen.db.find(
        session,
        orderBy: (t) => t.id,
        include: Citizen.include(
          address: Address.include(),
        ),
      );
    });

    tearDownAll(() async => await deleteAll(session));

    test('then the citizenWithAddress is not empty', () {
      expect(citizensIncludingAddress, isNotEmpty);
    });

    test('then alex citizen has an address object returned', () async {
      expect(citizensIncludingAddress.first.address, isNotNull);
    });

    test('then isak citizen has an address object returned', () async {
      expect(citizensIncludingAddress[1].address, isNotNull);
    });

    test('then lina citizen has no address object returned', () async {
      expect(citizensIncludingAddress[2].address, isNull);
    });
  });

  group(
      'Given models with a named relation when fetching from the foreign key origin side',
      () {
    late List<Address> addresses;
    setUpAll(() async {
      await _createTestDatabase(session);
      addresses = await Address.db.find(
        session,
        orderBy: (t) => t.id,
        include: Address.include(
          inhabitant: Citizen.include(),
        ),
      );
    });

    tearDownAll(() async => await deleteAll(session));

    test('then the addresses is not empty', () {
      expect(addresses, isNotEmpty);
    });

    test('then the first address is linked with alex', () async {
      expect(addresses.first.inhabitant?.name, 'Alex');
    });

    test('then the second address is linked with isak', () async {
      expect(addresses[1].inhabitant?.name, 'Isak');
    });
  });

  group('Given models with a named self relation', () {
    late List<Post> posts;
    setUpAll(() async {
      await _createTestDatabase(session);
      posts = await Post.db.find(
        session,
        include: Post.include(
          previous: Post.include(),
          next: Post.include(),
        ),
      );
    });

    tearDownAll(() async => await deleteAll(session));

    test('then the posts is not empty', () {
      expect(posts, isNotEmpty);
    });

    test('then the first post has a reference to the next post', () {
      var firstPost = posts[2];
      expect(firstPost.next?.content, posts[1].content);
    });

    test('then the first post has a null reference to the previous post', () {
      var firstPost = posts[2];
      expect(firstPost.previous, isNull);
    });

    test('then the second post has a reference to the next post', () {
      var secondPost = posts[1];
      expect(secondPost.next?.content, posts[0].content);
    });

    test('then the second post has a reference to the previous post', () {
      var secondPost = posts[1];
      expect(secondPost.previous?.content, posts[2].content);
    });

    test('then the third post has a null reference to the next post', () {
      var thirdPost = posts[0];
      expect(thirdPost.next, isNull);
    });

    test('then the third post has a reference to the previous post', () {
      var thirdPost = posts[0];
      expect(thirdPost.previous?.content, posts[1].content);
    });
  });
}
