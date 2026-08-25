/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import '../../changed_id_type/one_to_many/order.dart' as _ivss21qh;

abstract class CustomerInt
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CustomerInt._({
    this.id,
    required this.name,
    this.orders,
  });

  factory CustomerInt({
    int? id,
    required String name,
    List<_ivss21qh.OrderUuid>? orders,
  }) = _CustomerIntImpl;

  factory CustomerInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: jsonSerialization['orders'] == null
          ? null
          : _i08l111i.Protocol().deserialize<List<_ivss21qh.OrderUuid>>(
              jsonSerialization['orders'],
            ),
    );
  }

  static final t = CustomerIntTable();

  static const db = CustomerIntRepository._();

  @override
  int? id;

  String name;

  List<_ivss21qh.OrderUuid>? orders;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CustomerInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerInt copyWith({
    int? id,
    String? name,
    List<_ivss21qh.OrderUuid>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerInt',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerInt',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static CustomerIntInclude include({
    _ivss21qh.OrderUuidIncludeList? orders,
    _is.SelectColumnsBuilder<CustomerIntTable>? select,
  }) {
    return CustomerIntInclude._(
      orders: orders,
      selectedColumns: select?.call(CustomerInt.t),
    );
  }

  static CustomerIntIncludeList includeList({
    _is.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    CustomerIntInclude? include,
    _is.SelectColumnsBuilder<CustomerIntTable>? select,
  }) {
    return CustomerIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      include: include,
      selectedColumns: select?.call(CustomerInt.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerIntImpl extends CustomerInt {
  _CustomerIntImpl({
    int? id,
    required String name,
    List<_ivss21qh.OrderUuid>? orders,
  }) : super._(
         id: id,
         name: name,
         orders: orders,
       );

  /// Returns a shallow copy of this [CustomerInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return CustomerInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_ivss21qh.OrderUuid>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CustomerIntUpdateTable extends _is.UpdateTable<CustomerIntTable> {
  CustomerIntUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class CustomerIntTable extends _is.Table<int?> {
  CustomerIntTable({super.tableRelation}) : super(tableName: 'customer_int') {
    updateTable = CustomerIntUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final CustomerIntUpdateTable updateTable;

  late final _is.ColumnString name;

  _ivss21qh.OrderUuidTable? ___orders;

  _is.ManyRelation<_ivss21qh.OrderUuidTable>? _orders;

  _ivss21qh.OrderUuidTable get __orders {
    if (___orders != null) return ___orders!;
    ___orders = _is.createRelationTable(
      relationFieldName: '__orders',
      field: CustomerInt.t.id,
      foreignField: _ivss21qh.OrderUuid.t.customerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ivss21qh.OrderUuidTable(tableRelation: foreignTableRelation),
    );
    return ___orders!;
  }

  _is.ManyRelation<_ivss21qh.OrderUuidTable> get orders {
    if (_orders != null) return _orders!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'orders',
      field: CustomerInt.t.id,
      foreignField: _ivss21qh.OrderUuid.t.customerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ivss21qh.OrderUuidTable(tableRelation: foreignTableRelation),
    );
    _orders = _is.ManyRelation<_ivss21qh.OrderUuidTable>(
      tableWithRelations: relationTable,
      table: _ivss21qh.OrderUuidTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _orders!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'orders') {
      return __orders;
    }
    return null;
  }
}

class CustomerIntInclude extends _is.IncludeObject {
  CustomerIntInclude._({
    _ivss21qh.OrderUuidIncludeList? orders,
    this.selectedColumns,
  }) {
    _orders = orders;
  }

  _ivss21qh.OrderUuidIncludeList? _orders;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'orders': _orders};

  @override
  _is.Table<int?> get table => CustomerInt.t;
}

class CustomerIntIncludeList extends _is.IncludeList {
  CustomerIntIncludeList._({
    _is.WhereExpressionBuilder<CustomerIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(CustomerInt.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CustomerInt.t;
}

class CustomerIntRepository {
  const CustomerIntRepository._();

  final attach = const CustomerIntAttachRepository._();

  final attachRow = const CustomerIntAttachRowRepository._();

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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    _is.Transaction? transaction,
    CustomerIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CustomerInt>(
      where: where?.call(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerIntTable>? where,
    int? offset,
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    _is.Transaction? transaction,
    CustomerIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CustomerInt>(
      where: where?.call(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CustomerInt] by its [id] or null if no such row exists.
  Future<CustomerInt?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CustomerIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CustomerInt>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    _is.Transaction? transaction,
    CustomerIntInclude? include,
    _is.SelectColumnsBuilder<CustomerIntTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<CustomerInt>(
      where: where?.call(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(CustomerInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerIntTable>? where,
    int? offset,
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    _is.Transaction? transaction,
    CustomerIntInclude? include,
    _is.SelectColumnsBuilder<CustomerIntTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<CustomerInt>(
      where: where?.call(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(CustomerInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    CustomerIntInclude? include,
    _is.SelectColumnsBuilder<CustomerIntTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<CustomerInt>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(CustomerInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CustomerInt]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomerInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerInt>> insert(
    _is.DatabaseSession session,
    List<CustomerInt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CustomerInt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CustomerInt] and returns the inserted row.
  ///
  /// The returned [CustomerInt] will have its `id` field set.
  Future<CustomerInt> insertRow(
    _is.DatabaseSession session,
    CustomerInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomerInt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CustomerInt]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [CustomerInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerInt>> upsert(
    _is.DatabaseSession session,
    List<CustomerInt> rows, {
    required _is.ColumnSelections<CustomerIntTable> conflictColumns,
    _is.ColumnSelections<CustomerIntTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerIntTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CustomerInt>(
      rows,
      conflictColumns: conflictColumns(CustomerInt.t),
      updateColumns: updateColumns?.call(CustomerInt.t),
      updateWhere: updateWhere?.call(CustomerInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CustomerInt] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [CustomerInt] will have its `id` field set.
  Future<CustomerInt?> upsertRow(
    _is.DatabaseSession session,
    CustomerInt row, {
    required _is.ColumnSelections<CustomerIntTable> conflictColumns,
    _is.ColumnSelections<CustomerIntTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerIntTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CustomerInt>(
      row,
      conflictColumns: conflictColumns(CustomerInt.t),
      updateColumns: updateColumns?.call(CustomerInt.t),
      updateWhere: updateWhere?.call(CustomerInt.t),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerInt>> update(
    _is.DatabaseSession session,
    List<CustomerInt> rows, {
    _is.ColumnSelections<CustomerIntTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CustomerInt>(
      rows,
      columns: columns?.call(CustomerInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CustomerInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomerInt> updateRow(
    _is.DatabaseSession session,
    CustomerInt row, {
    _is.ColumnSelections<CustomerIntTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CustomerIntUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomerInt>(
      id,
      columnValues: columnValues(CustomerInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerInt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CustomerIntUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CustomerIntTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CustomerInt>(
      columnValues: columnValues(CustomerInt.t.updateTable),
      where: where(CustomerInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CustomerInt]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerInt>> delete(
    _is.DatabaseSession session,
    List<CustomerInt> rows, {
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CustomerInt>(
      rows,
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CustomerInt].
  Future<CustomerInt> deleteRow(
    _is.DatabaseSession session,
    CustomerInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomerInt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerInt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerIntTable> where,
    _is.OrderByBuilder<CustomerIntTable>? orderBy,
    _is.OrderByListBuilder<CustomerIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CustomerInt>(
      where: where(CustomerInt.t),
      orderBy: orderBy?.call(CustomerInt.t),
      orderByList: orderByList?.call(CustomerInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerIntTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CustomerInt>(
      where: where?.call(CustomerInt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CustomerInt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerIntTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CustomerInt>(
      where: where(CustomerInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CustomerIntAttachRepository {
  const CustomerIntAttachRepository._();

  /// Creates a relation between this [CustomerInt] and the given [OrderUuid]s
  /// by setting each [OrderUuid]'s foreign key `customerId` to refer to this [CustomerInt].
  Future<void> orders(
    _is.DatabaseSession session,
    CustomerInt customerInt,
    List<_ivss21qh.OrderUuid> orderUuid, {
    _is.Transaction? transaction,
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
    await session.db.update<_ivss21qh.OrderUuid>(
      $orderUuid,
      columns: [_ivss21qh.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerIntAttachRowRepository {
  const CustomerIntAttachRowRepository._();

  /// Creates a relation between this [CustomerInt] and the given [OrderUuid]
  /// by setting the [OrderUuid]'s foreign key `customerId` to refer to this [CustomerInt].
  Future<void> orders(
    _is.DatabaseSession session,
    CustomerInt customerInt,
    _ivss21qh.OrderUuid orderUuid, {
    _is.Transaction? transaction,
  }) async {
    if (orderUuid.id == null) {
      throw ArgumentError.notNull('orderUuid.id');
    }
    if (customerInt.id == null) {
      throw ArgumentError.notNull('customerInt.id');
    }

    var $orderUuid = orderUuid.copyWith(customerId: customerInt.id);
    await session.db.updateRow<_ivss21qh.OrderUuid>(
      $orderUuid,
      columns: [_ivss21qh.OrderUuid.t.customerId],
      transaction: transaction,
    );
  }
}
