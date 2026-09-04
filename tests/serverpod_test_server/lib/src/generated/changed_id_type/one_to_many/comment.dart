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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../../changed_id_type/one_to_many/order.dart' as _ivss21qh;

abstract class CommentInt
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CommentInt._({
    this.id,
    required this.description,
    required this.orderId,
    this.order,
  });

  factory CommentInt({
    int? id,
    required String description,
    required _is.UuidValue orderId,
    _ivss21qh.OrderUuid? order,
  }) = _CommentIntImpl;

  factory CommentInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CommentInt(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      orderId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      order: jsonSerialization['order'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ivss21qh.OrderUuid>(
              jsonSerialization['order'],
            ),
    );
  }

  static final t = CommentIntTable();

  static const db = CommentIntRepository._();

  @override
  int? id;

  String description;

  _is.UuidValue orderId;

  _ivss21qh.OrderUuid? order;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CommentInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CommentInt copyWith({
    int? id,
    String? description,
    _is.UuidValue? orderId,
    _ivss21qh.OrderUuid? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CommentInt',
      if (id != null) 'id': id,
      'description': description,
      'orderId': orderId.toJson(),
      if (order != null) 'order': order?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CommentInt',
      if (id != null) 'id': id,
      'description': description,
      'orderId': orderId.toJson(),
      if (order != null) 'order': order?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [CommentIntInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CommentIntInclude include({_ivss21qh.OrderUuidInclude? order}) {
    return CommentIntInclude._(order: order);
  }

  /// Builds a complete [CommentIntIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CommentIntIncludeList includeList({
    _is.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    CommentIntInclude? include,
  }) {
    return CommentIntIncludeList._(
      where: where?.call(CommentInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [CommentIntJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static CommentIntJsonInclude includeJson({
    _ivss21qh.OrderUuidJsonInclude? order,
    _is.SelectColumnsBuilder<CommentIntTable>? select,
  }) {
    return _CommentIntJsonInclude._(
      order: order,
      selectedColumns: select?.call(CommentInt.t),
    );
  }

  /// Builds a JSON-compatible [CommentIntJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static CommentIntJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    CommentIntJsonInclude? include,
    _is.SelectColumnsBuilder<CommentIntTable>? select,
  }) {
    return _CommentIntJsonIncludeList._(
      where: where?.call(CommentInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      include: include,
      selectedColumns: select?.call(CommentInt.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CommentIntImpl extends CommentInt {
  _CommentIntImpl({
    int? id,
    required String description,
    required _is.UuidValue orderId,
    _ivss21qh.OrderUuid? order,
  }) : super._(
         id: id,
         description: description,
         orderId: orderId,
         order: order,
       );

  /// Returns a shallow copy of this [CommentInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CommentInt copyWith({
    Object? id = _Undefined,
    String? description,
    _is.UuidValue? orderId,
    Object? order = _Undefined,
  }) {
    return CommentInt(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      orderId: orderId ?? this.orderId,
      order: order is _ivss21qh.OrderUuid? ? order : this.order?.copyWith(),
    );
  }
}

class CommentIntUpdateTable extends _is.UpdateTable<CommentIntTable> {
  CommentIntUpdateTable(super.table);

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> orderId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.orderId,
        value,
      );
}

class CommentIntTable extends _is.Table<int?> {
  CommentIntTable({super.tableRelation}) : super(tableName: 'comment_int') {
    updateTable = CommentIntUpdateTable(this);
    description = _is.ColumnString(
      'description',
      this,
    );
    orderId = _is.ColumnUuid(
      'orderId',
      this,
    );
  }

  late final CommentIntUpdateTable updateTable;

  late final _is.ColumnString description;

  late final _is.ColumnUuid orderId;

  _ivss21qh.OrderUuidTable? _order;

  _ivss21qh.OrderUuidTable get order {
    if (_order != null) return _order!;
    _order = _is.createRelationTable(
      relationFieldName: 'order',
      field: CommentInt.t.orderId,
      foreignField: _ivss21qh.OrderUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ivss21qh.OrderUuidTable(tableRelation: foreignTableRelation),
    );
    return _order!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    description,
    orderId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'order') {
      return order;
    }
    return null;
  }
}

abstract interface class CommentIntJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class CommentIntJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class CommentIntInclude extends _is.IncludeObject
    implements CommentIntJsonInclude, _is.FullModelInclude {
  CommentIntInclude._({_ivss21qh.OrderUuidInclude? order}) {
    _order = order;
  }

  _ivss21qh.OrderUuidInclude? _order;

  @override
  Map<String, _is.Include?> get includes => {'order': _order};

  @override
  _is.Table<int?> get table => CommentInt.t;
}

final class CommentIntIncludeList extends _is.IncludeList
    implements CommentIntJsonIncludeList, _is.FullModelInclude {
  CommentIntIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CommentIntInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CommentInt.t;
}

final class _CommentIntJsonInclude extends _is.IncludeObject
    implements CommentIntJsonInclude {
  _CommentIntJsonInclude._({
    _ivss21qh.OrderUuidJsonInclude? order,
    this.selectedColumns,
  }) {
    _order = order;
  }

  _ivss21qh.OrderUuidJsonInclude? _order;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'order': _order};

  @override
  _is.Table<int?> get table => CommentInt.t;
}

final class _CommentIntJsonIncludeList extends _is.IncludeList
    implements CommentIntJsonIncludeList {
  _CommentIntJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CommentIntJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CommentInt.t;
}

class CommentIntRepository {
  const CommentIntRepository._();

  final attachRow = const CommentIntAttachRowRepository._();

  /// Returns a list of [CommentInt]s matching the given query parameters.
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
  Future<List<CommentInt>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    _is.Transaction? transaction,
    CommentIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CommentInt>(
      where: where?.call(CommentInt.t),
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CommentInt] matching the given query parameters.
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
  Future<CommentInt?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommentIntTable>? where,
    int? offset,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    _is.Transaction? transaction,
    CommentIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CommentInt>(
      where: where?.call(CommentInt.t),
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CommentInt] by its [id] or null if no such row exists.
  Future<CommentInt?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CommentIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CommentInt>(
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
    _is.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    _is.Transaction? transaction,
    CommentIntJsonInclude? include,
    _is.SelectColumnsBuilder<CommentIntTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<CommentInt>(
      where: where?.call(CommentInt.t),
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(CommentInt.t),
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
    _is.WhereExpressionBuilder<CommentIntTable>? where,
    int? offset,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    _is.Transaction? transaction,
    CommentIntJsonInclude? include,
    _is.SelectColumnsBuilder<CommentIntTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<CommentInt>(
      where: where?.call(CommentInt.t),
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(CommentInt.t),
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
    CommentIntJsonInclude? include,
    _is.SelectColumnsBuilder<CommentIntTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<CommentInt>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(CommentInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CommentInt]s in the list and returns the inserted rows.
  ///
  /// The returned [CommentInt]s will have their `id` fields set.
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
  Future<List<CommentInt>> insert(
    _is.DatabaseSession session,
    List<CommentInt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CommentInt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CommentInt] and returns the inserted row.
  ///
  /// The returned [CommentInt] will have its `id` field set.
  Future<CommentInt> insertRow(
    _is.DatabaseSession session,
    CommentInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CommentInt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CommentInt]s in the list and returns the resulting rows.
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
  /// The returned [CommentInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommentInt>> upsert(
    _is.DatabaseSession session,
    List<CommentInt> rows, {
    required _is.ColumnSelections<CommentIntTable> conflictColumns,
    _is.ColumnSelections<CommentIntTable>? updateColumns,
    _is.WhereExpressionBuilder<CommentIntTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CommentInt>(
      rows,
      conflictColumns: conflictColumns(CommentInt.t),
      updateColumns: updateColumns?.call(CommentInt.t),
      updateWhere: updateWhere?.call(CommentInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CommentInt] and returns the resulting row.
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
  /// The returned [CommentInt] will have its `id` field set.
  Future<CommentInt?> upsertRow(
    _is.DatabaseSession session,
    CommentInt row, {
    required _is.ColumnSelections<CommentIntTable> conflictColumns,
    _is.ColumnSelections<CommentIntTable>? updateColumns,
    _is.WhereExpressionBuilder<CommentIntTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CommentInt>(
      row,
      conflictColumns: conflictColumns(CommentInt.t),
      updateColumns: updateColumns?.call(CommentInt.t),
      updateWhere: updateWhere?.call(CommentInt.t),
      transaction: transaction,
    );
  }

  /// Updates all [CommentInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommentInt>> update(
    _is.DatabaseSession session,
    List<CommentInt> rows, {
    _is.ColumnSelections<CommentIntTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CommentInt>(
      rows,
      columns: columns?.call(CommentInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CommentInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CommentInt> updateRow(
    _is.DatabaseSession session,
    CommentInt row, {
    _is.ColumnSelections<CommentIntTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CommentInt>(
      row,
      columns: columns?.call(CommentInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CommentInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CommentInt?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CommentIntUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CommentInt>(
      id,
      columnValues: columnValues(CommentInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CommentInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CommentInt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CommentIntUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CommentIntTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CommentInt>(
      columnValues: columnValues(CommentInt.t.updateTable),
      where: where(CommentInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CommentInt]s in the list and returns the deleted rows.
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
  Future<List<CommentInt>> delete(
    _is.DatabaseSession session,
    List<CommentInt> rows, {
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CommentInt>(
      rows,
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CommentInt].
  Future<CommentInt> deleteRow(
    _is.DatabaseSession session,
    CommentInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CommentInt>(
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
  Future<List<CommentInt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommentIntTable> where,
    _is.OrderByBuilder<CommentIntTable>? orderBy,
    _is.OrderByListBuilder<CommentIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CommentInt>(
      where: where(CommentInt.t),
      orderBy: orderBy?.call(CommentInt.t),
      orderByList: orderByList?.call(CommentInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CommentIntTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CommentInt>(
      where: where?.call(CommentInt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CommentInt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CommentIntTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CommentInt>(
      where: where(CommentInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CommentIntAttachRowRepository {
  const CommentIntAttachRowRepository._();

  /// Creates a relation between the given [CommentInt] and [OrderUuid]
  /// by setting the [CommentInt]'s foreign key `orderId` to refer to the [OrderUuid].
  Future<void> order(
    _is.DatabaseSession session,
    CommentInt commentInt,
    _ivss21qh.OrderUuid order, {
    _is.Transaction? transaction,
  }) async {
    if (commentInt.id == null) {
      throw ArgumentError.notNull('commentInt.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $commentInt = commentInt.copyWith(orderId: order.id);
    await session.db.updateRow<CommentInt>(
      $commentInt,
      columns: [CommentInt.t.orderId],
      transaction: transaction,
    );
  }
}
