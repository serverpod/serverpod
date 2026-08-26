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

abstract class UriDefault
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UriDefault._({
    this.id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) : uriDefault = uriDefault ?? Uri.parse('https://serverpod.dev/default'),
       uriDefaultNull =
           uriDefaultNull ?? Uri.parse('https://serverpod.dev/default');

  factory UriDefault({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) = _UriDefaultImpl;

  factory UriDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefault(
      id: jsonSerialization['id'] as int?,
      uriDefault: jsonSerialization['uriDefault'] == null
          ? null
          : _is.UriJsonExtension.fromJson(jsonSerialization['uriDefault']),
      uriDefaultNull: jsonSerialization['uriDefaultNull'] == null
          ? null
          : _is.UriJsonExtension.fromJson(jsonSerialization['uriDefaultNull']),
    );
  }

  static final t = UriDefaultTable();

  static const db = UriDefaultRepository._();

  @override
  int? id;

  Uri uriDefault;

  Uri? uriDefaultNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UriDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UriDefault copyWith({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UriDefault',
      if (id != null) 'id': id,
      'uriDefault': uriDefault.toJson(),
      if (uriDefaultNull != null) 'uriDefaultNull': uriDefaultNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UriDefault',
      if (id != null) 'id': id,
      'uriDefault': uriDefault.toJson(),
      if (uriDefaultNull != null) 'uriDefaultNull': uriDefaultNull?.toJson(),
    };
  }

  /// Builds a complete [UriDefaultInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static UriDefaultInclude include() {
    return UriDefaultInclude._();
  }

  /// Builds a complete [UriDefaultIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static UriDefaultIncludeList includeList({
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    UriDefaultInclude? include,
  }) {
    return UriDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [UriDefaultJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static UriDefaultJsonInclude includeJson({
    _is.SelectColumnsBuilder<UriDefaultTable>? select,
  }) {
    return _UriDefaultJsonInclude._(
      selectedColumns: select?.call(UriDefault.t),
    );
  }

  /// Builds a JSON-compatible [UriDefaultJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static UriDefaultJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    UriDefaultJsonInclude? include,
    _is.SelectColumnsBuilder<UriDefaultTable>? select,
  }) {
    return _UriDefaultJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      include: include,
      selectedColumns: select?.call(UriDefault.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultImpl extends UriDefault {
  _UriDefaultImpl({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) : super._(
         id: id,
         uriDefault: uriDefault,
         uriDefaultNull: uriDefaultNull,
       );

  /// Returns a shallow copy of this [UriDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UriDefault copyWith({
    Object? id = _Undefined,
    Uri? uriDefault,
    Object? uriDefaultNull = _Undefined,
  }) {
    return UriDefault(
      id: id is int? ? id : this.id,
      uriDefault: uriDefault ?? this.uriDefault,
      uriDefaultNull: uriDefaultNull is Uri?
          ? uriDefaultNull
          : this.uriDefaultNull,
    );
  }
}

class UriDefaultUpdateTable extends _is.UpdateTable<UriDefaultTable> {
  UriDefaultUpdateTable(super.table);

  _is.ColumnValue<Uri, Uri> uriDefault(Uri value) => _is.ColumnValue(
    table.uriDefault,
    value,
  );

  _is.ColumnValue<Uri, Uri> uriDefaultNull(Uri? value) => _is.ColumnValue(
    table.uriDefaultNull,
    value,
  );
}

class UriDefaultTable extends _is.Table<int?> {
  UriDefaultTable({super.tableRelation}) : super(tableName: 'uri_default') {
    updateTable = UriDefaultUpdateTable(this);
    uriDefault = _is.ColumnUri(
      'uriDefault',
      this,
      hasDefault: true,
    );
    uriDefaultNull = _is.ColumnUri(
      'uriDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final UriDefaultUpdateTable updateTable;

  late final _is.ColumnUri uriDefault;

  late final _is.ColumnUri uriDefaultNull;

  @override
  List<_is.Column> get columns => [
    id,
    uriDefault,
    uriDefaultNull,
  ];
}

abstract interface class UriDefaultJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class UriDefaultJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class UriDefaultInclude extends _is.IncludeObject
    implements UriDefaultJsonInclude, _is.FullModelInclude {
  UriDefaultInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UriDefault.t;
}

final class UriDefaultIncludeList extends _is.IncludeList
    implements UriDefaultJsonIncludeList, _is.FullModelInclude {
  UriDefaultIncludeList._({
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    UriDefaultInclude? super.include,
  }) {
    super.where = where?.call(UriDefault.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UriDefault.t;
}

final class _UriDefaultJsonInclude extends _is.IncludeObject
    implements UriDefaultJsonInclude {
  _UriDefaultJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UriDefault.t;
}

final class _UriDefaultJsonIncludeList extends _is.IncludeList
    implements UriDefaultJsonIncludeList {
  _UriDefaultJsonIncludeList._({
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    UriDefaultJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UriDefault.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UriDefault.t;
}

class UriDefaultRepository {
  const UriDefaultRepository._();

  /// Returns a list of [UriDefault]s matching the given query parameters.
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
  Future<List<UriDefault>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UriDefault>(
      where: where?.call(UriDefault.t),
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UriDefault] matching the given query parameters.
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
  Future<UriDefault?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UriDefault>(
      where: where?.call(UriDefault.t),
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UriDefault] by its [id] or null if no such row exists.
  Future<UriDefault?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UriDefault>(
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
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UriDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UriDefault>(
      where: where?.call(UriDefault.t),
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(UriDefault.t),
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
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UriDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UriDefault>(
      where: where?.call(UriDefault.t),
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(UriDefault.t),
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
    _is.SelectColumnsBuilder<UriDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UriDefault>(
      id,
      transaction: transaction,
      select: select?.call(UriDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UriDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [UriDefault]s will have their `id` fields set.
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
  Future<List<UriDefault>> insert(
    _is.DatabaseSession session,
    List<UriDefault> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UriDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UriDefault] and returns the inserted row.
  ///
  /// The returned [UriDefault] will have its `id` field set.
  Future<UriDefault> insertRow(
    _is.DatabaseSession session,
    UriDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UriDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UriDefault]s in the list and returns the resulting rows.
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
  /// The returned [UriDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UriDefault>> upsert(
    _is.DatabaseSession session,
    List<UriDefault> rows, {
    required _is.ColumnSelections<UriDefaultTable> conflictColumns,
    _is.ColumnSelections<UriDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<UriDefaultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UriDefault>(
      rows,
      conflictColumns: conflictColumns(UriDefault.t),
      updateColumns: updateColumns?.call(UriDefault.t),
      updateWhere: updateWhere?.call(UriDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UriDefault] and returns the resulting row.
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
  /// The returned [UriDefault] will have its `id` field set.
  Future<UriDefault?> upsertRow(
    _is.DatabaseSession session,
    UriDefault row, {
    required _is.ColumnSelections<UriDefaultTable> conflictColumns,
    _is.ColumnSelections<UriDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<UriDefaultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UriDefault>(
      row,
      conflictColumns: conflictColumns(UriDefault.t),
      updateColumns: updateColumns?.call(UriDefault.t),
      updateWhere: updateWhere?.call(UriDefault.t),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UriDefault>> update(
    _is.DatabaseSession session,
    List<UriDefault> rows, {
    _is.ColumnSelections<UriDefaultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UriDefault>(
      rows,
      columns: columns?.call(UriDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UriDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UriDefault> updateRow(
    _is.DatabaseSession session,
    UriDefault row, {
    _is.ColumnSelections<UriDefaultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UriDefault>(
      row,
      columns: columns?.call(UriDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UriDefault?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UriDefaultUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UriDefault>(
      id,
      columnValues: columnValues(UriDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UriDefault>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UriDefaultUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UriDefaultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UriDefault>(
      columnValues: columnValues(UriDefault.t.updateTable),
      where: where(UriDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UriDefault]s in the list and returns the deleted rows.
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
  Future<List<UriDefault>> delete(
    _is.DatabaseSession session,
    List<UriDefault> rows, {
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UriDefault>(
      rows,
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UriDefault].
  Future<UriDefault> deleteRow(
    _is.DatabaseSession session,
    UriDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UriDefault>(
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
  Future<List<UriDefault>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UriDefaultTable> where,
    _is.OrderByBuilder<UriDefaultTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UriDefault>(
      where: where(UriDefault.t),
      orderBy: orderBy?.call(UriDefault.t),
      orderByList: orderByList?.call(UriDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UriDefault>(
      where: where?.call(UriDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UriDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UriDefaultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UriDefault>(
      where: where(UriDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
