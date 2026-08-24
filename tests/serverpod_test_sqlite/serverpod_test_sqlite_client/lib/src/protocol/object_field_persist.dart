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
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import 'simple_data.dart' as _i0zisc0t;

abstract class ObjectFieldPersist
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  ObjectFieldPersist._({
    this.id,
    required this.normal,
    this.api,
    this.data,
  });

  factory ObjectFieldPersist({
    int? id,
    required String normal,
    String? api,
    _i0zisc0t.SimpleData? data,
  }) = _ObjectFieldPersistImpl;

  factory ObjectFieldPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectFieldPersist(
      id: jsonSerialization['id'] as int?,
      normal: jsonSerialization['normal'] as String,
      api: jsonSerialization['api'] as String?,
      data: jsonSerialization['data'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_i0zisc0t.SimpleData>(
              jsonSerialization['data'],
            ),
    );
  }

  static final t = ObjectFieldPersistTable();

  static const db = ObjectFieldPersistRepository._();

  @override
  int? id;

  String normal;

  String? api;

  _i0zisc0t.SimpleData? data;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectFieldPersist copyWith({
    int? id,
    String? normal,
    String? api,
    _i0zisc0t.SimpleData? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectFieldPersist',
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (data != null) 'data': data?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectFieldPersist',
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
      if (data != null) 'data': data?.toJsonForProtocol(),
    };
  }

  static ObjectFieldPersistInclude include({
    _isd.SelectColumnsBuilder<ObjectFieldPersistTable>? select,
  }) {
    return ObjectFieldPersistInclude.internal_(
      selectedColumns: select?.call(ObjectFieldPersist.t),
    );
  }

  static ObjectFieldPersistIncludeList includeList({
    _isd.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    _isd.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    ObjectFieldPersistInclude? include,
    _isd.SelectColumnsBuilder<ObjectFieldPersistTable>? select,
  }) {
    return ObjectFieldPersistIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      include: include,
      selectedColumns: select?.call(ObjectFieldPersist.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectFieldPersistImpl extends ObjectFieldPersist {
  _ObjectFieldPersistImpl({
    int? id,
    required String normal,
    String? api,
    _i0zisc0t.SimpleData? data,
  }) : super._(
         id: id,
         normal: normal,
         api: api,
         data: data,
       );

  /// Returns a shallow copy of this [ObjectFieldPersist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectFieldPersist copyWith({
    Object? id = _Undefined,
    String? normal,
    Object? api = _Undefined,
    Object? data = _Undefined,
  }) {
    return ObjectFieldPersist(
      id: id is int? ? id : this.id,
      normal: normal ?? this.normal,
      api: api is String? ? api : this.api,
      data: data is _i0zisc0t.SimpleData? ? data : this.data?.copyWith(),
    );
  }
}

class ObjectFieldPersistUpdateTable
    extends _isd.UpdateTable<ObjectFieldPersistTable> {
  ObjectFieldPersistUpdateTable(super.table);

  _isd.ColumnValue<String, String> normal(String value) => _isd.ColumnValue(
    table.normal,
    value,
  );
}

class ObjectFieldPersistTable extends _isd.Table<int?> {
  ObjectFieldPersistTable({super.tableRelation})
    : super(tableName: 'object_field_persist') {
    updateTable = ObjectFieldPersistUpdateTable(this);
    normal = _isd.ColumnString(
      'normal',
      this,
    );
  }

  late final ObjectFieldPersistUpdateTable updateTable;

  late final _isd.ColumnString normal;

  @override
  List<_isd.Column> get columns => [
    id,
    normal,
  ];
}

class ObjectFieldPersistInclude extends _isd.IncludeObject {
  ObjectFieldPersistInclude.internal_({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => ObjectFieldPersist.t;
}

class ObjectFieldPersistIncludeList extends _isd.IncludeList {
  ObjectFieldPersistIncludeList.internal_({
    _isd.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectFieldPersist.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => ObjectFieldPersist.t;
}

class ObjectFieldPersistRepository {
  const ObjectFieldPersistRepository._();

  /// Returns a list of [ObjectFieldPersist]s matching the given query parameters.
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
  Future<List<ObjectFieldPersist>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    _isd.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectFieldPersist>(
      where: where?.call(ObjectFieldPersist.t),
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectFieldPersist] matching the given query parameters.
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
  Future<ObjectFieldPersist?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? offset,
    _isd.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    _isd.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectFieldPersist>(
      where: where?.call(ObjectFieldPersist.t),
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectFieldPersist] by its [id] or null if no such row exists.
  Future<ObjectFieldPersist?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectFieldPersist>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectFieldPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectFieldPersist]s will have their `id` fields set.
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
  Future<List<ObjectFieldPersist>> insert(
    _isd.DatabaseSession session,
    List<ObjectFieldPersist> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectFieldPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectFieldPersist] and returns the inserted row.
  ///
  /// The returned [ObjectFieldPersist] will have its `id` field set.
  Future<ObjectFieldPersist> insertRow(
    _isd.DatabaseSession session,
    ObjectFieldPersist row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectFieldPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectFieldPersist]s in the list and returns the resulting rows.
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
  /// The returned [ObjectFieldPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectFieldPersist>> upsert(
    _isd.DatabaseSession session,
    List<ObjectFieldPersist> rows, {
    required _isd.ColumnSelections<ObjectFieldPersistTable> conflictColumns,
    _isd.ColumnSelections<ObjectFieldPersistTable>? updateColumns,
    _isd.WhereExpressionBuilder<ObjectFieldPersistTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectFieldPersist>(
      rows,
      conflictColumns: conflictColumns(ObjectFieldPersist.t),
      updateColumns: updateColumns?.call(ObjectFieldPersist.t),
      updateWhere: updateWhere?.call(ObjectFieldPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectFieldPersist] and returns the resulting row.
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
  /// The returned [ObjectFieldPersist] will have its `id` field set.
  Future<ObjectFieldPersist?> upsertRow(
    _isd.DatabaseSession session,
    ObjectFieldPersist row, {
    required _isd.ColumnSelections<ObjectFieldPersistTable> conflictColumns,
    _isd.ColumnSelections<ObjectFieldPersistTable>? updateColumns,
    _isd.WhereExpressionBuilder<ObjectFieldPersistTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectFieldPersist>(
      row,
      conflictColumns: conflictColumns(ObjectFieldPersist.t),
      updateColumns: updateColumns?.call(ObjectFieldPersist.t),
      updateWhere: updateWhere?.call(ObjectFieldPersist.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectFieldPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectFieldPersist>> update(
    _isd.DatabaseSession session,
    List<ObjectFieldPersist> rows, {
    _isd.ColumnSelections<ObjectFieldPersistTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectFieldPersist>(
      rows,
      columns: columns?.call(ObjectFieldPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectFieldPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectFieldPersist> updateRow(
    _isd.DatabaseSession session,
    ObjectFieldPersist row, {
    _isd.ColumnSelections<ObjectFieldPersistTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectFieldPersist>(
      row,
      columns: columns?.call(ObjectFieldPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectFieldPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectFieldPersist?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<ObjectFieldPersistUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectFieldPersist>(
      id,
      columnValues: columnValues(ObjectFieldPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectFieldPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectFieldPersist>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<ObjectFieldPersistUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<ObjectFieldPersistTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    _isd.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectFieldPersist>(
      columnValues: columnValues(ObjectFieldPersist.t.updateTable),
      where: where(ObjectFieldPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectFieldPersist]s in the list and returns the deleted rows.
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
  Future<List<ObjectFieldPersist>> delete(
    _isd.DatabaseSession session,
    List<ObjectFieldPersist> rows, {
    _isd.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    _isd.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectFieldPersist>(
      rows,
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectFieldPersist].
  Future<ObjectFieldPersist> deleteRow(
    _isd.DatabaseSession session,
    ObjectFieldPersist row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectFieldPersist>(
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
  Future<List<ObjectFieldPersist>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<ObjectFieldPersistTable> where,
    _isd.OrderByBuilder<ObjectFieldPersistTable>? orderBy,
    _isd.OrderByListBuilder<ObjectFieldPersistTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectFieldPersist>(
      where: where(ObjectFieldPersist.t),
      orderBy: orderBy?.call(ObjectFieldPersist.t),
      orderByList: orderByList?.call(ObjectFieldPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ObjectFieldPersistTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<ObjectFieldPersist>(
      where: where?.call(ObjectFieldPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectFieldPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<ObjectFieldPersistTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectFieldPersist>(
      where: where(ObjectFieldPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
