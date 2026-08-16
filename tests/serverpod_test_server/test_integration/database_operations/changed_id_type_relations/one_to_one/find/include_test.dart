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
      'when fetching models including relation then result includes relation data.',
      () async {
        var towns = await TownInt.db.insert(session, [
          TownInt(name: 'Stockholm'),
          TownInt(name: 'San Francisco'),
        ]);
        await CompanyUuid.db.insert(session, [
          CompanyUuid(name: 'Serverpod', townId: towns[0].id!),
          CompanyUuid(name: 'Apple', townId: towns[1].id!),
        ]);

        var companiesFetched = await CompanyUuid.db.find(
          session,
          include: CompanyUuid.include(town: TownInt.include()),
          orderBy: (t) => t.name,
        );

        var companyNames = companiesFetched.map((c) => c.name);
        expect(companyNames, containsAll(['Serverpod', 'Apple']));
        var companyTownNames = companiesFetched.map((c) => c.town?.name);
        expect(companyTownNames, containsAll(['Stockholm', 'San Francisco']));
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
      'when fetching models including nested relation then result includes nested relation data.',
      () async {
        var towns = await TownInt.db.insert(session, [
          TownInt(name: 'Stockholm'),
          TownInt(name: 'San Francisco'),
        ]);
        var companies = await CompanyUuid.db.insert(session, [
          CompanyUuid(name: 'Serverpod', townId: towns[0].id!),
          CompanyUuid(name: 'Apple', townId: towns[1].id!),
        ]);
        await CitizenInt.db.insert(session, [
          CitizenInt(name: 'Alex', companyId: companies[0].id!),
          CitizenInt(name: 'Lina', companyId: companies[1].id!),
        ]);

        var citizensFetched = await CitizenInt.db.find(
          session,
          include: CitizenInt.include(
            company: CompanyUuid.include(town: TownInt.include()),
          ),
          orderBy: (t) => t.name,
        );

        var citizenNames = citizensFetched.map((c) => c.name);
        expect(citizenNames, ['Alex', 'Lina']);
        var citizenCompanyNames = citizensFetched.map((c) => c.company?.name);
        expect(citizenCompanyNames, ['Serverpod', 'Apple']);
        var citizenCompanyTownNames = citizensFetched.map(
          (c) => c.company?.town?.name,
        );
        expect(citizenCompanyTownNames, ['Stockholm', 'San Francisco']);
      },
    );
  });

  group(
    'Given models with nested relations when fetching citizens with deep includes.',
    () {
      late List<CitizenInt> citizensWithDeepIncludes;
      setUpAll(() async {
        await _createTestDatabase(session);
        citizensWithDeepIncludes = await CitizenInt.db.find(
          session,
          orderBy: (t) => t.id,
          include: CitizenInt.include(
            company: CompanyUuid.include(town: TownInt.include()),
            oldCompany: CompanyUuid.include(town: TownInt.include()),
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
          expect(
            citizensWithDeepIncludes[0].oldCompany?.town?.name,
            'Skinnskatteberg',
          );
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
    },
  );

  group(
    'Given models with nested relations when fetching all citizens without includes',
    () {
      late List<CitizenInt> citizensWithoutIncludes;
      setUpAll(() async {
        await _createTestDatabase(session);
        citizensWithoutIncludes = await CitizenInt.db.find(
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
    },
  );

  group(
    'Given models with nested relations when fetching all citizens with shallow includes',
    () {
      late List<CitizenInt> citizensWithShallowIncludes;
      setUpAll(() async {
        await _createTestDatabase(session);
        citizensWithShallowIncludes = await CitizenInt.db.find(
          session,
          orderBy: (t) => t.id,
          include: CitizenInt.include(
            company: CompanyUuid.include(),
            oldCompany: CompanyUuid.include(),
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
    },
  );

  group('Given models with relations when finding by id with includes', () {
    late List<CitizenInt>? allCitizens;
    setUpAll(() async {
      await _createTestDatabase(session);
      allCitizens = await CitizenInt.db.find(session, orderBy: (t) => t.id);
    });

    tearDownAll(() async => await deleteAll(session));

    test('then retrieved citizen is same as expected.', () async {
      assert(allCitizens != null && allCitizens!.length > 1);
      var secondCitizen = allCitizens![1];

      var citizenById = await CitizenInt.db.findById(
        session,
        secondCitizen.id!,
        include: CitizenInt.include(company: CompanyUuid.include()),
      );

      expect(citizenById, isNotNull);
      expect(citizenById!.id, secondCitizen.id);
      expect(citizenById.name, secondCitizen.name);
      expect(citizenById.companyId, secondCitizen.companyId);
    });
  });

  group(
    'Given models with a named relation when fetching from the none origin side',
    () {
      late List<CitizenInt> citizensIncludingAddress;
      setUpAll(() async {
        await _createTestDatabase(session);
        citizensIncludingAddress = await CitizenInt.db.find(
          session,
          orderBy: (t) => t.id,
          include: CitizenInt.include(
            address: AddressUuid.include(),
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
    },
  );

  group(
    'Given models with a named relation when fetching from the foreign key origin side',
    () {
      late List<AddressUuid> addresses;
      setUpAll(() async {
        await _createTestDatabase(session);
        addresses = await AddressUuid.db.find(
          session,
          orderBy: (t) => t.id,
          include: AddressUuid.include(
            inhabitant: CitizenInt.include(),
          ),
        );
      });

      tearDownAll(() async => await deleteAll(session));

      test('then the addresses is not empty', () {
        expect(addresses, isNotEmpty);
      });

      test('then the addresses contains alex and isak', () async {
        var inhabitantsNames = addresses.map((e) => e.inhabitant?.name);
        expect(inhabitantsNames, contains('Alex'));
        expect(inhabitantsNames, contains('Isak'));
      });
    },
  );

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
