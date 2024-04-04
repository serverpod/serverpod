/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class Order extends _i1.TableRow {
  Order._({
    int? id,
    required this.description,
    required this.customerId,
    this.customer,
    this.comments,
  }) : super(id);

  factory Order({
    int? id,
    required String description,
    required int customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? comments,
  }) = _OrderImpl;

  factory Order.fromJson(Map<String, dynamic> jsonSerialization) {
    return Order(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      customerId: jsonSerialization['customerId'] as int,
      customer: jsonSerialization.containsKey('customer')
          ? _i2.Customer.fromJson(
              jsonSerialization['customer'] as Map<String, dynamic>)
          : null,
      comments: (jsonSerialization['comments'] as List<dynamic>?)
          ?.map((e) => _i2.Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static final t = OrderTable();

  static const db = OrderRepository._();

  String description;

  int customerId;

  _i2.Customer? customer;

  List<_i2.Comment>? comments;

  @override
  _i1.Table get table => t;

  Order copyWith({
    int? id,
    String? description,
    int? customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? comments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'customerId': customerId,
      if (customer != null) 'customer': customer?.toJson(),
      if (comments != null)
        'comments': comments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'customerId': customerId,
      if (customer != null) 'customer': customer?.allToJson(),
      if (comments != null)
        'comments': comments?.toJson(valueToJson: (v) => v.allToJson()),
    };
  }

  static OrderInclude include({
    _i2.CustomerInclude? customer,
    _i2.CommentIncludeList? comments,
  }) {
    return OrderInclude._(
      customer: customer,
      comments: comments,
    );
  }

  static OrderIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderTable>? orderByList,
    OrderInclude? include,
  }) {
    return OrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Order.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Order.t),
      include: include,
    );
  }
}

class _Undefined {}

class _OrderImpl extends Order {
  _OrderImpl({
    int? id,
    required String description,
    required int customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? comments,
  }) : super._(
          id: id,
          description: description,
          customerId: customerId,
          customer: customer,
          comments: comments,
        );

  @override
  Order copyWith({
    Object? id = _Undefined,
    String? description,
    int? customerId,
    Object? customer = _Undefined,
    Object? comments = _Undefined,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      customerId: customerId ?? this.customerId,
      customer:
          customer is _i2.Customer? ? customer : this.customer?.copyWith(),
      comments:
          comments is List<_i2.Comment>? ? comments : this.comments?.clone(),
    );
  }
}

class OrderTable extends _i1.Table {
  OrderTable({super.tableRelation}) : super(tableName: 'order') {
    description = _i1.ColumnString(
      'description',
      this,
    );
    customerId = _i1.ColumnInt(
      'customerId',
      this,
    );
  }

  late final _i1.ColumnString description;

  late final _i1.ColumnInt customerId;

  _i2.CustomerTable? _customer;

  _i2.CommentTable? ___comments;

  _i1.ManyRelation<_i2.CommentTable>? _comments;

  _i2.CustomerTable get customer {
    if (_customer != null) return _customer!;
    _customer = _i1.createRelationTable(
      relationFieldName: 'customer',
      field: Order.t.customerId,
      foreignField: _i2.Customer.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CustomerTable(tableRelation: foreignTableRelation),
    );
    return _customer!;
  }

  _i2.CommentTable get __comments {
    if (___comments != null) return ___comments!;
    ___comments = _i1.createRelationTable(
      relationFieldName: '__comments',
      field: Order.t.id,
      foreignField: _i2.Comment.t.orderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CommentTable(tableRelation: foreignTableRelation),
    );
    return ___comments!;
  }

  _i1.ManyRelation<_i2.CommentTable> get comments {
    if (_comments != null) return _comments!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'comments',
      field: Order.t.id,
      foreignField: _i2.Comment.t.orderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CommentTable(tableRelation: foreignTableRelation),
    );
    _comments = _i1.ManyRelation<_i2.CommentTable>(
      tableWithRelations: relationTable,
      table: _i2.CommentTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _comments!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        description,
        customerId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'customer') {
      return customer;
    }
    if (relationField == 'comments') {
      return __comments;
    }
    return null;
  }
}

class OrderInclude extends _i1.IncludeObject {
  OrderInclude._({
    _i2.CustomerInclude? customer,
    _i2.CommentIncludeList? comments,
  }) {
    _customer = customer;
    _comments = comments;
  }

  _i2.CustomerInclude? _customer;

  _i2.CommentIncludeList? _comments;

  @override
  Map<String, _i1.Include?> get includes => {
        'customer': _customer,
        'comments': _comments,
      };

  @override
  _i1.Table get table => Order.t;
}

class OrderIncludeList extends _i1.IncludeList {
  OrderIncludeList._({
    _i1.WhereExpressionBuilder<OrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Order.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Order.t;
}

class OrderRepository {
  const OrderRepository._();

  final attach = const OrderAttachRepository._();

  final attachRow = const OrderAttachRowRepository._();

  Future<List<Order>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderTable>? orderByList,
    _i1.Transaction? transaction,
    OrderInclude? include,
  }) async {
    return session.db.find<Order>(
      where: where?.call(Order.t),
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Order?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrderTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderTable>? orderByList,
    _i1.Transaction? transaction,
    OrderInclude? include,
  }) async {
    return session.db.findFirstRow<Order>(
      where: where?.call(Order.t),
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Order?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    OrderInclude? include,
  }) async {
    return session.db.findById<Order>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Order>> insert(
    _i1.Session session,
    List<Order> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Order>(
      rows,
      transaction: transaction,
    );
  }

  Future<Order> insertRow(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Order>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Order>> update(
    _i1.Session session,
    List<Order> rows, {
    _i1.ColumnSelections<OrderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Order>(
      rows,
      columns: columns?.call(Order.t),
      transaction: transaction,
    );
  }

  Future<Order> updateRow(
    _i1.Session session,
    Order row, {
    _i1.ColumnSelections<OrderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Order>(
      row,
      columns: columns?.call(Order.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Order> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Order>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Order>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OrderTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Order>(
      where: where(Order.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Order>(
      where: where?.call(Order.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class OrderAttachRepository {
  const OrderAttachRepository._();

  Future<void> comments(
    _i1.Session session,
    Order order,
    List<_i2.Comment> comment,
  ) async {
    if (comment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('comment.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $comment = comment.map((e) => e.copyWith(orderId: order.id)).toList();
    await session.db.update<_i2.Comment>(
      $comment,
      columns: [_i2.Comment.t.orderId],
    );
  }
}

class OrderAttachRowRepository {
  const OrderAttachRowRepository._();

  Future<void> customer(
    _i1.Session session,
    Order order,
    _i2.Customer customer,
  ) async {
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }
    if (customer.id == null) {
      throw ArgumentError.notNull('customer.id');
    }

    var $order = order.copyWith(customerId: customer.id);
    await session.db.updateRow<Order>(
      $order,
      columns: [Order.t.customerId],
    );
  }

  Future<void> comments(
    _i1.Session session,
    Order order,
    _i2.Comment comment,
  ) async {
    if (comment.id == null) {
      throw ArgumentError.notNull('comment.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $comment = comment.copyWith(orderId: order.id);
    await session.db.updateRow<_i2.Comment>(
      $comment,
      columns: [_i2.Comment.t.orderId],
    );
  }
}
