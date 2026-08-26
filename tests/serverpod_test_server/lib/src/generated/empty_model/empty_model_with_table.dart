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

abstract class EmptyModelWithTable
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EmptyModelWithTable._({this.id});

  factory EmptyModelWithTable({int? id}) = _EmptyModelWithTableImpl;

  factory EmptyModelWithTable.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmptyModelWithTable(id: jsonSerialization['id'] as int?);
  }

  static final t = EmptyModelWithTableTable();

  static const db = EmptyModelWithTableRepository._();

  @override
  int? id;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmptyModelWithTable]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EmptyModelWithTable copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmptyModelWithTable',
      if (id != null) 'id': id,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmptyModelWithTable',
      if (id != null) 'id': id,
    };
  }

  /// Builds a complete [EmptyModelWithTableInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EmptyModelWithTableInclude include() {
    return EmptyModelWithTableInclude._();
  }

  /// Builds a complete [EmptyModelWithTableIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EmptyModelWithTableIncludeList includeList({
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    EmptyModelWithTableInclude? include,
  }) {
    return EmptyModelWithTableIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [EmptyModelWithTableJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static EmptyModelWithTableJsonInclude includeJson({
    _is.SelectColumnsBuilder<EmptyModelWithTableTable>? select,
  }) {
    return _EmptyModelWithTableJsonInclude._(
      selectedColumns: select?.call(EmptyModelWithTable.t),
    );
  }

  /// Builds a JSON-compatible [EmptyModelWithTableJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static EmptyModelWithTableJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    EmptyModelWithTableJsonInclude? include,
    _is.SelectColumnsBuilder<EmptyModelWithTableTable>? select,
  }) {
    return _EmptyModelWithTableJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      include: include,
      selectedColumns: select?.call(EmptyModelWithTable.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmptyModelWithTableImpl extends EmptyModelWithTable {
  _EmptyModelWithTableImpl({int? id}) : super._(id: id);

  /// Returns a shallow copy of this [EmptyModelWithTable]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EmptyModelWithTable copyWith({Object? id = _Undefined}) {
    return EmptyModelWithTable(id: id is int? ? id : this.id);
  }
}

class EmptyModelWithTableUpdateTable
    extends _is.UpdateTable<EmptyModelWithTableTable> {
  EmptyModelWithTableUpdateTable(super.table);
}

class EmptyModelWithTableTable extends _is.Table<int?> {
  EmptyModelWithTableTable({super.tableRelation})
    : super(tableName: 'empty_model_with_table') {
    updateTable = EmptyModelWithTableUpdateTable(this);
  }

  late final EmptyModelWithTableUpdateTable updateTable;

  @override
  List<_is.Column> get columns => [id];
}

abstract interface class EmptyModelWithTableJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class EmptyModelWithTableJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class EmptyModelWithTableInclude extends _is.IncludeObject
    implements EmptyModelWithTableJsonInclude, _is.FullModelInclude {
  EmptyModelWithTableInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmptyModelWithTable.t;
}

final class EmptyModelWithTableIncludeList extends _is.IncludeList
    implements EmptyModelWithTableJsonIncludeList, _is.FullModelInclude {
  EmptyModelWithTableIncludeList._({
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EmptyModelWithTableInclude? super.include,
  }) {
    super.where = where?.call(EmptyModelWithTable.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmptyModelWithTable.t;
}

final class _EmptyModelWithTableJsonInclude extends _is.IncludeObject
    implements EmptyModelWithTableJsonInclude {
  _EmptyModelWithTableJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EmptyModelWithTable.t;
}

final class _EmptyModelWithTableJsonIncludeList extends _is.IncludeList
    implements EmptyModelWithTableJsonIncludeList {
  _EmptyModelWithTableJsonIncludeList._({
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EmptyModelWithTableJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EmptyModelWithTable.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EmptyModelWithTable.t;
}

class EmptyModelWithTableRepository {
  const EmptyModelWithTableRepository._();

  /// Returns a list of [EmptyModelWithTable]s matching the given query parameters.
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
  Future<List<EmptyModelWithTable>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmptyModelWithTable] matching the given query parameters.
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
  Future<EmptyModelWithTable?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? offset,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmptyModelWithTable] by its [id] or null if no such row exists.
  Future<EmptyModelWithTable?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmptyModelWithTable>(
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
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmptyModelWithTableTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EmptyModelWithTable.t),
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
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? offset,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EmptyModelWithTableTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EmptyModelWithTable.t),
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
    _is.SelectColumnsBuilder<EmptyModelWithTableTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmptyModelWithTable>(
      id,
      transaction: transaction,
      select: select?.call(EmptyModelWithTable.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmptyModelWithTable]s in the list and returns the inserted rows.
  ///
  /// The returned [EmptyModelWithTable]s will have their `id` fields set.
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
  Future<List<EmptyModelWithTable>> insert(
    _is.DatabaseSession session,
    List<EmptyModelWithTable> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmptyModelWithTable>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmptyModelWithTable] and returns the inserted row.
  ///
  /// The returned [EmptyModelWithTable] will have its `id` field set.
  Future<EmptyModelWithTable> insertRow(
    _is.DatabaseSession session,
    EmptyModelWithTable row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmptyModelWithTable>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmptyModelWithTable]s in the list and returns the resulting rows.
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
  /// The returned [EmptyModelWithTable]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmptyModelWithTable>> upsert(
    _is.DatabaseSession session,
    List<EmptyModelWithTable> rows, {
    required _is.ColumnSelections<EmptyModelWithTableTable> conflictColumns,
    _is.ColumnSelections<EmptyModelWithTableTable>? updateColumns,
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmptyModelWithTable>(
      rows,
      conflictColumns: conflictColumns(EmptyModelWithTable.t),
      updateColumns: updateColumns?.call(EmptyModelWithTable.t),
      updateWhere: updateWhere?.call(EmptyModelWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmptyModelWithTable] and returns the resulting row.
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
  /// The returned [EmptyModelWithTable] will have its `id` field set.
  Future<EmptyModelWithTable?> upsertRow(
    _is.DatabaseSession session,
    EmptyModelWithTable row, {
    required _is.ColumnSelections<EmptyModelWithTableTable> conflictColumns,
    _is.ColumnSelections<EmptyModelWithTableTable>? updateColumns,
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmptyModelWithTable>(
      row,
      conflictColumns: conflictColumns(EmptyModelWithTable.t),
      updateColumns: updateColumns?.call(EmptyModelWithTable.t),
      updateWhere: updateWhere?.call(EmptyModelWithTable.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmptyModelWithTable]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmptyModelWithTable>> update(
    _is.DatabaseSession session,
    List<EmptyModelWithTable> rows, {
    _is.ColumnSelections<EmptyModelWithTableTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmptyModelWithTable>(
      rows,
      columns: columns?.call(EmptyModelWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmptyModelWithTable]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmptyModelWithTable> updateRow(
    _is.DatabaseSession session,
    EmptyModelWithTable row, {
    _is.ColumnSelections<EmptyModelWithTableTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmptyModelWithTable>(
      row,
      columns: columns?.call(EmptyModelWithTable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmptyModelWithTable] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmptyModelWithTable?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EmptyModelWithTableUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EmptyModelWithTable>(
      id,
      columnValues: columnValues(EmptyModelWithTable.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmptyModelWithTable]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmptyModelWithTable>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EmptyModelWithTableUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EmptyModelWithTableTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmptyModelWithTable>(
      columnValues: columnValues(EmptyModelWithTable.t.updateTable),
      where: where(EmptyModelWithTable.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmptyModelWithTable]s in the list and returns the deleted rows.
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
  Future<List<EmptyModelWithTable>> delete(
    _is.DatabaseSession session,
    List<EmptyModelWithTable> rows, {
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmptyModelWithTable>(
      rows,
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmptyModelWithTable].
  Future<EmptyModelWithTable> deleteRow(
    _is.DatabaseSession session,
    EmptyModelWithTable row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmptyModelWithTable>(
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
  Future<List<EmptyModelWithTable>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmptyModelWithTableTable> where,
    _is.OrderByBuilder<EmptyModelWithTableTable>? orderBy,
    _is.OrderByListBuilder<EmptyModelWithTableTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmptyModelWithTable>(
      where: where(EmptyModelWithTable.t),
      orderBy: orderBy?.call(EmptyModelWithTable.t),
      orderByList: orderByList?.call(EmptyModelWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EmptyModelWithTableTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EmptyModelWithTable>(
      where: where?.call(EmptyModelWithTable.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmptyModelWithTable] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EmptyModelWithTableTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmptyModelWithTable>(
      where: where(EmptyModelWithTable.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
