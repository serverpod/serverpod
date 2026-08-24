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

abstract class ObjectWithObject
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithObject._({
    this.id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
    this.nestedDataList,
    this.nestedDataListInMap,
    this.nestedDataMap,
  });

  factory ObjectWithObject({
    int? id,
    required _i0zisc0t.SimpleData data,
    _i0zisc0t.SimpleData? nullableData,
    required List<_i0zisc0t.SimpleData> dataList,
    List<_i0zisc0t.SimpleData>? nullableDataList,
    required List<_i0zisc0t.SimpleData?> listWithNullableData,
    List<_i0zisc0t.SimpleData?>? nullableListWithNullableData,
    List<List<_i0zisc0t.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
    nestedDataListInMap,
    Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap,
  }) = _ObjectWithObjectImpl;

  factory ObjectWithObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithObject(
      id: jsonSerialization['id'] as int?,
      data: _igqrxdcj.Protocol().deserialize<_i0zisc0t.SimpleData>(
        jsonSerialization['data'],
      ),
      nullableData: jsonSerialization['nullableData'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i0zisc0t.SimpleData>(
              jsonSerialization['nullableData'],
            ),
      dataList: _igqrxdcj.Protocol().deserialize<List<_i0zisc0t.SimpleData>>(
        jsonSerialization['dataList'],
      ),
      nullableDataList: jsonSerialization['nullableDataList'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_i0zisc0t.SimpleData>>(
              jsonSerialization['nullableDataList'],
            ),
      listWithNullableData: _igqrxdcj.Protocol()
          .deserialize<List<_i0zisc0t.SimpleData?>>(
            jsonSerialization['listWithNullableData'],
          ),
      nullableListWithNullableData:
          jsonSerialization['nullableListWithNullableData'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_i0zisc0t.SimpleData?>>(
              jsonSerialization['nullableListWithNullableData'],
            ),
      nestedDataList: jsonSerialization['nestedDataList'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<List<_i0zisc0t.SimpleData>>>(
              jsonSerialization['nestedDataList'],
            ),
      nestedDataListInMap: jsonSerialization['nestedDataListInMap'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<
              Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>
            >(jsonSerialization['nestedDataListInMap']),
      nestedDataMap: jsonSerialization['nestedDataMap'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<Map<String, Map<int, _i0zisc0t.SimpleData>>>(
                  jsonSerialization['nestedDataMap'],
                ),
    );
  }

  static final t = ObjectWithObjectTable();

  static const db = ObjectWithObjectRepository._();

  @override
  int? id;

  _i0zisc0t.SimpleData data;

  _i0zisc0t.SimpleData? nullableData;

  List<_i0zisc0t.SimpleData> dataList;

  List<_i0zisc0t.SimpleData>? nullableDataList;

  List<_i0zisc0t.SimpleData?> listWithNullableData;

  List<_i0zisc0t.SimpleData?>? nullableListWithNullableData;

  List<List<_i0zisc0t.SimpleData>>? nestedDataList;

  Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>? nestedDataListInMap;

  Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithObject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithObject copyWith({
    int? id,
    _i0zisc0t.SimpleData? data,
    _i0zisc0t.SimpleData? nullableData,
    List<_i0zisc0t.SimpleData>? dataList,
    List<_i0zisc0t.SimpleData>? nullableDataList,
    List<_i0zisc0t.SimpleData?>? listWithNullableData,
    List<_i0zisc0t.SimpleData?>? nullableListWithNullableData,
    List<List<_i0zisc0t.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
    nestedDataListInMap,
    Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithObject',
      if (id != null) 'id': id,
      'data': data.toJson(),
      if (nullableData != null) 'nullableData': nullableData?.toJson(),
      'dataList': dataList.toJson(valueToJson: (v) => v.toJson()),
      if (nullableDataList != null)
        'nullableDataList': nullableDataList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'listWithNullableData': listWithNullableData.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (nullableListWithNullableData != null)
        'nullableListWithNullableData': nullableListWithNullableData?.toJson(
          valueToJson: (v) => v?.toJson(),
        ),
      if (nestedDataList != null)
        'nestedDataList': nestedDataList?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
      if (nestedDataListInMap != null)
        'nestedDataListInMap': nestedDataListInMap?.toJson(
          valueToJson: (v) => v.toJson(
            valueToJson: (v) => v?.toJson(
              valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
            ),
          ),
        ),
      if (nestedDataMap != null)
        'nestedDataMap': nestedDataMap?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithObject',
      if (id != null) 'id': id,
      'data': data.toJsonForProtocol(),
      if (nullableData != null)
        'nullableData': nullableData?.toJsonForProtocol(),
      'dataList': dataList.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nullableDataList != null)
        'nullableDataList': nullableDataList?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'listWithNullableData': listWithNullableData.toJson(
        valueToJson: (v) => v?.toJsonForProtocol(),
      ),
      if (nullableListWithNullableData != null)
        'nullableListWithNullableData': nullableListWithNullableData?.toJson(
          valueToJson: (v) => v?.toJsonForProtocol(),
        ),
      if (nestedDataList != null)
        'nestedDataList': nestedDataList?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
      if (nestedDataListInMap != null)
        'nestedDataListInMap': nestedDataListInMap?.toJson(
          valueToJson: (v) => v.toJson(
            valueToJson: (v) => v?.toJson(
              valueToJson: (v) =>
                  v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
            ),
          ),
        ),
      if (nestedDataMap != null)
        'nestedDataMap': nestedDataMap?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
    };
  }

  static ObjectWithObjectInclude include({
    _is.SelectColumnsBuilder<ObjectWithObjectTable>? select,
  }) {
    return ObjectWithObjectInclude.internal_(
      selectedColumns: select?.call(ObjectWithObject.t),
    );
  }

  static ObjectWithObjectIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    ObjectWithObjectInclude? include,
    _is.SelectColumnsBuilder<ObjectWithObjectTable>? select,
  }) {
    return ObjectWithObjectIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      include: include,
      selectedColumns: select?.call(ObjectWithObject.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithObjectImpl extends ObjectWithObject {
  _ObjectWithObjectImpl({
    int? id,
    required _i0zisc0t.SimpleData data,
    _i0zisc0t.SimpleData? nullableData,
    required List<_i0zisc0t.SimpleData> dataList,
    List<_i0zisc0t.SimpleData>? nullableDataList,
    required List<_i0zisc0t.SimpleData?> listWithNullableData,
    List<_i0zisc0t.SimpleData?>? nullableListWithNullableData,
    List<List<_i0zisc0t.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
    nestedDataListInMap,
    Map<String, Map<int, _i0zisc0t.SimpleData>>? nestedDataMap,
  }) : super._(
         id: id,
         data: data,
         nullableData: nullableData,
         dataList: dataList,
         nullableDataList: nullableDataList,
         listWithNullableData: listWithNullableData,
         nullableListWithNullableData: nullableListWithNullableData,
         nestedDataList: nestedDataList,
         nestedDataListInMap: nestedDataListInMap,
         nestedDataMap: nestedDataMap,
       );

  /// Returns a shallow copy of this [ObjectWithObject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithObject copyWith({
    Object? id = _Undefined,
    _i0zisc0t.SimpleData? data,
    Object? nullableData = _Undefined,
    List<_i0zisc0t.SimpleData>? dataList,
    Object? nullableDataList = _Undefined,
    List<_i0zisc0t.SimpleData?>? listWithNullableData,
    Object? nullableListWithNullableData = _Undefined,
    Object? nestedDataList = _Undefined,
    Object? nestedDataListInMap = _Undefined,
    Object? nestedDataMap = _Undefined,
  }) {
    return ObjectWithObject(
      id: id is int? ? id : this.id,
      data: data ?? this.data.copyWith(),
      nullableData: nullableData is _i0zisc0t.SimpleData?
          ? nullableData
          : this.nullableData?.copyWith(),
      dataList: dataList ?? this.dataList.map((e0) => e0.copyWith()).toList(),
      nullableDataList: nullableDataList is List<_i0zisc0t.SimpleData>?
          ? nullableDataList
          : this.nullableDataList?.map((e0) => e0.copyWith()).toList(),
      listWithNullableData:
          listWithNullableData ??
          this.listWithNullableData.map((e0) => e0?.copyWith()).toList(),
      nullableListWithNullableData:
          nullableListWithNullableData is List<_i0zisc0t.SimpleData?>?
          ? nullableListWithNullableData
          : this.nullableListWithNullableData
                ?.map((e0) => e0?.copyWith())
                .toList(),
      nestedDataList: nestedDataList is List<List<_i0zisc0t.SimpleData>>?
          ? nestedDataList
          : this.nestedDataList
                ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
                .toList(),
      nestedDataListInMap:
          nestedDataListInMap
              is Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
          ? nestedDataListInMap
          : this.nestedDataListInMap?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0
                    .map(
                      (e1) => e1
                          ?.map(
                            (e2) => e2.map(
                              (
                                key3,
                                value3,
                              ) => MapEntry(
                                key3,
                                value3.copyWith(),
                              ),
                            ),
                          )
                          .toList(),
                    )
                    .toList(),
              ),
            ),
      nestedDataMap:
          nestedDataMap is Map<String, Map<int, _i0zisc0t.SimpleData>>?
          ? nestedDataMap
          : this.nestedDataMap?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.map(
                  (
                    key1,
                    value1,
                  ) => MapEntry(
                    key1,
                    value1.copyWith(),
                  ),
                ),
              ),
            ),
    );
  }
}

class ObjectWithObjectUpdateTable
    extends _is.UpdateTable<ObjectWithObjectTable> {
  ObjectWithObjectUpdateTable(super.table);

  _is.ColumnValue<_i0zisc0t.SimpleData, _i0zisc0t.SimpleData> data(
    _i0zisc0t.SimpleData value,
  ) => _is.ColumnValue(
    table.data,
    value,
  );

  _is.ColumnValue<_i0zisc0t.SimpleData, _i0zisc0t.SimpleData> nullableData(
    _i0zisc0t.SimpleData? value,
  ) => _is.ColumnValue(
    table.nullableData,
    value,
  );

  _is.ColumnValue<List<_i0zisc0t.SimpleData>, List<_i0zisc0t.SimpleData>>
  dataList(List<_i0zisc0t.SimpleData> value) => _is.ColumnValue(
    table.dataList,
    value,
  );

  _is.ColumnValue<List<_i0zisc0t.SimpleData>, List<_i0zisc0t.SimpleData>>
  nullableDataList(List<_i0zisc0t.SimpleData>? value) => _is.ColumnValue(
    table.nullableDataList,
    value,
  );

  _is.ColumnValue<List<_i0zisc0t.SimpleData?>, List<_i0zisc0t.SimpleData?>>
  listWithNullableData(List<_i0zisc0t.SimpleData?> value) => _is.ColumnValue(
    table.listWithNullableData,
    value,
  );

  _is.ColumnValue<List<_i0zisc0t.SimpleData?>, List<_i0zisc0t.SimpleData?>>
  nullableListWithNullableData(List<_i0zisc0t.SimpleData?>? value) =>
      _is.ColumnValue(
        table.nullableListWithNullableData,
        value,
      );

  _is.ColumnValue<
    List<List<_i0zisc0t.SimpleData>>,
    List<List<_i0zisc0t.SimpleData>>
  >
  nestedDataList(List<List<_i0zisc0t.SimpleData>>? value) => _is.ColumnValue(
    table.nestedDataList,
    value,
  );

  _is.ColumnValue<
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>,
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>
  >
  nestedDataListInMap(
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>? value,
  ) => _is.ColumnValue(
    table.nestedDataListInMap,
    value,
  );

  _is.ColumnValue<
    Map<String, Map<int, _i0zisc0t.SimpleData>>,
    Map<String, Map<int, _i0zisc0t.SimpleData>>
  >
  nestedDataMap(Map<String, Map<int, _i0zisc0t.SimpleData>>? value) =>
      _is.ColumnValue(
        table.nestedDataMap,
        value,
      );
}

class ObjectWithObjectTable extends _is.Table<int?> {
  ObjectWithObjectTable({super.tableRelation})
    : super(tableName: 'object_with_object') {
    updateTable = ObjectWithObjectUpdateTable(this);
    data = _is.ColumnSerializable<_i0zisc0t.SimpleData>(
      'data',
      this,
    );
    nullableData = _is.ColumnSerializable<_i0zisc0t.SimpleData>(
      'nullableData',
      this,
    );
    dataList = _is.ColumnSerializable<List<_i0zisc0t.SimpleData>>(
      'dataList',
      this,
    );
    nullableDataList = _is.ColumnSerializable<List<_i0zisc0t.SimpleData>>(
      'nullableDataList',
      this,
    );
    listWithNullableData = _is.ColumnSerializable<List<_i0zisc0t.SimpleData?>>(
      'listWithNullableData',
      this,
    );
    nullableListWithNullableData =
        _is.ColumnSerializable<List<_i0zisc0t.SimpleData?>>(
          'nullableListWithNullableData',
          this,
        );
    nestedDataList = _is.ColumnSerializable<List<List<_i0zisc0t.SimpleData>>>(
      'nestedDataList',
      this,
    );
    nestedDataListInMap =
        _is.ColumnSerializable<
          Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>
        >(
          'nestedDataListInMap',
          this,
        );
    nestedDataMap =
        _is.ColumnSerializable<Map<String, Map<int, _i0zisc0t.SimpleData>>>(
          'nestedDataMap',
          this,
        );
  }

  late final ObjectWithObjectUpdateTable updateTable;

  late final _is.ColumnSerializable<_i0zisc0t.SimpleData> data;

  late final _is.ColumnSerializable<_i0zisc0t.SimpleData> nullableData;

  late final _is.ColumnSerializable<List<_i0zisc0t.SimpleData>> dataList;

  late final _is.ColumnSerializable<List<_i0zisc0t.SimpleData>>
  nullableDataList;

  late final _is.ColumnSerializable<List<_i0zisc0t.SimpleData?>>
  listWithNullableData;

  late final _is.ColumnSerializable<List<_i0zisc0t.SimpleData?>>
  nullableListWithNullableData;

  late final _is.ColumnSerializable<List<List<_i0zisc0t.SimpleData>>>
  nestedDataList;

  late final _is.ColumnSerializable<
    Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>
  >
  nestedDataListInMap;

  late final _is.ColumnSerializable<Map<String, Map<int, _i0zisc0t.SimpleData>>>
  nestedDataMap;

  @override
  List<_is.Column> get columns => [
    id,
    data,
    nullableData,
    dataList,
    nullableDataList,
    listWithNullableData,
    nullableListWithNullableData,
    nestedDataList,
    nestedDataListInMap,
    nestedDataMap,
  ];
}

class ObjectWithObjectInclude extends _is.IncludeObject {
  ObjectWithObjectInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithObject.t;
}

class ObjectWithObjectIncludeList extends _is.IncludeList {
  ObjectWithObjectIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithObject.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithObject.t;
}

class ObjectWithObjectRepository {
  const ObjectWithObjectRepository._();

  /// Returns a list of [ObjectWithObject]s matching the given query parameters.
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
  Future<List<ObjectWithObject>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithObject] matching the given query parameters.
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
  Future<ObjectWithObject?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithObject] by its [id] or null if no such row exists.
  Future<ObjectWithObject?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithObject>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithObject]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithObject]s will have their `id` fields set.
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
  Future<List<ObjectWithObject>> insert(
    _is.DatabaseSession session,
    List<ObjectWithObject> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithObject>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithObject] and returns the inserted row.
  ///
  /// The returned [ObjectWithObject] will have its `id` field set.
  Future<ObjectWithObject> insertRow(
    _is.DatabaseSession session,
    ObjectWithObject row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithObject>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithObject]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithObject]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithObject>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithObject> rows, {
    required _is.ColumnSelections<ObjectWithObjectTable> conflictColumns,
    _is.ColumnSelections<ObjectWithObjectTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithObjectTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithObject>(
      rows,
      conflictColumns: conflictColumns(ObjectWithObject.t),
      updateColumns: updateColumns?.call(ObjectWithObject.t),
      updateWhere: updateWhere?.call(ObjectWithObject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithObject] and returns the resulting row.
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
  /// The returned [ObjectWithObject] will have its `id` field set.
  Future<ObjectWithObject?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithObject row, {
    required _is.ColumnSelections<ObjectWithObjectTable> conflictColumns,
    _is.ColumnSelections<ObjectWithObjectTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithObjectTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithObject>(
      row,
      conflictColumns: conflictColumns(ObjectWithObject.t),
      updateColumns: updateColumns?.call(ObjectWithObject.t),
      updateWhere: updateWhere?.call(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithObject]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithObject>> update(
    _is.DatabaseSession session,
    List<ObjectWithObject> rows, {
    _is.ColumnSelections<ObjectWithObjectTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithObject>(
      rows,
      columns: columns?.call(ObjectWithObject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithObject]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithObject> updateRow(
    _is.DatabaseSession session,
    ObjectWithObject row, {
    _is.ColumnSelections<ObjectWithObjectTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithObject>(
      row,
      columns: columns?.call(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithObject] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithObject?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithObjectUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithObject>(
      id,
      columnValues: columnValues(ObjectWithObject.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithObject]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithObject>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithObjectUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithObjectTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithObject>(
      columnValues: columnValues(ObjectWithObject.t.updateTable),
      where: where(ObjectWithObject.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithObject]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithObject>> delete(
    _is.DatabaseSession session,
    List<ObjectWithObject> rows, {
    _is.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithObject>(
      rows,
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithObject].
  Future<ObjectWithObject> deleteRow(
    _is.DatabaseSession session,
    ObjectWithObject row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithObject>(
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
  Future<List<ObjectWithObject>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithObjectTable> where,
    _is.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithObject>(
      where: where(ObjectWithObject.t),
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithObject] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithObjectTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithObject>(
      where: where(ObjectWithObject.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
