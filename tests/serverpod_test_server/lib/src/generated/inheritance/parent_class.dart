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
import '../protocol.dart' as _iv35mfmj;

class ParentClass extends _iv35mfmj.GrandparentClass
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ParentClass({
    this.id,
    required super.grandParentField,
    required this.parentField,
  });

  factory ParentClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentClass(
      id: jsonSerialization['id'] as int?,
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
    );
  }

  static final t = ParentClassTable();

  static const db = ParentClassRepository._();

  @override
  int? id;

  String parentField;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ParentClass]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ParentClass copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
  }) {
    return ParentClass(
      id: id is int? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentClass',
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParentClass',
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  /// Builds a complete [ParentClassInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ParentClassInclude include() {
    return ParentClassInclude._();
  }

  /// Builds a complete [ParentClassIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ParentClassIncludeList includeList({
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    ParentClassInclude? include,
  }) {
    return ParentClassIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ParentClassJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ParentClassJsonInclude includeJson({
    _is.SelectColumnsBuilder<ParentClassTable>? select,
  }) {
    return _ParentClassJsonInclude._(
      selectedColumns: select?.call(ParentClass.t),
    );
  }

  /// Builds a JSON-compatible [ParentClassJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ParentClassJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    ParentClassJsonInclude? include,
    _is.SelectColumnsBuilder<ParentClassTable>? select,
  }) {
    return _ParentClassJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      include: include,
      selectedColumns: select?.call(ParentClass.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class ParentClassUpdateTable extends _is.UpdateTable<ParentClassTable> {
  ParentClassUpdateTable(super.table);

  _is.ColumnValue<String, String> grandParentField(String value) =>
      _is.ColumnValue(
        table.grandParentField,
        value,
      );

  _is.ColumnValue<String, String> parentField(String value) => _is.ColumnValue(
    table.parentField,
    value,
  );
}

class ParentClassTable extends _is.Table<int?> {
  ParentClassTable({super.tableRelation})
    : super(tableName: 'parent_class_table') {
    updateTable = ParentClassUpdateTable(this);
    grandParentField = _is.ColumnString(
      'grandParentField',
      this,
    );
    parentField = _is.ColumnString(
      'parentField',
      this,
    );
  }

  late final ParentClassUpdateTable updateTable;

  late final _is.ColumnString grandParentField;

  late final _is.ColumnString parentField;

  @override
  List<_is.Column> get columns => [
    id,
    grandParentField,
    parentField,
  ];
}

abstract interface class ParentClassJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ParentClassJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ParentClassInclude extends _is.IncludeObject
    implements ParentClassJsonInclude, _is.FullModelInclude {
  ParentClassInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ParentClass.t;
}

final class ParentClassIncludeList extends _is.IncludeList
    implements ParentClassJsonIncludeList, _is.FullModelInclude {
  ParentClassIncludeList._({
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ParentClassInclude? super.include,
  }) {
    super.where = where?.call(ParentClass.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ParentClass.t;
}

final class _ParentClassJsonInclude extends _is.IncludeObject
    implements ParentClassJsonInclude {
  _ParentClassJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ParentClass.t;
}

final class _ParentClassJsonIncludeList extends _is.IncludeList
    implements ParentClassJsonIncludeList {
  _ParentClassJsonIncludeList._({
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ParentClassJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ParentClass.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ParentClass.t;
}

class ParentClassRepository {
  const ParentClassRepository._();

  /// Returns a list of [ParentClass]s matching the given query parameters.
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
  Future<List<ParentClass>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ParentClass>(
      where: where?.call(ParentClass.t),
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ParentClass] matching the given query parameters.
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
  Future<ParentClass?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    int? offset,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ParentClass>(
      where: where?.call(ParentClass.t),
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ParentClass] by its [id] or null if no such row exists.
  Future<ParentClass?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ParentClass>(
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
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ParentClassTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ParentClass>(
      where: where?.call(ParentClass.t),
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ParentClass.t),
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
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    int? offset,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ParentClassTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ParentClass>(
      where: where?.call(ParentClass.t),
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ParentClass.t),
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
    _is.SelectColumnsBuilder<ParentClassTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ParentClass>(
      id,
      transaction: transaction,
      select: select?.call(ParentClass.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ParentClass]s in the list and returns the inserted rows.
  ///
  /// The returned [ParentClass]s will have their `id` fields set.
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
  Future<List<ParentClass>> insert(
    _is.DatabaseSession session,
    List<ParentClass> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ParentClass>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ParentClass] and returns the inserted row.
  ///
  /// The returned [ParentClass] will have its `id` field set.
  Future<ParentClass> insertRow(
    _is.DatabaseSession session,
    ParentClass row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ParentClass>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ParentClass]s in the list and returns the resulting rows.
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
  /// The returned [ParentClass]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ParentClass>> upsert(
    _is.DatabaseSession session,
    List<ParentClass> rows, {
    required _is.ColumnSelections<ParentClassTable> conflictColumns,
    _is.ColumnSelections<ParentClassTable>? updateColumns,
    _is.WhereExpressionBuilder<ParentClassTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ParentClass>(
      rows,
      conflictColumns: conflictColumns(ParentClass.t),
      updateColumns: updateColumns?.call(ParentClass.t),
      updateWhere: updateWhere?.call(ParentClass.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ParentClass] and returns the resulting row.
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
  /// The returned [ParentClass] will have its `id` field set.
  Future<ParentClass?> upsertRow(
    _is.DatabaseSession session,
    ParentClass row, {
    required _is.ColumnSelections<ParentClassTable> conflictColumns,
    _is.ColumnSelections<ParentClassTable>? updateColumns,
    _is.WhereExpressionBuilder<ParentClassTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ParentClass>(
      row,
      conflictColumns: conflictColumns(ParentClass.t),
      updateColumns: updateColumns?.call(ParentClass.t),
      updateWhere: updateWhere?.call(ParentClass.t),
      transaction: transaction,
    );
  }

  /// Updates all [ParentClass]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ParentClass>> update(
    _is.DatabaseSession session,
    List<ParentClass> rows, {
    _is.ColumnSelections<ParentClassTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ParentClass>(
      rows,
      columns: columns?.call(ParentClass.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ParentClass]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ParentClass> updateRow(
    _is.DatabaseSession session,
    ParentClass row, {
    _is.ColumnSelections<ParentClassTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ParentClass>(
      row,
      columns: columns?.call(ParentClass.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ParentClass] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ParentClass?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ParentClassUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ParentClass>(
      id,
      columnValues: columnValues(ParentClass.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ParentClass]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ParentClass>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ParentClassUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ParentClassTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ParentClass>(
      columnValues: columnValues(ParentClass.t.updateTable),
      where: where(ParentClass.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ParentClass]s in the list and returns the deleted rows.
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
  Future<List<ParentClass>> delete(
    _is.DatabaseSession session,
    List<ParentClass> rows, {
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ParentClass>(
      rows,
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ParentClass].
  Future<ParentClass> deleteRow(
    _is.DatabaseSession session,
    ParentClass row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ParentClass>(
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
  Future<List<ParentClass>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ParentClassTable> where,
    _is.OrderByBuilder<ParentClassTable>? orderBy,
    _is.OrderByListBuilder<ParentClassTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ParentClass>(
      where: where(ParentClass.t),
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ParentClass>(
      where: where?.call(ParentClass.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ParentClass] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ParentClassTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ParentClass>(
      where: where(ParentClass.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
