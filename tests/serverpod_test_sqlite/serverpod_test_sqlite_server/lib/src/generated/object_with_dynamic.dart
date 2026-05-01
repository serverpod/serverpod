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
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i2;

abstract class ObjectWithDynamic
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithDynamic._({
    this.id,
    required this.payload,
    required this.jsonbPayload,
    required this.payloadList,
    required this.payloadMap,
    required this.payloadSet,
    required this.payloadMapWithDynamicKeys,
  });

  factory ObjectWithDynamic({
    int? id,
    required dynamic payload,
    required dynamic jsonbPayload,
    required List<dynamic> payloadList,
    required Map<String, dynamic> payloadMap,
    required Set<dynamic> payloadSet,
    required Map<dynamic, dynamic> payloadMapWithDynamicKeys,
  }) = _ObjectWithDynamicImpl;

  factory ObjectWithDynamic.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithDynamic(
      id: jsonSerialization['id'] as int?,
      payload: _i2.Protocol().decodeDynamicFieldValue(
        jsonSerialization['payload'],
      ),
      jsonbPayload: _i2.Protocol().decodeDynamicFieldValue(
        jsonSerialization['jsonbPayload'],
      ),
      payloadList: _i2.Protocol().deserialize<List<dynamic>>(
        jsonSerialization['payloadList'],
      ),
      payloadMap: _i2.Protocol().deserialize<Map<String, dynamic>>(
        jsonSerialization['payloadMap'],
      ),
      payloadSet: _i2.Protocol().deserialize<Set<dynamic>>(
        jsonSerialization['payloadSet'],
      ),
      payloadMapWithDynamicKeys: _i2.Protocol()
          .deserialize<Map<dynamic, dynamic>>(
            jsonSerialization['payloadMapWithDynamicKeys'],
          ),
    );
  }

  static final t = ObjectWithDynamicTable();

  static const db = ObjectWithDynamicRepository._();

  @override
  int? id;

  dynamic payload;

  dynamic jsonbPayload;

  List<dynamic> payloadList;

  Map<String, dynamic> payloadMap;

  Set<dynamic> payloadSet;

  Map<dynamic, dynamic> payloadMapWithDynamicKeys;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithDynamic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithDynamic copyWith({
    int? id,
    dynamic payload,
    dynamic jsonbPayload,
    List<dynamic>? payloadList,
    Map<String, dynamic>? payloadMap,
    Set<dynamic>? payloadSet,
    Map<dynamic, dynamic>? payloadMapWithDynamicKeys,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithDynamic',
      if (id != null) 'id': id,
      'payload': _i2.Protocol().encodeWithType(payload),
      'jsonbPayload': _i2.Protocol().encodeWithType(jsonbPayload),
      'payloadList': payloadList.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
      'payloadMap': payloadMap.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
      'payloadSet': payloadSet.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
      'payloadMapWithDynamicKeys': payloadMapWithDynamicKeys.toJson(
        keyToJson: (k) => _i2.Protocol().encodeWithType(k),
        valueToJson: (v) => _i2.Protocol().encodeWithType(v),
      ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithDynamic',
      if (id != null) 'id': id,
      'payload': _i2.Protocol().encodeWithTypeForProtocol(payload),
      'jsonbPayload': _i2.Protocol().encodeWithTypeForProtocol(jsonbPayload),
      'payloadList': payloadList.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithTypeForProtocol(v),
      ),
      'payloadMap': payloadMap.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithTypeForProtocol(v),
      ),
      'payloadSet': payloadSet.toJson(
        valueToJson: (v) => _i2.Protocol().encodeWithTypeForProtocol(v),
      ),
      'payloadMapWithDynamicKeys': payloadMapWithDynamicKeys.toJson(
        keyToJson: (k) => _i2.Protocol().encodeWithTypeForProtocol(k),
        valueToJson: (v) => _i2.Protocol().encodeWithTypeForProtocol(v),
      ),
    };
  }

  static ObjectWithDynamicInclude include() {
    return ObjectWithDynamicInclude._();
  }

  static ObjectWithDynamicIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithDynamicTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDynamicTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDynamicTable>? orderByList,
    ObjectWithDynamicInclude? include,
  }) {
    return ObjectWithDynamicIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDynamic.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ObjectWithDynamic.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithDynamicImpl extends ObjectWithDynamic {
  _ObjectWithDynamicImpl({
    int? id,
    required dynamic payload,
    required dynamic jsonbPayload,
    required List<dynamic> payloadList,
    required Map<String, dynamic> payloadMap,
    required Set<dynamic> payloadSet,
    required Map<dynamic, dynamic> payloadMapWithDynamicKeys,
  }) : super._(
         id: id,
         payload: payload,
         jsonbPayload: jsonbPayload,
         payloadList: payloadList,
         payloadMap: payloadMap,
         payloadSet: payloadSet,
         payloadMapWithDynamicKeys: payloadMapWithDynamicKeys,
       );

  /// Returns a shallow copy of this [ObjectWithDynamic]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithDynamic copyWith({
    Object? id = _Undefined,
    Object? payload = _Undefined,
    Object? jsonbPayload = _Undefined,
    List<dynamic>? payloadList,
    Map<String, dynamic>? payloadMap,
    Set<dynamic>? payloadSet,
    Map<dynamic, dynamic>? payloadMapWithDynamicKeys,
  }) {
    return ObjectWithDynamic(
      id: id is int? ? id : this.id,
      payload: payload is! _Undefined ? payload : this.payload,
      jsonbPayload: jsonbPayload is! _Undefined
          ? jsonbPayload
          : this.jsonbPayload,
      payloadList: payloadList ?? this.payloadList.map((e0) => e0).toList(),
      payloadMap:
          payloadMap ??
          this.payloadMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      payloadSet: payloadSet ?? this.payloadSet.map((e0) => e0).toSet(),
      payloadMapWithDynamicKeys:
          payloadMapWithDynamicKeys ??
          this.payloadMapWithDynamicKeys.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}

class ObjectWithDynamicUpdateTable
    extends _i1.UpdateTable<ObjectWithDynamicTable> {
  ObjectWithDynamicUpdateTable(super.table);

  _i1.ColumnValue<dynamic, dynamic> payload(dynamic value) => _i1.ColumnValue(
    table.payload,
    value,
  );

  _i1.ColumnValue<dynamic, dynamic> jsonbPayload(dynamic value) =>
      _i1.ColumnValue(
        table.jsonbPayload,
        value,
      );

  _i1.ColumnValue<List<dynamic>, List<dynamic>> payloadList(
    List<dynamic> value,
  ) => _i1.ColumnValue(
    table.payloadList,
    value,
  );

  _i1.ColumnValue<Map<String, dynamic>, Map<String, dynamic>> payloadMap(
    Map<String, dynamic> value,
  ) => _i1.ColumnValue(
    table.payloadMap,
    value,
  );

  _i1.ColumnValue<Set<dynamic>, Set<dynamic>> payloadSet(Set<dynamic> value) =>
      _i1.ColumnValue(
        table.payloadSet,
        value,
      );

  _i1.ColumnValue<Map<dynamic, dynamic>, Map<dynamic, dynamic>>
  payloadMapWithDynamicKeys(Map<dynamic, dynamic> value) => _i1.ColumnValue(
    table.payloadMapWithDynamicKeys,
    value,
  );
}

class ObjectWithDynamicTable extends _i1.Table<int?> {
  ObjectWithDynamicTable({super.tableRelation})
    : super(tableName: 'object_with_dynamic') {
    updateTable = ObjectWithDynamicUpdateTable(this);
    payload = _i1.ColumnSerializable<dynamic>(
      'payload',
      this,
    );
    jsonbPayload = _i1.ColumnStructured<dynamic>(
      'jsonbPayload',
      this,
    );
    payloadList = _i1.ColumnSerializable<List<dynamic>>(
      'payloadList',
      this,
    );
    payloadMap = _i1.ColumnSerializable<Map<String, dynamic>>(
      'payloadMap',
      this,
    );
    payloadSet = _i1.ColumnSerializable<Set<dynamic>>(
      'payloadSet',
      this,
    );
    payloadMapWithDynamicKeys = _i1.ColumnStructured<Map<dynamic, dynamic>>(
      'payloadMapWithDynamicKeys',
      this,
    );
  }

  late final ObjectWithDynamicUpdateTable updateTable;

  late final _i1.ColumnSerializable<dynamic> payload;

  late final _i1.ColumnStructured<dynamic> jsonbPayload;

  late final _i1.ColumnSerializable<List<dynamic>> payloadList;

  late final _i1.ColumnSerializable<Map<String, dynamic>> payloadMap;

  late final _i1.ColumnSerializable<Set<dynamic>> payloadSet;

  late final _i1.ColumnStructured<Map<dynamic, dynamic>>
  payloadMapWithDynamicKeys;

  @override
  List<_i1.Column> get columns => [
    id,
    payload,
    jsonbPayload,
    payloadList,
    payloadMap,
    payloadSet,
    payloadMapWithDynamicKeys,
  ];
}

class ObjectWithDynamicInclude extends _i1.IncludeObject {
  ObjectWithDynamicInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithDynamic.t;
}

class ObjectWithDynamicIncludeList extends _i1.IncludeList {
  ObjectWithDynamicIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithDynamicTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithDynamic.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithDynamic.t;
}

class ObjectWithDynamicRepository {
  const ObjectWithDynamicRepository._();

  /// Returns a list of [ObjectWithDynamic]s matching the given query parameters.
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
  Future<List<ObjectWithDynamic>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithDynamicTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDynamicTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDynamicTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithDynamic>(
      where: where?.call(ObjectWithDynamic.t),
      orderBy: orderBy?.call(ObjectWithDynamic.t),
      orderByList: orderByList?.call(ObjectWithDynamic.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithDynamic] matching the given query parameters.
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
  Future<ObjectWithDynamic?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithDynamicTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDynamicTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDynamicTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithDynamic>(
      where: where?.call(ObjectWithDynamic.t),
      orderBy: orderBy?.call(ObjectWithDynamic.t),
      orderByList: orderByList?.call(ObjectWithDynamic.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithDynamic] by its [id] or null if no such row exists.
  Future<ObjectWithDynamic?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithDynamic>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithDynamic]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithDynamic]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ObjectWithDynamic>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithDynamic> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ObjectWithDynamic>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ObjectWithDynamic] and returns the inserted row.
  ///
  /// The returned [ObjectWithDynamic] will have its `id` field set.
  Future<ObjectWithDynamic> insertRow(
    _i1.DatabaseSession session,
    ObjectWithDynamic row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithDynamic>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithDynamic]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithDynamic>> update(
    _i1.DatabaseSession session,
    List<ObjectWithDynamic> rows, {
    _i1.ColumnSelections<ObjectWithDynamicTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithDynamic>(
      rows,
      columns: columns?.call(ObjectWithDynamic.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithDynamic]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithDynamic> updateRow(
    _i1.DatabaseSession session,
    ObjectWithDynamic row, {
    _i1.ColumnSelections<ObjectWithDynamicTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithDynamic>(
      row,
      columns: columns?.call(ObjectWithDynamic.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithDynamic] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithDynamic?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithDynamicUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithDynamic>(
      id,
      columnValues: columnValues(ObjectWithDynamic.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithDynamic]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithDynamic>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithDynamicUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithDynamicTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDynamicTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithDynamicTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithDynamic>(
      columnValues: columnValues(ObjectWithDynamic.t.updateTable),
      where: where(ObjectWithDynamic.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDynamic.t),
      orderByList: orderByList?.call(ObjectWithDynamic.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithDynamic]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithDynamic>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithDynamic> rows, {
    _i1.OrderByBuilder<ObjectWithDynamicTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDynamicTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithDynamic>(
      rows,
      orderBy: orderBy?.call(ObjectWithDynamic.t),
      orderByList: orderByList?.call(ObjectWithDynamic.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithDynamic].
  Future<ObjectWithDynamic> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithDynamic row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithDynamic>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<ObjectWithDynamic>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithDynamicTable> where,
    _i1.OrderByBuilder<ObjectWithDynamicTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDynamicTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithDynamic>(
      where: where(ObjectWithDynamic.t),
      orderBy: orderBy?.call(ObjectWithDynamic.t),
      orderByList: orderByList?.call(ObjectWithDynamic.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithDynamicTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithDynamic>(
      where: where?.call(ObjectWithDynamic.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithDynamic] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithDynamicTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithDynamic>(
      where: where(ObjectWithDynamic.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
