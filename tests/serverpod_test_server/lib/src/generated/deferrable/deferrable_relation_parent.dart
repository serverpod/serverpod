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

abstract class DeferrableRelationParent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DeferrableRelationParent._({
    this.id,
    required this.name,
  });

  factory DeferrableRelationParent({
    int? id,
    required String name,
  }) = _DeferrableRelationParentImpl;

  factory DeferrableRelationParent.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeferrableRelationParent(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  static final t = DeferrableRelationParentTable();

  static const db = DeferrableRelationParentRepository._();

  @override
  int? id;

  String name;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeferrableRelationParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeferrableRelationParent copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeferrableRelationParent',
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeferrableRelationParent',
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static DeferrableRelationParentInclude include() {
    return DeferrableRelationParentInclude._();
  }

  static DeferrableRelationParentIncludeList includeList({
    _i1.WhereExpressionBuilder<DeferrableRelationParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationParentTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationParentTable>? orderByList,
    DeferrableRelationParentInclude? include,
  }) {
    return DeferrableRelationParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeferrableRelationParent.t),
      orderByList: orderByList?.call(DeferrableRelationParent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeferrableRelationParentImpl extends DeferrableRelationParent {
  _DeferrableRelationParentImpl({
    int? id,
    required String name,
  }) : super._(
         id: id,
         name: name,
       );

  /// Returns a shallow copy of this [DeferrableRelationParent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeferrableRelationParent copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return DeferrableRelationParent(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class DeferrableRelationParentUpdateTable
    extends _i1.UpdateTable<DeferrableRelationParentTable> {
  DeferrableRelationParentUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );
}

class DeferrableRelationParentTable extends _i1.Table<int?> {
  DeferrableRelationParentTable({super.tableRelation})
    : super(tableName: 'deferrable_relation_parent') {
    updateTable = DeferrableRelationParentUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final DeferrableRelationParentUpdateTable updateTable;

  late final _i1.ColumnString name;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
  ];
}

class DeferrableRelationParentInclude extends _i1.IncludeObject {
  DeferrableRelationParentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DeferrableRelationParent.t;
}

class DeferrableRelationParentIncludeList extends _i1.IncludeList {
  DeferrableRelationParentIncludeList._({
    _i1.WhereExpressionBuilder<DeferrableRelationParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeferrableRelationParent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DeferrableRelationParent.t;
}

class DeferrableRelationParentRepository {
  const DeferrableRelationParentRepository._();

  /// Returns a list of [DeferrableRelationParent]s matching the given query parameters.
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
  Future<List<DeferrableRelationParent>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationParentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationParentTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationParentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeferrableRelationParent>(
      where: where?.call(DeferrableRelationParent.t),
      orderBy: orderBy?.call(DeferrableRelationParent.t),
      orderByList: orderByList?.call(DeferrableRelationParent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeferrableRelationParent] matching the given query parameters.
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
  Future<DeferrableRelationParent?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationParentTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationParentTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationParentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeferrableRelationParent>(
      where: where?.call(DeferrableRelationParent.t),
      orderBy: orderBy?.call(DeferrableRelationParent.t),
      orderByList: orderByList?.call(DeferrableRelationParent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeferrableRelationParent] by its [id] or null if no such row exists.
  Future<DeferrableRelationParent?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeferrableRelationParent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeferrableRelationParent]s in the list and returns the inserted rows.
  ///
  /// The returned [DeferrableRelationParent]s will have their `id` fields set.
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
  Future<List<DeferrableRelationParent>> insert(
    _i1.DatabaseSession session,
    List<DeferrableRelationParent> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeferrableRelationParent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeferrableRelationParent] and returns the inserted row.
  ///
  /// The returned [DeferrableRelationParent] will have its `id` field set.
  Future<DeferrableRelationParent> insertRow(
    _i1.DatabaseSession session,
    DeferrableRelationParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeferrableRelationParent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeferrableRelationParent]s in the list and returns the resulting rows.
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
  /// The returned [DeferrableRelationParent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationParent>> upsert(
    _i1.DatabaseSession session,
    List<DeferrableRelationParent> rows, {
    required _i1.ColumnSelections<DeferrableRelationParentTable>
    conflictColumns,
    _i1.ColumnSelections<DeferrableRelationParentTable>? updateColumns,
    _i1.WhereExpressionBuilder<DeferrableRelationParentTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeferrableRelationParent>(
      rows,
      conflictColumns: conflictColumns(DeferrableRelationParent.t),
      updateColumns: updateColumns?.call(DeferrableRelationParent.t),
      updateWhere: updateWhere?.call(DeferrableRelationParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeferrableRelationParent] and returns the resulting row.
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
  /// The returned [DeferrableRelationParent] will have its `id` field set.
  Future<DeferrableRelationParent?> upsertRow(
    _i1.DatabaseSession session,
    DeferrableRelationParent row, {
    required _i1.ColumnSelections<DeferrableRelationParentTable>
    conflictColumns,
    _i1.ColumnSelections<DeferrableRelationParentTable>? updateColumns,
    _i1.WhereExpressionBuilder<DeferrableRelationParentTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeferrableRelationParent>(
      row,
      conflictColumns: conflictColumns(DeferrableRelationParent.t),
      updateColumns: updateColumns?.call(DeferrableRelationParent.t),
      updateWhere: updateWhere?.call(DeferrableRelationParent.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeferrableRelationParent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationParent>> update(
    _i1.DatabaseSession session,
    List<DeferrableRelationParent> rows, {
    _i1.ColumnSelections<DeferrableRelationParentTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeferrableRelationParent>(
      rows,
      columns: columns?.call(DeferrableRelationParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeferrableRelationParent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeferrableRelationParent> updateRow(
    _i1.DatabaseSession session,
    DeferrableRelationParent row, {
    _i1.ColumnSelections<DeferrableRelationParentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeferrableRelationParent>(
      row,
      columns: columns?.call(DeferrableRelationParent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeferrableRelationParent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeferrableRelationParent?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DeferrableRelationParentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeferrableRelationParent>(
      id,
      columnValues: columnValues(DeferrableRelationParent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeferrableRelationParent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeferrableRelationParent>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeferrableRelationParentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DeferrableRelationParentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeferrableRelationParentTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationParentTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeferrableRelationParent>(
      columnValues: columnValues(DeferrableRelationParent.t.updateTable),
      where: where(DeferrableRelationParent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeferrableRelationParent.t),
      orderByList: orderByList?.call(DeferrableRelationParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeferrableRelationParent]s in the list and returns the deleted rows.
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
  Future<List<DeferrableRelationParent>> delete(
    _i1.DatabaseSession session,
    List<DeferrableRelationParent> rows, {
    _i1.OrderByBuilder<DeferrableRelationParentTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationParentTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeferrableRelationParent>(
      rows,
      orderBy: orderBy?.call(DeferrableRelationParent.t),
      orderByList: orderByList?.call(DeferrableRelationParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeferrableRelationParent].
  Future<DeferrableRelationParent> deleteRow(
    _i1.DatabaseSession session,
    DeferrableRelationParent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeferrableRelationParent>(
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
  Future<List<DeferrableRelationParent>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeferrableRelationParentTable> where,
    _i1.OrderByBuilder<DeferrableRelationParentTable>? orderBy,
    _i1.OrderByListBuilder<DeferrableRelationParentTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeferrableRelationParent>(
      where: where(DeferrableRelationParent.t),
      orderBy: orderBy?.call(DeferrableRelationParent.t),
      orderByList: orderByList?.call(DeferrableRelationParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeferrableRelationParentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeferrableRelationParent>(
      where: where?.call(DeferrableRelationParent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeferrableRelationParent] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeferrableRelationParentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeferrableRelationParent>(
      where: where(DeferrableRelationParent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
