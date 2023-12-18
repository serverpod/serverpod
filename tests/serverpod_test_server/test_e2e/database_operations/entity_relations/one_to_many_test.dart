import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Client client) async {
  // Customers
  var customers = [
    Customer(name: 'Alex'),
    Customer(name: 'Isak'),
    Customer(name: 'Viktor'),
  ];

  customers = await client.oneToMany.customerInsert(customers);

  // Orders
  var orders = [
    Order(description: 'Order 1', customerId: customers[0].id!),
    Order(description: 'Order 2', customerId: customers[0].id!),
    Order(description: 'Order 3', customerId: customers[0].id!),
    Order(description: 'Order 4', customerId: customers[1].id!),
    Order(description: 'Order 5', customerId: customers[1].id!),
  ];

  orders = await client.oneToMany.orderInsert(orders);

  // Comments
  var comments = [
    // Order 1
    Comment(description: 'Comment 1', orderId: orders[0].id!),
    Comment(description: 'Comment 2', orderId: orders[0].id!),
    Comment(description: 'Comment 3', orderId: orders[0].id!),
    Comment(description: 'Comment 4', orderId: orders[0].id!),
    Comment(description: 'Comment 5', orderId: orders[0].id!),

    // Order 2
    Comment(description: 'Comment 6', orderId: orders[1].id!),
    Comment(description: 'Comment 7', orderId: orders[1].id!),
    Comment(description: 'Comment 8', orderId: orders[1].id!),
    Comment(description: 'Comment 9', orderId: orders[1].id!),

    // Order 3
    Comment(description: 'Comment 10', orderId: orders[2].id!),
    Comment(description: 'Comment 11', orderId: orders[2].id!),
    Comment(description: 'Comment 12', orderId: orders[2].id!),

    // Order 4
    Comment(description: 'Comment 13', orderId: orders[3].id!),
    Comment(description: 'Comment 14', orderId: orders[3].id!),
  ];

  await client.oneToMany.commentInsert(comments);
}

void main() async {
  var client = Client(serverUrl);

  group('Select queries - ', () {
    group(
        'Given models with many relations ordered on number of many relations',
        () {
      late List<Customer> customersOrderedByOrders;

      setUpAll(() async {
        await _createTestDatabase(client);
        customersOrderedByOrders =
            await client.oneToMany.customerOrderByOrderCountAscending();
      });

      tearDownAll(() async => await client.oneToMany.deleteAll());

      test('then customers are returned in expected order.', () {
        var customerNames = customersOrderedByOrders.map((e) => e.name);
        expect(customerNames, ['Viktor', 'Isak', 'Alex']);
      });
    });

    group(
        'Given models with many relations ordered on number of many relations with specific property',
        () {
      late List<Customer> customersOrderedByOrders;

      setUpAll(() async {
        await _createTestDatabase(client);
        customersOrderedByOrders = await client.oneToMany
            .customerOrderByOrderCountAscendingWhereDescriptionIs('Order 4');
      });

      tearDownAll(() async => await client.oneToMany.deleteAll());

      test('then customers are returned in expected order.', () {
        var customerNames = customersOrderedByOrders.map((e) => e.name);
        // Isak is the only user that has an order with description 'Order 4'
        expect(customerNames, ['Alex', 'Viktor', 'Isak']);
      });
    });
  });
}
