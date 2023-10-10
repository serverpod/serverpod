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
    required this.customerId,
    this.customer,
    this.items,
  }) : super(id);

  factory Order({
    int? id,
    required String description,
    required int customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? items,
  }) = _OrderImpl;

  factory Order.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Order(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      customerId: serializationManager
          .deserialize<int>(jsonSerialization['customerId']),
      customer: serializationManager
          .deserialize<_i2.Customer?>(jsonSerialization['customer']),
      items: serializationManager
          .deserialize<List<_i2.Comment>?>(jsonSerialization['items']),
    );
  }

  static final t = OrderTable();

  static const db = OrderRepository._();

  String description;

  int customerId;

  _i2.Customer? customer;

  List<_i2.Comment>? items;

  @override
  _i1.Table get table => t;

  Order copyWith({
    int? id,
    String? description,
    int? customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'customerId': customerId,
      'customer': customer,
      'items': items,
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
      'customerId': customerId,
      'customer': customer,
      'items': items,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
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
    required int customerId,
    _i2.Customer? customer,
    List<_i2.Comment>? items,
  }) : super._(
          id: id,
          description: description,
          customerId: customerId,
          customer: customer,
          items: items,
        );

  @override
  Order copyWith({
    Object? id = _Undefined,
    String? description,
    int? customerId,
    Object? customer = _Undefined,
    Object? items = _Undefined,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      customerId: customerId ?? this.customerId,
      customer:
          customer is _i2.Customer? ? customer : this.customer?.copyWith(),
      items: items is List<_i2.Comment>? ? items : this.items?.clone(),
    );
  }
}

typedef OrderExpressionBuilder = _i1.Expression Function(OrderTable);

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

  _i1.ManyRelation<_i2.CommentTable>? _items;

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

  _i1.ManyRelation<_i2.CommentTable> get items {
    if (_items != null) return _items!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'items',
      field: Order.t.id,
      foreignField: _i2.Comment.t.orderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CommentTable(tableRelation: foreignTableRelation),
    );
    _items = _i1.ManyRelation<_i2.CommentTable>(
      tableWithRelations: relationTable,
      table: _i2.Comment.t,
    );
    return _items!;
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

  final attachRow = const OrderAttachRowRepository._();

  Future<List<Order>> find(
    _i1.Session session, {
    OrderExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
    OrderInclude? include,
  }) async {
    return session.dbNext.find<Order>(
      where: where?.call(Order.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  Future<Order?> findRow(
    _i1.Session session, {
    OrderExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
    OrderInclude? include,
  }) async {
    return session.dbNext.findRow<Order>(
      where: where?.call(Order.t),
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
    return session.dbNext.findById<Order>(
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
    return session.dbNext.insert<Order>(
      rows,
      transaction: transaction,
    );
  }

  Future<Order> insertRow(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Order>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Order>> update(
    _i1.Session session,
    List<Order> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Order>(
      rows,
      transaction: transaction,
    );
  }

  Future<Order> updateRow(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Order>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Order> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Order>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Order row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Order>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required OrderExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Order>(
      where: where(Order.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    OrderExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Order>(
      where: where?.call(Order.t),
      limit: limit,
      transaction: transaction,
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
    await session.dbNext.updateRow<Order>(
      $order,
      columns: [Order.t.customerId],
    );
  }
}
