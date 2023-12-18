import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
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
        'when deleting models filtered on count of many relation then only matching models are deleted',
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
        // Isak orders
        Order(description: 'Order 4', customerId: customers[1].id!),
        // Viktor orders
        Order(description: 'Order 5', customerId: customers[2].id!),
        Order(description: 'Order 6', customerId: customers[2].id!),
      ]);

      var deletedCustomerIds = await Customer.db.deleteWhere(
        session,
        // All customers with more than one order
        where: (c) => c.orders.count() > 1,
      );

      expect(deletedCustomerIds, hasLength(2));
      expect(
        deletedCustomerIds,
        containsAll([
          customers[0].id, // Alex
          customers[2].id, // Viktor
        ]),
      );
    });
    test(
        'when deleting models filtered on filtered many relation count then result is as expected',
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

      var deletedCustomerIds = await Customer.db.deleteWhere(
        session,
        // All customers with more than one order starting with 'prem'
        where: (c) => c.orders.count((o) => o.description.ilike('prem%')) > 1,
      );

      expect(deletedCustomerIds, [
        customers[2].id, // Viktor
      ]);
    });

    test(
        'when deleting models filtered on many relation count in combination with other filter then result is as expected.',
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

      var deletedCustomerIds = await Customer.db.deleteWhere(
        session,
        // All customers with more than two orders or name 'Isak'
        where: (c) => (c.orders.count() > 2) | c.name.equals('Isak'),
      );

      expect(deletedCustomerIds, hasLength(2));
      expect(
          deletedCustomerIds,
          containsAll([
            customers[0].id, // Alex
            customers[1].id, // Isak
          ]));
    });

    test(
        'when deleting models filtered on multiple many relation count then result is as expected.',
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

      var deletedCustomerIds = await Customer.db.deleteWhere(
        session,
        // All customers with more than one orders but less than three
        where: (c) => (c.orders.count() > 1) & (c.orders.count() < 3),
      );

      expect(deletedCustomerIds, [
        customers[2].id, // Viktor
      ]);
    });

    test(
        'when deleting models filtered on multiple filtered many relation count then result is as expected.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
      ]);
      await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Prem: Order 1', customerId: customers[0].id!),
        Order(description: 'Prem: Order 2', customerId: customers[0].id!),
        Order(description: 'Basic: Order 3', customerId: customers[0].id!),
        // Viktor orders
        Order(description: 'Prem: Order 4', customerId: customers[2].id!),
        Order(description: 'Prem: Order 5', customerId: customers[2].id!),
        Order(description: 'Basic: Order 6', customerId: customers[2].id!),
        Order(description: 'Basic: Order 7', customerId: customers[2].id!),
      ]);

      var deletedCustomerIds = await Customer.db.deleteWhere(
        session,
        // All customers with more than one premium order and one basic order
        where: (c) =>
            (c.orders.count((o) => o.description.ilike('prem%')) > 1) &
            (c.orders.count((o) => o.description.ilike('basic%')) > 1),
      );

      expect(deletedCustomerIds, [
        customers[2].id, // Viktor
      ]);
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
        'when filtering on nested many relation count then result is as expected',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
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
        // Alex - Order 2 comments
        Comment(description: 'Comment 3', orderId: orders[1].id!),
        Comment(description: 'Comment 4', orderId: orders[1].id!),
        Comment(description: 'Comment 5', orderId: orders[1].id!),
        // Isak - Order 3 comments
        Comment(description: 'Comment 6', orderId: orders[2].id!),
        Comment(description: 'Comment 7', orderId: orders[2].id!),
        Comment(description: 'Comment 8', orderId: orders[2].id!),
        // Isak - Order 4 comments
        Comment(description: 'Comment 9', orderId: orders[3].id!),
        Comment(description: 'Comment 10', orderId: orders[3].id!),
        Comment(description: 'Comment 11', orderId: orders[3].id!),
        // Viktor - Order 5 comments
        Comment(description: 'Comment 12', orderId: orders[4].id!),
        Comment(description: 'Comment 13', orderId: orders[4].id!),
        Comment(description: 'Comment 14', orderId: orders[4].id!),
      ]);

      var deletedCustomerIds = await Customer.db.deleteWhere(
        session,
        // All customers with more than one order with more than two comments
        where: (c) => c.orders.count((o) => o.comments.count() > 2) > 1,
      );

      expect(deletedCustomerIds, [
        customers[1].id, // Isak
      ]);
    });

    test(
        'when deleting models filtered on filtered nested many relation count then result is as expected',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
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
        Comment(description: 'Del: Comment 1', orderId: orders[0].id!),
        Comment(description: 'Del: Comment 2', orderId: orders[0].id!),
        // Alex - Order 2 comments
        Comment(description: 'Del: Comment 3', orderId: orders[1].id!),
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

      var deletedCustomerIds = await Customer.db.deleteWhere(
        session,
        where: (c) => c.orders.count(
            // All customers with more than one order with more than one comment starting with 'del'
            (o) => o.comments.count((c) => c.description.ilike('del%')) > 1) > 1,
      );

      expect(deletedCustomerIds, [
        customers[1].id, // Isak
      ]);
    });
  });
}
