import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given entities with multiple one to many relations', () {
    tearDown(() async {
      await Person.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Organization.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await City.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });
    test(
        'when fetching entities ordered on multiple separate one to many relations then result order is as expected.',
        () async {
      var cities = await City.db.insert(session, [
        City(name: 'Stockholm'),
        City(name: 'San Francisco'),
        City(name: 'London'),
      ]);

      var people = await Person.db.insert(session, [
        Person(name: 'Tom'),
        Person(name: 'John'),
        Person(name: 'Jane'),
        Person(name: 'Viktor'),
        Person(name: 'Isak'),
        Person(name: 'Alex'),
      ]);
      // Attach Tom, Jane and John to San Fransisco
      await City.db.attach.citizens(session, cities[1], people.sublist(0, 3));
      // Attach Viktor, Isak and Alex to Stockholm
      await City.db.attach.citizens(session, cities[0], people.sublist(3, 6));

      var organizations = await Organization.db.insert(session, [
        Organization(name: 'Apple'),
        Organization(name: 'Google'),
        Organization(name: 'Serverpod'),
        Organization(name: 'Barclays'),
        Organization(name: 'BBC'),
      ]);

      // Attach Serverpod to Stockholm
      await City.db.attachRow
          .organizations(session, cities[0], organizations[2]);
      // Attach Apple and Google to San Fransisco
      await City.db.attach
          .organizations(session, cities[1], organizations.sublist(0, 2));
      // Attach Barclays and BBC to London
      await City.db.attach
          .organizations(session, cities[2], organizations.sublist(3, 5));

      var citiesFetched = await City.db.find(
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

      var cityNames = citiesFetched.map((e) => e.name);
      expect(cityNames, ['San Francisco', 'Stockholm', 'London']);
    });
  });
}
