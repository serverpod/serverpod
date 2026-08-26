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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../models_with_relations/one_to_many/order.dart' as _ig920ya2;

abstract class Comment
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Comment._({
    this.id,
    required this.description,
    required this.orderId,
    this.order,
  });

  factory Comment({
    int? id,
    required String description,
    required int orderId,
    _ig920ya2.Order? order,
  }) = _CommentImpl;

  factory Comment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Comment(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_ig920ya2.Order>(
              jsonSerialization['order'],
            ),
    );
  }

  static final t = CommentTable();

  static const db = CommentRepository._();

  @override
  int? id;

  String description;

  int orderId;

  _ig920ya2.Order? order;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Comment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Comment copyWith({
    int? id,
    String? description,
    int? orderId,
    _ig920ya2.Order? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Comment',
      if (id != null) 'id': id,
      'description': description,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Comment',
      if (id != null) 'id': id,
      'description': description,
      'orderId': orderId,
      if (order != null) 'order': order?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [CommentInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CommentInclude include({_ig920ya2.OrderInclude? order}) {
    return CommentInclude._(order: order);
  }

  /// Builds a complete [CommentIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CommentIncludeList includeList({
    _isd.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    CommentInclude? include,
  }) {
    return CommentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [CommentJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static CommentJsonInclude includeJson({
    _ig920ya2.OrderJsonInclude? order,
    _isd.SelectColumnsBuilder<CommentTable>? select,
  }) {
    return _CommentJsonInclude._(
      order: order,
      selectedColumns: select?.call(Comment.t),
    );
  }

  /// Builds a JSON-compatible [CommentJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static CommentJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    CommentJsonInclude? include,
    _isd.SelectColumnsBuilder<CommentTable>? select,
  }) {
    return _CommentJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      include: include,
      selectedColumns: select?.call(Comment.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommentImpl extends Comment {
  _CommentImpl({
    int? id,
    required String description,
    required int orderId,
    _ig920ya2.Order? order,
  }) : super._(
         id: id,
         description: description,
         orderId: orderId,
         order: order,
       );

  /// Returns a shallow copy of this [Comment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Comment copyWith({
    Object? id = _Undefined,
    String? description,
    int? orderId,
    Object? order = _Undefined,
  }) {
    return Comment(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      orderId: orderId ?? this.orderId,
      order: order is _ig920ya2.Order? ? order : this.order?.copyWith(),
    );
  }
}

class CommentUpdateTable extends _isd.UpdateTable<CommentTable> {
  CommentUpdateTable(super.table);

  _isd.ColumnValue<String, String> description(String value) =>
      _isd.ColumnValue(
        table.description,
        value,
      );

  _isd.ColumnValue<int, int> orderId(int value) => _isd.ColumnValue(
    table.orderId,
    value,
  );
}

class CommentTable extends _isd.Table<int?> {
  CommentTable({super.tableRelation}) : super(tableName: 'comment') {
    updateTable = CommentUpdateTable(this);
    description = _isd.ColumnString(
      'description',
      this,
    );
    orderId = _isd.ColumnInt(
      'orderId',
      this,
    );
  }

  late final CommentUpdateTable updateTable;

  late final _isd.ColumnString description;

  late final _isd.ColumnInt orderId;

  _ig920ya2.OrderTable? _order;

  _ig920ya2.OrderTable get order {
    if (_order != null) return _order!;
    _order = _isd.createRelationTable(
      relationFieldName: 'order',
      field: Comment.t.orderId,
      foreignField: _ig920ya2.Order.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ig920ya2.OrderTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    description,
    orderId,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'order') {
      return order;
    }
    return null;
  }
}

abstract interface class CommentJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class CommentJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class CommentInclude extends _isd.IncludeObject
    implements CommentJsonInclude, _isd.FullModelInclude {
  CommentInclude._({_ig920ya2.OrderInclude? order}) {
    _order = order;
  }

  _ig920ya2.OrderInclude? _order;

  @override
  Map<String, _isd.Include?> get includes => {'order': _order};

  @override
  _isd.Table<int?> get table => Comment.t;
}

final class CommentIncludeList extends _isd.IncludeList
    implements CommentJsonIncludeList, _isd.FullModelInclude {
  CommentIncludeList._({
    _isd.WhereExpressionBuilder<CommentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CommentInclude? super.include,
  }) {
    super.where = where?.call(Comment.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Comment.t;
}

final class _CommentJsonInclude extends _isd.IncludeObject
    implements CommentJsonInclude {
  _CommentJsonInclude._({
    _ig920ya2.OrderJsonInclude? order,
    this.selectedColumns,
  }) {
    _order = order;
  }

  _ig920ya2.OrderJsonInclude? _order;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {'order': _order};

  @override
  _isd.Table<int?> get table => Comment.t;
}

final class _CommentJsonIncludeList extends _isd.IncludeList
    implements CommentJsonIncludeList {
  _CommentJsonIncludeList._({
    _isd.WhereExpressionBuilder<CommentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CommentJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Comment.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Comment.t;
}

class CommentRepository {
  const CommentRepository._();

  final attachRow = const CommentAttachRowRepository._();

  /// Returns a list of [Comment]s matching the given query parameters.
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
  Future<List<Comment>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    _isd.Transaction? transaction,
    CommentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Comment>(
      where: where?.call(Comment.t),
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Comment] matching the given query parameters.
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
  Future<Comment?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CommentTable>? where,
    int? offset,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    _isd.Transaction? transaction,
    CommentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Comment>(
      where: where?.call(Comment.t),
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Comment] by its [id] or null if no such row exists.
  Future<Comment?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    CommentInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Comment>(
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    _isd.Transaction? transaction,
    CommentJsonInclude? include,
    _isd.SelectColumnsBuilder<CommentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Comment>(
      where: where?.call(Comment.t),
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Comment.t),
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CommentTable>? where,
    int? offset,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    _isd.Transaction? transaction,
    CommentJsonInclude? include,
    _isd.SelectColumnsBuilder<CommentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Comment>(
      where: where?.call(Comment.t),
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Comment.t),
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
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    CommentJsonInclude? include,
    _isd.SelectColumnsBuilder<CommentTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Comment>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Comment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Comment]s in the list and returns the inserted rows.
  ///
  /// The returned [Comment]s will have their `id` fields set.
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
  Future<List<Comment>> insert(
    _isd.DatabaseSession session,
    List<Comment> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Comment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Comment] and returns the inserted row.
  ///
  /// The returned [Comment] will have its `id` field set.
  Future<Comment> insertRow(
    _isd.DatabaseSession session,
    Comment row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Comment>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Comment]s in the list and returns the resulting rows.
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
  /// The returned [Comment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Comment>> upsert(
    _isd.DatabaseSession session,
    List<Comment> rows, {
    required _isd.ColumnSelections<CommentTable> conflictColumns,
    _isd.ColumnSelections<CommentTable>? updateColumns,
    _isd.WhereExpressionBuilder<CommentTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Comment>(
      rows,
      conflictColumns: conflictColumns(Comment.t),
      updateColumns: updateColumns?.call(Comment.t),
      updateWhere: updateWhere?.call(Comment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Comment] and returns the resulting row.
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
  /// The returned [Comment] will have its `id` field set.
  Future<Comment?> upsertRow(
    _isd.DatabaseSession session,
    Comment row, {
    required _isd.ColumnSelections<CommentTable> conflictColumns,
    _isd.ColumnSelections<CommentTable>? updateColumns,
    _isd.WhereExpressionBuilder<CommentTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Comment>(
      row,
      conflictColumns: conflictColumns(Comment.t),
      updateColumns: updateColumns?.call(Comment.t),
      updateWhere: updateWhere?.call(Comment.t),
      transaction: transaction,
    );
  }

  /// Updates all [Comment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Comment>> update(
    _isd.DatabaseSession session,
    List<Comment> rows, {
    _isd.ColumnSelections<CommentTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Comment>(
      rows,
      columns: columns?.call(Comment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Comment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Comment> updateRow(
    _isd.DatabaseSession session,
    Comment row, {
    _isd.ColumnSelections<CommentTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Comment>(
      row,
      columns: columns?.call(Comment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Comment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Comment?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<CommentUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Comment>(
      id,
      columnValues: columnValues(Comment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Comment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Comment>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<CommentUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<CommentTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Comment>(
      columnValues: columnValues(Comment.t.updateTable),
      where: where(Comment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Comment]s in the list and returns the deleted rows.
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
  Future<List<Comment>> delete(
    _isd.DatabaseSession session,
    List<Comment> rows, {
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Comment>(
      rows,
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Comment].
  Future<Comment> deleteRow(
    _isd.DatabaseSession session,
    Comment row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Comment>(
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
  Future<List<Comment>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CommentTable> where,
    _isd.OrderByBuilder<CommentTable>? orderBy,
    _isd.OrderByListBuilder<CommentTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Comment>(
      where: where(Comment.t),
      orderBy: orderBy?.call(Comment.t),
      orderByList: orderByList?.call(Comment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CommentTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Comment>(
      where: where?.call(Comment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Comment] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CommentTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Comment>(
      where: where(Comment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CommentAttachRowRepository {
  const CommentAttachRowRepository._();

  /// Creates a relation between the given [Comment] and [Order]
  /// by setting the [Comment]'s foreign key `orderId` to refer to the [Order].
  Future<void> order(
    _isd.DatabaseSession session,
    Comment comment,
    _ig920ya2.Order order, {
    _isd.Transaction? transaction,
  }) async {
    if (comment.id == null) {
      throw ArgumentError.notNull('comment.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $comment = comment.copyWith(orderId: order.id);
    await session.db.updateRow<Comment>(
      $comment,
      columns: [Comment.t.orderId],
      transaction: transaction,
    );
  }
}
