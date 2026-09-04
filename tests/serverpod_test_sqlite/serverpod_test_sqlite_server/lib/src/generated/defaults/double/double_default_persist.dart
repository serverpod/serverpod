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

abstract class DoubleDefaultPersist
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DoubleDefaultPersist._({
    this.id,
    this.doubleDefaultPersist,
  });

  factory DoubleDefaultPersist({
    int? id,
    double? doubleDefaultPersist,
  }) = _DoubleDefaultPersistImpl;

  factory DoubleDefaultPersist.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DoubleDefaultPersist(
      id: jsonSerialization['id'] as int?,
      doubleDefaultPersist: (jsonSerialization['doubleDefaultPersist'] as num?)
          ?.toDouble(),
    );
  }

  static final t = DoubleDefaultPersistTable();

  static const db = DoubleDefaultPersistRepository._();

  @override
  int? id;

  double? doubleDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DoubleDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoubleDefaultPersist copyWith({
    int? id,
    double? doubleDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoubleDefaultPersist',
      if (id != null) 'id': id,
      if (doubleDefaultPersist != null)
        'doubleDefaultPersist': doubleDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoubleDefaultPersist',
      if (id != null) 'id': id,
      if (doubleDefaultPersist != null)
        'doubleDefaultPersist': doubleDefaultPersist,
    };
  }

  /// Builds a complete [DoubleDefaultPersistInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DoubleDefaultPersistInclude include() {
    return DoubleDefaultPersistInclude._();
  }

  /// Builds a complete [DoubleDefaultPersistIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DoubleDefaultPersistIncludeList includeList({
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    DoubleDefaultPersistInclude? include,
  }) {
    return DoubleDefaultPersistIncludeList._(
      where: where?.call(DoubleDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [DoubleDefaultPersistJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static DoubleDefaultPersistJsonInclude includeJson({
    _is.SelectColumnsBuilder<DoubleDefaultPersistTable>? select,
  }) {
    return _DoubleDefaultPersistJsonInclude._(
      selectedColumns: select?.call(DoubleDefaultPersist.t),
    );
  }

  /// Builds a JSON-compatible [DoubleDefaultPersistJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static DoubleDefaultPersistJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    DoubleDefaultPersistJsonInclude? include,
    _is.SelectColumnsBuilder<DoubleDefaultPersistTable>? select,
  }) {
    return _DoubleDefaultPersistJsonIncludeList._(
      where: where?.call(DoubleDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      include: include,
      selectedColumns: select?.call(DoubleDefaultPersist.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultPersistImpl extends DoubleDefaultPersist {
  _DoubleDefaultPersistImpl({
    int? id,
    double? doubleDefaultPersist,
  }) : super._(
         id: id,
         doubleDefaultPersist: doubleDefaultPersist,
       );

  /// Returns a shallow copy of this [DoubleDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoubleDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? doubleDefaultPersist = _Undefined,
  }) {
    return DoubleDefaultPersist(
      id: id is int? ? id : this.id,
      doubleDefaultPersist: doubleDefaultPersist is double?
          ? doubleDefaultPersist
          : this.doubleDefaultPersist,
    );
  }
}

class DoubleDefaultPersistUpdateTable
    extends _is.UpdateTable<DoubleDefaultPersistTable> {
  DoubleDefaultPersistUpdateTable(super.table);

  _is.ColumnValue<double, double> doubleDefaultPersist(double? value) =>
      _is.ColumnValue(
        table.doubleDefaultPersist,
        value,
      );
}

class DoubleDefaultPersistTable extends _is.Table<int?> {
  DoubleDefaultPersistTable({super.tableRelation})
    : super(tableName: 'double_default_persist') {
    updateTable = DoubleDefaultPersistUpdateTable(this);
    doubleDefaultPersist = _is.ColumnDouble(
      'doubleDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final DoubleDefaultPersistUpdateTable updateTable;

  late final _is.ColumnDouble doubleDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    doubleDefaultPersist,
  ];
}

abstract interface class DoubleDefaultPersistJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class DoubleDefaultPersistJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class DoubleDefaultPersistInclude extends _is.IncludeObject
    implements DoubleDefaultPersistJsonInclude, _is.FullModelInclude {
  DoubleDefaultPersistInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoubleDefaultPersist.t;
}

final class DoubleDefaultPersistIncludeList extends _is.IncludeList
    implements DoubleDefaultPersistJsonIncludeList, _is.FullModelInclude {
  DoubleDefaultPersistIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DoubleDefaultPersistInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoubleDefaultPersist.t;
}

final class _DoubleDefaultPersistJsonInclude extends _is.IncludeObject
    implements DoubleDefaultPersistJsonInclude {
  _DoubleDefaultPersistJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoubleDefaultPersist.t;
}

final class _DoubleDefaultPersistJsonIncludeList extends _is.IncludeList
    implements DoubleDefaultPersistJsonIncludeList {
  _DoubleDefaultPersistJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DoubleDefaultPersistJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoubleDefaultPersist.t;
}

class DoubleDefaultPersistRepository {
  const DoubleDefaultPersistRepository._();

  /// Returns a list of [DoubleDefaultPersist]s matching the given query parameters.
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
  Future<List<DoubleDefaultPersist>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DoubleDefaultPersist] matching the given query parameters.
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
  Future<DoubleDefaultPersist?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DoubleDefaultPersist] by its [id] or null if no such row exists.
  Future<DoubleDefaultPersist?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DoubleDefaultPersist>(
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
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DoubleDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(DoubleDefaultPersist.t),
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
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DoubleDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(DoubleDefaultPersist.t),
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
    _is.SelectColumnsBuilder<DoubleDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<DoubleDefaultPersist>(
      id,
      transaction: transaction,
      select: select?.call(DoubleDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DoubleDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [DoubleDefaultPersist]s will have their `id` fields set.
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
  Future<List<DoubleDefaultPersist>> insert(
    _is.DatabaseSession session,
    List<DoubleDefaultPersist> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DoubleDefaultPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DoubleDefaultPersist] and returns the inserted row.
  ///
  /// The returned [DoubleDefaultPersist] will have its `id` field set.
  Future<DoubleDefaultPersist> insertRow(
    _is.DatabaseSession session,
    DoubleDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoubleDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DoubleDefaultPersist]s in the list and returns the resulting rows.
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
  /// The returned [DoubleDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoubleDefaultPersist>> upsert(
    _is.DatabaseSession session,
    List<DoubleDefaultPersist> rows, {
    required _is.ColumnSelections<DoubleDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<DoubleDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DoubleDefaultPersist>(
      rows,
      conflictColumns: conflictColumns(DoubleDefaultPersist.t),
      updateColumns: updateColumns?.call(DoubleDefaultPersist.t),
      updateWhere: updateWhere?.call(DoubleDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DoubleDefaultPersist] and returns the resulting row.
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
  /// The returned [DoubleDefaultPersist] will have its `id` field set.
  Future<DoubleDefaultPersist?> upsertRow(
    _is.DatabaseSession session,
    DoubleDefaultPersist row, {
    required _is.ColumnSelections<DoubleDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<DoubleDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DoubleDefaultPersist>(
      row,
      conflictColumns: conflictColumns(DoubleDefaultPersist.t),
      updateColumns: updateColumns?.call(DoubleDefaultPersist.t),
      updateWhere: updateWhere?.call(DoubleDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoubleDefaultPersist>> update(
    _is.DatabaseSession session,
    List<DoubleDefaultPersist> rows, {
    _is.ColumnSelections<DoubleDefaultPersistTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DoubleDefaultPersist>(
      rows,
      columns: columns?.call(DoubleDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DoubleDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoubleDefaultPersist> updateRow(
    _is.DatabaseSession session,
    DoubleDefaultPersist row, {
    _is.ColumnSelections<DoubleDefaultPersistTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoubleDefaultPersist>(
      row,
      columns: columns?.call(DoubleDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoubleDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DoubleDefaultPersist?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DoubleDefaultPersistUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DoubleDefaultPersist>(
      id,
      columnValues: columnValues(DoubleDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoubleDefaultPersist>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DoubleDefaultPersistUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DoubleDefaultPersistTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DoubleDefaultPersist>(
      columnValues: columnValues(DoubleDefaultPersist.t.updateTable),
      where: where(DoubleDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DoubleDefaultPersist]s in the list and returns the deleted rows.
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
  Future<List<DoubleDefaultPersist>> delete(
    _is.DatabaseSession session,
    List<DoubleDefaultPersist> rows, {
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DoubleDefaultPersist>(
      rows,
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DoubleDefaultPersist].
  Future<DoubleDefaultPersist> deleteRow(
    _is.DatabaseSession session,
    DoubleDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoubleDefaultPersist>(
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
  Future<List<DoubleDefaultPersist>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoubleDefaultPersistTable> where,
    _is.OrderByBuilder<DoubleDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DoubleDefaultPersist>(
      where: where(DoubleDefaultPersist.t),
      orderBy: orderBy?.call(DoubleDefaultPersist.t),
      orderByList: orderByList?.call(DoubleDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoubleDefaultPersistTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DoubleDefaultPersist>(
      where: where?.call(DoubleDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DoubleDefaultPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoubleDefaultPersistTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DoubleDefaultPersist>(
      where: where(DoubleDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
