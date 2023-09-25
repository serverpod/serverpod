/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Order extends _i1.TableRow {
  Order._({
    int? id,
    required this.description,
    this.comments,
    required this.customerId,
    this.customer,
  }) : super(id);

  factory Order({
    int? id,
    required String description,
    List<_i2.Comment>? comments,
    required int customerId,
    _i2.Customer? customer,
  }) = _OrderImpl;

  factory Order.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Order(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      comments: serializationManager
          .deserialize<List<_i2.Comment>?>(jsonSerialization['comments']),
      customerId: serializationManager
          .deserialize<int>(jsonSerialization['customerId']),
      customer: serializationManager
          .deserialize<_i2.Customer?>(jsonSerialization['customer']),
    );
  }

  static final t = OrderTable();

  static final db = OrderRepository._();

  String description;

  List<_i2.Comment>? comments;

  int customerId;

  _i2.Customer? customer;

  @override
  _i1.Table get table => t;
  Order copyWith({
    int? id,
    String? description,
    List<_i2.Comment>? comments,
    int? customerId,
    _i2.Customer? customer,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'comments': comments,
      'customerId': customerId,
      'customer': customer,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'description': description,
      'customerId': customerId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'description': description,
      'comments': comments,
      'customerId': customerId,
      'customer': customer,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'description':
        description = value;
        return;
      case 'customerId':
        customerId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Order>> find(
    _i1.Session session, {
    OrderExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    OrderInclude? include,
  }) async {
    return session.db.find<Order>(
      where: where != null ? where(Order.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Order?> findSingleRow(
    _i1.Session session, {
    OrderExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    OrderInclude? include,
  }) async {
    return session.db.findSingleRow<Order>(
      where: where != null ? where(Order.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Order?> findById(
    _i1.Session session,
    int id, {
    OrderInclude? include,
  }) async {
    return session.db.findById<Order>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required OrderExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Order>(
      where: where(Order.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    OrderExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Order>(
      where: where != null ? where(Order.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static OrderInclude include({_i2.CustomerInclude? customer}) {
    return OrderInclude._(customer: customer);
  }
}

class _Undefined {}

class _OrderImpl extends Order {
  _OrderImpl({
    int? id,
    required String description,
    List<_i2.Comment>? comments,
    required int customerId,
    _i2.Customer? customer,
  }) : super._(
          id: id,
          description: description,
          comments: comments,
          customerId: customerId,
          customer: customer,
        );

  @override
  Order copyWith({
    Object? id = _Undefined,
    String? description,
    Object? comments = _Undefined,
    int? customerId,
    Object? customer = _Undefined,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      comments:
          comments is List<_i2.Comment>? ? comments : this.comments?.clone(),
      customerId: customerId ?? this.customerId,
      customer:
          customer is _i2.Customer? ? customer : this.customer?.copyWith(),
    );
  }
}

typedef OrderExpressionBuilder = _i1.Expression Function(OrderTable);
typedef OrderWithoutManyRelationsExpressionBuilder = _i1.Expression Function(
    OrderWithoutManyRelationsTable);

class OrderTable extends OrderWithoutManyRelationsTable {
  OrderTable({
    super.queryPrefix,
    super.tableRelations,
  });

  _i2.CommentWithoutManyRelationsTable? _comments;

  _i2.CommentWithoutManyRelationsTable get _commentsTable {
    if (_comments != null) return _comments!;
    _comments = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'comments',
      foreignTableName: _i2.Comment.t.tableName,
      column: id,
      foreignColumnName: _i2.Comment.t.orderId.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.CommentWithoutManyRelationsTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _comments!;
  }

  _i1.ManyRelation comments(
      _i2.CommentWithoutManyRelationsExpressionBuilder where) {
    return _i1.ManyRelation(
      table: _commentsTable,
      where: where(_commentsTable),
      foreignIdColumnName: 'orderId',
    );
  }
}

class OrderWithoutManyRelationsTable extends _i1.Table {
  OrderWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'order') {
    description = _i1.ColumnString(
      'description',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    customerId = _i1.ColumnInt(
      'customerId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString description;

  late final _i1.ColumnInt customerId;

  _i2.CustomerTable? _customer;

  _i2.CustomerTable get customer {
    if (_customer != null) return _customer!;
    _customer = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'customer',
      foreignTableName: _i2.Customer.t.tableName,
      column: customerId,
      foreignColumnName: _i2.Customer.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.CustomerTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _customer!;
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
    return null;
  }
}

@Deprecated('Use OrderTable.t instead.')
OrderTable tOrder = OrderTable();

class OrderInclude extends _i1.Include {
  OrderInclude._({_i2.CustomerInclude? customer}) {
    _customer = customer;
  }

  _i2.CustomerInclude? _customer;

  @override
  Map<String, _i1.Include?> get includes => {'customer': _customer};
  @override
  _i1.Table get table => Order.t;
}

class OrderRepository {
  const OrderRepository._();

  final attach = const OrderAttachRepository._();
}

class OrderAttachRepository {
  const OrderAttachRepository._();

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
    await session.db.update(
      $order,
      columns: [Order.t.customerId],
    );
  }
}
