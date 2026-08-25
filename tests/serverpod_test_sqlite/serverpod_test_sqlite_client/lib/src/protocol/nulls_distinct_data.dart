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

abstract class NullsDistinctData
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  NullsDistinctData._({
    this.id,
    required this.tenantId,
    required this.category,
    this.archivedAt,
  });

  factory NullsDistinctData({
    int? id,
    required int tenantId,
    required String category,
    String? archivedAt,
  }) = _NullsDistinctDataImpl;

  factory NullsDistinctData.fromJson(Map<String, dynamic> jsonSerialization) {
    return NullsDistinctData(
      id: jsonSerialization['id'] as int?,
      tenantId: jsonSerialization['tenantId'] as int,
      category: jsonSerialization['category'] as String,
      archivedAt: jsonSerialization['archivedAt'] as String?,
    );
  }

  static final t = NullsDistinctDataTable();

  static const db = NullsDistinctDataRepository._();

  @override
  int? id;

  int tenantId;

  String category;

  String? archivedAt;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [NullsDistinctData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NullsDistinctData copyWith({
    int? id,
    int? tenantId,
    String? category,
    String? archivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NullsDistinctData',
      if (id != null) 'id': id,
      'tenantId': tenantId,
      'category': category,
      if (archivedAt != null) 'archivedAt': archivedAt,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NullsDistinctData',
      if (id != null) 'id': id,
      'tenantId': tenantId,
      'category': category,
      if (archivedAt != null) 'archivedAt': archivedAt,
    };
  }

  static NullsDistinctDataInclude include({
    _isd.SelectColumnsBuilder<NullsDistinctDataTable>? select,
  }) {
    return NullsDistinctDataInclude._(
      selectedColumns: select?.call(NullsDistinctData.t),
    );
  }

  static NullsDistinctDataIncludeList includeList({
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    NullsDistinctDataInclude? include,
    _isd.SelectColumnsBuilder<NullsDistinctDataTable>? select,
  }) {
    return NullsDistinctDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      include: include,
      selectedColumns: select?.call(NullsDistinctData.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NullsDistinctDataImpl extends NullsDistinctData {
  _NullsDistinctDataImpl({
    int? id,
    required int tenantId,
    required String category,
    String? archivedAt,
  }) : super._(
         id: id,
         tenantId: tenantId,
         category: category,
         archivedAt: archivedAt,
       );

  /// Returns a shallow copy of this [NullsDistinctData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NullsDistinctData copyWith({
    Object? id = _Undefined,
    int? tenantId,
    String? category,
    Object? archivedAt = _Undefined,
  }) {
    return NullsDistinctData(
      id: id is int? ? id : this.id,
      tenantId: tenantId ?? this.tenantId,
      category: category ?? this.category,
      archivedAt: archivedAt is String? ? archivedAt : this.archivedAt,
    );
  }
}

class NullsDistinctDataUpdateTable
    extends _isd.UpdateTable<NullsDistinctDataTable> {
  NullsDistinctDataUpdateTable(super.table);

  _isd.ColumnValue<int, int> tenantId(int value) => _isd.ColumnValue(
    table.tenantId,
    value,
  );

  _isd.ColumnValue<String, String> category(String value) => _isd.ColumnValue(
    table.category,
    value,
  );

  _isd.ColumnValue<String, String> archivedAt(String? value) =>
      _isd.ColumnValue(
        table.archivedAt,
        value,
      );
}

class NullsDistinctDataTable extends _isd.Table<int?> {
  NullsDistinctDataTable({super.tableRelation})
    : super(tableName: 'nulls_distinct_data') {
    updateTable = NullsDistinctDataUpdateTable(this);
    tenantId = _isd.ColumnInt(
      'tenantId',
      this,
    );
    category = _isd.ColumnString(
      'category',
      this,
    );
    archivedAt = _isd.ColumnString(
      'archivedAt',
      this,
    );
  }

  late final NullsDistinctDataUpdateTable updateTable;

  late final _isd.ColumnInt tenantId;

  late final _isd.ColumnString category;

  late final _isd.ColumnString archivedAt;

  @override
  List<_isd.Column> get columns => [
    id,
    tenantId,
    category,
    archivedAt,
  ];
}

class NullsDistinctDataInclude extends _isd.IncludeObject {
  NullsDistinctDataInclude._({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => NullsDistinctData.t;
}

class NullsDistinctDataIncludeList extends _isd.IncludeList {
  NullsDistinctDataIncludeList._({
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(NullsDistinctData.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => NullsDistinctData.t;
}

class NullsDistinctDataRepository {
  const NullsDistinctDataRepository._();

  /// Returns a list of [NullsDistinctData]s matching the given query parameters.
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
  Future<List<NullsDistinctData>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NullsDistinctData>(
      where: where?.call(NullsDistinctData.t),
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NullsDistinctData] matching the given query parameters.
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
  Future<NullsDistinctData?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? where,
    int? offset,
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NullsDistinctData>(
      where: where?.call(NullsDistinctData.t),
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NullsDistinctData] by its [id] or null if no such row exists.
  Future<NullsDistinctData?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NullsDistinctData>(
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
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<NullsDistinctDataTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<NullsDistinctData>(
      where: where?.call(NullsDistinctData.t),
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(NullsDistinctData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? where,
    int? offset,
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<NullsDistinctDataTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<NullsDistinctData>(
      where: where?.call(NullsDistinctData.t),
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(NullsDistinctData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<NullsDistinctDataTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<NullsDistinctData>(
      id,
      transaction: transaction,
      select: select?.call(NullsDistinctData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NullsDistinctData]s in the list and returns the inserted rows.
  ///
  /// The returned [NullsDistinctData]s will have their `id` fields set.
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
  Future<List<NullsDistinctData>> insert(
    _isd.DatabaseSession session,
    List<NullsDistinctData> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NullsDistinctData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NullsDistinctData] and returns the inserted row.
  ///
  /// The returned [NullsDistinctData] will have its `id` field set.
  Future<NullsDistinctData> insertRow(
    _isd.DatabaseSession session,
    NullsDistinctData row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<NullsDistinctData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NullsDistinctData]s in the list and returns the resulting rows.
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
  /// The returned [NullsDistinctData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NullsDistinctData>> upsert(
    _isd.DatabaseSession session,
    List<NullsDistinctData> rows, {
    required _isd.ColumnSelections<NullsDistinctDataTable> conflictColumns,
    _isd.ColumnSelections<NullsDistinctDataTable>? updateColumns,
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NullsDistinctData>(
      rows,
      conflictColumns: conflictColumns(NullsDistinctData.t),
      updateColumns: updateColumns?.call(NullsDistinctData.t),
      updateWhere: updateWhere?.call(NullsDistinctData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NullsDistinctData] and returns the resulting row.
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
  /// The returned [NullsDistinctData] will have its `id` field set.
  Future<NullsDistinctData?> upsertRow(
    _isd.DatabaseSession session,
    NullsDistinctData row, {
    required _isd.ColumnSelections<NullsDistinctDataTable> conflictColumns,
    _isd.ColumnSelections<NullsDistinctDataTable>? updateColumns,
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NullsDistinctData>(
      row,
      conflictColumns: conflictColumns(NullsDistinctData.t),
      updateColumns: updateColumns?.call(NullsDistinctData.t),
      updateWhere: updateWhere?.call(NullsDistinctData.t),
      transaction: transaction,
    );
  }

  /// Updates all [NullsDistinctData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NullsDistinctData>> update(
    _isd.DatabaseSession session,
    List<NullsDistinctData> rows, {
    _isd.ColumnSelections<NullsDistinctDataTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NullsDistinctData>(
      rows,
      columns: columns?.call(NullsDistinctData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NullsDistinctData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NullsDistinctData> updateRow(
    _isd.DatabaseSession session,
    NullsDistinctData row, {
    _isd.ColumnSelections<NullsDistinctDataTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<NullsDistinctData>(
      row,
      columns: columns?.call(NullsDistinctData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NullsDistinctData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NullsDistinctData?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<NullsDistinctDataUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<NullsDistinctData>(
      id,
      columnValues: columnValues(NullsDistinctData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NullsDistinctData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NullsDistinctData>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<NullsDistinctDataUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<NullsDistinctDataTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NullsDistinctData>(
      columnValues: columnValues(NullsDistinctData.t.updateTable),
      where: where(NullsDistinctData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NullsDistinctData]s in the list and returns the deleted rows.
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
  Future<List<NullsDistinctData>> delete(
    _isd.DatabaseSession session,
    List<NullsDistinctData> rows, {
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NullsDistinctData>(
      rows,
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NullsDistinctData].
  Future<NullsDistinctData> deleteRow(
    _isd.DatabaseSession session,
    NullsDistinctData row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NullsDistinctData>(
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
  Future<List<NullsDistinctData>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<NullsDistinctDataTable> where,
    _isd.OrderByBuilder<NullsDistinctDataTable>? orderBy,
    _isd.OrderByListBuilder<NullsDistinctDataTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NullsDistinctData>(
      where: where(NullsDistinctData.t),
      orderBy: orderBy?.call(NullsDistinctData.t),
      orderByList: orderByList?.call(NullsDistinctData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<NullsDistinctDataTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<NullsDistinctData>(
      where: where?.call(NullsDistinctData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NullsDistinctData] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<NullsDistinctDataTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NullsDistinctData>(
      where: where(NullsDistinctData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
