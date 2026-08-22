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

/// Information about a server method.
abstract class MethodInfo
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MethodInfo._({
    this.id,
    required this.endpoint,
    required this.method,
  });

  factory MethodInfo({
    int? id,
    required String endpoint,
    required String method,
  }) = _MethodInfoImpl;

  factory MethodInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MethodInfo(
      id: jsonSerialization['id'] as int?,
      endpoint: jsonSerialization['endpoint'] as String,
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = MethodInfoTable();

  static const db = MethodInfoRepository._();

  @override
  int? id;

  /// The endpoint of this method.
  String endpoint;

  /// The name of this method.
  String method;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MethodInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MethodInfo copyWith({
    int? id,
    String? endpoint,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.MethodInfo',
      if (id != null) 'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.MethodInfo',
      if (id != null) 'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  static MethodInfoInclude include() {
    return MethodInfoInclude.internal_();
  }

  static MethodInfoIncludeList includeList({
    _is.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MethodInfoTable>? orderBy,
    _is.OrderByListBuilder<MethodInfoTable>? orderByList,
    MethodInfoInclude? include,
  }) {
    return MethodInfoIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MethodInfoImpl extends MethodInfo {
  _MethodInfoImpl({
    int? id,
    required String endpoint,
    required String method,
  }) : super._(
         id: id,
         endpoint: endpoint,
         method: method,
       );

  /// Returns a shallow copy of this [MethodInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MethodInfo copyWith({
    Object? id = _Undefined,
    String? endpoint,
    String? method,
  }) {
    return MethodInfo(
      id: id is int? ? id : this.id,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
    );
  }
}

class MethodInfoUpdateTable extends _is.UpdateTable<MethodInfoTable> {
  MethodInfoUpdateTable(super.table);

  _is.ColumnValue<String, String> endpoint(String value) => _is.ColumnValue(
    table.endpoint,
    value,
  );

  _is.ColumnValue<String, String> method(String value) => _is.ColumnValue(
    table.method,
    value,
  );
}

class MethodInfoTable extends _is.Table<int?> {
  MethodInfoTable({super.tableRelation})
    : super(tableName: 'serverpod_method') {
    updateTable = MethodInfoUpdateTable(this);
    endpoint = _is.ColumnString(
      'endpoint',
      this,
    );
    method = _is.ColumnString(
      'method',
      this,
    );
  }

  late final MethodInfoUpdateTable updateTable;

  /// The endpoint of this method.
  late final _is.ColumnString endpoint;

  /// The name of this method.
  late final _is.ColumnString method;

  @override
  List<_is.Column> get columns => [
    id,
    endpoint,
    method,
  ];
}

class MethodInfoInclude extends _is.IncludeObject {
  MethodInfoInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MethodInfo.t;
}

class MethodInfoIncludeList extends _is.IncludeList {
  MethodInfoIncludeList.internal_({
    _is.WhereExpressionBuilder<MethodInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(MethodInfo.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MethodInfo.t;
}

class MethodInfoRepository {
  const MethodInfoRepository._();

  /// Returns a list of [MethodInfo]s matching the given query parameters.
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
  Future<List<MethodInfo>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MethodInfoTable>? orderBy,
    _is.OrderByListBuilder<MethodInfoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MethodInfo>(
      where: where?.call(MethodInfo.t),
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MethodInfo] matching the given query parameters.
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
  Future<MethodInfo?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MethodInfoTable>? where,
    int? offset,
    _is.OrderByBuilder<MethodInfoTable>? orderBy,
    _is.OrderByListBuilder<MethodInfoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MethodInfo>(
      where: where?.call(MethodInfo.t),
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MethodInfo] by its [id] or null if no such row exists.
  Future<MethodInfo?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MethodInfo>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MethodInfo]s in the list and returns the inserted rows.
  ///
  /// The returned [MethodInfo]s will have their `id` fields set.
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
  Future<List<MethodInfo>> insert(
    _is.DatabaseSession session,
    List<MethodInfo> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MethodInfo>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MethodInfo] and returns the inserted row.
  ///
  /// The returned [MethodInfo] will have its `id` field set.
  Future<MethodInfo> insertRow(
    _is.DatabaseSession session,
    MethodInfo row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MethodInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MethodInfo]s in the list and returns the resulting rows.
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
  /// The returned [MethodInfo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MethodInfo>> upsert(
    _is.DatabaseSession session,
    List<MethodInfo> rows, {
    required _is.ColumnSelections<MethodInfoTable> conflictColumns,
    _is.ColumnSelections<MethodInfoTable>? updateColumns,
    _is.WhereExpressionBuilder<MethodInfoTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MethodInfo>(
      rows,
      conflictColumns: conflictColumns(MethodInfo.t),
      updateColumns: updateColumns?.call(MethodInfo.t),
      updateWhere: updateWhere?.call(MethodInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MethodInfo] and returns the resulting row.
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
  /// The returned [MethodInfo] will have its `id` field set.
  Future<MethodInfo?> upsertRow(
    _is.DatabaseSession session,
    MethodInfo row, {
    required _is.ColumnSelections<MethodInfoTable> conflictColumns,
    _is.ColumnSelections<MethodInfoTable>? updateColumns,
    _is.WhereExpressionBuilder<MethodInfoTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MethodInfo>(
      row,
      conflictColumns: conflictColumns(MethodInfo.t),
      updateColumns: updateColumns?.call(MethodInfo.t),
      updateWhere: updateWhere?.call(MethodInfo.t),
      transaction: transaction,
    );
  }

  /// Updates all [MethodInfo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MethodInfo>> update(
    _is.DatabaseSession session,
    List<MethodInfo> rows, {
    _is.ColumnSelections<MethodInfoTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MethodInfo>(
      rows,
      columns: columns?.call(MethodInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MethodInfo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MethodInfo> updateRow(
    _is.DatabaseSession session,
    MethodInfo row, {
    _is.ColumnSelections<MethodInfoTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MethodInfo>(
      row,
      columns: columns?.call(MethodInfo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MethodInfo] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MethodInfo?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MethodInfoUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MethodInfo>(
      id,
      columnValues: columnValues(MethodInfo.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MethodInfo]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MethodInfo>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MethodInfoUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MethodInfoTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MethodInfoTable>? orderBy,
    _is.OrderByListBuilder<MethodInfoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MethodInfo>(
      columnValues: columnValues(MethodInfo.t.updateTable),
      where: where(MethodInfo.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MethodInfo]s in the list and returns the deleted rows.
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
  Future<List<MethodInfo>> delete(
    _is.DatabaseSession session,
    List<MethodInfo> rows, {
    _is.OrderByBuilder<MethodInfoTable>? orderBy,
    _is.OrderByListBuilder<MethodInfoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MethodInfo>(
      rows,
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MethodInfo].
  Future<MethodInfo> deleteRow(
    _is.DatabaseSession session,
    MethodInfo row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MethodInfo>(
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
  Future<List<MethodInfo>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MethodInfoTable> where,
    _is.OrderByBuilder<MethodInfoTable>? orderBy,
    _is.OrderByListBuilder<MethodInfoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MethodInfo>(
      where: where(MethodInfo.t),
      orderBy: orderBy?.call(MethodInfo.t),
      orderByList: orderByList?.call(MethodInfo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MethodInfoTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MethodInfo>(
      where: where?.call(MethodInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MethodInfo] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MethodInfoTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MethodInfo>(
      where: where(MethodInfo.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
