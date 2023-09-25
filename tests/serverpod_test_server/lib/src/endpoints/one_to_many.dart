import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
// Required because this collides with our Order definitions
import '/src/generated/entities_with_relations/one_to_many/2_order.dart' as o;

class OneToManyEndpoint extends Endpoint {
  Future<List<Customer>> customerFindWhereOrderDescriptionIs(
    Session session, {
    required String description,
  }) async {
    return await Customer.find(
      session,
      where: (t) =>
          t.orders((o) => o.description.equals(description)).count > 0,
    );
  }

  Future<List<Customer>> customerFindWhereOrdersGreaterThan(
    Session session, {
    required int numberOfOrders,
  }) async {
    return await Customer.find(
      session,
      where: (t) => t.orders((_) => Constant.bool(true)).count > numberOfOrders,
    );
  }

  Future<List<Customer>> customerOrderByOrderCountAscending(
    Session session,
  ) async {
    return await Customer.find(
      session,
      orderBy: Customer.t.orders((_) => Constant.bool(true)).count,
      orderDescending: false,
    );
  }

  Future<int> customerCountWhereOrdersGreaterThan(
    Session session, {
    required int numberOfOrders,
  }) async {
    return await Customer.count(
      session,
      where: (t) => t.orders((_) => Constant.bool(true)).count > numberOfOrders,
    );
  }

  Future<int> customerCountWhereOrderDescriptionIs(
    Session session, {
    required String description,
  }) async {
    return await Customer.count(
      session,
      where: (t) =>
          t.orders((o) => o.description.equals(description)).count > 0,
    );
  }

  Future<int?> commentInsert(Session session, Comment comment) async {
    await Comment.insert(session, comment);
    return comment.id;
  }

  Future<int?> orderInsert(Session session, o.Order order) async {
    await o.Order.insert(session, order);
    return order.id;
  }

  Future<int?> customerInsert(Session session, Customer customer) async {
    await Customer.insert(session, customer);
    return customer.id;
  }

  Future<int> deleteAll(Session session) async {
    var commentDeletions =
        await Comment.delete(session, where: (_) => Constant.bool(true));
    var orderDeletions =
        await o.Order.delete(session, where: (_) => Constant.bool(true));
    var customerDeletions =
        await Customer.delete(session, where: (_) => Constant.bool(true));

    return commentDeletions + orderDeletions + customerDeletions;
  }
}
