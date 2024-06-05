import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to many relation', () {
    tearDown(() async {
      await Order.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Customer.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching models ordered on count of many relation then result is as expected.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
      ]);

      await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        Order(description: 'Order 2', customerId: customers[0].id!),
        Order(description: 'Order 3', customerId: customers[0].id!),
        // Viktor orders
        Order(description: 'Order 4', customerId: customers[2].id!),
        Order(description: 'Order 5', customerId: customers[2].id!),
      ]);

      var fetchedCustomers = await Customer.db.find(
        session,
        // Order by number of orders in descending order
        orderBy: (t) => t.orders.count(),
        orderDescending: true,
      );

      var customerNames = fetchedCustomers.map((e) => e.name);
      expect(customerNames, ['Alex', 'Viktor', 'Isak']);
    });

    test(
        'when fetching models ordered on count of filtered many relation then result is as expected.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
      ]);

      await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Prem: Order 1', customerId: customers[0].id!),
        Order(description: 'Order 2', customerId: customers[0].id!),
        Order(description: 'Order 3', customerId: customers[0].id!),
        // Viktor orders
        Order(description: 'Prem: Order 4', customerId: customers[2].id!),
        Order(description: 'Prem: Order 5', customerId: customers[2].id!),
      ]);

      var fetchedCustomers = await Customer.db.find(
        session,
        // Order by number of Prem orders in descending order
        orderBy: (t) => t.orders.count((o) => o.description.ilike('prem%')),
        orderDescending: true,
      );

      var customerNames = fetchedCustomers.map((e) => e.name);
      expect(customerNames, ['Viktor', 'Alex', 'Isak']);
    });
  });

  group('Given models with multiple one to many relations', () {
    tearDown(() async {
      await Person.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Organization.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await City.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });
    test(
        'when fetching models ordered on multiple separate one to many relations then result order is as expected.',
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
      // Attach Tom, Jane and John to San Francisco
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
      // Attach Apple and Google to San Francisco
      await City.db.attach
          .organizations(session, cities[1], organizations.sublist(0, 2));
      // Attach Barclays and BBC to London
      await City.db.attach
          .organizations(session, cities[2], organizations.sublist(3, 5));

      var citiesFetched = await City.db.find(
        session,
        // Order cities by number of citizens and then the number of organizations
        orderByList: (t) => [
          db.Order(
            column: t.citizens.count(),
            orderDescending: true,
          ),
          db.Order(
            column: t.organizations.count(),
            orderDescending: true,
          )
        ],
      );

      var cityNames = citiesFetched.map((e) => e.name);
      expect(cityNames, ['San Francisco', 'Stockholm', 'London']);
    });
  });
}
