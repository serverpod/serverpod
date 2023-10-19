import 'package:serverpod/server.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Session session) async {
  var otherEmployees = await Person.db.insert(session, [
    Person(name: 'Tom'),
    Person(name: 'John'),
    Person(name: 'Jane'),
  ]);

  var otherOrganization = await Organization.db.insertRow(
    session,
    Organization(name: 'Other'),
  );

  await Organization.db.attach
      .people(session, otherOrganization, otherEmployees);

  var serverpodEmployees = await Person.db.insert(session, [
    Person(name: 'Alex'),
    Person(name: 'Isak'),
    Person(name: 'Viktor'),
    Person(name: 'Jennie'),
  ]);

  var serverpod = await Organization.db.insertRow(
    session,
    Organization(name: 'Serverpod'),
  );

  await Organization.db.attach.people(session, serverpod, serverpodEmployees);
}

Future<void> _clearTestDatabase(Session session) async {
  await Person.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
  await Organization.db
      .deleteWhere(session, where: (_) => db.Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _clearTestDatabase(session));

  group('Given find query', () {
    test(
        'when filtering on count of nested many relation then result is as expected.',
        () async {
      var customers = await Person.db.find(
        session,
        // Find people where more than 3 people in their organization
        where: (p) => p.organization.people.count() > 3,
      );

      var customerNames = customers.map((e) => e.name);
      expect(customerNames, hasLength(4));
      expect(
          customerNames,
          containsAll([
            'Alex',
            'Isak',
            'Viktor',
            'Jennie',
          ]));
    });

    test(
        'when filtering on count of filtered nested many relation then result is as expected.',
        () async {
      var customers = await Person.db.find(
        session,
        // Find people where more than one person with a name starting with 'j'
        // in their organization.
        where: (p) =>
            p.organization.people.count((p) => p.name.ilike('j%')) > 1,
      );

      var customerNames = customers.map((e) => e.name);
      expect(customerNames, hasLength(3));
      expect(customerNames, containsAll(['Tom', 'John', 'Jane']));
    });
  });
}
