import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to many relation ', () {
    tearDown(() async {
      await Order.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Customer.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when counting models filtered on any many relation then result is as expected.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
        Customer(name: 'Lisa'),
      ]);
      await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        Order(description: 'Order 2', customerId: customers[0].id!),
        Order(description: 'Order 3', customerId: customers[0].id!),
        // Lisa orders
        Order(description: 'Order 5', customerId: customers[3].id!),
        Order(description: 'Order 6', customerId: customers[3].id!),
      ]);

      var customerCount = await Customer.db.count(
        session,
        // All customers with any order
        where: (c) => c.orders.any(),
      );

      expect(customerCount, 2);
    });

    test(
        'when counting models filtered on filtered any many relation then result is as expected',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
        Customer(name: 'Lisa'),
      ]);
      await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Prem: Order 1', customerId: customers[0].id!),
        Order(description: 'Prem: Order 2', customerId: customers[0].id!),
        Order(description: 'Order 3', customerId: customers[0].id!),
        // Viktor orders
        Order(description: 'Order 4', customerId: customers[2].id!),
        // Lisa orders
        Order(description: 'Prem: Order 5', customerId: customers[3].id!),
        Order(description: 'Order 6', customerId: customers[3].id!),
      ]);

      var customerCount = await Customer.db.count(
        session,
        // All customers with any order starting with 'prem'
        where: (c) => c.orders.any((o) => o.description.ilike('prem%')),
      );

      expect(customerCount, 2);
    });

    test(
        'when counting models filtered on multiple any many relation then result is as expected.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
        Customer(name: 'Lisa'),
      ]);
      await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Prem: Order 1', customerId: customers[0].id!),
        Order(description: 'Order 2', customerId: customers[0].id!),
        Order(description: 'Del: Order 3', customerId: customers[0].id!),
        // Viktor orders
        Order(description: 'Del: Order 4', customerId: customers[2].id!),
        // Lisa orders
        Order(description: 'Prem: Order 5', customerId: customers[3].id!),
        Order(description: 'Order 6', customerId: customers[3].id!),
      ]);

      var customerCount = await Customer.db.count(
        session,
        // All customers with any order starting with 'del and any order starting with 'prem'
        where: (c) =>
            c.orders.any((o) => o.description.ilike('del%')) &
            c.orders.any((o) => o.description.ilike('prem%')),
      );

      expect(customerCount, 1);
    });
  });

  group('Given models with nested one to many relation', () {
    tearDown(() async {
      await Comment.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Order.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Customer.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when counting models filtered on nested any many relation then result is as expected',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
        Customer(name: 'Lisa'),
      ]);
      var orders = await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        Order(description: 'Order 2', customerId: customers[0].id!),
        // Isak orders
        Order(description: 'Order 3', customerId: customers[1].id!),
        Order(description: 'Order 4', customerId: customers[1].id!),
        // Viktor orders
        Order(description: 'Order 5', customerId: customers[2].id!),
      ]);
      await Comment.db.insert(session, [
        // Alex - Order 1 comments
        Comment(description: 'Comment 1', orderId: orders[0].id!),
        Comment(description: 'Comment 2', orderId: orders[0].id!),
        // Isak - Order 3 comments
        Comment(description: 'Comment 6', orderId: orders[2].id!),
        Comment(description: 'Comment 7', orderId: orders[2].id!),
        Comment(description: 'Comment 8', orderId: orders[2].id!),
        // Isak - Order 4 comments
        Comment(description: 'Comment 9', orderId: orders[3].id!),
        Comment(description: 'Comment 10', orderId: orders[3].id!),
        Comment(description: 'Comment 11', orderId: orders[3].id!),
      ]);
      var customerCount = await Customer.db.count(
        session,
        // All customers with any order that has any comment.
        where: (c) => c.orders.any((o) => o.comments.any()),
      );

      expect(customerCount, 2);
    });

    test(
        'when counting models filtered on filtered nested any many relation then result is as expected',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
        Customer(name: 'Lisa'),
      ]);
      var orders = await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        Order(description: 'Order 2', customerId: customers[0].id!),
        // Isak orders
        Order(description: 'Order 3', customerId: customers[1].id!),
        Order(description: 'Order 4', customerId: customers[1].id!),
        // Viktor orders
        Order(description: 'Order 5', customerId: customers[2].id!),
      ]);
      await Comment.db.insert(session, [
        // Alex - Order 1 comments
        Comment(description: 'Prem: Comment 1', orderId: orders[0].id!),
        Comment(description: 'Comment 2', orderId: orders[0].id!),
        // Alex - Order 2 comments
        Comment(description: 'Comment 3', orderId: orders[1].id!),
        Comment(description: 'Comment 4', orderId: orders[1].id!),
        Comment(description: 'Comment 5', orderId: orders[1].id!),
        // Isak - Order 3 comments
        Comment(description: 'Del: Comment 6', orderId: orders[2].id!),
        Comment(description: 'Del: Comment 7', orderId: orders[2].id!),
        Comment(description: 'Comment 8', orderId: orders[2].id!),
        // Isak - Order 4 comments
        Comment(description: 'Del: Comment 9', orderId: orders[3].id!),
        Comment(description: 'Del: Comment 10', orderId: orders[3].id!),
        Comment(description: 'Comment 11', orderId: orders[3].id!),
        // Viktor - Order 5 comments
        Comment(description: 'Del: Comment 12', orderId: orders[4].id!),
        Comment(description: 'Del: Comment 13', orderId: orders[4].id!),
        Comment(description: 'Comment 14', orderId: orders[4].id!),
      ]);

      var customerCount = await Customer.db.count(
        session,
        where: (c) => c.orders.any(
            // All customers any order that has any comment starting with 'del'
            (o) => o.comments.any((c) => c.description.ilike('del%'))),
      );

      expect(customerCount, 2);
    });
  });
}
