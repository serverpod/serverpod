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
import 'package:serverpod/serverpod.dart' as _i1;
import 'simple_data.dart' as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class ObjectWithJsonb
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
    required _i2.SimpleData jsonbObject,
    required List<String> jsonbIndexed,
    required List<String> jsonbIndexedGin,
    required List<String> jsonbIndexedGinJsonbPath,
    required List<String> jsonbIndexedImplicitGin,
    List<String>? nullableJsonb,
  }) = _ObjectWithJsonbImpl;

  factory ObjectWithJsonb.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithJsonb(
      id: jsonSerialization['id'] as int?,
      notJsonb: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['notJsonb'],
      ),
      jsonb: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonb'],
      ),
      jsonbMap: _i3.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['jsonbMap'],
      ),
      jsonbObject: _i3.Protocol().deserialize<_i2.SimpleData>(
        jsonSerialization['jsonbObject'],
      ),
      jsonbIndexed: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexed'],
      ),
      jsonbIndexedGin: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGin'],
      ),
      jsonbIndexedGinJsonbPath: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedGinJsonbPath'],
      ),
      jsonbIndexedImplicitGin: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['jsonbIndexedImplicitGin'],
      ),
      nullableJsonb: jsonSerialization['nullableJsonb'] == null
          ? null
          : _i3.Protocol().deserialize<List<String>>(
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

  _i2.SimpleData jsonbObject;

  List<String> jsonbIndexed;

  List<String> jsonbIndexedGin;

  List<String> jsonbIndexedGinJsonbPath;

  List<String> jsonbIndexedImplicitGin;

  List<String>? nullableJsonb;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithJsonb]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithJsonb copyWith({
    int? id,
    List<String>? notJsonb,
    List<String>? jsonb,
    Map<String, String>? jsonbMap,
    _i2.SimpleData? jsonbObject,
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
    return ObjectWithJsonbInclude._();
  }

  static ObjectWithJsonbIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    ObjectWithJsonbInclude? include,
  }) {
    return ObjectWithJsonbIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithJsonbImpl extends ObjectWithJsonb {
  _ObjectWithJsonbImpl({
    int? id,
    required List<String> notJsonb,
    required List<String> jsonb,
    required Map<String, String> jsonbMap,
    required _i2.SimpleData jsonbObject,
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
  @_i1.useResult
  @override
  ObjectWithJsonb copyWith({
    Object? id = _Undefined,
    List<String>? notJsonb,
    List<String>? jsonb,
    Map<String, String>? jsonbMap,
    _i2.SimpleData? jsonbObject,
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

class ObjectWithJsonbUpdateTable extends _i1.UpdateTable<ObjectWithJsonbTable> {
  ObjectWithJsonbUpdateTable(super.table);

  _i1.ColumnValue<List<String>, List<String>> notJsonb(List<String> value) =>
      _i1.ColumnValue(
        table.notJsonb,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> jsonb(List<String> value) =>
      _i1.ColumnValue(
        table.jsonb,
        value,
      );

  _i1.ColumnValue<Map<String, String>, Map<String, String>> jsonbMap(
    Map<String, String> value,
  ) => _i1.ColumnValue(
    table.jsonbMap,
    value,
  );

  _i1.ColumnValue<_i2.SimpleData, _i2.SimpleData> jsonbObject(
    _i2.SimpleData value,
  ) => _i1.ColumnValue(
    table.jsonbObject,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> jsonbIndexed(
    List<String> value,
  ) => _i1.ColumnValue(
    table.jsonbIndexed,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> jsonbIndexedGin(
    List<String> value,
  ) => _i1.ColumnValue(
    table.jsonbIndexedGin,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> jsonbIndexedGinJsonbPath(
    List<String> value,
  ) => _i1.ColumnValue(
    table.jsonbIndexedGinJsonbPath,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> jsonbIndexedImplicitGin(
    List<String> value,
  ) => _i1.ColumnValue(
    table.jsonbIndexedImplicitGin,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> nullableJsonb(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.nullableJsonb,
    value,
  );
}

class ObjectWithJsonbTable extends _i1.Table<int?> {
  ObjectWithJsonbTable({super.tableRelation})
    : super(tableName: 'object_with_jsonb') {
    updateTable = ObjectWithJsonbUpdateTable(this);
    notJsonb = _i1.ColumnSerializable<List<String>>(
      'notJsonb',
      this,
    );
    jsonb = _i1.ColumnStructured<List<String>>(
      'jsonb',
      this,
    );
    jsonbMap = _i1.ColumnStructured<Map<String, String>>(
      'jsonbMap',
      this,
    );
    jsonbObject = _i1.ColumnStructured<_i2.SimpleData>(
      'jsonbObject',
      this,
    );
    jsonbIndexed = _i1.ColumnStructured<List<String>>(
      'jsonbIndexed',
      this,
    );
    jsonbIndexedGin = _i1.ColumnStructured<List<String>>(
      'jsonbIndexedGin',
      this,
    );
    jsonbIndexedGinJsonbPath = _i1.ColumnStructured<List<String>>(
      'jsonbIndexedGinJsonbPath',
      this,
    );
    jsonbIndexedImplicitGin = _i1.ColumnStructured<List<String>>(
      'jsonbIndexedImplicitGin',
      this,
    );
    nullableJsonb = _i1.ColumnStructured<List<String>>(
      'nullableJsonb',
      this,
    );
  }

  late final ObjectWithJsonbUpdateTable updateTable;

  late final _i1.ColumnSerializable<List<String>> notJsonb;

  late final _i1.ColumnStructured<List<String>> jsonb;

  late final _i1.ColumnStructured<Map<String, String>> jsonbMap;

  late final _i1.ColumnStructured<_i2.SimpleData> jsonbObject;

  late final _i1.ColumnStructured<List<String>> jsonbIndexed;

  late final _i1.ColumnStructured<List<String>> jsonbIndexedGin;

  late final _i1.ColumnStructured<List<String>> jsonbIndexedGinJsonbPath;

  late final _i1.ColumnStructured<List<String>> jsonbIndexedImplicitGin;

  late final _i1.ColumnStructured<List<String>> nullableJsonb;

  @override
  List<_i1.Column> get columns => [
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

class ObjectWithJsonbInclude extends _i1.IncludeObject {
  ObjectWithJsonbInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithJsonb.t;
}

class ObjectWithJsonbIncludeList extends _i1.IncludeList {
  ObjectWithJsonbIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithJsonb.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithJsonb.t;
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithJsonb] by its [id] or null if no such row exists.
  Future<ObjectWithJsonb?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
  Future<List<ObjectWithJsonb>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ObjectWithJsonb>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ObjectWithJsonb] and returns the inserted row.
  ///
  /// The returned [ObjectWithJsonb] will have its `id` field set.
  Future<ObjectWithJsonb> insertRow(
    _i1.DatabaseSession session,
    ObjectWithJsonb row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithJsonb>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonb]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithJsonb>> update(
    _i1.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _i1.ColumnSelections<ObjectWithJsonbTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithJsonb>(
      rows,
      columns: columns?.call(ObjectWithJsonb.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithJsonb]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithJsonb> updateRow(
    _i1.DatabaseSession session,
    ObjectWithJsonb row, {
    _i1.ColumnSelections<ObjectWithJsonbTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithJsonbUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithJsonb>(
      id,
      columnValues: columnValues(ObjectWithJsonb.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonb]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithJsonb>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithJsonbUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithJsonb>(
      columnValues: columnValues(ObjectWithJsonb.t.updateTable),
      where: where(ObjectWithJsonb.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithJsonb]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithJsonb>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithJsonb> rows, {
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithJsonb>(
      rows,
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithJsonb].
  Future<ObjectWithJsonb> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithJsonb row, {
    _i1.Transaction? transaction,
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
  Future<List<ObjectWithJsonb>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    _i1.OrderByBuilder<ObjectWithJsonbTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithJsonbTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithJsonb>(
      where: where(ObjectWithJsonb.t),
      orderBy: orderBy?.call(ObjectWithJsonb.t),
      orderByList: orderByList?.call(ObjectWithJsonb.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithJsonbTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithJsonb>(
      where: where?.call(ObjectWithJsonb.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithJsonb] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithJsonbTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithJsonb>(
      where: where(ObjectWithJsonb.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

abstract class ObjectWithJsonbReactiveFutureCall
    extends _i1.ReactiveFutureCall<ObjectWithJsonb> {
  @override
  String get tableName => 'object_with_jsonb';

  _i1.WhereExpressionBuilder<ObjectWithJsonbTable> get where;
  @override
  _i1.Expression? get condition => where(ObjectWithJsonb.t);
}
