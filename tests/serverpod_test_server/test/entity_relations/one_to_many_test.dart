import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client) async {
  // Customers
  var customer1 = Customer(name: 'Alex');
  var customer2 = Customer(name: 'Isak');
  var customer3 = Customer(name: 'Viktor');

  customer1.id = await client.oneToMany.customerInsert(customer1);
  customer2.id = await client.oneToMany.customerInsert(customer2);
  customer3.id = await client.oneToMany.customerInsert(customer3);

  // Orders
  var order1 = Order(description: 'Order 1', customerId: customer1.id!);
  var order2 = Order(description: 'Order 2', customerId: customer1.id!);

  var order3 = Order(description: 'Order 3', customerId: customer2.id!);

  order1.id = await client.oneToMany.orderInsert(order1);
  order2.id = await client.oneToMany.orderInsert(order2);
  order3.id = await client.oneToMany.orderInsert(order3);

  // Comments
  var comment1 = Comment(description: 'Comment 1', orderId: order1.id!);
  var comment2 = Comment(description: 'Comment 2', orderId: order1.id!);

  var comment3 = Comment(description: 'Comment 3', orderId: order2.id!);

  comment1.id = await client.oneToMany.commentInsert(comment1);
  comment2.id = await client.oneToMany.commentInsert(comment2);
  comment3.id = await client.oneToMany.commentInsert(comment3);
}

void main() async {
  var client = Client(serverUrl);

  group('Select queries - ', () {
    group(
        'Given entities with many relations when filtering on number of many relations',
        () {
      late List<Customer> customersWithMoreThanOneOrder;

      setUpAll(() async {
        await _createTestDatabase(client);
        customersWithMoreThanOneOrder = await client.oneToMany
            .customerFindWhereOrdersGreaterThan(numberOfOrders: 1);
      });

      tearDownAll(() async => await client.oneToMany.deleteAll());

      test('then the correct customer is returned', () {
        var customerNames = customersWithMoreThanOneOrder.map((e) => e.name);
        expect(customerNames, ['Alex']);
      });
    });

    group(
        'Given entities with many relations when filtering on many relation attributes',
        () {
      late List<Customer> customersWithOrdersWithMatchingDescription;
      setUpAll(() async {
        await _createTestDatabase(client);
        customersWithOrdersWithMatchingDescription = await client.oneToMany
            .customerFindWhereOrderDescriptionIs(description: 'Order 3');
      });

      tearDownAll(() async => await client.oneToMany.deleteAll());

      test('then the correct customer is returned', () {
        var customerNames =
            customersWithOrdersWithMatchingDescription.map((e) => e.name);
        expect(customerNames, ['Isak']);
      });
    });

    group(
        'Given entities with many relations when ordering by many relation count',
        () {
      late List<Customer> customersOrderedByOrders;
      setUpAll(() async {
        await _createTestDatabase(client);
        customersOrderedByOrders =
            await client.oneToMany.customerOrderByOrderCountAscending();
      });

      tearDownAll(() async => await client.oneToMany.deleteAll());

      test('then customers are returned in correct order', () {
        var customerNames = customersOrderedByOrders.map((e) => e.name);
        expect(customerNames, ['Viktor', 'Isak', 'Alex']);
      });
    });
  });

  group('Count queries - ', () {
    group(
        'Given entities with many relations when performing a count query based on number of many relations',
        () {
      late int customersWithMoreAtLeastOneOrder;
      setUpAll(() async {
        await _createTestDatabase(client);
        customersWithMoreAtLeastOneOrder = await client.oneToMany
            .customerCountWhereOrdersGreaterThan(numberOfOrders: 0);
      });

      tearDownAll(() async => await client.oneToMany.deleteAll());

      test('then correct count is returned.', () {
        expect(customersWithMoreAtLeastOneOrder, 2);
      });
    });

    group(
        'Given entities with many relations when performing a count query based on many relation attributes',
        () {
      late int customersWithOrdersWithMatchingDescription;
      setUpAll(() async {
        await _createTestDatabase(client);
        customersWithOrdersWithMatchingDescription = await client.oneToMany
            .customerCountWhereOrderDescriptionIs(description: 'Order 1');
      });

      tearDownAll(() async => await client.oneToMany.deleteAll());

      test('then correct count is returned.', () {
        expect(customersWithOrdersWithMatchingDescription, 1);
      });
    });
  });
}
