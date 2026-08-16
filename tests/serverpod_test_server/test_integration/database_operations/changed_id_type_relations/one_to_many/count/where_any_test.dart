import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to many relation ', () {
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
      'when counting models filtered on any many relation then result is as expected.',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
          CustomerInt(name: 'Lisa'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(description: 'OrderUuid 1', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          OrderUuid(description: 'OrderUuid 3', customerId: customers[0].id!),
          // Lisa orders
          OrderUuid(description: 'OrderUuid 5', customerId: customers[3].id!),
          OrderUuid(description: 'OrderUuid 6', customerId: customers[3].id!),
        ]);

        var customerCount = await CustomerInt.db.count(
          session,
          // All customers with any order
          where: (c) => c.orders.any(),
        );

        expect(customerCount, 2);
      },
    );

    test(
      'when counting models filtered on filtered any many relation then result is as expected',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
          CustomerInt(name: 'Lisa'),
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
          OrderUuid(description: 'OrderUuid 3', customerId: customers[0].id!),
          // Viktor orders
          OrderUuid(description: 'OrderUuid 4', customerId: customers[2].id!),
          // Lisa orders
          OrderUuid(
            description: 'Prem: OrderUuid 5',
            customerId: customers[3].id!,
          ),
          OrderUuid(description: 'OrderUuid 6', customerId: customers[3].id!),
        ]);

        var customerCount = await CustomerInt.db.count(
          session,
          // All customers with any order starting with 'prem'
          where: (c) => c.orders.any((o) => o.description.ilike('prem%')),
        );

        expect(customerCount, 2);
      },
    );

    test(
      'when counting models filtered on multiple any many relation then result is as expected.',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
          CustomerInt(name: 'Lisa'),
        ]);
        await OrderUuid.db.insert(session, [
          // Alex orders
          OrderUuid(
            description: 'Prem: OrderUuid 1',
            customerId: customers[0].id!,
          ),
          OrderUuid(description: 'OrderUuid 2', customerId: customers[0].id!),
          OrderUuid(
            description: 'Del: OrderUuid 3',
            customerId: customers[0].id!,
          ),
          // Viktor orders
          OrderUuid(
            description: 'Del: OrderUuid 4',
            customerId: customers[2].id!,
          ),
          // Lisa orders
          OrderUuid(
            description: 'Prem: OrderUuid 5',
            customerId: customers[3].id!,
          ),
          OrderUuid(description: 'OrderUuid 6', customerId: customers[3].id!),
        ]);

        var customerCount = await CustomerInt.db.count(
          session,
          // All customers with any order starting with 'del and any order starting with 'prem'
          where: (c) =>
              c.orders.any((o) => o.description.ilike('del%')) &
              c.orders.any((o) => o.description.ilike('prem%')),
        );

        expect(customerCount, 1);
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
      'when counting models filtered on nested any many relation then result is as expected',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
          CustomerInt(name: 'Lisa'),
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
          // Isak - OrderUuid 3 comments
          CommentInt(description: 'CommentInt 6', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 7', orderId: orders[2].id),
          CommentInt(description: 'CommentInt 8', orderId: orders[2].id),
          // Isak - OrderUuid 4 comments
          CommentInt(description: 'CommentInt 9', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 10', orderId: orders[3].id),
          CommentInt(description: 'CommentInt 11', orderId: orders[3].id),
        ]);
        var customerCount = await CustomerInt.db.count(
          session,
          // All customers with any order that has any comment.
          where: (c) => c.orders.any((o) => o.comments.any()),
        );

        expect(customerCount, 2);
      },
    );

    test(
      'when counting models filtered on filtered nested any many relation then result is as expected',
      () async {
        var customers = await CustomerInt.db.insert(session, [
          CustomerInt(name: 'Alex'),
          CustomerInt(name: 'Isak'),
          CustomerInt(name: 'Viktor'),
          CustomerInt(name: 'Lisa'),
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
          CommentInt(description: 'Prem: CommentInt 1', orderId: orders[0].id),
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
          // Viktor - OrderUuid 5 comments
          CommentInt(description: 'Del: CommentInt 12', orderId: orders[4].id),
          CommentInt(description: 'Del: CommentInt 13', orderId: orders[4].id),
          CommentInt(description: 'CommentInt 14', orderId: orders[4].id),
        ]);

        var customerCount = await CustomerInt.db.count(
          session,
          where: (c) => c.orders.any(
            // All customers any order that has any comment starting with 'del'
            (o) => o.comments.any((c) => c.description.ilike('del%')),
          ),
        );

        expect(customerCount, 2);
      },
    );
  });
}
