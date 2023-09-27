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

  static Future<Customer?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Customer>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required CustomerWithoutManyRelationsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Customer>(
      where: where(Customer.t),
      transaction: transaction,
    );
  }

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
typedef CustomerWithoutManyRelationsExpressionBuilder = _i1.Expression Function(
    CustomerWithoutManyRelationsTable);

class CustomerTable extends CustomerWithoutManyRelationsTable {
  CustomerTable({
    super.queryPrefix,
    super.tableRelations,
  });

  _i2.OrderWithoutManyRelationsTable? _orders;

  _i2.OrderWithoutManyRelationsTable get _ordersTable {
    if (_orders != null) return _orders!;
    _orders = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'orders',
      foreignTableName: _i2.Order.t.tableName,
      column: id,
      foreignColumnName: _i2.Order.t.customerId.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.OrderWithoutManyRelationsTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _orders!;
  }

  _i1.ManyRelation orders(
      _i2.OrderWithoutManyRelationsExpressionBuilder where) {
    return _i1.ManyRelation(
      table: _ordersTable,
      where: where(_ordersTable),
      foreignIdColumnName: 'customerId',
    );
  }
}

class CustomerWithoutManyRelationsTable extends _i1.Table {
  CustomerWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'customer') {
    name = _i1.ColumnString(
      'name',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString name;

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
