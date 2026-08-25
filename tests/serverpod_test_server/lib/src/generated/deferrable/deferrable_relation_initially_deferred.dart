/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class DeferrableRelationInitiallyDeferred
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DeferrableRelationInitiallyDeferred._({
    this.id,
    required this.parentId,
  });

  factory DeferrableRelationInitiallyDeferred({
    int? id,
    required int parentId,
  }) = _DeferrableRelationInitiallyDeferredImpl;

  factory DeferrableRelationInitiallyDeferred.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeferrableRelationInitiallyDeferred(
      id: jsonSerialization['id'] as int?,
      parentId: jsonSerialization['parentId'] as int,
    );
  }

  static final t = DeferrableRelationInitiallyDeferredTable();

  static const db = DeferrableRelationInitiallyDeferredRepository._();

  @override
  int? id;

  int parentId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeferrableRelationInitiallyDeferred]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeferrableRelationInitiallyDeferred copyWith({
    int? id,
    int? parentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeferrableRelationInitiallyDeferred',
      if (id != null) 'id': id,
      'parentId': parentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeferrableRelationInitiallyDeferred',
      if (id != null) 'id': id,
      'parentId': parentId,
    };
  }

  static DeferrableRelationInitiallyDeferredInclude include({
    _is.SelectColumnsBuilder<DeferrableRelationInitiallyDeferredTable>? select,
  }) {
    return DeferrableRelationInitiallyDeferredInclude._(
      selectedColumns: select?.call(DeferrableRelationInitiallyDeferred.t),
    );
  }

  static DeferrableRelationInitiallyDeferredIncludeList includeList({
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    DeferrableRelationInitiallyDeferredInclude? include,
    _is.SelectColumnsBuilder<DeferrableRelationInitiallyDeferredTable>? select,
  }) {
    return DeferrableRelationInitiallyDeferredIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      include: include,
      selectedColumns: select?.call(DeferrableRelationInitiallyDeferred.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeferrableRelationInitiallyDeferredImpl
    extends DeferrableRelationInitiallyDeferred {
  _DeferrableRelationInitiallyDeferredImpl({
    int? id,
    required int parentId,
  }) : super._(
         id: id,
         parentId: parentId,
       );

  /// Returns a shallow copy of this [DeferrableRelationInitiallyDeferred]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeferrableRelationInitiallyDeferred copyWith({
    Object? id = _Undefined,
    int? parentId,
  }) {
    return DeferrableRelationInitiallyDeferred(
      id: id is int? ? id : this.id,
      parentId: parentId ?? this.parentId,
    );
  }
}

class DeferrableRelationInitiallyDeferredUpdateTable
    extends _is.UpdateTable<DeferrableRelationInitiallyDeferredTable> {
  DeferrableRelationInitiallyDeferredUpdateTable(super.table);

  _is.ColumnValue<int, int> parentId(int value) => _is.ColumnValue(
    table.parentId,
    value,
  );
}

class DeferrableRelationInitiallyDeferredTable extends _is.Table<int?> {
  DeferrableRelationInitiallyDeferredTable({super.tableRelation})
    : super(tableName: 'deferrable_relation_initially_deferred') {
    updateTable = DeferrableRelationInitiallyDeferredUpdateTable(this);
    parentId = _is.ColumnInt(
      'parentId',
      this,
    );
  }

  late final DeferrableRelationInitiallyDeferredUpdateTable updateTable;

  late final _is.ColumnInt parentId;

  @override
  List<_is.Column> get columns => [
    id,
    parentId,
  ];
}

class DeferrableRelationInitiallyDeferredInclude extends _is.IncludeObject {
  DeferrableRelationInitiallyDeferredInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DeferrableRelationInitiallyDeferred.t;
}

class DeferrableRelationInitiallyDeferredIncludeList extends _is.IncludeList {
  DeferrableRelationInitiallyDeferredIncludeList._({
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(DeferrableRelationInitiallyDeferred.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DeferrableRelationInitiallyDeferred.t;
}

class DeferrableRelationInitiallyDeferredRepository {
  const DeferrableRelationInitiallyDeferredRepository._();

  /// Returns a list of [DeferrableRelationInitiallyDeferred]s matching the given query parameters.
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
  Future<List<DeferrableRelationInitiallyDeferred>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeferrableRelationInitiallyDeferred>(
      where: where?.call(DeferrableRelationInitiallyDeferred.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeferrableRelationInitiallyDeferred] matching the given query parameters.
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
  Future<DeferrableRelationInitiallyDeferred?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? offset,
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeferrableRelationInitiallyDeferred>(
      where: where?.call(DeferrableRelationInitiallyDeferred.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeferrableRelationInitiallyDeferred] by its [id] or null if no such row exists.
  Future<DeferrableRelationInitiallyDeferred?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeferrableRelationInitiallyDeferred>(
      id,
      transaction: transaction,
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
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DeferrableRelationInitiallyDeferredTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<DeferrableRelationInitiallyDeferred>(
      where: where?.call(DeferrableRelationInitiallyDeferred.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(DeferrableRelationInitiallyDeferred.t),
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
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? offset,
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DeferrableRelationInitiallyDeferredTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<DeferrableRelationInitiallyDeferred>(
      where: where?.call(DeferrableRelationInitiallyDeferred.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(DeferrableRelationInitiallyDeferred.t),
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
    _is.SelectColumnsBuilder<DeferrableRelationInitiallyDeferredTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<DeferrableRelationInitiallyDeferred>(
      id,
      transaction: transaction,
      select: select?.call(DeferrableRelationInitiallyDeferred.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeferrableRelationInitiallyDeferred]s in the list and returns the inserted rows.
  ///
  /// The returned [DeferrableRelationInitiallyDeferred]s will have their `id` fields set.
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
  Future<List<DeferrableRelationInitiallyDeferred>> insert(
    _is.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeferrableRelationInitiallyDeferred>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeferrableRelationInitiallyDeferred] and returns the inserted row.
  ///
  /// The returned [DeferrableRelationInitiallyDeferred] will have its `id` field set.
  Future<DeferrableRelationInitiallyDeferred> insertRow(
    _is.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeferrableRelationInitiallyDeferred>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeferrableRelationInitiallyDeferred]s in the list and returns the resulting rows.
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
  /// The returned [DeferrableRelationInitiallyDeferred]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationInitiallyDeferred>> upsert(
    _is.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    required _is.ColumnSelections<DeferrableRelationInitiallyDeferredTable>
    conflictColumns,
    _is.ColumnSelections<DeferrableRelationInitiallyDeferredTable>?
    updateColumns,
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeferrableRelationInitiallyDeferred>(
      rows,
      conflictColumns: conflictColumns(DeferrableRelationInitiallyDeferred.t),
      updateColumns: updateColumns?.call(DeferrableRelationInitiallyDeferred.t),
      updateWhere: updateWhere?.call(DeferrableRelationInitiallyDeferred.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeferrableRelationInitiallyDeferred] and returns the resulting row.
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
  /// The returned [DeferrableRelationInitiallyDeferred] will have its `id` field set.
  Future<DeferrableRelationInitiallyDeferred?> upsertRow(
    _is.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    required _is.ColumnSelections<DeferrableRelationInitiallyDeferredTable>
    conflictColumns,
    _is.ColumnSelections<DeferrableRelationInitiallyDeferredTable>?
    updateColumns,
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeferrableRelationInitiallyDeferred>(
      row,
      conflictColumns: conflictColumns(DeferrableRelationInitiallyDeferred.t),
      updateColumns: updateColumns?.call(DeferrableRelationInitiallyDeferred.t),
      updateWhere: updateWhere?.call(DeferrableRelationInitiallyDeferred.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeferrableRelationInitiallyDeferred]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationInitiallyDeferred>> update(
    _is.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    _is.ColumnSelections<DeferrableRelationInitiallyDeferredTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeferrableRelationInitiallyDeferred>(
      rows,
      columns: columns?.call(DeferrableRelationInitiallyDeferred.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeferrableRelationInitiallyDeferred]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeferrableRelationInitiallyDeferred> updateRow(
    _is.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    _is.ColumnSelections<DeferrableRelationInitiallyDeferredTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeferrableRelationInitiallyDeferred>(
      row,
      columns: columns?.call(DeferrableRelationInitiallyDeferred.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeferrableRelationInitiallyDeferred] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeferrableRelationInitiallyDeferred?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      DeferrableRelationInitiallyDeferredUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeferrableRelationInitiallyDeferred>(
      id,
      columnValues: columnValues(
        DeferrableRelationInitiallyDeferred.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [DeferrableRelationInitiallyDeferred]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationInitiallyDeferred>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      DeferrableRelationInitiallyDeferredUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<
      DeferrableRelationInitiallyDeferredTable
    >
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeferrableRelationInitiallyDeferred>(
      columnValues: columnValues(
        DeferrableRelationInitiallyDeferred.t.updateTable,
      ),
      where: where(DeferrableRelationInitiallyDeferred.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeferrableRelationInitiallyDeferred]s in the list and returns the deleted rows.
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
  Future<List<DeferrableRelationInitiallyDeferred>> delete(
    _is.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeferrableRelationInitiallyDeferred>(
      rows,
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeferrableRelationInitiallyDeferred].
  Future<DeferrableRelationInitiallyDeferred> deleteRow(
    _is.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeferrableRelationInitiallyDeferred>(
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
  Future<List<DeferrableRelationInitiallyDeferred>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<
      DeferrableRelationInitiallyDeferredTable
    >
    where,
    _is.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _is.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeferrableRelationInitiallyDeferred>(
      where: where(DeferrableRelationInitiallyDeferred.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeferrableRelationInitiallyDeferred>(
      where: where?.call(DeferrableRelationInitiallyDeferred.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeferrableRelationInitiallyDeferred] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<
      DeferrableRelationInitiallyDeferredTable
    >
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeferrableRelationInitiallyDeferred>(
      where: where(DeferrableRelationInitiallyDeferred.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
