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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;
import 'package:serverpod_test_shared_module_shared/serverpod_test_shared_module_shared.dart'
    as _ivdm85cg;

abstract class SharedModuleTable
    implements _isd.TableRow<int?>, _iss.ProtocolSerialization {
  SharedModuleTable._({
    this.id,
    required this.name,
    required this.data,
  });

  factory SharedModuleTable({
    int? id,
    required String name,
    required dynamic data,
  }) = _SharedModuleTableImpl;

  factory SharedModuleTable.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedModuleTable(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      data: _ivdm85cg.Protocol().deserializeDynamicFieldValue(
        jsonSerialization['data'],
      ),
    );
  }

  static final t = SharedModuleTableTable();

  static const db = SharedModuleTableRepository._();

  @override
  int? id;

  String name;

  dynamic data;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedModuleTable]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  SharedModuleTable copyWith({
    int? id,
    String? name,
    dynamic data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_test_shared_module.SharedModuleTable',
      if (id != null) 'id': id,
      'name': name,
      'data': _ivdm85cg.Protocol().dynamicFieldToJson(data),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_test_shared_module.SharedModuleTable',
      if (id != null) 'id': id,
      'name': name,
      'data': _ivdm85cg.Protocol().dynamicFieldToJson(
        data,
        forProtocol: true,
      ),
    };
  }

  /// Builds a complete [SharedModuleTableInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static SharedModuleTableInclude include() {
    return SharedModuleTableInclude._();
  }

  /// Builds a complete [SharedModuleTableIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static SharedModuleTableIncludeList includeList({
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    SharedModuleTableInclude? include,
  }) {
    return SharedModuleTableIncludeList._(
      where: where?.call(SharedModuleTable.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [SharedModuleTableJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static SharedModuleTableJsonInclude includeJson({
    _isd.SelectColumnsBuilder<SharedModuleTableTable>? select,
  }) {
    return _SharedModuleTableJsonInclude._(
      selectedColumns: select?.call(SharedModuleTable.t),
    );
  }

  /// Builds a JSON-compatible [SharedModuleTableJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static SharedModuleTableJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    SharedModuleTableJsonInclude? include,
    _isd.SelectColumnsBuilder<SharedModuleTableTable>? select,
  }) {
    return _SharedModuleTableJsonIncludeList._(
      where: where?.call(SharedModuleTable.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      include: include,
      selectedColumns: select?.call(SharedModuleTable.t),
    );
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedModuleTableImpl extends SharedModuleTable {
  _SharedModuleTableImpl({
    int? id,
    required String name,
    required dynamic data,
  }) : super._(
         id: id,
         name: name,
         data: data,
       );

  /// Returns a shallow copy of this [SharedModuleTable]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  SharedModuleTable copyWith({
    Object? id = _Undefined,
    String? name,
    Object? data = _Undefined,
  }) {
    return SharedModuleTable(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      data: data != _Undefined ? data : this.data,
    );
  }
}

class SharedModuleTableUpdateTable
    extends _isd.UpdateTable<SharedModuleTableTable> {
  SharedModuleTableUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );

  _isd.ColumnValue<dynamic, dynamic> data(dynamic value) => _isd.ColumnValue(
    table.data,
    value,
  );
}

class SharedModuleTableTable extends _isd.Table<int?> {
  SharedModuleTableTable({super.tableRelation})
    : super(tableName: 'shared_module_table') {
    updateTable = SharedModuleTableUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
    data = _isd.ColumnSerializable<dynamic>(
      'data',
      this,
    );
  }

  late final SharedModuleTableUpdateTable updateTable;

  late final _isd.ColumnString name;

  late final _isd.ColumnSerializable<dynamic> data;

  @override
  List<_isd.Column> get columns => [
    id,
    name,
    data,
  ];
}

abstract interface class SharedModuleTableJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class SharedModuleTableJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class SharedModuleTableInclude extends _isd.IncludeObject
    implements SharedModuleTableJsonInclude, _isd.FullModelInclude {
  SharedModuleTableInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => SharedModuleTable.t;
}

final class SharedModuleTableIncludeList extends _isd.IncludeList
    implements SharedModuleTableJsonIncludeList, _isd.FullModelInclude {
  SharedModuleTableIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    SharedModuleTableInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => SharedModuleTable.t;
}

final class _SharedModuleTableJsonInclude extends _isd.IncludeObject
    implements SharedModuleTableJsonInclude {
  _SharedModuleTableJsonInclude._({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => SharedModuleTable.t;
}

final class _SharedModuleTableJsonIncludeList extends _isd.IncludeList
    implements SharedModuleTableJsonIncludeList {
  _SharedModuleTableJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    SharedModuleTableJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => SharedModuleTable.t;
}

class SharedModuleTableRepository {
  const SharedModuleTableRepository._();

  /// Returns a list of [SharedModuleTable]s matching the given query parameters.
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
  Future<List<SharedModuleTable>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SharedModuleTable>(
      where: where?.call(SharedModuleTable.t),
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SharedModuleTable] matching the given query parameters.
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
  Future<SharedModuleTable?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? where,
    int? offset,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SharedModuleTable>(
      where: where?.call(SharedModuleTable.t),
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SharedModuleTable] by its [id] or null if no such row exists.
  Future<SharedModuleTable?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SharedModuleTable>(
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
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SharedModuleTableTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<SharedModuleTable>(
      where: where?.call(SharedModuleTable.t),
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(SharedModuleTable.t),
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
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? where,
    int? offset,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SharedModuleTableTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<SharedModuleTable>(
      where: where?.call(SharedModuleTable.t),
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(SharedModuleTable.t),
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
    _isd.SelectColumnsBuilder<SharedModuleTableTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<SharedModuleTable>(
      id,
      transaction: transaction,
      select: select?.call(SharedModuleTable.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SharedModuleTable]s in the list and returns the inserted rows.
  ///
  /// The returned [SharedModuleTable]s will have their `id` fields set.
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
  Future<List<SharedModuleTable>> insert(
    _isd.DatabaseSession session,
    List<SharedModuleTable> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SharedModuleTable>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SharedModuleTable] and returns the inserted row.
  ///
  /// The returned [SharedModuleTable] will have its `id` field set.
  Future<SharedModuleTable> insertRow(
    _isd.DatabaseSession session,
    SharedModuleTable row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedModuleTable>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SharedModuleTable]s in the list and returns the resulting rows.
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
  /// The returned [SharedModuleTable]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedModuleTable>> upsert(
    _isd.DatabaseSession session,
    List<SharedModuleTable> rows, {
    required _isd.ColumnSelections<SharedModuleTableTable> conflictColumns,
    _isd.ColumnSelections<SharedModuleTableTable>? updateColumns,
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SharedModuleTable>(
      rows,
      conflictColumns: conflictColumns(SharedModuleTable.t),
      updateColumns: updateColumns?.call(SharedModuleTable.t),
      updateWhere: updateWhere?.call(SharedModuleTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SharedModuleTable] and returns the resulting row.
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
  /// The returned [SharedModuleTable] will have its `id` field set.
  Future<SharedModuleTable?> upsertRow(
    _isd.DatabaseSession session,
    SharedModuleTable row, {
    required _isd.ColumnSelections<SharedModuleTableTable> conflictColumns,
    _isd.ColumnSelections<SharedModuleTableTable>? updateColumns,
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SharedModuleTable>(
      row,
      conflictColumns: conflictColumns(SharedModuleTable.t),
      updateColumns: updateColumns?.call(SharedModuleTable.t),
      updateWhere: updateWhere?.call(SharedModuleTable.t),
      transaction: transaction,
    );
  }

  /// Updates all [SharedModuleTable]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedModuleTable>> update(
    _isd.DatabaseSession session,
    List<SharedModuleTable> rows, {
    _isd.ColumnSelections<SharedModuleTableTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SharedModuleTable>(
      rows,
      columns: columns?.call(SharedModuleTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SharedModuleTable]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedModuleTable> updateRow(
    _isd.DatabaseSession session,
    SharedModuleTable row, {
    _isd.ColumnSelections<SharedModuleTableTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<SharedModuleTable>(
      row,
      columns: columns?.call(SharedModuleTable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedModuleTable] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SharedModuleTable?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<SharedModuleTableUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<SharedModuleTable>(
      id,
      columnValues: columnValues(SharedModuleTable.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SharedModuleTable]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedModuleTable>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<SharedModuleTableUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<SharedModuleTableTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SharedModuleTable>(
      columnValues: columnValues(SharedModuleTable.t.updateTable),
      where: where(SharedModuleTable.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SharedModuleTable]s in the list and returns the deleted rows.
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
  Future<List<SharedModuleTable>> delete(
    _isd.DatabaseSession session,
    List<SharedModuleTable> rows, {
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SharedModuleTable>(
      rows,
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SharedModuleTable].
  Future<SharedModuleTable> deleteRow(
    _isd.DatabaseSession session,
    SharedModuleTable row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedModuleTable>(
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
  Future<List<SharedModuleTable>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SharedModuleTableTable> where,
    _isd.OrderByBuilder<SharedModuleTableTable>? orderBy,
    _isd.OrderByListBuilder<SharedModuleTableTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SharedModuleTable>(
      where: where(SharedModuleTable.t),
      orderBy: orderBy?.call(SharedModuleTable.t),
      orderByList: orderByList?.call(SharedModuleTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SharedModuleTableTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<SharedModuleTable>(
      where: where?.call(SharedModuleTable.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SharedModuleTable] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SharedModuleTableTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SharedModuleTable>(
      where: where(SharedModuleTable.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
