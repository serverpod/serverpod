import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
// Required because this collides with our Order definitions
import '/src/generated/entities_with_relations/one_to_many/order.dart' as o;

class OneToManyEndpoint extends Endpoint {
  Future<List<Customer>> customerOrderByOrderCountAscending(
    Session session,
  ) async {
    return await Customer.db.find(
      session,
      orderBy: (t) => t.orders.count(),
      orderDescending: false,
    );
  }

  Future<List<Customer>> customerOrderByOrderCountAscendingWhereDescriptionIs(
    Session session,
    String description,
  ) async {
    return await Customer.db.find(
      session,
      orderBy:
          (t) => t.orders.count((o) => o.description.equals(description)),
      orderDescending: false,
    );
  }

  Future<List<Comment>> commentInsert(
      Session session, List<Comment> comments) async {
    return await Comment.db.insert(session, comments);
  }

  Future<List<o.Order>> orderInsert(
      Session session, List<o.Order> orders) async {
    return await o.Order.db.insert(session, orders);
  }

  Future<List<Customer>> customerInsert(
      Session session, List<Customer> customers) async {
    return await Customer.db.insert(session, customers);
  }

  Future<int> deleteAll(Session session) async {
    var commentDeletions = await Comment.db
        .deleteWhere(session, where: (_) => Constant.bool(true));
    var orderDeletions = await o.Order.db
        .deleteWhere(session, where: (_) => Constant.bool(true));
    var customerDeletions = await Customer.db
        .deleteWhere(session, where: (_) => Constant.bool(true));

    return commentDeletions.length +
        orderDeletions.length +
        customerDeletions.length;
  }
}
