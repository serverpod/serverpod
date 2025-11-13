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
      'when fetching models filtered by none many relation then result is as expected.',
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
          // All customers with no order.
          where: (c) => c.orders.none(),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, ['Isak']);
      },
    );

    test(
      'when fetching models filtered by filtered none many relation then result is as expected',
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
          // All customers with no orders with a description starting with 'prem'.
          where: (c) => c.orders.none((o) => o.description.ilike('prem%')),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames, containsAll(['Alex', 'Isak']));
      },
    );

    test(
      'when fetching models filtered on none many relation in combination with other filter then result is as expected.',
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
          // All customers with no orders or name 'Viktor'
          where: (c) => c.orders.none() | c.name.equals('Viktor'),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames, containsAll(['Isak', 'Viktor']));
      },
    );

    test(
      'when fetching models filtered on OR filtered none many relation then result is as expected.',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(
            description: 'Basic: OrderUuid 2',
            customerId: customers[0].id!,
          ),
          OrderUuid(description: 'OrderUuid 3', customerId: customers[0].id!),
          // Viktor orders
          OrderUuid(
            description: 'Prem: OrderUuid 4',
            customerId: customers[2].id!,
          ),
          OrderUuid(description: 'OrderUuid 5', customerId: customers[2].id!),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers with no orders with a description starting with 'prem'
          // or 'basic'.
          where: (c) => c.orders.none(
            (o) => o.description.ilike('prem%') | o.description.ilike('basic%'),
          ),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, ['Isak']);
      },
    );

    test(
      'when fetching models filtered on multiple filtered none many relation then result is as expected.',
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
          // All customers with no orders with a description starting with 'prem'
          // or no orders with a description starting with 'basic'.
          where: (c) =>
              c.orders.none((o) => o.description.ilike('prem%')) |
              c.orders.none((o) => o.description.ilike('basic%')),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames, containsAll(['Isak', 'Alex']));
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
      'when filtering on nested none many relation then result is as expected',
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
        ]);
        await CommentInt.db.insert(session, [
          // Alex - OrderUuid 1 comments
          CommentInt(description: 'CommentInt 1', orderId: orders[0].id),
          CommentInt(description: 'CommentInt 2', orderId: orders[0].id),
          // Isak - OrderUuid 3 comments
          CommentInt(description: 'CommentInt 6', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 7', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 8', orderId: orders[2].id),
          // Isak - OrderUuid 4 comments
          CommentInt(description: 'CommentInt 9', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 10', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 11', orderId: orders[3].id),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          // All customers without orders that have no comments.
          where: (c) => c.orders.none((o) => o.comments.none()),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames, containsAll(['Isak', 'Viktor']));
      },
    );

    test(
      'when fetching models filtered on filtered nested none many relation then result is as expected',
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
          CommentInt(description: 'Del: CommentInt 6', orderId: orders[2].id),
          CommentInt(description: 'Del: CommentInt 7', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 8', orderId: orders[2].id),
          // Isak - OrderUuid 4 comments
          CommentInt(description: 'Del: CommentInt 9', orderId: orders[3].id),
          CommentInt(description: 'Del: CommentInt 10', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 11', orderId: orders[3].id),
        ]);

        var fetchedCustomers = await CustomerInt.db.find(
          session,
          where: (c) => c.orders.none(
            /// All customers without orders that have no comments with a description starting with 'del'.
            (o) => o.comments.none((c) => c.description.ilike('del%')),
          ),
        );

        var customerNames = fetchedCustomers.map((e) => e.name);
        expect(customerNames, hasLength(2));
        expect(customerNames, containsAll(['Isak', 'Viktor']));
      },
    );
  });
}
