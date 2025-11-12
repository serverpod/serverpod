import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to many relation', () {
    tearDown(() async {
      await OrderUuid.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
      await CustomerInt.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
    });

    test(
      'when fetching models filtered on many relation count then result is as expected.',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 3', customerId: customers[0].id!),
          // Viktor orders
          OrderUuid(description: 'OrderUuid 4', customerId: customers[2].id!),
          OrderUuid(description: 'OrderUuid 5', customerId: customers[2].id!),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with more than one order
          where: (c) => c.orders.count() > 1,
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames, containsAll(['Alex', 'Viktor']));
      },
    );

    test(
      'when fetching models filtered on filtered many relation count then result is as expected',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(
            description: 'Prem: OrderUuid 1',
            customerId: customers[0].id!,
          ),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 3', customerId: customers[0].id!),
          // Viktor orders
          OrderUuid(
            description: 'Prem: OrderUuid 4',
            customerId: customers[2].id!,
          ),
          OrderUuid(
            description: 'Prem: OrderUuid 5',
            customerId: customers[2].id!,
          ),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with more than one order starting with 'prem'
          where: (c) => c.orders.count((o) => o.description.ilike('prem%')) > 1,
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, ['Viktor']);
      },
    );

    test(
      'when fetching models filtered on many relation count in combination with other filter then result is as expected.',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 3', customerId: customers[0].id!),
          // Viktor orders
          OrderUuid(description: 'OrderUuid 4', customerId: customers[2].id!),
          OrderUuid(description: 'OrderUuid 5', customerId: customers[2].id!),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with more than two orders or name 'Isak'
          where: (c) => (c.orders.count() > 2) | c.name.equals('Isak'),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames, containsAll(['Alex', 'Isak']));
      },
    );

    test(
      'when fetching models filtered on multiple many relation count then result is as expected.',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 3', customerId: customers[0].id!),
          // Viktor orders
          OrderUuid(description: 'OrderUuid 4', customerId: customers[2].id!),
          OrderUuid(description: 'OrderUuid 5', customerId: customers[2].id!),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with more than one orders but less than three
          where: (c) => (c.orders.count() > 1) & (c.orders.count() < 3),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, ['Viktor']);
      },
    );

    test(
      'when fetching models filtered on multiple filtered many relation count then result is as expected.',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(
            description: 'Prem: OrderUuid 1',
            customerId: customers[0].id!,
          ),
          OrderUuid(
            description: 'Prem: OrderUuid 2',
            customerId: customers[0].id!,
          ),
          OrderUuid(
            description: 'Basic: OrderUuid 3',
            customerId: customers[0].id!,
          ),
          // Viktor orders
          OrderUuid(
            description: 'Prem: OrderUuid 4',
            customerId: customers[2].id!,
          ),
          OrderUuid(
            description: 'Prem: OrderUuid 5',
            customerId: customers[2].id!,
          ),
          OrderUuid(
            description: 'Basic: OrderUuid 6',
            customerId: customers[2].id!,
          ),
          OrderUuid(
            description: 'Basic: OrderUuid 7',
            customerId: customers[2].id!,
          ),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with more than one premium order and one basic order
          where: (c) =>
              (c.orders.count((o) => o.description.ilike('prem%')) > 1) &
              (c.orders.count((o) => o.description.ilike('basic%')) > 1),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, ['Viktor']);
      },
    );

    test(
      'when fetching models filtered and ordered on many relation count then result is as expected',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          // Isak orders
          OrderUuid(
            description: 'Prem: OrderUuid 3',
            customerId: customers[1].id!,
          ),
          OrderUuid(
            description: 'Prem: OrderUuid 4',
            customerId: customers[1].id!,
          ),
          // Viktor orders
          OrderUuid(
            description: 'Prem: OrderUuid 5',
            customerId: customers[2].id!,
          ),
          OrderUuid(
            description: 'Prem: OrderUuid 6',
            customerId: customers[2].id!,
          ),
          OrderUuid(
            description: 'Basic: OrderUuid 7',
            customerId: customers[2].id!,
          ),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with more than one order with a description starting with 'prem'
          where: (c) => c.orders.count((o) => o.description.ilike('prem%')) > 1,
          // OrderUuid by number of orders with descriptions starting with 'basic'
          orderBy: (t) => t.orders.count((o) => o.description.ilike('basic%')),
          orderDescending: true,
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames.first, 'Viktor');
        expect(customerNames.last, 'Isak');
      },
    );
  });

  group('Given models with nested one to many relation', () {
    tearDown(() async {
      await CommentInt.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
      await OrderUuid.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
      await CustomerInt.db.deleteWhere(
        session,
        where: (_) => db.Constant.bool(true),
      );
    });

    test(
      'when filtering on nested many relation count then result is as expected',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        var orders = await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          // Isak orders
          OrderUuid(description: 'OrderUuid 3', customerId: customers[1].id!),
          OrderUuid(description: 'OrderUuid 4', customerId: customers[1].id!),
          // Viktor orders
          OrderUuid(description: 'OrderUuid 5', customerId: customers[2].id!),
        ]);
        await CommentInt.db.insert(session, [
          // Alex - OrderUuid 1 comments
          CommentInt(description: 'CommentInt 1', orderId: orders[0].id),
          CommentInt(description: 'CommentInt 2', orderId: orders[0].id),
          // Alex - OrderUuid 2 comments
          CommentInt(description: 'CommentInt 3', orderId: orders[1].id),
          CommentInt(description: 'CommentInt 4', orderId: orders[1].id),
          CommentInt(description: 'CommentInt 5', orderId: orders[1].id),
          // Isak - OrderUuid 3 comments
          CommentInt(description: 'CommentInt 6', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 7', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 8', orderId: orders[2].id),
          // Isak - OrderUuid 4 comments
          CommentInt(description: 'CommentInt 9', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 10', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 11', orderId: orders[3].id),
          // Viktor - OrderUuid 5 comments
          CommentInt(description: 'CommentInt 12', orderId: orders[4].id),
          CommentInt(description: 'CommentInt 13', orderId: orders[4].id),
          CommentInt(description: 'CommentInt 14', orderId: orders[4].id),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with more than one order with more than two comments
          where: (c) => c.orders.count((o) => o.comments.count() > 2) > 1,
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(1));
        expect(customerNames, contains('Isak'));
      },
    );

    test(
      'when fetching models filtered on filtered nested many relation count then result is as expected',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        var orders = await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          // Isak orders
          OrderUuid(description: 'OrderUuid 3', customerId: customers[1].id!),
          OrderUuid(description: 'OrderUuid 4', customerId: customers[1].id!),
          // Viktor orders
          OrderUuid(description: 'OrderUuid 5', customerId: customers[2].id!),
        ]);
        await CommentInt.db.insert(session, [
          // Alex - OrderUuid 1 comments
          CommentInt(description: 'Del: CommentInt 1', orderId: orders[0].id),
          CommentInt(description: 'Del: CommentInt 2', orderId: orders[0].id),
          // Alex - OrderUuid 2 comments
          CommentInt(description: 'Del: CommentInt 3', orderId: orders[1].id),
          CommentInt(description: 'CommentInt 4', orderId: orders[1].id),
          CommentInt(description: 'CommentInt 5', orderId: orders[1].id),
          // Isak - OrderUuid 3 comments
          CommentInt(description: 'Del: CommentInt 6', orderId: orders[2].id),
          CommentInt(description: 'Del: CommentInt 7', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 8', orderId: orders[2].id),
          // Isak - OrderUuid 4 comments
          CommentInt(description: 'Del: CommentInt 9', orderId: orders[3].id),
          CommentInt(description: 'Del: CommentInt 10', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 11', orderId: orders[3].id),
          // Viktor - OrderUuid 5 comments
          CommentInt(description: 'Del: CommentInt 12', orderId: orders[4].id),
          CommentInt(description: 'Del: CommentInt 13', orderId: orders[4].id),
          CommentInt(description: 'CommentInt 14', orderId: orders[4].id),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          where: (c) =>
              c.orders.count(
                // All customers with more than one order with more than one comment starting with 'del'
                (o) => o.comments.count((c) => c.description.ilike('del%')) > 1,
              ) >
              1,
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, ['Isak']);
      },
    );
  });
}
