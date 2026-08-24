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

abstract class IntDefaultPersist
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  IntDefaultPersist._({
    this.id,
    this.intDefaultPersist,
  });

  factory IntDefaultPersist({
    int? id,
    int? intDefaultPersist,
  }) = _IntDefaultPersistImpl;

  factory IntDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultPersist(
      id: jsonSerialization['id'] as int?,
      intDefaultPersist: jsonSerialization['intDefaultPersist'] as int?,
    );
  }

  static final t = IntDefaultPersistTable();

  static const db = IntDefaultPersistRepository._();

  @override
  int? id;

  int? intDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [IntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IntDefaultPersist copyWith({
    int? id,
    int? intDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IntDefaultPersist',
      if (id != null) 'id': id,
      if (intDefaultPersist != null) 'intDefaultPersist': intDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IntDefaultPersist',
      if (id != null) 'id': id,
      if (intDefaultPersist != null) 'intDefaultPersist': intDefaultPersist,
    };
  }

  static IntDefaultPersistInclude include() {
    return IntDefaultPersistInclude._();
  }

  static IntDefaultPersistIncludeList includeList({
    _is.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    IntDefaultPersistInclude? include,
  }) {
    return IntDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultPersistImpl extends IntDefaultPersist {
  _IntDefaultPersistImpl({
    int? id,
    int? intDefaultPersist,
  }) : super._(
         id: id,
         intDefaultPersist: intDefaultPersist,
       );

  /// Returns a shallow copy of this [IntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IntDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? intDefaultPersist = _Undefined,
  }) {
    return IntDefaultPersist(
      id: id is int? ? id : this.id,
      intDefaultPersist: intDefaultPersist is int?
          ? intDefaultPersist
          : this.intDefaultPersist,
    );
  }
}

class IntDefaultPersistUpdateTable
    extends _is.UpdateTable<IntDefaultPersistTable> {
  IntDefaultPersistUpdateTable(super.table);

  _is.ColumnValue<int, int> intDefaultPersist(int? value) => _is.ColumnValue(
    table.intDefaultPersist,
    value,
  );
}

class IntDefaultPersistTable extends _is.Table<int?> {
  IntDefaultPersistTable({super.tableRelation})
    : super(tableName: 'int_default_persist') {
    updateTable = IntDefaultPersistUpdateTable(this);
    intDefaultPersist = _is.ColumnInt(
      'intDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final IntDefaultPersistUpdateTable updateTable;

  late final _is.ColumnInt intDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    intDefaultPersist,
  ];
}

class IntDefaultPersistInclude extends _is.IncludeObject {
  IntDefaultPersistInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IntDefaultPersist.t;
}

class IntDefaultPersistIncludeList extends _is.IncludeList {
  IntDefaultPersistIncludeList._({
    _is.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IntDefaultPersist.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IntDefaultPersist.t;
}

class IntDefaultPersistRepository {
  const IntDefaultPersistRepository._();

  /// Returns a list of [IntDefaultPersist]s matching the given query parameters.
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
  Future<List<IntDefaultPersist>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IntDefaultPersist>(
      where: where?.call(IntDefaultPersist.t),
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IntDefaultPersist] matching the given query parameters.
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
  Future<IntDefaultPersist?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IntDefaultPersist>(
      where: where?.call(IntDefaultPersist.t),
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IntDefaultPersist] by its [id] or null if no such row exists.
  Future<IntDefaultPersist?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IntDefaultPersist>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IntDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [IntDefaultPersist]s will have their `id` fields set.
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
  Future<List<IntDefaultPersist>> insert(
    _is.DatabaseSession session,
    List<IntDefaultPersist> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IntDefaultPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IntDefaultPersist] and returns the inserted row.
  ///
  /// The returned [IntDefaultPersist] will have its `id` field set.
  Future<IntDefaultPersist> insertRow(
    _is.DatabaseSession session,
    IntDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IntDefaultPersist]s in the list and returns the resulting rows.
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
  /// The returned [IntDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultPersist>> upsert(
    _is.DatabaseSession session,
    List<IntDefaultPersist> rows, {
    required _is.ColumnSelections<IntDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<IntDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<IntDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IntDefaultPersist>(
      rows,
      conflictColumns: conflictColumns(IntDefaultPersist.t),
      updateColumns: updateColumns?.call(IntDefaultPersist.t),
      updateWhere: updateWhere?.call(IntDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IntDefaultPersist] and returns the resulting row.
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
  /// The returned [IntDefaultPersist] will have its `id` field set.
  Future<IntDefaultPersist?> upsertRow(
    _is.DatabaseSession session,
    IntDefaultPersist row, {
    required _is.ColumnSelections<IntDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<IntDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<IntDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IntDefaultPersist>(
      row,
      conflictColumns: conflictColumns(IntDefaultPersist.t),
      updateColumns: updateColumns?.call(IntDefaultPersist.t),
      updateWhere: updateWhere?.call(IntDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates all [IntDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultPersist>> update(
    _is.DatabaseSession session,
    List<IntDefaultPersist> rows, {
    _is.ColumnSelections<IntDefaultPersistTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IntDefaultPersist>(
      rows,
      columns: columns?.call(IntDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IntDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IntDefaultPersist> updateRow(
    _is.DatabaseSession session,
    IntDefaultPersist row, {
    _is.ColumnSelections<IntDefaultPersistTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntDefaultPersist>(
      row,
      columns: columns?.call(IntDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IntDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IntDefaultPersist?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IntDefaultPersistUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IntDefaultPersist>(
      id,
      columnValues: columnValues(IntDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IntDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultPersist>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IntDefaultPersistUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<IntDefaultPersistTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IntDefaultPersist>(
      columnValues: columnValues(IntDefaultPersist.t.updateTable),
      where: where(IntDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IntDefaultPersist]s in the list and returns the deleted rows.
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
  Future<List<IntDefaultPersist>> delete(
    _is.DatabaseSession session,
    List<IntDefaultPersist> rows, {
    _is.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IntDefaultPersist>(
      rows,
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IntDefaultPersist].
  Future<IntDefaultPersist> deleteRow(
    _is.DatabaseSession session,
    IntDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntDefaultPersist>(
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
  Future<List<IntDefaultPersist>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IntDefaultPersistTable> where,
    _is.OrderByBuilder<IntDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IntDefaultPersist>(
      where: where(IntDefaultPersist.t),
      orderBy: orderBy?.call(IntDefaultPersist.t),
      orderByList: orderByList?.call(IntDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultPersistTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IntDefaultPersist>(
      where: where?.call(IntDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IntDefaultPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IntDefaultPersistTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IntDefaultPersist>(
      where: where(IntDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
