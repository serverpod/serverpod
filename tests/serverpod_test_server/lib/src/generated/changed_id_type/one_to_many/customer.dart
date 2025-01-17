/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/one_to_many/order.dart' as _i2;

abstract class CustomerInt
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  CustomerInt._({
    this.id,
    required this.name,
    this.orders,
  });

  factory CustomerInt({
    int? id,
    required String name,
    List<_i2.OrderUuid>? orders,
  }) = _CustomerIntImpl;

  factory CustomerInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: (jsonSerialization['orders'] as List?)
          ?.map((e) => _i2.OrderUuid.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = CustomerIntTable();

  static const db = CustomerIntRepository._();

  @override
  int? id;

  String name;

  List<_i2.OrderUuid>? orders;

  @override
  _i1.Table<int> get table => t;

  CustomerInt copyWith({
    int? id,
    String? name,
    List<_i2.OrderUuid>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static CustomerIntInclude include({_i2.OrderUuidIncludeList? orders}) {
    return CustomerIntInclude._(orders: orders);
  }

  static CustomerIntIncludeList includeList({
    _i1.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerIntTable>? orderByList,
    CustomerIntInclude? include,
  }) {
    return CustomerIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerInt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CustomerInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerIntImpl extends CustomerInt {
  _CustomerIntImpl({
    int? id,
    required String name,
    List<_i2.OrderUuid>? orders,
  }) : super._(
          id: id,
          name: name,
          orders: orders,
        );

  @override
  CustomerInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return CustomerInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_i2.OrderUuid>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CustomerIntTable extends _i1.Table<int> {
  CustomerIntTable({super.tableRelation}) : super(tableName: 'customer_int') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.OrderUuidTable? ___orders;

  _i1.ManyRelation<_i2.OrderUuidTable>? _orders;

  _i2.OrderUuidTable get __orders {
    if (___orders != null) return ___orders!;
    ___orders = _i1.createRelationTable(
      relationFieldName: '__orders',
      field: CustomerInt.t.id,
      foreignField: _i2.OrderUuid.t.customerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderUuidTable(tableRelation: foreignTableRelation),
    );
    return ___orders!;
  }

  _i1.ManyRelation<_i2.OrderUuidTable> get orders {
    if (_orders != null) return _orders!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'orders',
      field: CustomerInt.t.id,
      foreignField: _i2.OrderUuid.t.customerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderUuidTable(tableRelation: foreignTableRelation),
    );
    _orders = _i1.ManyRelation<_i2.OrderUuidTable>(
      tableWithRelations: relationTable,
      table: _i2.OrderUuidTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _orders!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'orders') {
      return __orders;
    }
    return null;
  }
}

class CustomerIntInclude extends _i1.IncludeObject {
  CustomerIntInclude._({_i2.OrderUuidIncludeList? orders}) {
    _orders = orders;
  }

  _i2.OrderUuidIncludeList? _orders;

  @override
  Map<String, _i1.Include?> get includes => {'orders': _orders};

  @override
  _i1.Table<int> get table => CustomerInt.t;
}

class CustomerIntIncludeList extends _i1.IncludeList {
  CustomerIntIncludeList._({
    _i1.WhereExpressionBuilder<CustomerIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CustomerInt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => CustomerInt.t;
}

class CustomerIntRepository {
  const CustomerIntRepository._();

  final attach = const CustomerIntAttachRepository._();

  final attachRow = const CustomerIntAttachRowRepository._();

  final detach = const CustomerIntDetachRepository._();

  final detachRow = const CustomerIntDetachRowRepository._();

  Future<List<CustomerInt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerIntTable>? orderByList,
    _i1.Transaction? transaction,
    CustomerIntInclude? include,
  }) async {
    return session.db.find<int, CustomerInt>(
      where: where?.call(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CustomerInt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CustomerIntTable>? where,
    int? offset,
    _i1.OrderByBuilder<CustomerIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerIntTable>? orderByList,
    _i1.Transaction? transaction,
    CustomerIntInclude? include,
  }) async {
    return session.db.findFirstRow<int, CustomerInt>(
      where: where?.call(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CustomerInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CustomerIntInclude? include,
  }) async {
    return session.db.findById<int, CustomerInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<CustomerInt>> insert(
    _i1.Session session,
    List<CustomerInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<int, CustomerInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<CustomerInt> insertRow(
    _i1.Session session,
    CustomerInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<int, CustomerInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CustomerInt>> update(
    _i1.Session session,
    List<CustomerInt> rows, {
    _i1.ColumnSelections<CustomerIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<int, CustomerInt>(
      rows,
      columns: columns?.call(CustomerInt.t),
      transaction: transaction,
    );
  }

  Future<CustomerInt> updateRow(
    _i1.Session session,
    CustomerInt row, {
    _i1.ColumnSelections<CustomerIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<int, CustomerInt>(
      row,
      columns: columns?.call(CustomerInt.t),
      transaction: transaction,
    );
  }

  Future<List<CustomerInt>> delete(
    _i1.Session session,
    List<CustomerInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<int, CustomerInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<CustomerInt> deleteRow(
    _i1.Session session,
    CustomerInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<int, CustomerInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CustomerInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CustomerIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<int, CustomerInt>(
      where: where(CustomerInt.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<int, CustomerInt>(
      where: where?.call(CustomerInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CustomerIntAttachRepository {
  const CustomerIntAttachRepository._();

  Future<void> orders(
    _i1.Session session,
    CustomerInt customerInt,
    List<_i2.OrderUuid> orderUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (orderUuid.any((e) => e.id == null)) {
      throw ArgumentError.notNull('orderUuid.id');
    }
    if (customerInt.id == null) {
      throw ArgumentError.notNull('customerInt.id');
    }

    var $orderUuid =
        orderUuid.map((e) => e.copyWith(customerId: customerInt.id)).toList();
    await session.db.update<_i1.UuidValue, _i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerIntAttachRowRepository {
  const CustomerIntAttachRowRepository._();

  Future<void> orders(
    _i1.Session session,
    CustomerInt customerInt,
    _i2.OrderUuid orderUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (orderUuid.id == null) {
      throw ArgumentError.notNull('orderUuid.id');
    }
    if (customerInt.id == null) {
      throw ArgumentError.notNull('customerInt.id');
    }

    var $orderUuid = orderUuid.copyWith(customerId: customerInt.id);
    await session.db.updateRow<_i1.UuidValue, _i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerIntDetachRepository {
  const CustomerIntDetachRepository._();

  Future<void> orders(
    _i1.Session session,
    List<_i2.OrderUuid> orderUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (orderUuid.any((e) => e.id == null)) {
      throw ArgumentError.notNull('orderUuid.id');
    }

    var $orderUuid =
        orderUuid.map((e) => e.copyWith(customerId: null)).toList();
    await session.db.update<_i1.UuidValue, _i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerIntDetachRowRepository {
  const CustomerIntDetachRowRepository._();

  Future<void> orders(
    _i1.Session session,
    _i2.OrderUuid orderUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (orderUuid.id == null) {
      throw ArgumentError.notNull('orderUuid.id');
    }

    var $orderUuid = orderUuid.copyWith(customerId: null);
    await session.db.updateRow<_i1.UuidValue, _i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}
