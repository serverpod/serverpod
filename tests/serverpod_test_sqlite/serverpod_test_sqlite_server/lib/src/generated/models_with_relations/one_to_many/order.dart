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
import '../../models_with_relations/one_to_many/comment.dart' as _ij3ynzrj;
import '../../models_with_relations/one_to_many/customer.dart' as _i3fqgdb1;

abstract class Order implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Order._({
    this.id,
    required this.description,
    required this.customerId,
    this.customer,
    this.comments,
  });

  factory Order({
    int? id,
    required String description,
    required int customerId,
    _i3fqgdb1.Customer? customer,
    List<_ij3ynzrj.Comment>? comments,
  }) = _OrderImpl;

  factory Order.fromJson(Map<String, dynamic> jsonSerialization) {
    return Order(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      customerId: jsonSerialization['customerId'] as int,
      customer: jsonSerialization['customer'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_i3fqgdb1.Customer>(
              jsonSerialization['customer'],
            ),
      comments: jsonSerialization['comments'] == null
          ? null
          : _i08l111i.Protocol().deserialize<List<_ij3ynzrj.Comment>>(
              jsonSerialization['comments'],
            ),
    );
  }

  static final t = OrderTable();

  static const db = OrderRepository._();

  @override
  int? id;

  String description;

  int customerId;

  _i3fqgdb1.Customer? customer;

  List<_ij3ynzrj.Comment>? comments;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Order]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Order copyWith({
    int? id,
    String? description,
    int? customerId,
    _i3fqgdb1.Customer? customer,
    List<_ij3ynzrj.Comment>? comments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Order',
      if (id != null) 'id': id,
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
      '__className__': 'Order',
      if (id != null) 'id': id,
      'description': description,
      'customerId': customerId,
      if (customer != null) 'customer': customer?.toJsonForProtocol(),
      if (comments != null)
        'comments': comments?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  /// Builds a complete [OrderInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static OrderInclude include({
    _i3fqgdb1.CustomerInclude? customer,
    _ij3ynzrj.CommentIncludeList? comments,
  }) {
    return OrderInclude._(
      customer: customer,
      comments: comments,
    );
  }

  /// Builds a complete [OrderIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static OrderIncludeList includeList({
    _is.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    OrderInclude? include,
  }) {
    return OrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [OrderJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static OrderJsonInclude includeJson({
    _i3fqgdb1.CustomerJsonInclude? customer,
    _ij3ynzrj.CommentJsonIncludeList? comments,
    _is.SelectColumnsBuilder<OrderTable>? select,
  }) {
    return _OrderJsonInclude._(
      customer: customer,
      comments: comments,
      selectedColumns: select?.call(Order.t),
    );
  }

  /// Builds a JSON-compatible [OrderJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static OrderJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    OrderJsonInclude? include,
    _is.SelectColumnsBuilder<OrderTable>? select,
  }) {
    return _OrderJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      include: include,
      selectedColumns: select?.call(Order.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderImpl extends Order {
  _OrderImpl({
    int? id,
    required String description,
    required int customerId,
    _i3fqgdb1.Customer? customer,
    List<_ij3ynzrj.Comment>? comments,
  }) : super._(
         id: id,
         description: description,
         customerId: customerId,
         customer: customer,
         comments: comments,
       );

  /// Returns a shallow copy of this [Order]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
      customer: customer is _i3fqgdb1.Customer?
          ? customer
          : this.customer?.copyWith(),
      comments: comments is List<_ij3ynzrj.Comment>?
          ? comments
          : this.comments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class OrderUpdateTable extends _is.UpdateTable<OrderTable> {
  OrderUpdateTable(super.table);

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<int, int> customerId(int value) => _is.ColumnValue(
    table.customerId,
    value,
  );
}

class OrderTable extends _is.Table<int?> {
  OrderTable({super.tableRelation}) : super(tableName: 'order') {
    updateTable = OrderUpdateTable(this);
    description = _is.ColumnString(
      'description',
      this,
    );
    customerId = _is.ColumnInt(
      'customerId',
      this,
    );
  }

  late final OrderUpdateTable updateTable;

  late final _is.ColumnString description;

  late final _is.ColumnInt customerId;

  _i3fqgdb1.CustomerTable? _customer;

  _ij3ynzrj.CommentTable? ___comments;

  _is.ManyRelation<_ij3ynzrj.CommentTable>? _comments;

  _i3fqgdb1.CustomerTable get customer {
    if (_customer != null) return _customer!;
    _customer = _is.createRelationTable(
      relationFieldName: 'customer',
      field: Order.t.customerId,
      foreignField: _i3fqgdb1.Customer.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3fqgdb1.CustomerTable(tableRelation: foreignTableRelation),
    );
    return _customer!;
  }

  _ij3ynzrj.CommentTable get __comments {
    if (___comments != null) return ___comments!;
    ___comments = _is.createRelationTable(
      relationFieldName: '__comments',
      field: Order.t.id,
      foreignField: _ij3ynzrj.Comment.t.orderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ij3ynzrj.CommentTable(tableRelation: foreignTableRelation),
    );
    return ___comments!;
  }

  _is.ManyRelation<_ij3ynzrj.CommentTable> get comments {
    if (_comments != null) return _comments!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'comments',
      field: Order.t.id,
      foreignField: _ij3ynzrj.Comment.t.orderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ij3ynzrj.CommentTable(tableRelation: foreignTableRelation),
    );
    _comments = _is.ManyRelation<_ij3ynzrj.CommentTable>(
      tableWithRelations: relationTable,
      table: _ij3ynzrj.CommentTable(
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

abstract interface class OrderJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class OrderJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class OrderInclude extends _is.IncludeObject
    implements OrderJsonInclude, _is.FullModelInclude {
  OrderInclude._({
    _i3fqgdb1.CustomerInclude? customer,
    _ij3ynzrj.CommentIncludeList? comments,
  }) {
    _customer = customer;
    _comments = comments;
  }

  _i3fqgdb1.CustomerInclude? _customer;

  _ij3ynzrj.CommentIncludeList? _comments;

  @override
  Map<String, _is.Include?> get includes => {
    'customer': _customer,
    'comments': _comments,
  };

  @override
  _is.Table<int?> get table => Order.t;
}

final class OrderIncludeList extends _is.IncludeList
    implements OrderJsonIncludeList, _is.FullModelInclude {
  OrderIncludeList._({
    _is.WhereExpressionBuilder<OrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    OrderInclude? super.include,
  }) {
    super.where = where?.call(Order.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Order.t;
}

final class _OrderJsonInclude extends _is.IncludeObject
    implements OrderJsonInclude {
  _OrderJsonInclude._({
    _i3fqgdb1.CustomerJsonInclude? customer,
    _ij3ynzrj.CommentJsonIncludeList? comments,
    this.selectedColumns,
  }) {
    _customer = customer;
    _comments = comments;
  }

  _i3fqgdb1.CustomerJsonInclude? _customer;

  _ij3ynzrj.CommentJsonIncludeList? _comments;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'customer': _customer,
    'comments': _comments,
  };

  @override
  _is.Table<int?> get table => Order.t;
}

final class _OrderJsonIncludeList extends _is.IncludeList
    implements OrderJsonIncludeList {
  _OrderJsonIncludeList._({
    _is.WhereExpressionBuilder<OrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    OrderJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Order.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Order.t;
}

class OrderRepository {
  const OrderRepository._();

  final attach = const OrderAttachRepository._();

  final attachRow = const OrderAttachRowRepository._();

  /// Returns a list of [Order]s matching the given query parameters.
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
  Future<List<Order>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    _is.Transaction? transaction,
    OrderInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Order>(
      where: where?.call(Order.t),
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Order] matching the given query parameters.
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
  Future<Order?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderTable>? where,
    int? offset,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    _is.Transaction? transaction,
    OrderInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Order>(
      where: where?.call(Order.t),
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Order] by its [id] or null if no such row exists.
  Future<Order?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    OrderInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Order>(
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
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    _is.Transaction? transaction,
    OrderJsonInclude? include,
    _is.SelectColumnsBuilder<OrderTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Order>(
      where: where?.call(Order.t),
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Order.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<OrderTable>? where,
    int? offset,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    _is.Transaction? transaction,
    OrderJsonInclude? include,
    _is.SelectColumnsBuilder<OrderTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Order>(
      where: where?.call(Order.t),
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Order.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    OrderJsonInclude? include,
    _is.SelectColumnsBuilder<OrderTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Order>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Order.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Order]s in the list and returns the inserted rows.
  ///
  /// The returned [Order]s will have their `id` fields set.
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
  Future<List<Order>> insert(
    _is.DatabaseSession session,
    List<Order> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Order>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Order] and returns the inserted row.
  ///
  /// The returned [Order] will have its `id` field set.
  Future<Order> insertRow(
    _is.DatabaseSession session,
    Order row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Order>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Order]s in the list and returns the resulting rows.
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
  /// The returned [Order]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Order>> upsert(
    _is.DatabaseSession session,
    List<Order> rows, {
    required _is.ColumnSelections<OrderTable> conflictColumns,
    _is.ColumnSelections<OrderTable>? updateColumns,
    _is.WhereExpressionBuilder<OrderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Order>(
      rows,
      conflictColumns: conflictColumns(Order.t),
      updateColumns: updateColumns?.call(Order.t),
      updateWhere: updateWhere?.call(Order.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Order] and returns the resulting row.
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
  /// The returned [Order] will have its `id` field set.
  Future<Order?> upsertRow(
    _is.DatabaseSession session,
    Order row, {
    required _is.ColumnSelections<OrderTable> conflictColumns,
    _is.ColumnSelections<OrderTable>? updateColumns,
    _is.WhereExpressionBuilder<OrderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Order>(
      row,
      conflictColumns: conflictColumns(Order.t),
      updateColumns: updateColumns?.call(Order.t),
      updateWhere: updateWhere?.call(Order.t),
      transaction: transaction,
    );
  }

  /// Updates all [Order]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Order>> update(
    _is.DatabaseSession session,
    List<Order> rows, {
    _is.ColumnSelections<OrderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Order>(
      rows,
      columns: columns?.call(Order.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Order]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Order> updateRow(
    _is.DatabaseSession session,
    Order row, {
    _is.ColumnSelections<OrderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Order>(
      row,
      columns: columns?.call(Order.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Order] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Order?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<OrderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Order>(
      id,
      columnValues: columnValues(Order.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Order]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Order>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<OrderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<OrderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Order>(
      columnValues: columnValues(Order.t.updateTable),
      where: where(Order.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Order]s in the list and returns the deleted rows.
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
  Future<List<Order>> delete(
    _is.DatabaseSession session,
    List<Order> rows, {
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Order>(
      rows,
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Order].
  Future<Order> deleteRow(
    _is.DatabaseSession session,
    Order row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Order>(
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
  Future<List<Order>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrderTable> where,
    _is.OrderByBuilder<OrderTable>? orderBy,
    _is.OrderByListBuilder<OrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Order>(
      where: where(Order.t),
      orderBy: orderBy?.call(Order.t),
      orderByList: orderByList?.call(Order.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Order>(
      where: where?.call(Order.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Order] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Order>(
      where: where(Order.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class OrderAttachRepository {
  const OrderAttachRepository._();

  /// Creates a relation between this [Order] and the given [Comment]s
  /// by setting each [Comment]'s foreign key `orderId` to refer to this [Order].
  Future<void> comments(
    _is.DatabaseSession session,
    Order order,
    List<_ij3ynzrj.Comment> comment, {
    _is.Transaction? transaction,
  }) async {
    if (comment.any((e) => e.id == null)) {
      throw ArgumentError.notNull('comment.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $comment = comment.map((e) => e.copyWith(orderId: order.id)).toList();
    await session.db.update<_ij3ynzrj.Comment>(
      $comment,
      columns: [_ij3ynzrj.Comment.t.orderId],
      transaction: transaction,
    );
  }
}

class OrderAttachRowRepository {
  const OrderAttachRowRepository._();

  /// Creates a relation between the given [Order] and [Customer]
  /// by setting the [Order]'s foreign key `customerId` to refer to the [Customer].
  Future<void> customer(
    _is.DatabaseSession session,
    Order order,
    _i3fqgdb1.Customer customer, {
    _is.Transaction? transaction,
  }) async {
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
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Order] and the given [Comment]
  /// by setting the [Comment]'s foreign key `orderId` to refer to this [Order].
  Future<void> comments(
    _is.DatabaseSession session,
    Order order,
    _ij3ynzrj.Comment comment, {
    _is.Transaction? transaction,
  }) async {
    if (comment.id == null) {
      throw ArgumentError.notNull('comment.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $comment = comment.copyWith(orderId: order.id);
    await session.db.updateRow<_ij3ynzrj.Comment>(
      $comment,
      columns: [_ij3ynzrj.Comment.t.orderId],
      transaction: transaction,
    );
  }
}
