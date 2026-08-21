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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:meta/meta.dart' as _i2;

abstract class DeferrableRelationInitiallyDeferred
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeferrableRelationInitiallyDeferred]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  static DeferrableRelationInitiallyDeferredInclude include() {
    return DeferrableRelationInitiallyDeferredInclude.internal_();
  }

  static DeferrableRelationInitiallyDeferredIncludeList includeList({
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    DeferrableRelationInitiallyDeferredInclude? include,
  }) {
    return DeferrableRelationInitiallyDeferredIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeferrableRelationInitiallyDeferred.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyDeferred.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
  @_i1.useResult
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
    extends _i1.UpdateTable<DeferrableRelationInitiallyDeferredTable> {
  DeferrableRelationInitiallyDeferredUpdateTable(super.table);

  _i1.ColumnValue<int, int> parentId(int value) => _i1.ColumnValue(
    table.parentId,
    value,
  );
}

class DeferrableRelationInitiallyDeferredTable extends _i1.Table<int?> {
  DeferrableRelationInitiallyDeferredTable({super.tableRelation})
    : super(tableName: 'deferrable_relation_initially_deferred') {
    updateTable = DeferrableRelationInitiallyDeferredUpdateTable(this);
    parentId = _i1.ColumnInt(
      'parentId',
      this,
    );
  }

  late final DeferrableRelationInitiallyDeferredUpdateTable updateTable;

  late final _i1.ColumnInt parentId;

  @override
  List<_i1.Column> get columns => [
    id,
    parentId,
  ];
}

class DeferrableRelationInitiallyDeferredInclude extends _i1.IncludeObject {
  @_i2.internal
  DeferrableRelationInitiallyDeferredInclude.internal_({
    List<_i1.Column>? this.selectedColumns,
  }) {}

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DeferrableRelationInitiallyDeferred.t;
}

class DeferrableRelationInitiallyDeferredIncludeList extends _i1.IncludeList {
  @_i2.internal
  DeferrableRelationInitiallyDeferredIncludeList.internal_({
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_i1.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(DeferrableRelationInitiallyDeferred.t);
  }

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DeferrableRelationInitiallyDeferred.t;
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeferrableRelationInitiallyDeferred>(
      id,
      transaction: transaction,
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
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    required _i1.ColumnSelections<DeferrableRelationInitiallyDeferredTable>
    conflictColumns,
    _i1.ColumnSelections<DeferrableRelationInitiallyDeferredTable>?
    updateColumns,
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>?
    updateWhere,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    required _i1.ColumnSelections<DeferrableRelationInitiallyDeferredTable>
    conflictColumns,
    _i1.ColumnSelections<DeferrableRelationInitiallyDeferredTable>?
    updateColumns,
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>?
    updateWhere,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    _i1.ColumnSelections<DeferrableRelationInitiallyDeferredTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    _i1.ColumnSelections<DeferrableRelationInitiallyDeferredTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<
      DeferrableRelationInitiallyDeferredUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<
      DeferrableRelationInitiallyDeferredUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<
      DeferrableRelationInitiallyDeferredTable
    >
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyDeferred> rows, {
    _i1.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyDeferred row, {
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<
      DeferrableRelationInitiallyDeferredTable
    >
    where,
    _i1.OrderByBuilder<DeferrableRelationInitiallyDeferredTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyDeferredTable>?
    orderByList,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyDeferredTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeferrableRelationInitiallyDeferred>(
      where: where?.call(DeferrableRelationInitiallyDeferred.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeferrableRelationInitiallyDeferred] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<
      DeferrableRelationInitiallyDeferredTable
    >
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeferrableRelationInitiallyDeferred>(
      where: where(DeferrableRelationInitiallyDeferred.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
