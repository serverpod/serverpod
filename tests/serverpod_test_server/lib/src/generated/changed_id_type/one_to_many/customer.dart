/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/one_to_many/order.dart' as _i2;

abstract class CustomerInt
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CustomerInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  /// Returns a shallow copy of this [CustomerInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

class CustomerIntUpdateTable extends _i1.UpdateTable<CustomerIntTable> {
  CustomerIntUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );
}

class CustomerIntTable extends _i1.Table<int?> {
  CustomerIntTable({super.tableRelation}) : super(tableName: 'customer_int') {
    updateTable = CustomerIntUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final CustomerIntUpdateTable updateTable;

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
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
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
  _i1.Table<int?> get table => CustomerInt.t;
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
  _i1.Table<int?> get table => CustomerInt.t;
}

class CustomerIntRepository {
  const CustomerIntRepository._();

  final attach = const CustomerIntAttachRepository._();

  final attachRow = const CustomerIntAttachRowRepository._();

  final detach = const CustomerIntDetachRepository._();

  final detachRow = const CustomerIntDetachRowRepository._();

  /// Returns a list of [CustomerInt]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
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
    return session.db.find<CustomerInt>(
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

  /// Returns the first matching [CustomerInt] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
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
    return session.db.findFirstRow<CustomerInt>(
      where: where?.call(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CustomerInt] by its [id] or null if no such row exists.
  Future<CustomerInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CustomerIntInclude? include,
  }) async {
    return session.db.findById<CustomerInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CustomerInt]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomerInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CustomerInt>> insert(
    _i1.Session session,
    List<CustomerInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CustomerInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CustomerInt] and returns the inserted row.
  ///
  /// The returned [CustomerInt] will have its `id` field set.
  Future<CustomerInt> insertRow(
    _i1.Session session,
    CustomerInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomerInt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CustomerInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CustomerInt>> update(
    _i1.Session session,
    List<CustomerInt> rows, {
    _i1.ColumnSelections<CustomerIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CustomerInt>(
      rows,
      columns: columns?.call(CustomerInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomerInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomerInt> updateRow(
    _i1.Session session,
    CustomerInt row, {
    _i1.ColumnSelections<CustomerIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CustomerInt>(
      row,
      columns: columns?.call(CustomerInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomerInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CustomerInt?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CustomerIntUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomerInt>(
      id,
      columnValues: columnValues(CustomerInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CustomerInt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CustomerIntUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CustomerIntTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerIntTable>? orderBy,
    _i1.OrderByListBuilder<CustomerIntTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CustomerInt>(
      columnValues: columnValues(CustomerInt.t.updateTable),
      where: where(CustomerInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CustomerInt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CustomerInt>> delete(
    _i1.Session session,
    List<CustomerInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CustomerInt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CustomerInt].
  Future<CustomerInt> deleteRow(
    _i1.Session session,
    CustomerInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomerInt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CustomerInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CustomerIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CustomerInt>(
      where: where(CustomerInt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CustomerInt>(
      where: where?.call(CustomerInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CustomerIntAttachRepository {
  const CustomerIntAttachRepository._();

  /// Creates a relation between this [CustomerInt] and the given [OrderUuid]s
  /// by setting each [OrderUuid]'s foreign key `customerId` to refer to this [CustomerInt].
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

    var $orderUuid = orderUuid
        .map((e) => e.copyWith(customerId: customerInt.id))
        .toList();
    await session.db.update<_i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerIntAttachRowRepository {
  const CustomerIntAttachRowRepository._();

  /// Creates a relation between this [CustomerInt] and the given [OrderUuid]
  /// by setting the [OrderUuid]'s foreign key `customerId` to refer to this [CustomerInt].
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
    await session.db.updateRow<_i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerIntDetachRepository {
  const CustomerIntDetachRepository._();

  /// Detaches the relation between this [CustomerInt] and the given [OrderUuid]
  /// by setting the [OrderUuid]'s foreign key `customerId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> orders(
    _i1.Session session,
    List<_i2.OrderUuid> orderUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (orderUuid.any((e) => e.id == null)) {
      throw ArgumentError.notNull('orderUuid.id');
    }

    var $orderUuid = orderUuid
        .map((e) => e.copyWith(customerId: null))
        .toList();
    await session.db.update<_i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerIntDetachRowRepository {
  const CustomerIntDetachRowRepository._();

  /// Detaches the relation between this [CustomerInt] and the given [OrderUuid]
  /// by setting the [OrderUuid]'s foreign key `customerId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> orders(
    _i1.Session session,
    _i2.OrderUuid orderUuid, {
    _i1.Transaction? transaction,
  }) async {
    if (orderUuid.id == null) {
      throw ArgumentError.notNull('orderUuid.id');
    }

    var $orderUuid = orderUuid.copyWith(customerId: null);
    await session.db.updateRow<_i2.OrderUuid>(
      $orderUuid,
      columns: [_i2.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}
