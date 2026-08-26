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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

abstract class ObjectWithByteData
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithByteData._({
    this.id,
    required this.byteData,
  });

  factory ObjectWithByteData({
    int? id,
    required _idt.ByteData byteData,
  }) = _ObjectWithByteDataImpl;

  factory ObjectWithByteData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithByteData(
      id: jsonSerialization['id'] as int?,
      byteData: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
    );
  }

  static final t = ObjectWithByteDataTable();

  static const db = ObjectWithByteDataRepository._();

  @override
  int? id;

  _idt.ByteData byteData;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithByteData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithByteData copyWith({
    int? id,
    _idt.ByteData? byteData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithByteData',
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithByteData',
      if (id != null) 'id': id,
      'byteData': byteData.toJson(),
    };
  }

  /// Builds a complete [ObjectWithByteDataInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithByteDataInclude include() {
    return ObjectWithByteDataInclude._();
  }

  /// Builds a complete [ObjectWithByteDataIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithByteDataIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    ObjectWithByteDataInclude? include,
  }) {
    return ObjectWithByteDataIncludeList._(
      where: where?.call(ObjectWithByteData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ObjectWithByteDataJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ObjectWithByteDataJsonInclude includeJson({
    _is.SelectColumnsBuilder<ObjectWithByteDataTable>? select,
  }) {
    return _ObjectWithByteDataJsonInclude._(
      selectedColumns: select?.call(ObjectWithByteData.t),
    );
  }

  /// Builds a JSON-compatible [ObjectWithByteDataJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ObjectWithByteDataJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    ObjectWithByteDataJsonInclude? include,
    _is.SelectColumnsBuilder<ObjectWithByteDataTable>? select,
  }) {
    return _ObjectWithByteDataJsonIncludeList._(
      where: where?.call(ObjectWithByteData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      include: include,
      selectedColumns: select?.call(ObjectWithByteData.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithByteDataImpl extends ObjectWithByteData {
  _ObjectWithByteDataImpl({
    int? id,
    required _idt.ByteData byteData,
  }) : super._(
         id: id,
         byteData: byteData,
       );

  /// Returns a shallow copy of this [ObjectWithByteData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithByteData copyWith({
    Object? id = _Undefined,
    _idt.ByteData? byteData,
  }) {
    return ObjectWithByteData(
      id: id is int? ? id : this.id,
      byteData: byteData ?? this.byteData.clone(),
    );
  }
}

class ObjectWithByteDataUpdateTable
    extends _is.UpdateTable<ObjectWithByteDataTable> {
  ObjectWithByteDataUpdateTable(super.table);

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> byteData(_idt.ByteData value) =>
      _is.ColumnValue(
        table.byteData,
        value,
      );
}

class ObjectWithByteDataTable extends _is.Table<int?> {
  ObjectWithByteDataTable({super.tableRelation})
    : super(tableName: 'object_with_bytedata') {
    updateTable = ObjectWithByteDataUpdateTable(this);
    byteData = _is.ColumnByteData(
      'byteData',
      this,
    );
  }

  late final ObjectWithByteDataUpdateTable updateTable;

  late final _is.ColumnByteData byteData;

  @override
  List<_is.Column> get columns => [
    id,
    byteData,
  ];
}

abstract interface class ObjectWithByteDataJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ObjectWithByteDataJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ObjectWithByteDataInclude extends _is.IncludeObject
    implements ObjectWithByteDataJsonInclude, _is.FullModelInclude {
  ObjectWithByteDataInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithByteData.t;
}

final class ObjectWithByteDataIncludeList extends _is.IncludeList
    implements ObjectWithByteDataJsonIncludeList, _is.FullModelInclude {
  ObjectWithByteDataIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithByteDataInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithByteData.t;
}

final class _ObjectWithByteDataJsonInclude extends _is.IncludeObject
    implements ObjectWithByteDataJsonInclude {
  _ObjectWithByteDataJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithByteData.t;
}

final class _ObjectWithByteDataJsonIncludeList extends _is.IncludeList
    implements ObjectWithByteDataJsonIncludeList {
  _ObjectWithByteDataJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithByteDataJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithByteData.t;
}

class ObjectWithByteDataRepository {
  const ObjectWithByteDataRepository._();

  /// Returns a list of [ObjectWithByteData]s matching the given query parameters.
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
  Future<List<ObjectWithByteData>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithByteData] matching the given query parameters.
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
  Future<ObjectWithByteData?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithByteData] by its [id] or null if no such row exists.
  Future<ObjectWithByteData?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithByteData>(
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
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithByteDataTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithByteData.t),
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
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithByteDataTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithByteData.t),
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
    _is.SelectColumnsBuilder<ObjectWithByteDataTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ObjectWithByteData>(
      id,
      transaction: transaction,
      select: select?.call(ObjectWithByteData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithByteData]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithByteData]s will have their `id` fields set.
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
  Future<List<ObjectWithByteData>> insert(
    _is.DatabaseSession session,
    List<ObjectWithByteData> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithByteData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithByteData] and returns the inserted row.
  ///
  /// The returned [ObjectWithByteData] will have its `id` field set.
  Future<ObjectWithByteData> insertRow(
    _is.DatabaseSession session,
    ObjectWithByteData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithByteData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithByteData]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithByteData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithByteData>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithByteData> rows, {
    required _is.ColumnSelections<ObjectWithByteDataTable> conflictColumns,
    _is.ColumnSelections<ObjectWithByteDataTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithByteData>(
      rows,
      conflictColumns: conflictColumns(ObjectWithByteData.t),
      updateColumns: updateColumns?.call(ObjectWithByteData.t),
      updateWhere: updateWhere?.call(ObjectWithByteData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithByteData] and returns the resulting row.
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
  /// The returned [ObjectWithByteData] will have its `id` field set.
  Future<ObjectWithByteData?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithByteData row, {
    required _is.ColumnSelections<ObjectWithByteDataTable> conflictColumns,
    _is.ColumnSelections<ObjectWithByteDataTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithByteData>(
      row,
      conflictColumns: conflictColumns(ObjectWithByteData.t),
      updateColumns: updateColumns?.call(ObjectWithByteData.t),
      updateWhere: updateWhere?.call(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithByteData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithByteData>> update(
    _is.DatabaseSession session,
    List<ObjectWithByteData> rows, {
    _is.ColumnSelections<ObjectWithByteDataTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithByteData>(
      rows,
      columns: columns?.call(ObjectWithByteData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithByteData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithByteData> updateRow(
    _is.DatabaseSession session,
    ObjectWithByteData row, {
    _is.ColumnSelections<ObjectWithByteDataTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithByteData>(
      row,
      columns: columns?.call(ObjectWithByteData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithByteData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithByteData?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithByteDataUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithByteData>(
      id,
      columnValues: columnValues(ObjectWithByteData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithByteData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithByteData>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithByteDataUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithByteDataTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithByteData>(
      columnValues: columnValues(ObjectWithByteData.t.updateTable),
      where: where(ObjectWithByteData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithByteData]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithByteData>> delete(
    _is.DatabaseSession session,
    List<ObjectWithByteData> rows, {
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithByteData>(
      rows,
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithByteData].
  Future<ObjectWithByteData> deleteRow(
    _is.DatabaseSession session,
    ObjectWithByteData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithByteData>(
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
  Future<List<ObjectWithByteData>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithByteDataTable> where,
    _is.OrderByBuilder<ObjectWithByteDataTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithByteDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithByteData>(
      where: where(ObjectWithByteData.t),
      orderBy: orderBy?.call(ObjectWithByteData.t),
      orderByList: orderByList?.call(ObjectWithByteData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithByteDataTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithByteData>(
      where: where?.call(ObjectWithByteData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithByteData] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithByteDataTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithByteData>(
      where: where(ObjectWithByteData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
