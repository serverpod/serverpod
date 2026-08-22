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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'simple_data.dart' as _i0zisc0t;

abstract class ObjectWithJsonb
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithJsonb._({
    this.id,
    required this.notJsonb,
    required this.jsonb,
    required this.jsonbMap,
    required this.jsonbObject,
    required this.jsonbIndexed,
    required this.jsonbIndexedGin,
    required this.jsonbIndexedGinJsonbPath,
    required this.jsonbIndexedImplicitGin,
    this.nullableJsonb,
  });

  factory ObjectWithJsonb({
    int? id,
    required List<String> notJsonb,
    required List<String> jsonb,
    required Map<String, String> jsonbMap,
    required _i0zisc0t.SimpleData jsonbObject,
    required List<String> jsonbIndexed,
    required List<String> jsonbIndexedGin,
    required List<String> jsonbIndexedGinJsonbPath,
    required List<String> jsonbIndexedImplicitGin,
    List<String>? nullableJsonb,
  }) = _ObjectWithJsonbImpl;

  factory ObjectWithJsonb.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithJsonb(
      id: jsonSerialization['id'] as int?,
      notJsonb: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['notJsonb'],
      ),
      jsonb: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonb'],
      ),
      jsonbMap: _igqrxdcj.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['jsonbMap'],
      ),
      jsonbObject: _igqrxdcj.Protocol().deserialize<_i0zisc0t.SimpleData>(
        jsonSerialization['jsonbObject'],
      ),
      jsonbIndexed: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexed'],
      ),
      jsonbIndexedGin: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGin'],
      ),
      jsonbIndexedGinJsonbPath: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGinJsonbPath'],
      ),
      jsonbIndexedImplicitGin: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedImplicitGin'],
      ),
      nullableJsonb: jsonSerialization['nullableJsonb'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<String>>(
              jsonSerialization['nullableJsonb'],
            ),
    );
  }

  static final t = ObjectWithJsonbTable();

  static const db = ObjectWithJsonbRepository._();

  @override
  int? id;

  List<String> notJsonb;

  List<String> jsonb;

  Map<String, String> jsonbMap;

  _i0zisc0t.SimpleData jsonbObject;

  List<String> jsonbIndexed;

  List<String> jsonbIndexedGin;

  List<String> jsonbIndexedGinJsonbPath;

  List<String> jsonbIndexedImplicitGin;

  List<String>? nullableJsonb;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithJsonb copyWith({
    int? id,
    List<String>? notJsonb,
    List<String>? jsonb,
    Map<String, String>? jsonbMap,
    _i0zisc0t.SimpleData? jsonbObject,
    List<String>? jsonbIndexed,
    List<String>? jsonbIndexedGin,
    List<String>? jsonbIndexedGinJsonbPath,
    List<String>? jsonbIndexedImplicitGin,
    List<String>? nullableJsonb,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonb',
      if (id != null) 'id': id,
      'notJsonb': notJsonb.toJson(),
      'jsonb': jsonb.toJson(),
      'jsonbMap': jsonbMap.toJson(),
      'jsonbObject': jsonbObject.toJson(),
      'jsonbIndexed': jsonbIndexed.toJson(),
      'jsonbIndexedGin': jsonbIndexedGin.toJson(),
      'jsonbIndexedGinJsonbPath': jsonbIndexedGinJsonbPath.toJson(),
      'jsonbIndexedImplicitGin': jsonbIndexedImplicitGin.toJson(),
      if (nullableJsonb != null) 'nullableJsonb': nullableJsonb?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithJsonb',
      if (id != null) 'id': id,
      'notJsonb': notJsonb.toJson(),
      'jsonb': jsonb.toJson(),
      'jsonbMap': jsonbMap.toJson(),
      'jsonbObject': jsonbObject.toJsonForProtocol(),
      'jsonbIndexed': jsonbIndexed.toJson(),
      'jsonbIndexedGin': jsonbIndexedGin.toJson(),
      'jsonbIndexedGinJsonbPath': jsonbIndexedGinJsonbPath.toJson(),
      'jsonbIndexedImplicitGin': jsonbIndexedImplicitGin.toJson(),
      if (nullableJsonb != null) 'nullableJsonb': nullableJsonb?.toJson(),
    };
  }

  static ObjectWithJsonbInclude include() {
    return ObjectWithJsonbInclude.internal_();
  }

  static ObjectWithJsonbIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    ObjectWithJsonbInclude? include,
  }) {
    return ObjectWithJsonbIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithJsonbImpl extends ObjectWithJsonb {
  _ObjectWithJsonbImpl({
    int? id,
    required List<String> notJsonb,
    required List<String> jsonb,
    required Map<String, String> jsonbMap,
    required _i0zisc0t.SimpleData jsonbObject,
    required List<String> jsonbIndexed,
    required List<String> jsonbIndexedGin,
    required List<String> jsonbIndexedGinJsonbPath,
    required List<String> jsonbIndexedImplicitGin,
    List<String>? nullableJsonb,
  }) : super._(
         id: id,
         notJsonb: notJsonb,
         jsonb: jsonb,
         jsonbMap: jsonbMap,
         jsonbObject: jsonbObject,
         jsonbIndexed: jsonbIndexed,
         jsonbIndexedGin: jsonbIndexedGin,
         jsonbIndexedGinJsonbPath: jsonbIndexedGinJsonbPath,
         jsonbIndexedImplicitGin: jsonbIndexedImplicitGin,
         nullableJsonb: nullableJsonb,
       );

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithJsonb copyWith({
    Object? id = _Undefined,
    List<String>? notJsonb,
    List<String>? jsonb,
    Map<String, String>? jsonbMap,
    _i0zisc0t.SimpleData? jsonbObject,
    List<String>? jsonbIndexed,
    List<String>? jsonbIndexedGin,
    List<String>? jsonbIndexedGinJsonbPath,
    List<String>? jsonbIndexedImplicitGin,
    Object? nullableJsonb = _Undefined,
  }) {
    return ObjectWithJsonb(
      id: id is int? ? id : this.id,
      notJsonb: notJsonb ?? this.notJsonb.map((e0) => e0).toList(),
      jsonb: jsonb ?? this.jsonb.map((e0) => e0).toList(),
      jsonbMap:
          jsonbMap ??
          this.jsonbMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      jsonbObject: jsonbObject ?? this.jsonbObject.copyWith(),
      jsonbIndexed: jsonbIndexed ?? this.jsonbIndexed.map((e0) => e0).toList(),
      jsonbIndexedGin:
          jsonbIndexedGin ?? this.jsonbIndexedGin.map((e0) => e0).toList(),
      jsonbIndexedGinJsonbPath:
          jsonbIndexedGinJsonbPath ??
          this.jsonbIndexedGinJsonbPath.map((e0) => e0).toList(),
      jsonbIndexedImplicitGin:
          jsonbIndexedImplicitGin ??
          this.jsonbIndexedImplicitGin.map((e0) => e0).toList(),
      nullableJsonb: nullableJsonb is List<String>?
          ? nullableJsonb
          : this.nullableJsonb?.map((e0) => e0).toList(),
    );
  }
}

class ObjectWithJsonbUpdateTable extends _is.UpdateTable<ObjectWithJsonbTable> {
  ObjectWithJsonbUpdateTable(super.table);

  _is.ColumnValue<List<String>, List<String>> notJsonb(List<String> value) =>
      _is.ColumnValue(
        table.notJsonb,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> jsonb(List<String> value) =>
      _is.ColumnValue(
        table.jsonb,
        value,
      );

  _is.ColumnValue<Map<String, String>, Map<String, String>> jsonbMap(
    Map<String, String> value,
  ) => _is.ColumnValue(
    table.jsonbMap,
    value,
  );

  _is.ColumnValue<_i0zisc0t.SimpleData, _i0zisc0t.SimpleData> jsonbObject(
    _i0zisc0t.SimpleData value,
  ) => _is.ColumnValue(
    table.jsonbObject,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> jsonbIndexed(
    List<String> value,
  ) => _is.ColumnValue(
    table.jsonbIndexed,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> jsonbIndexedGin(
    List<String> value,
  ) => _is.ColumnValue(
    table.jsonbIndexedGin,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> jsonbIndexedGinJsonbPath(
    List<String> value,
  ) => _is.ColumnValue(
    table.jsonbIndexedGinJsonbPath,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> jsonbIndexedImplicitGin(
    List<String> value,
  ) => _is.ColumnValue(
    table.jsonbIndexedImplicitGin,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> nullableJsonb(
    List<String>? value,
  ) => _is.ColumnValue(
    table.nullableJsonb,
    value,
  );
}

class ObjectWithJsonbTable extends _is.Table<int?> {
  ObjectWithJsonbTable({super.tableRelation})
    : super(tableName: 'object_with_jsonb') {
    updateTable = ObjectWithJsonbUpdateTable(this);
    notJsonb = _is.ColumnSerializable<List<String>>(
      'notJsonb',
      this,
    );
    jsonb = _is.ColumnStructured<List<String>>(
      'jsonb',
      this,
    );
    jsonbMap = _is.ColumnStructured<Map<String, String>>(
      'jsonbMap',
      this,
    );
    jsonbObject = _is.ColumnStructured<_i0zisc0t.SimpleData>(
      'jsonbObject',
      this,
    );
    jsonbIndexed = _is.ColumnStructured<List<String>>(
      'jsonbIndexed',
      this,
    );
    jsonbIndexedGin = _is.ColumnStructured<List<String>>(
      'jsonbIndexedGin',
      this,
    );
    jsonbIndexedGinJsonbPath = _is.ColumnStructured<List<String>>(
      'jsonbIndexedGinJsonbPath',
      this,
    );
    jsonbIndexedImplicitGin = _is.ColumnStructured<List<String>>(
      'jsonbIndexedImplicitGin',
      this,
    );
    nullableJsonb = _is.ColumnStructured<List<String>>(
      'nullableJsonb',
      this,
    );
  }

  late final ObjectWithJsonbUpdateTable updateTable;

  late final _is.ColumnSerializable<List<String>> notJsonb;

  late final _is.ColumnStructured<List<String>> jsonb;

  late final _is.ColumnStructured<Map<String, String>> jsonbMap;

  late final _is.ColumnStructured<_i0zisc0t.SimpleData> jsonbObject;

  late final _is.ColumnStructured<List<String>> jsonbIndexed;

  late final _is.ColumnStructured<List<String>> jsonbIndexedGin;

  late final _is.ColumnStructured<List<String>> jsonbIndexedGinJsonbPath;

  late final _is.ColumnStructured<List<String>> jsonbIndexedImplicitGin;

  late final _is.ColumnStructured<List<String>> nullableJsonb;

  @override
  List<_is.Column> get columns => [
    id,
    notJsonb,
    jsonb,
    jsonbMap,
    jsonbObject,
    jsonbIndexed,
    jsonbIndexedGin,
    jsonbIndexedGinJsonbPath,
    jsonbIndexedImplicitGin,
    nullableJsonb,
  ];
}

class ObjectWithJsonbInclude extends _is.IncludeObject {
  ObjectWithJsonbInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithJsonb.t;
}

class ObjectWithJsonbIncludeList extends _is.IncludeList {
  ObjectWithJsonbIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithJsonb.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithJsonb.t;
}

class ObjectWithJsonbRepository {
  const ObjectWithJsonbRepository._();

  /// Returns a list of [ObjectWithJsonb]s matching the given query parameters.
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
  Future<List<ObjectWithJsonb>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithJsonb] matching the given query parameters.
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
  Future<ObjectWithJsonb?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithJsonb] by its [id] or null if no such row exists.
  Future<ObjectWithJsonb?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithJsonb>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithJsonb]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithJsonb]s will have their `id` fields set.
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
  Future<List<ObjectWithJsonb>> insert(
    _is.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithJsonb>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithJsonb] and returns the inserted row.
  ///
  /// The returned [ObjectWithJsonb] will have its `id` field set.
  Future<ObjectWithJsonb> insertRow(
    _is.DatabaseSession session,
    ObjectWithJsonb row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithJsonb>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithJsonb]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithJsonb]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithJsonb>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    required _is.ColumnSelections<ObjectWithJsonbTable> conflictColumns,
    _is.ColumnSelections<ObjectWithJsonbTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithJsonbTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithJsonb>(
      rows,
      conflictColumns: conflictColumns(ObjectWithJsonb.t),
      updateColumns: updateColumns?.call(ObjectWithJsonb.t),
      updateWhere: updateWhere?.call(ObjectWithJsonb.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithJsonb] and returns the resulting row.
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
  /// The returned [ObjectWithJsonb] will have its `id` field set.
  Future<ObjectWithJsonb?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithJsonb row, {
    required _is.ColumnSelections<ObjectWithJsonbTable> conflictColumns,
    _is.ColumnSelections<ObjectWithJsonbTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithJsonbTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithJsonb>(
      row,
      conflictColumns: conflictColumns(ObjectWithJsonb.t),
      updateColumns: updateColumns?.call(ObjectWithJsonb.t),
      updateWhere: updateWhere?.call(ObjectWithJsonb.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonb]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithJsonb>> update(
    _is.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _is.ColumnSelections<ObjectWithJsonbTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithJsonb>(
      rows,
      columns: columns?.call(ObjectWithJsonb.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithJsonb]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithJsonb> updateRow(
    _is.DatabaseSession session,
    ObjectWithJsonb row, {
    _is.ColumnSelections<ObjectWithJsonbTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithJsonb>(
      row,
      columns: columns?.call(ObjectWithJsonb.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithJsonb] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithJsonb?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithJsonbUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithJsonb>(
      id,
      columnValues: columnValues(ObjectWithJsonb.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonb]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithJsonb>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithJsonbUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithJsonb>(
      columnValues: columnValues(ObjectWithJsonb.t.updateTable),
      where: where(ObjectWithJsonb.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithJsonb]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithJsonb>> delete(
    _is.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _is.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithJsonb>(
      rows,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithJsonb].
  Future<ObjectWithJsonb> deleteRow(
    _is.DatabaseSession session,
    ObjectWithJsonb row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithJsonb>(
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
  Future<List<ObjectWithJsonb>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    _is.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithJsonb>(
      where: where(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithJsonb] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithJsonb>(
      where: where(ObjectWithJsonb.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
