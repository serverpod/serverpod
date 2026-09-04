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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;

/// Just some simple data.
abstract class SimpleData
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  SimpleData._({
    this.id,
    required this.num,
  });

  factory SimpleData({
    int? id,
    required int num,
  }) = _SimpleDataImpl;

  factory SimpleData.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleData(
      id: jsonSerialization['id'] as int?,
      num: jsonSerialization['num'] as int,
    );
  }

  static final t = SimpleDataTable();

  static const db = SimpleDataRepository._();

  @override
  int? id;

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  int num;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [SimpleData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SimpleData copyWith({
    int? id,
    int? num,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SimpleData',
      if (id != null) 'id': id,
      'num': num,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SimpleData',
      if (id != null) 'id': id,
      'num': num,
    };
  }

  /// Builds a complete [SimpleDataInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static SimpleDataInclude include() {
    return SimpleDataInclude._();
  }

  /// Builds a complete [SimpleDataIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static SimpleDataIncludeList includeList({
    _isd.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    SimpleDataInclude? include,
  }) {
    return SimpleDataIncludeList._(
      where: where?.call(SimpleData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [SimpleDataJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static SimpleDataJsonInclude includeJson({
    _isd.SelectColumnsBuilder<SimpleDataTable>? select,
  }) {
    return _SimpleDataJsonInclude._(
      selectedColumns: select?.call(SimpleData.t),
    );
  }

  /// Builds a JSON-compatible [SimpleDataJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static SimpleDataJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    SimpleDataJsonInclude? include,
    _isd.SelectColumnsBuilder<SimpleDataTable>? select,
  }) {
    return _SimpleDataJsonIncludeList._(
      where: where?.call(SimpleData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      include: include,
      selectedColumns: select?.call(SimpleData.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SimpleDataImpl extends SimpleData {
  _SimpleDataImpl({
    int? id,
    required int num,
  }) : super._(
         id: id,
         num: num,
       );

  /// Returns a shallow copy of this [SimpleData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SimpleData copyWith({
    Object? id = _Undefined,
    int? num,
  }) {
    return SimpleData(
      id: id is int? ? id : this.id,
      num: num ?? this.num,
    );
  }
}

class SimpleDataUpdateTable extends _isd.UpdateTable<SimpleDataTable> {
  SimpleDataUpdateTable(super.table);

  _isd.ColumnValue<int, int> num(int value) => _isd.ColumnValue(
    table.num,
    value,
  );
}

class SimpleDataTable extends _isd.Table<int?> {
  SimpleDataTable({super.tableRelation}) : super(tableName: 'simple_data') {
    updateTable = SimpleDataUpdateTable(this);
    num = _isd.ColumnInt(
      'num',
      this,
    );
  }

  late final SimpleDataUpdateTable updateTable;

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  late final _isd.ColumnInt num;

  @override
  List<_isd.Column> get columns => [
    id,
    num,
  ];
}

abstract interface class SimpleDataJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class SimpleDataJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class SimpleDataInclude extends _isd.IncludeObject
    implements SimpleDataJsonInclude, _isd.FullModelInclude {
  SimpleDataInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => SimpleData.t;
}

final class SimpleDataIncludeList extends _isd.IncludeList
    implements SimpleDataJsonIncludeList, _isd.FullModelInclude {
  SimpleDataIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    SimpleDataInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => SimpleData.t;
}

final class _SimpleDataJsonInclude extends _isd.IncludeObject
    implements SimpleDataJsonInclude {
  _SimpleDataJsonInclude._({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => SimpleData.t;
}

final class _SimpleDataJsonIncludeList extends _isd.IncludeList
    implements SimpleDataJsonIncludeList {
  _SimpleDataJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    SimpleDataJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => SimpleData.t;
}

class SimpleDataRepository {
  const SimpleDataRepository._();

  /// Returns a list of [SimpleData]s matching the given query parameters.
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
  Future<List<SimpleData>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SimpleData] matching the given query parameters.
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
  Future<SimpleData?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDataTable>? where,
    int? offset,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SimpleData] by its [id] or null if no such row exists.
  Future<SimpleData?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SimpleData>(
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SimpleDataTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(SimpleData.t),
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDataTable>? where,
    int? offset,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SimpleDataTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<SimpleData>(
      where: where?.call(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(SimpleData.t),
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
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SimpleDataTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<SimpleData>(
      id,
      transaction: transaction,
      select: select?.call(SimpleData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SimpleData]s in the list and returns the inserted rows.
  ///
  /// The returned [SimpleData]s will have their `id` fields set.
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
  Future<List<SimpleData>> insert(
    _isd.DatabaseSession session,
    List<SimpleData> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SimpleData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SimpleData] and returns the inserted row.
  ///
  /// The returned [SimpleData] will have its `id` field set.
  Future<SimpleData> insertRow(
    _isd.DatabaseSession session,
    SimpleData row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<SimpleData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SimpleData]s in the list and returns the resulting rows.
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
  /// The returned [SimpleData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SimpleData>> upsert(
    _isd.DatabaseSession session,
    List<SimpleData> rows, {
    required _isd.ColumnSelections<SimpleDataTable> conflictColumns,
    _isd.ColumnSelections<SimpleDataTable>? updateColumns,
    _isd.WhereExpressionBuilder<SimpleDataTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SimpleData>(
      rows,
      conflictColumns: conflictColumns(SimpleData.t),
      updateColumns: updateColumns?.call(SimpleData.t),
      updateWhere: updateWhere?.call(SimpleData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SimpleData] and returns the resulting row.
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
  /// The returned [SimpleData] will have its `id` field set.
  Future<SimpleData?> upsertRow(
    _isd.DatabaseSession session,
    SimpleData row, {
    required _isd.ColumnSelections<SimpleDataTable> conflictColumns,
    _isd.ColumnSelections<SimpleDataTable>? updateColumns,
    _isd.WhereExpressionBuilder<SimpleDataTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SimpleData>(
      row,
      conflictColumns: conflictColumns(SimpleData.t),
      updateColumns: updateColumns?.call(SimpleData.t),
      updateWhere: updateWhere?.call(SimpleData.t),
      transaction: transaction,
    );
  }

  /// Updates all [SimpleData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SimpleData>> update(
    _isd.DatabaseSession session,
    List<SimpleData> rows, {
    _isd.ColumnSelections<SimpleDataTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SimpleData>(
      rows,
      columns: columns?.call(SimpleData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SimpleData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SimpleData> updateRow(
    _isd.DatabaseSession session,
    SimpleData row, {
    _isd.ColumnSelections<SimpleDataTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<SimpleData>(
      row,
      columns: columns?.call(SimpleData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SimpleData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SimpleData?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<SimpleDataUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<SimpleData>(
      id,
      columnValues: columnValues(SimpleData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SimpleData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SimpleData>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<SimpleDataUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<SimpleDataTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SimpleData>(
      columnValues: columnValues(SimpleData.t.updateTable),
      where: where(SimpleData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SimpleData]s in the list and returns the deleted rows.
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
  Future<List<SimpleData>> delete(
    _isd.DatabaseSession session,
    List<SimpleData> rows, {
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SimpleData>(
      rows,
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SimpleData].
  Future<SimpleData> deleteRow(
    _isd.DatabaseSession session,
    SimpleData row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SimpleData>(
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
  Future<List<SimpleData>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SimpleDataTable> where,
    _isd.OrderByBuilder<SimpleDataTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDataTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SimpleData>(
      where: where(SimpleData.t),
      orderBy: orderBy?.call(SimpleData.t),
      orderByList: orderByList?.call(SimpleData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDataTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<SimpleData>(
      where: where?.call(SimpleData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SimpleData] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SimpleDataTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SimpleData>(
      where: where(SimpleData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
