import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod/server.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Session session) async {
  var ikeaEmployees = await Person.db.insert(session, [
    Person(name: 'Tom'),
    Person(name: 'John'),
    Person(name: 'Jane'),
  ]);

  var serverpodEmployees = await Person.db.insert(session, [
    Person(name: 'Alex'),
    Person(name: 'Isak'),
    Person(name: 'Viktor'),
  ]);

  var sanFransiscoCitizens = await Person.db.insert(session, [
    Person(name: 'Lisa'),
    Person(name: 'Marc'),
    Person(name: 'Annie'),
    Person(name: 'Wendy'),
  ]);

  var ikea = await Organization.db.insertRow(
    session,
    Organization(name: 'Ikea'),
  );

  await Organization.db.attach.people(session, ikea, ikeaEmployees);

  var serverpod = await Organization.db.insertRow(
    session,
    Organization(name: 'Serverpod'),
  );

  await Organization.db.attach.people(session, serverpod, serverpodEmployees);

  var google = await Organization.db.insertRow(
    session,
    Organization(name: 'Google'),
  );

  await Organization.db.attach.people(session, serverpod, sanFransiscoCitizens);

  var apple = await Organization.db.insertRow(
    session,
    Organization(name: 'Apple'),
  );

  var stockholm = await City.db.insertRow(
    session,
    City(name: 'Stockholm'),
  );
  await City.db.attach.citizens(
    session,
    stockholm,
    [
      serverpodEmployees[0],
      serverpodEmployees[2],
      ikeaEmployees[0],
      ikeaEmployees[2],
    ],
  );

  await City.db.attach.organizations(session, stockholm, [serverpod]);

  var almhult = await City.db.insertRow(
    session,
    City(name: 'Älmhult'),
  );

  await City.db.attach.citizens(
    session,
    almhult,
    [
      serverpodEmployees[1],
      ikeaEmployees[1],
    ],
  );

  await City.db.attach.organizations(session, almhult, [ikea]);

  var sanFrancisco = await City.db.insertRow(
    session,
    City(name: 'San Francisco'),
  );

  await City.db.attach.citizens(
    session,
    sanFrancisco,
    [
      sanFransiscoCitizens[0],
      sanFransiscoCitizens[1],
      sanFransiscoCitizens[2],
      sanFransiscoCitizens[3],
    ],
  );
  await City.db.attach.organizations(session, sanFrancisco, [google, apple]);
}

Future<void> _clearTestDatabase(Session session) async {
  await Person.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
  await Organization.db
      .deleteWhere(session, where: (_) => db.Constant.bool(true));
  await City.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _clearTestDatabase(session));

  group('Given ordered find query', () {
    test(
        'when ordering on filtered count of nested many relation then result order is as expected.',
        () async {
      var persons = await Person.db.find(
        session,
        // Order people by number of people in their organization ascending
        // and then their name.
        orderByList: [
          db.Order(
            column: Person.t.organization.people.count(),
            orderDescending: false,
          ),
          db.Order(
            column: Person.t.name,
          )
        ],
      );

      var personNames = persons.map((e) => e.name);
      expect(personNames, [
        'Jane',
        'John',
        'Tom',
        'Alex',
        'Annie',
        'Isak',
        'Lisa',
        'Marc',
        'Viktor',
        'Wendy'
      ]);
    });

    test(
        'when ordering on filtered count of nested many relation then result order is as expected.',
        () async {
      var persons = await Person.db.find(
        session,
        // Order people by number of people in their organization with a name
        // starting with 'a' and then their name.
        orderByList: [
          db.Order(
            column:
                Person.t.organization.people.count((p) => p.name.ilike('a%')),
            orderDescending: true,
          ),
          db.Order(
            column: Person.t.name,
          )
        ],
      );

      var personNames = persons.map((e) => e.name);
      expect(personNames, [
        'Alex',
        'Annie',
        'Isak',
        'Lisa',
        'Marc',
        'Viktor',
        'Wendy',
        'Jane',
        'John',
        'Tom'
      ]);
    });

    test(
        'when ordering on multiple many relations then result order is as expected.',
        () async {
      var cities = await City.db.find(
        session,
        // Order cities by number of citizens and then the number of organizations
        orderByList: [
          db.Order(
            column: City.t.citizens.count(),
            orderDescending: true,
          ),
          db.Order(
            column: City.t.organizations.count(),
            orderDescending: true,
          )
        ],
      );

      var cityNames = cities.map((e) => e.name);
      expect(cityNames, ['San Francisco', 'Stockholm', 'Älmhult']);
    });
  });
}
