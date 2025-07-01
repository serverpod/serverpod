import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
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
        'when deleting models filtered by every many relation then result is as expected',
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
        Order(description: 'Prem: Order 4', customerId: customers[2].id!),
        Order(description: 'Prem: Order 5', customerId: customers[2].id!),
      ]);

      var deletedCustomers = await Customer.db.deleteWhere(
        session,
        // All customers where every order has a description starting with 'prem'.
        where: (c) => c.orders.every((o) => o.description.ilike('prem%')),
      );

      expect(deletedCustomers, hasLength(1));
      expect(
        deletedCustomers.firstOrNull?.id,
        customers[2].id, // Viktor
      );
    });

    test(
        'when deleting models filtered on every many relation in combination with other filter then result is as expected.',
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
        Order(description: 'Prem: Order 3', customerId: customers[0].id!),
        // Viktor orders
        Order(description: 'Order 4', customerId: customers[2].id!),
        Order(description: 'Order 5', customerId: customers[2].id!),
      ]);

      var deletedCustomers = await Customer.db.deleteWhere(
        session,
        // All customers where every order has a description starting with 'prem' or customer name is 'Viktor'
        where: (c) =>
            c.orders.every((o) => o.description.ilike('prem%')) |
            c.name.equals('Isak'),
      );

      expect(deletedCustomers, hasLength(2));
      var deletedCustomerIds = deletedCustomers.map((c) => c.id).toList();
      expect(
          deletedCustomerIds,
          containsAll([
            customers[0].id, // Alex
            customers[1].id, // Isak
          ]));
    });

    test(
        'when deleting models filtered on combined filtered every many relation then result is as expected.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Alex'),
        Customer(name: 'Isak'),
        Customer(name: 'Viktor'),
      ]);
      await Order.db.insert(session, [
        // Alex orders
        Order(description: 'Prem: Order 1', customerId: customers[0].id!),
        Order(description: 'Basic: Order 2', customerId: customers[0].id!),
        Order(description: 'Order 3', customerId: customers[0].id!),
        // Viktor orders
        Order(description: 'Prem: Order 4', customerId: customers[2].id!),
        Order(description: 'Basic: Order 5', customerId: customers[2].id!),
      ]);

      var deletedCustomers = await Customer.db.deleteWhere(
        session,
        // All customers where every order has a description starting with 'prem'
        // or 'basic'.
        where: (c) => c.orders.every((o) =>
            o.description.ilike('prem%') | o.description.ilike('basic%')),
      );

      expect(deletedCustomers, hasLength(1));
      expect(
        deletedCustomers.firstOrNull?.id,
        customers[2].id, // Viktor
      );
    });

    test(
        'when deleting models filtered on multiple every many relation then result is as expected.',
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
        // Isak orders
        Order(description: 'Basic: Order 1', customerId: customers[1].id!),
        Order(description: 'Basic: Order 2', customerId: customers[1].id!),
        // Viktor orders
        Order(description: 'Prem: Order 4', customerId: customers[2].id!),
        Order(description: 'Prem: Order 5', customerId: customers[2].id!),
        Order(description: 'Basic: Order 6', customerId: customers[2].id!),
        Order(description: 'Basic: Order 7', customerId: customers[2].id!),
      ]);

      var deletedCustomers = await Customer.db.deleteWhere(
        session,
        // All customers where every order has a description starting with 'prem'
        // or every order has a description starting with 'basic'.
        where: (c) =>
            c.orders.every((o) => o.description.ilike('prem%')) |
            c.orders.every((o) => o.description.ilike('basic%')),
      );

      expect(deletedCustomers, hasLength(2));
      var deletedCustomerIds = deletedCustomers.map((c) => c.id).toList();
      expect(
          deletedCustomerIds,
          containsAll([
            customers[0].id, // Alex
            customers[1].id, // Isak
          ]));
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
        'when deleting models filtered on nested every many relation then result is as expected',
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
        Comment(description: 'Del: Comment 1', orderId: orders[0].id!),
        Comment(description: 'Del: Comment 2', orderId: orders[0].id!),
        // Alex - Order 2 comments
        Comment(description: 'Del: Comment 3', orderId: orders[1].id!),
        Comment(description: 'Del: Comment 4', orderId: orders[1].id!),
        // Isak - Order 3 comments
        Comment(description: 'Del: Comment 6', orderId: orders[2].id!),
        Comment(description: 'Del: Comment 7', orderId: orders[2].id!),
        Comment(description: 'Del: Comment 8', orderId: orders[2].id!),
        // Isak - Order 4 comments
        Comment(description: 'Comment 9', orderId: orders[3].id!),
        Comment(description: 'Comment 10', orderId: orders[3].id!),
        Comment(description: 'Comment 11', orderId: orders[3].id!),
        // Viktor - Order 5 comments
        Comment(description: 'Del: Comment 12', orderId: orders[4].id!),
        Comment(description: 'Del: Comment 13', orderId: orders[4].id!),
        Comment(description: 'Del: Comment 14', orderId: orders[4].id!),
      ]);

      var deletedCustomers = await Customer.db.deleteWhere(
        session,
        // All customers where every comment for every order starts with del.
        where: (c) => c.orders
            .every((o) => o.comments.every((c) => c.description.ilike('del%'))),
      );

      expect(deletedCustomers, hasLength(2));
      var deletedCustomerIds = deletedCustomers.map((c) => c.id).toList();
      expect(deletedCustomerIds, [
        customers[0].id, // Alex
        customers[2].id, // Viktor
      ]);
    });

    test(
        'when deleting models filtered on nested every many relation in combination with separate filter then result is as expected',
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
        // Lisa orders
        Order(description: 'Prem: Order 5', customerId: customers[3].id!),
      ]);
      await Comment.db.insert(session, [
        // Alex - Order 1 comments
        Comment(description: 'Del: Comment 1', orderId: orders[0].id!),
        Comment(description: 'Del: Comment 2', orderId: orders[0].id!),
        // Alex - Order 2 comments
        Comment(description: 'Del: Comment 3', orderId: orders[1].id!),
        // Isak - Order 3 comments
        Comment(description: 'Del: Comment 4', orderId: orders[2].id!),
        Comment(description: 'Del: Comment 5', orderId: orders[2].id!),
        Comment(description: 'Comment 6', orderId: orders[2].id!),
        // Isak - Order 4 comments
        Comment(description: 'Del: Comment 7', orderId: orders[3].id!),
        Comment(description: 'Del: Comment 8', orderId: orders[3].id!),
        Comment(description: 'Del: Comment 9', orderId: orders[3].id!),
      ]);

      var deletedCustomers = await Customer.db.deleteWhere(
        session,
        // All customers where every comment for every order starts with 'del' or every order starts with 'prem'.
        where: (c) => c.orders.every((o) =>
            o.comments.every((c) => c.description.ilike('del%')) |
            o.description.ilike('prem%')),
      );

      expect(deletedCustomers, hasLength(2));
      var deletedCustomerIds = deletedCustomers.map((c) => c.id).toList();
      expect(
          deletedCustomerIds,
          containsAll([
            customers[0].id, // Alex
            customers[3].id, // Lisa
          ]));
    });
  });
}
