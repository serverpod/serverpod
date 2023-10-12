import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod/server.dart';
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

  group('Given ordered find query', () {
    test(
        'when ordering on filtered count of nested many relation then result is as expected.',
        () async {
      var customers = await Person.db.find(
        session,
        // Order people by number of people in their organization with a name
        // starting with 'a' and then their name in descending order.
        orderByList: [
          db.Order(
            column:
                Person.t.organization.people.count((p) => p.name.ilike('a%')),
            orderDescending: true,
          ),
          db.Order(
            column: Person.t.name,
            orderDescending: true,
          )
        ],
      );

      var customerNames = customers.map((e) => e.name);
      expect(customerNames, ['Viktor', 'Isak', 'Alex', 'Tom', 'John', 'Jane']);
    });
  });
}
