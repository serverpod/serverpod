import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group(
      'Given entities with one to many relation nested in a one to one relation',
      () {
    tearDown(() async {
      await Person.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Organization.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching entities filtered on count of nested many relation then result is as expected.',
        () async {
      var people = await Person.db.insert(session, [
        Person(name: 'Tom'),
        Person(name: 'John'),
        Person(name: 'Jane'),
        Person(name: 'Viktor'),
        Person(name: 'Isak'),
        Person(name: 'Alex'),
        Person(name: 'Lisa'),
      ]);
      var organizations = await Organization.db.insert(session, [
        Organization(name: 'Ikea'),
        Organization(name: 'Google'),
        Organization(name: 'Serverpod'),
      ]);
      // Attach Tom, Jane and John to Ikea
      await Organization.db.attach
          .people(session, organizations[0], people.sublist(0, 3));
      // Attach Viktor to Google
      await Organization.db.attachRow
          .people(session, organizations[1], people[3]);
      // Attach Isak and Alex to Serverpod
      await Organization.db.attach
          .people(session, organizations[2], people.sublist(4, 6));

      var peopleFetched = await Person.db.find(
        session,
        // Find people connected to an organizations with more than one person
        where: (p) => p.organization.people.count() > 1,
      );

      var customerNames = peopleFetched.map((e) => e.name);
      expect(customerNames, hasLength(5));
      expect(
          customerNames,
          containsAll([
            'Tom',
            'John',
            'Jane',
            'Isak',
            'Alex',
          ]));
    });

    test(
        'when fetching entities filtered on filtered nested many relation count then result is as expected.',
        () async {
      var people = await Person.db.insert(session, [
        Person(name: 'Tom'),
        Person(name: 'John'),
        Person(name: 'Jane'),
        Person(name: 'Viktor'),
        Person(name: 'Isak'),
        Person(name: 'Alex'),
        Person(name: 'Lisa'),
      ]);
      var organizations = await Organization.db.insert(session, [
        Organization(name: 'Ikea'),
        Organization(name: 'Google'),
        Organization(name: 'Serverpod'),
      ]);
      // Attach Tom, Jane and John to Ikea
      await Organization.db.attach
          .people(session, organizations[0], people.sublist(0, 3));
      // Attach Viktor to Google
      await Organization.db.attachRow
          .people(session, organizations[1], people[3]);
      // Attach Isak and Alex to Serverpod
      await Organization.db.attach
          .people(session, organizations[2], people.sublist(4, 6));

      var peopleFetched = await Person.db.find(
        session,
        // Find people where more than one person with a name starting with 'j'
        // in their organization.
        where: (p) =>
            p.organization.people.count((p) => p.name.ilike('j%')) > 1,
      );

      var customerNames = peopleFetched.map((e) => e.name);
      expect(customerNames, hasLength(3));
      expect(customerNames, containsAll(['Tom', 'John', 'Jane']));
    });
  });
}
