import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  tearDown(() async {
    await Order.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    await Customer.db
        .deleteWhere(session, where: (_) => db.Constant.bool(true));
  });

  group('Given count column in database', () {
    test('when filtering on equals then matching row is returned.', () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().equals(2),
      );

      expect(result, hasLength(1));
      expect(result.first.name, customers[1].name);
    });

    test('when filtering on equals zero then matching row is returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().equals(0),
      );

      expect(result, hasLength(1));
      expect(result.first.name, customers[1].name);
    });

    test('when filtering using notEquals then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().notEquals(1),
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[1].name));
      expect(resultNames, contains(customers[2].name));
    });

    test('when filtering using notEquals zero then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().notEquals(0),
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[1].name));
    });

    test('when filtering on inSet then matching row is returned.', () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().inSet({0, 2}),
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[1].name));
      expect(resultNames, contains(customers[2].name));
    });

    test('when filtering with an empty inSet then no rows are.', () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().inSet({}),
      );

      expect(result, isEmpty);
    });

    test('when filtering on notInSet then matching row is returned.', () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().notInSet({1}),
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[1].name));
      expect(resultNames, contains(customers[2].name));
    });

    test('when filtering with empty notInSet then all rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().notInSet({}),
      );

      expect(result, hasLength(3));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, containsAll(customers.map((e) => e.name)));
    });

    test('when filtering on greater than then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count() > 0,
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[1].name));
    });

    test(
        'when filtering using greater or equal than then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count() >= 1,
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[1].name));
    });

    test(
        'when filtering using greater or equal than with zero then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count() >= 0,
      );

      expect(result, hasLength(3));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[1].name));
      expect(resultNames, contains(customers[2].name));
    });

    test(
        'when filtering using greater or equal than with negative value then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count() >= -1,
      );

      expect(result, hasLength(3));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[1].name));
      expect(resultNames, contains(customers[2].name));
    });

    test('when filtering using less than then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count() < 2,
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[2].name));
    });

    test(
        'when filtering using less or equal than then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count() <= 1,
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[2].name));
    });

    test('when filtering using between then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().between(0, 1),
      );

      expect(result, hasLength(2));
      var resultNames = result.map((e) => e.name);
      expect(resultNames, contains(customers[0].name));
      expect(resultNames, contains(customers[2].name));
    });

    test('when filtering notBetween then matching rows are returned.',
        () async {
      var customers = await Customer.db.insert(session, [
        Customer(name: 'Customer 1'),
        Customer(name: 'Customer 2'),
        Customer(name: 'Customer 3'),
      ]);

      await Order.db.insert(session, [
        // Customer 1 orders
        Order(description: 'Order 1', customerId: customers[0].id!),
        // Customer 2 orders
        Order(description: 'Order 2', customerId: customers[1].id!),
        Order(description: 'Order 3', customerId: customers[1].id!),
      ]);

      var result = await Customer.db.find(
        session,
        where: (c) => c.orders.count().notBetween(0, 1),
      );

      expect(result, hasLength(1));
      expect(result.first.name, customers[1].name);
    });
  });
}
