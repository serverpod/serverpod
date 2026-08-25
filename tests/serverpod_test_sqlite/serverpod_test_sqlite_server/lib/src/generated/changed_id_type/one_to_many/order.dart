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
import '../../changed_id_type/one_to_many/comment.dart' as _i7e4crca;
import '../../changed_id_type/one_to_many/customer.dart' as _iwdajoe0;

abstract class OrderUuid
    implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  OrderUuid._({
    _is.UuidValue? id,
    required this.description,
    required this.customerId,
    this.customer,
    this.comments,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory OrderUuid({
    _is.UuidValue? id,
    required String description,
    required int customerId,
    _iwdajoe0.CustomerInt? customer,
    List<_i7e4crca.CommentInt>? comments,
  }) = _OrderUuidImpl;

  factory OrderUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      description: jsonSerialization['description'] as String,
      customerId: jsonSerialization['customerId'] as int,
      customer: jsonSerialization['customer'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_iwdajoe0.CustomerInt>(
              jsonSerialization['customer'],
            ),
      comments: jsonSerialization['comments'] == null
          ? null
          : _i08l111i.Protocol().deserialize<List<_i7e4crca.CommentInt>>(
              jsonSerialization['comments'],
            ),
    );
  }

  static final t = OrderUuidTable();

  static const db = OrderUuidRepository._();

  @override
  _is.UuidValue id;

  String description;

  int customerId;

  _iwdajoe0.CustomerInt? customer;

  List<_i7e4crca.CommentInt>? comments;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [OrderUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OrderUuid copyWith({
    _is.UuidValue? id,
    String? description,
    int? customerId,
    _iwdajoe0.CustomerInt? customer,
    List<_i7e4crca.CommentInt>? comments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderUuid',
      'id': id.toJson(),
      'description': description,
      'customerId': customerId,
      if (customer != null) 'customer': customer?.toJson(),
      if (comments != null)
        'comments': comments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderUuid',
      'id': id.toJson(),
      'description': description,
      'customerId': customerId,
      if (customer != null) 'customer': customer?.toJsonForProtocol(),
      if (comments != null)
        'comments': comments?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static OrderUuidInclude include({
    _iwdajoe0.CustomerIntInclude? customer,
    _i7e4crca.CommentIntIncludeList? comments,
    _is.SelectColumnsBuilder<OrderUuidTable>? select,
  }) {
    return OrderUuidInclude._(
      customer: customer,
      comments: comments,
      selectedColumns: select?.call(OrderUuid.t),
    );
  }

  static OrderUuidIncludeList includeList({
    _is.WhereExpressionBuilder<OrderUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    OrderUuidInclude? include,
    _is.SelectColumnsBuilder<OrderUuidTable>? select,
  }) {
    return OrderUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      include: include,
      selectedColumns: select?.call(OrderUuid.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderUuidImpl extends OrderUuid {
  _OrderUuidImpl({
    _is.UuidValue? id,
    required String description,
    required int customerId,
    _iwdajoe0.CustomerInt? customer,
    List<_i7e4crca.CommentInt>? comments,
  }) : super._(
         id: id,
         description: description,
         customerId: customerId,
         customer: customer,
         comments: comments,
       );

  /// Returns a shallow copy of this [OrderUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OrderUuid copyWith({
    _is.UuidValue? id,
    String? description,
    int? customerId,
    Object? customer = _Undefined,
    Object? comments = _Undefined,
  }) {
    return OrderUuid(
      id: id ?? this.id,
      description: description ?? this.description,
      customerId: customerId ?? this.customerId,
      customer: customer is _iwdajoe0.CustomerInt?
          ? customer
          : this.customer?.copyWith(),
      comments: comments is List<_i7e4crca.CommentInt>?
          ? comments
          : this.comments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class OrderUuidUpdateTable extends _is.UpdateTable<OrderUuidTable> {
  OrderUuidUpdateTable(super.table);

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<int, int> customerId(int value) => _is.ColumnValue(
    table.customerId,
    value,
  );
}

class OrderUuidTable extends _is.Table<_is.UuidValue> {
  OrderUuidTable({super.tableRelation}) : super(tableName: 'order_uuid') {
    updateTable = OrderUuidUpdateTable(this);
    description = _is.ColumnString(
      'description',
      this,
    );
    customerId = _is.ColumnInt(
      'customerId',
      this,
    );
  }

  late final OrderUuidUpdateTable updateTable;

  late final _is.ColumnString description;

  late final _is.ColumnInt customerId;

  _iwdajoe0.CustomerIntTable? _customer;

  _i7e4crca.CommentIntTable? ___comments;

  _is.ManyRelation<_i7e4crca.CommentIntTable>? _comments;

  _iwdajoe0.CustomerIntTable get customer {
    if (_customer != null) return _customer!;
    _customer = _is.createRelationTable(
      relationFieldName: 'customer',
      field: OrderUuid.t.customerId,
      foreignField: _iwdajoe0.CustomerInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iwdajoe0.CustomerIntTable(tableRelation: foreignTableRelation),
    );
    return _customer!;
  }

  _i7e4crca.CommentIntTable get __comments {
    if (___comments != null) return ___comments!;
    ___comments = _is.createRelationTable(
      relationFieldName: '__comments',
      field: OrderUuid.t.id,
      foreignField: _i7e4crca.CommentInt.t.orderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7e4crca.CommentIntTable(tableRelation: foreignTableRelation),
    );
    return ___comments!;
  }

  _is.ManyRelation<_i7e4crca.CommentIntTable> get comments {
    if (_comments != null) return _comments!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'comments',
      field: OrderUuid.t.id,
      foreignField: _i7e4crca.CommentInt.t.orderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7e4crca.CommentIntTable(tableRelation: foreignTableRelation),
    );
    _comments = _is.ManyRelation<_i7e4crca.CommentIntTable>(
      tableWithRelations: relationTable,
      table: _i7e4crca.CommentIntTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _comments!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    description,
    customerId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'customer') {
      return customer;
    }
    if (relationField == 'comments') {
      return __comments;
    }
    return null;
  }
}

class OrderUuidInclude extends _is.IncludeObject {
  OrderUuidInclude._({
    _iwdajoe0.CustomerIntInclude? customer,
    _i7e4crca.CommentIntIncludeList? comments,
    this.selectedColumns,
  }) {
    _customer = customer;
    _comments = comments;
  }

  _iwdajoe0.CustomerIntInclude? _customer;

  _i7e4crca.CommentIntIncludeList? _comments;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'customer': _customer,
    'comments': _comments,
  };

  @override
  _is.Table<_is.UuidValue> get table => OrderUuid.t;
}

class OrderUuidIncludeList extends _is.IncludeList {
  OrderUuidIncludeList._({
    _is.WhereExpressionBuilder<OrderUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(OrderUuid.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => OrderUuid.t;
}

class OrderUuidRepository {
  const OrderUuidRepository._();

  final attach = const OrderUuidAttachRepository._();

  final attachRow = const OrderUuidAttachRowRepository._();

  /// Returns a list of [OrderUuid]s matching the given query parameters.
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
  Future<List<OrderUuid>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    _is.Transaction? transaction,
    OrderUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderUuid>(
      where: where?.call(OrderUuid.t),
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderUuid] matching the given query parameters.
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
  Future<OrderUuid?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderUuidTable>? where,
    int? offset,
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    _is.Transaction? transaction,
    OrderUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderUuid>(
      where: where?.call(OrderUuid.t),
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderUuid] by its [id] or null if no such row exists.
  Future<OrderUuid?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    OrderUuidInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderUuid>(
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

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    _is.Transaction? transaction,
    OrderUuidInclude? include,
    _is.SelectColumnsBuilder<OrderUuidTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<OrderUuid>(
      where: where?.call(OrderUuid.t),
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(OrderUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderUuidTable>? where,
    int? offset,
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    _is.Transaction? transaction,
    OrderUuidInclude? include,
    _is.SelectColumnsBuilder<OrderUuidTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<OrderUuid>(
      where: where?.call(OrderUuid.t),
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(OrderUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    OrderUuidInclude? include,
    _is.SelectColumnsBuilder<OrderUuidTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<OrderUuid>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(OrderUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderUuid]s will have their `id` fields set.
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
  Future<List<OrderUuid>> insert(
    _is.DatabaseSession session,
    List<OrderUuid> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<OrderUuid>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [OrderUuid] and returns the inserted row.
  ///
  /// The returned [OrderUuid] will have its `id` field set.
  Future<OrderUuid> insertRow(
    _is.DatabaseSession session,
    OrderUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [OrderUuid]s in the list and returns the resulting rows.
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
  /// The returned [OrderUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrderUuid>> upsert(
    _is.DatabaseSession session,
    List<OrderUuid> rows, {
    required _is.ColumnSelections<OrderUuidTable> conflictColumns,
    _is.ColumnSelections<OrderUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<OrderUuidTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<OrderUuid>(
      rows,
      conflictColumns: conflictColumns(OrderUuid.t),
      updateColumns: updateColumns?.call(OrderUuid.t),
      updateWhere: updateWhere?.call(OrderUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [OrderUuid] and returns the resulting row.
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
  /// The returned [OrderUuid] will have its `id` field set.
  Future<OrderUuid?> upsertRow(
    _is.DatabaseSession session,
    OrderUuid row, {
    required _is.ColumnSelections<OrderUuidTable> conflictColumns,
    _is.ColumnSelections<OrderUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<OrderUuidTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<OrderUuid>(
      row,
      conflictColumns: conflictColumns(OrderUuid.t),
      updateColumns: updateColumns?.call(OrderUuid.t),
      updateWhere: updateWhere?.call(OrderUuid.t),
      transaction: transaction,
    );
  }

  /// Updates all [OrderUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrderUuid>> update(
    _is.DatabaseSession session,
    List<OrderUuid> rows, {
    _is.ColumnSelections<OrderUuidTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<OrderUuid>(
      rows,
      columns: columns?.call(OrderUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [OrderUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderUuid> updateRow(
    _is.DatabaseSession session,
    OrderUuid row, {
    _is.ColumnSelections<OrderUuidTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderUuid>(
      row,
      columns: columns?.call(OrderUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderUuid] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderUuid?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<OrderUuidUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderUuid>(
      id,
      columnValues: columnValues(OrderUuid.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderUuid]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrderUuid>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<OrderUuidUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<OrderUuidTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<OrderUuid>(
      columnValues: columnValues(OrderUuid.t.updateTable),
      where: where(OrderUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [OrderUuid]s in the list and returns the deleted rows.
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
  Future<List<OrderUuid>> delete(
    _is.DatabaseSession session,
    List<OrderUuid> rows, {
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<OrderUuid>(
      rows,
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [OrderUuid].
  Future<OrderUuid> deleteRow(
    _is.DatabaseSession session,
    OrderUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderUuid>(
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
  Future<List<OrderUuid>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrderUuidTable> where,
    _is.OrderByBuilder<OrderUuidTable>? orderBy,
    _is.OrderByListBuilder<OrderUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<OrderUuid>(
      where: where(OrderUuid.t),
      orderBy: orderBy?.call(OrderUuid.t),
      orderByList: orderByList?.call(OrderUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderUuidTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<OrderUuid>(
      where: where?.call(OrderUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderUuid] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrderUuidTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderUuid>(
      where: where(OrderUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class OrderUuidAttachRepository {
  const OrderUuidAttachRepository._();

  /// Creates a relation between this [OrderUuid] and the given [CommentInt]s
  /// by setting each [CommentInt]'s foreign key `orderId` to refer to this [OrderUuid].
  Future<void> comments(
    _is.DatabaseSession session,
    OrderUuid orderUuid,
    List<_i7e4crca.CommentInt> commentInt, {
    _is.Transaction? transaction,
  }) async {
    if (commentInt.any((e) => e.id == null)) {
      throw ArgumentError.notNull('commentInt.id');
    }
    if (orderUuid.id == null) {
      throw ArgumentError.notNull('orderUuid.id');
    }

    var $commentInt = commentInt
        .map((e) => e.copyWith(orderId: orderUuid.id))
        .toList();
    await session.db.update<_i7e4crca.CommentInt>(
      $commentInt,
      columns: [_i7e4crca.CommentInt.t.orderId],
      transaction: transaction,
    );
  }
}

class OrderUuidAttachRowRepository {
  const OrderUuidAttachRowRepository._();

  /// Creates a relation between the given [OrderUuid] and [CustomerInt]
  /// by setting the [OrderUuid]'s foreign key `customerId` to refer to the [CustomerInt].
  Future<void> customer(
    _is.DatabaseSession session,
    OrderUuid orderUuid,
    _iwdajoe0.CustomerInt customer, {
    _is.Transaction? transaction,
  }) async {
    if (orderUuid.id == null) {
      throw ArgumentError.notNull('orderUuid.id');
    }
    if (customer.id == null) {
      throw ArgumentError.notNull('customer.id');
    }

    var $orderUuid = orderUuid.copyWith(customerId: customer.id);
    await session.db.updateRow<OrderUuid>(
      $orderUuid,
      columns: [OrderUuid.t.customerId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [OrderUuid] and the given [CommentInt]
  /// by setting the [CommentInt]'s foreign key `orderId` to refer to this [OrderUuid].
  Future<void> comments(
    _is.DatabaseSession session,
    OrderUuid orderUuid,
    _i7e4crca.CommentInt commentInt, {
    _is.Transaction? transaction,
  }) async {
    if (commentInt.id == null) {
      throw ArgumentError.notNull('commentInt.id');
    }
    if (orderUuid.id == null) {
      throw ArgumentError.notNull('orderUuid.id');
    }

    var $commentInt = commentInt.copyWith(orderId: orderUuid.id);
    await session.db.updateRow<_i7e4crca.CommentInt>(
      $commentInt,
      columns: [_i7e4crca.CommentInt.t.orderId],
      transaction: transaction,
    );
  }
}
