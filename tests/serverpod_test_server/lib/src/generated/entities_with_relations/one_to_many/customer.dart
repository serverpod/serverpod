/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Customer extends _i1.TableRow {
  Customer._({
    int? id,
    required this.name,
    this.orders,
  }) : super(id);

  factory Customer({
    int? id,
    required String name,
    List<_i2.Order>? orders,
  }) = _CustomerImpl;

  factory Customer.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Customer(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      orders: serializationManager
          .deserialize<List<_i2.Order>?>(jsonSerialization['orders']),
    );
  }

  static final t = CustomerTable();

  static const db = CustomerRepository._();

  String name;

  List<_i2.Order>? orders;

  @override
  _i1.Table get table => t;

  Customer copyWith({
    int? id,
    String? name,
    List<_i2.Order>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'orders': orders,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'orders': orders,
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
      case 'name':
        name = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Customer>> find(
    _i1.Session session, {
    CustomerExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Customer>(
      where: where != null ? where(Customer.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<Customer?> findSingleRow(
    _i1.Session session, {
    CustomerExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Customer>(
      where: where != null ? where(Customer.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Customer?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Customer>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required CustomerExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Customer>(
      where: where(Customer.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Customer row, {
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
    Customer row, {
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
    Customer row, {
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
    CustomerExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Customer>(
      where: where != null ? where(Customer.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static CustomerInclude include() {
    return CustomerInclude._();
  }
}

class _Undefined {}

class _CustomerImpl extends Customer {
  _CustomerImpl({
    int? id,
    required String name,
    List<_i2.Order>? orders,
  }) : super._(
          id: id,
          name: name,
          orders: orders,
        );

  @override
  Customer copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return Customer(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_i2.Order>? ? orders : this.orders?.clone(),
    );
  }
}

typedef CustomerExpressionBuilder = _i1.Expression Function(CustomerTable);

class CustomerTable extends _i1.Table {
  CustomerTable({super.tableRelation}) : super(tableName: 'customer') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i1.ManyRelation<_i2.OrderTable>? _orders;

  _i1.ManyRelation<_i2.OrderTable> get orders {
    if (_orders != null) return _orders!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'orders',
      field: Customer.t.id,
      foreignField: _i2.Order.t.customerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderTable(tableRelation: foreignTableRelation),
    );
    _orders = _i1.ManyRelation<_i2.OrderTable>(
      tableWithRelations: relationTable,
      table: _i2.Order.t,
    );
    return _orders!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];
}

@Deprecated('Use CustomerTable.t instead.')
CustomerTable tCustomer = CustomerTable();

class CustomerInclude extends _i1.Include {
  CustomerInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => Customer.t;
}

class CustomerRepository {
  const CustomerRepository._();

  Future<List<Customer>> find(
    _i1.Session session, {
    CustomerExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<Customer>(
      where: where?.call(Customer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<Customer?> findRow(
    _i1.Session session, {
    CustomerExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<Customer>(
      where: where?.call(Customer.t),
      transaction: transaction,
    );
  }

  Future<Customer?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<Customer>(
      id,
      transaction: transaction,
    );
  }

  Future<List<Customer>> insert(
    _i1.Session session,
    List<Customer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Customer>(
      rows,
      transaction: transaction,
    );
  }

  Future<Customer> insertRow(
    _i1.Session session,
    Customer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Customer>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Customer>> update(
    _i1.Session session,
    List<Customer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Customer>(
      rows,
      transaction: transaction,
    );
  }

  Future<Customer> updateRow(
    _i1.Session session,
    Customer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Customer>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Customer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Customer>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Customer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Customer>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required CustomerExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Customer>(
      where: where(Customer.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    CustomerExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Customer>(
      where: where?.call(Customer.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
