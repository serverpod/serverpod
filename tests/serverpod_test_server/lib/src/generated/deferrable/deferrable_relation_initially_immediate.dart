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

abstract class DeferrableRelationInitiallyImmediate
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DeferrableRelationInitiallyImmediate._({
    this.id,
    required this.parentId,
  });

  factory DeferrableRelationInitiallyImmediate({
    int? id,
    required int parentId,
  }) = _DeferrableRelationInitiallyImmediateImpl;

  factory DeferrableRelationInitiallyImmediate.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeferrableRelationInitiallyImmediate(
      id: jsonSerialization['id'] as int?,
      parentId: jsonSerialization['parentId'] as int,
    );
  }

  static final t = DeferrableRelationInitiallyImmediateTable();

  static const db = DeferrableRelationInitiallyImmediateRepository._();

  @override
  int? id;

  int parentId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeferrableRelationInitiallyImmediate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeferrableRelationInitiallyImmediate copyWith({
    int? id,
    int? parentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeferrableRelationInitiallyImmediate',
      if (id != null) 'id': id,
      'parentId': parentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeferrableRelationInitiallyImmediate',
      if (id != null) 'id': id,
      'parentId': parentId,
    };
  }

  static DeferrableRelationInitiallyImmediateInclude include() {
    return DeferrableRelationInitiallyImmediateInclude.internal_();
  }

  static DeferrableRelationInitiallyImmediateIncludeList includeList({
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyImmediateTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyImmediateTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyImmediateTable>?
    orderByList,
    DeferrableRelationInitiallyImmediateInclude? include,
  }) {
    return DeferrableRelationInitiallyImmediateIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeferrableRelationInitiallyImmediate.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyImmediate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeferrableRelationInitiallyImmediateImpl
    extends DeferrableRelationInitiallyImmediate {
  _DeferrableRelationInitiallyImmediateImpl({
    int? id,
    required int parentId,
  }) : super._(
         id: id,
         parentId: parentId,
       );

  /// Returns a shallow copy of this [DeferrableRelationInitiallyImmediate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeferrableRelationInitiallyImmediate copyWith({
    Object? id = _Undefined,
    int? parentId,
  }) {
    return DeferrableRelationInitiallyImmediate(
      id: id is int? ? id : this.id,
      parentId: parentId ?? this.parentId,
    );
  }
}

class DeferrableRelationInitiallyImmediateUpdateTable
    extends _i1.UpdateTable<DeferrableRelationInitiallyImmediateTable> {
  DeferrableRelationInitiallyImmediateUpdateTable(super.table);

  _i1.ColumnValue<int, int> parentId(int value) => _i1.ColumnValue(
    table.parentId,
    value,
  );
}

class DeferrableRelationInitiallyImmediateTable extends _i1.Table<int?> {
  DeferrableRelationInitiallyImmediateTable({super.tableRelation})
    : super(tableName: 'deferrable_relation_initially_immediate') {
    updateTable = DeferrableRelationInitiallyImmediateUpdateTable(this);
    parentId = _i1.ColumnInt(
      'parentId',
      this,
    );
  }

  late final DeferrableRelationInitiallyImmediateUpdateTable updateTable;

  late final _i1.ColumnInt parentId;

  @override
  List<_i1.Column> get columns => [
    id,
    parentId,
  ];
}

class DeferrableRelationInitiallyImmediateInclude extends _i1.IncludeObject {
  @_i2.internal
  DeferrableRelationInitiallyImmediateInclude.internal_({
    List<_i1.Column>? this.selectedColumns,
  }) {}

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DeferrableRelationInitiallyImmediate.t;
}

class DeferrableRelationInitiallyImmediateIncludeList extends _i1.IncludeList {
  @_i2.internal
  DeferrableRelationInitiallyImmediateIncludeList.internal_({
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyImmediateTable>?
    where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_i1.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(DeferrableRelationInitiallyImmediate.t);
  }

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DeferrableRelationInitiallyImmediate.t;
}

class DeferrableRelationInitiallyImmediateRepository {
  const DeferrableRelationInitiallyImmediateRepository._();

  /// Returns a list of [DeferrableRelationInitiallyImmediate]s matching the given query parameters.
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
  Future<List<DeferrableRelationInitiallyImmediate>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyImmediateTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyImmediateTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyImmediateTable>?
    orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeferrableRelationInitiallyImmediate>(
      where: where?.call(DeferrableRelationInitiallyImmediate.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyImmediate.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyImmediate.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeferrableRelationInitiallyImmediate] matching the given query parameters.
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
  Future<DeferrableRelationInitiallyImmediate?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyImmediateTable>?
    where,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyImmediateTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyImmediateTable>?
    orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeferrableRelationInitiallyImmediate>(
      where: where?.call(DeferrableRelationInitiallyImmediate.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyImmediate.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyImmediate.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeferrableRelationInitiallyImmediate] by its [id] or null if no such row exists.
  Future<DeferrableRelationInitiallyImmediate?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeferrableRelationInitiallyImmediate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeferrableRelationInitiallyImmediate]s in the list and returns the inserted rows.
  ///
  /// The returned [DeferrableRelationInitiallyImmediate]s will have their `id` fields set.
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
  Future<List<DeferrableRelationInitiallyImmediate>> insert(
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyImmediate> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeferrableRelationInitiallyImmediate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeferrableRelationInitiallyImmediate] and returns the inserted row.
  ///
  /// The returned [DeferrableRelationInitiallyImmediate] will have its `id` field set.
  Future<DeferrableRelationInitiallyImmediate> insertRow(
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyImmediate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeferrableRelationInitiallyImmediate>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeferrableRelationInitiallyImmediate]s in the list and returns the resulting rows.
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
  /// The returned [DeferrableRelationInitiallyImmediate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationInitiallyImmediate>> upsert(
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyImmediate> rows, {
    required _i1.ColumnSelections<DeferrableRelationInitiallyImmediateTable>
    conflictColumns,
    _i1.ColumnSelections<DeferrableRelationInitiallyImmediateTable>?
    updateColumns,
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyImmediateTable>?
    updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeferrableRelationInitiallyImmediate>(
      rows,
      conflictColumns: conflictColumns(DeferrableRelationInitiallyImmediate.t),
      updateColumns: updateColumns?.call(
        DeferrableRelationInitiallyImmediate.t,
      ),
      updateWhere: updateWhere?.call(DeferrableRelationInitiallyImmediate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeferrableRelationInitiallyImmediate] and returns the resulting row.
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
  /// The returned [DeferrableRelationInitiallyImmediate] will have its `id` field set.
  Future<DeferrableRelationInitiallyImmediate?> upsertRow(
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyImmediate row, {
    required _i1.ColumnSelections<DeferrableRelationInitiallyImmediateTable>
    conflictColumns,
    _i1.ColumnSelections<DeferrableRelationInitiallyImmediateTable>?
    updateColumns,
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyImmediateTable>?
    updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeferrableRelationInitiallyImmediate>(
      row,
      conflictColumns: conflictColumns(DeferrableRelationInitiallyImmediate.t),
      updateColumns: updateColumns?.call(
        DeferrableRelationInitiallyImmediate.t,
      ),
      updateWhere: updateWhere?.call(DeferrableRelationInitiallyImmediate.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeferrableRelationInitiallyImmediate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationInitiallyImmediate>> update(
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyImmediate> rows, {
    _i1.ColumnSelections<DeferrableRelationInitiallyImmediateTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeferrableRelationInitiallyImmediate>(
      rows,
      columns: columns?.call(DeferrableRelationInitiallyImmediate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeferrableRelationInitiallyImmediate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeferrableRelationInitiallyImmediate> updateRow(
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyImmediate row, {
    _i1.ColumnSelections<DeferrableRelationInitiallyImmediateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeferrableRelationInitiallyImmediate>(
      row,
      columns: columns?.call(DeferrableRelationInitiallyImmediate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeferrableRelationInitiallyImmediate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeferrableRelationInitiallyImmediate?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<
      DeferrableRelationInitiallyImmediateUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeferrableRelationInitiallyImmediate>(
      id,
      columnValues: columnValues(
        DeferrableRelationInitiallyImmediate.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [DeferrableRelationInitiallyImmediate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationInitiallyImmediate>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<
      DeferrableRelationInitiallyImmediateUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<
      DeferrableRelationInitiallyImmediateTable
    >
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationInitiallyImmediateTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyImmediateTable>?
    orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeferrableRelationInitiallyImmediate>(
      columnValues: columnValues(
        DeferrableRelationInitiallyImmediate.t.updateTable,
      ),
      where: where(DeferrableRelationInitiallyImmediate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeferrableRelationInitiallyImmediate.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyImmediate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeferrableRelationInitiallyImmediate]s in the list and returns the deleted rows.
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
  Future<List<DeferrableRelationInitiallyImmediate>> delete(
    _i1.DatabaseSession session,
    List<DeferrableRelationInitiallyImmediate> rows, {
    _i1.OrderByBuilder<DeferrableRelationInitiallyImmediateTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyImmediateTable>?
    orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeferrableRelationInitiallyImmediate>(
      rows,
      orderBy: orderBy?.call(DeferrableRelationInitiallyImmediate.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyImmediate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeferrableRelationInitiallyImmediate].
  Future<DeferrableRelationInitiallyImmediate> deleteRow(
    _i1.DatabaseSession session,
    DeferrableRelationInitiallyImmediate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeferrableRelationInitiallyImmediate>(
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
  Future<List<DeferrableRelationInitiallyImmediate>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<
      DeferrableRelationInitiallyImmediateTable
    >
    where,
    _i1.OrderByBuilder<DeferrableRelationInitiallyImmediateTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationInitiallyImmediateTable>?
    orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeferrableRelationInitiallyImmediate>(
      where: where(DeferrableRelationInitiallyImmediate.t),
      orderBy: orderBy?.call(DeferrableRelationInitiallyImmediate.t),
      orderByList: orderByList?.call(DeferrableRelationInitiallyImmediate.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationInitiallyImmediateTable>?
    where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeferrableRelationInitiallyImmediate>(
      where: where?.call(DeferrableRelationInitiallyImmediate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeferrableRelationInitiallyImmediate] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<
      DeferrableRelationInitiallyImmediateTable
    >
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeferrableRelationInitiallyImmediate>(
      where: where(DeferrableRelationInitiallyImmediate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
