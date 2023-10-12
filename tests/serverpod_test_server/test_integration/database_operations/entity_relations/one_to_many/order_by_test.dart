import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod/server.dart';
import 'package:test/test.dart';

Future<void> _createTestDatabase(Session session) async {
  // Customers
  var customers = [
    Customer(name: 'Alex'),
    Customer(name: 'Isak'),
    Customer(name: 'Viktor'),
  ];

  customers = await Customer.db.insert(session, customers);

  // Orders
  var orders = [
    // Alex orders
    Order(description: 'Basic: Order 1', customerId: customers[0].id!),
    Order(description: 'Prem: Order 2', customerId: customers[0].id!),
    Order(description: 'Basic: Order 3', customerId: customers[0].id!),
    // Isak orders
    Order(description: 'Prem: Order 4', customerId: customers[1].id!),
    Order(description: 'Prem: Order 5', customerId: customers[1].id!),
  ];

  orders = await Order.db.insert(session, orders);

  // Comments
  var comments = [
    // Order 1
    Comment(description: 'Del: Comment 1', orderId: orders[0].id!),
    Comment(description: 'Del: Comment 2', orderId: orders[0].id!),
    Comment(description: 'Del: Comment 3', orderId: orders[0].id!),
    Comment(description: 'Comment 4', orderId: orders[0].id!),
    Comment(description: 'Comment 5', orderId: orders[0].id!),

    // Order 2
    Comment(description: 'Del: Comment 6', orderId: orders[1].id!),
    Comment(description: 'Comment 7', orderId: orders[1].id!),
    Comment(description: 'Comment 8', orderId: orders[1].id!),
    Comment(description: 'Comment 9', orderId: orders[1].id!),

    // Order 3
    Comment(description: 'Comment 10', orderId: orders[2].id!),
    Comment(description: 'Comment 11', orderId: orders[2].id!),
    Comment(description: 'Comment 12', orderId: orders[2].id!),

    // Order 4
    Comment(description: 'Del: Comment 13', orderId: orders[3].id!),
    Comment(description: 'Del: Comment 14', orderId: orders[3].id!),
  ];

  await Comment.db.insert(session, comments);
}

Future<void> _clearTestDatabase(Session session) async {
  await Comment.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
  await Order.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
  await Customer.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _clearTestDatabase(session));

  group('Given ordered find query', () {
    test('when ordering on count of many relation then result is as expected.',
        () async {
      var customers = await Customer.db.find(
        session,
        // Order by number of orders in ascending order
        orderBy: Customer.t.orders.count(),
        orderDescending: false,
      );

      var customerNames = customers.map((e) => e.name);
      expect(customerNames, ['Viktor', 'Isak', 'Alex']);
    });

    test(
        'when ordering on count of many relation with specific property then result is as expected.',
        () async {
      var customers = await Customer.db.find(
        session,
        // Order by number of Prem orders in descending order
        orderBy: Customer.t.orders.count((o) => o.description.ilike('prem%')),
        orderDescending: true,
      );

      var customerNames = customers.map((e) => e.name);
      expect(customerNames, ['Isak', 'Alex', 'Viktor']);
    });
  });
}
