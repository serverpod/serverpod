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

abstract class ObjectWithParent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithParent._({
    this.id,
    required this.other,
  });

  factory ObjectWithParent({
    int? id,
    required int other,
  }) = _ObjectWithParentImpl;

  factory ObjectWithParent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithParent(
      id: jsonSerialization['id'] as int?,
      other: jsonSerialization['other'] as int,
    );
  }

  static final t = ObjectWithParentTable();

  static const db = ObjectWithParentRepository._();

  @override
  int? id;

  int other;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithParent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithParent copyWith({
    int? id,
    int? other,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithParent',
      if (id != null) 'id': id,
      'other': other,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithParent',
      if (id != null) 'id': id,
      'other': other,
    };
  }

  /// Builds a complete [ObjectWithParentInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithParentInclude include() {
    return ObjectWithParentInclude._();
  }

  /// Builds a complete [ObjectWithParentIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithParentIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    ObjectWithParentInclude? include,
  }) {
    return ObjectWithParentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ObjectWithParentJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ObjectWithParentJsonInclude includeJson({
    _is.SelectColumnsBuilder<ObjectWithParentTable>? select,
  }) {
    return _ObjectWithParentJsonInclude._(
      selectedColumns: select?.call(ObjectWithParent.t),
    );
  }

  /// Builds a JSON-compatible [ObjectWithParentJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ObjectWithParentJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    ObjectWithParentJsonInclude? include,
    _is.SelectColumnsBuilder<ObjectWithParentTable>? select,
  }) {
    return _ObjectWithParentJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      include: include,
      selectedColumns: select?.call(ObjectWithParent.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithParentImpl extends ObjectWithParent {
  _ObjectWithParentImpl({
    int? id,
    required int other,
  }) : super._(
         id: id,
         other: other,
       );

  /// Returns a shallow copy of this [ObjectWithParent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithParent copyWith({
    Object? id = _Undefined,
    int? other,
  }) {
    return ObjectWithParent(
      id: id is int? ? id : this.id,
      other: other ?? this.other,
    );
  }
}

class ObjectWithParentUpdateTable
    extends _is.UpdateTable<ObjectWithParentTable> {
  ObjectWithParentUpdateTable(super.table);

  _is.ColumnValue<int, int> other(int value) => _is.ColumnValue(
    table.other,
    value,
  );
}

class ObjectWithParentTable extends _is.Table<int?> {
  ObjectWithParentTable({super.tableRelation})
    : super(tableName: 'object_with_parent') {
    updateTable = ObjectWithParentUpdateTable(this);
    other = _is.ColumnInt(
      'other',
      this,
    );
  }

  late final ObjectWithParentUpdateTable updateTable;

  late final _is.ColumnInt other;

  @override
  List<_is.Column> get columns => [
    id,
    other,
  ];
}

abstract interface class ObjectWithParentJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ObjectWithParentJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ObjectWithParentInclude extends _is.IncludeObject
    implements ObjectWithParentJsonInclude, _is.FullModelInclude {
  ObjectWithParentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithParent.t;
}

final class ObjectWithParentIncludeList extends _is.IncludeList
    implements ObjectWithParentJsonIncludeList, _is.FullModelInclude {
  ObjectWithParentIncludeList._({
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithParentInclude? super.include,
  }) {
    super.where = where?.call(ObjectWithParent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithParent.t;
}

final class _ObjectWithParentJsonInclude extends _is.IncludeObject
    implements ObjectWithParentJsonInclude {
  _ObjectWithParentJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithParent.t;
}

final class _ObjectWithParentJsonIncludeList extends _is.IncludeList
    implements ObjectWithParentJsonIncludeList {
  _ObjectWithParentJsonIncludeList._({
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithParentJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithParent.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithParent.t;
}

class ObjectWithParentRepository {
  const ObjectWithParentRepository._();

  /// Returns a list of [ObjectWithParent]s matching the given query parameters.
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
  Future<List<ObjectWithParent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithParent] matching the given query parameters.
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
  Future<ObjectWithParent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithParent] by its [id] or null if no such row exists.
  Future<ObjectWithParent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithParent>(
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
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithParentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithParent.t),
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
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithParentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithParent.t),
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
    _is.SelectColumnsBuilder<ObjectWithParentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ObjectWithParent>(
      id,
      transaction: transaction,
      select: select?.call(ObjectWithParent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithParent]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithParent]s will have their `id` fields set.
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
  Future<List<ObjectWithParent>> insert(
    _is.DatabaseSession session,
    List<ObjectWithParent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithParent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithParent] and returns the inserted row.
  ///
  /// The returned [ObjectWithParent] will have its `id` field set.
  Future<ObjectWithParent> insertRow(
    _is.DatabaseSession session,
    ObjectWithParent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithParent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithParent]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithParent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithParent>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithParent> rows, {
    required _is.ColumnSelections<ObjectWithParentTable> conflictColumns,
    _is.ColumnSelections<ObjectWithParentTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithParentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithParent>(
      rows,
      conflictColumns: conflictColumns(ObjectWithParent.t),
      updateColumns: updateColumns?.call(ObjectWithParent.t),
      updateWhere: updateWhere?.call(ObjectWithParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithParent] and returns the resulting row.
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
  /// The returned [ObjectWithParent] will have its `id` field set.
  Future<ObjectWithParent?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithParent row, {
    required _is.ColumnSelections<ObjectWithParentTable> conflictColumns,
    _is.ColumnSelections<ObjectWithParentTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithParentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithParent>(
      row,
      conflictColumns: conflictColumns(ObjectWithParent.t),
      updateColumns: updateColumns?.call(ObjectWithParent.t),
      updateWhere: updateWhere?.call(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithParent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithParent>> update(
    _is.DatabaseSession session,
    List<ObjectWithParent> rows, {
    _is.ColumnSelections<ObjectWithParentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithParent>(
      rows,
      columns: columns?.call(ObjectWithParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithParent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithParent> updateRow(
    _is.DatabaseSession session,
    ObjectWithParent row, {
    _is.ColumnSelections<ObjectWithParentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithParent>(
      row,
      columns: columns?.call(ObjectWithParent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithParent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithParent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithParentUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithParent>(
      id,
      columnValues: columnValues(ObjectWithParent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithParent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithParent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithParentUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithParentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithParent>(
      columnValues: columnValues(ObjectWithParent.t.updateTable),
      where: where(ObjectWithParent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithParent]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithParent>> delete(
    _is.DatabaseSession session,
    List<ObjectWithParent> rows, {
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithParent>(
      rows,
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithParent].
  Future<ObjectWithParent> deleteRow(
    _is.DatabaseSession session,
    ObjectWithParent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithParent>(
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
  Future<List<ObjectWithParent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithParentTable> where,
    _is.OrderByBuilder<ObjectWithParentTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithParentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithParent>(
      where: where(ObjectWithParent.t),
      orderBy: orderBy?.call(ObjectWithParent.t),
      orderByList: orderByList?.call(ObjectWithParent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithParentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithParent>(
      where: where?.call(ObjectWithParent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithParent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithParentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithParent>(
      where: where(ObjectWithParent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
