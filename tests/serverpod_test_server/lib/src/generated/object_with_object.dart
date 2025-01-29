/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'simple_data.dart' as _i2;

abstract class ObjectWithObject
    implements _i1.TableRow, _i1.ProtocolSerialization {
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
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
    List<List<_i2.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap,
    Map<String, Map<int, _i2.SimpleData>>? nestedDataMap,
  }) = _ObjectWithObjectImpl;

  factory ObjectWithObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithObject(
      id: jsonSerialization['id'] as int?,
      data: _i2.SimpleData.fromJson(
          (jsonSerialization['data'] as Map<String, dynamic>)),
      nullableData: jsonSerialization['nullableData'] == null
          ? null
          : _i2.SimpleData.fromJson(
              (jsonSerialization['nullableData'] as Map<String, dynamic>)),
      dataList: (jsonSerialization['dataList'] as List)
          .map((e) => _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      nullableDataList: (jsonSerialization['nullableDataList'] as List?)
          ?.map((e) => _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      listWithNullableData: (jsonSerialization['listWithNullableData'] as List)
          .map((e) => e == null
              ? null
              : _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
          .toList(),
      nullableListWithNullableData:
          (jsonSerialization['nullableListWithNullableData'] as List?)
              ?.map((e) => e == null
                  ? null
                  : _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
              .toList(),
      nestedDataList: (jsonSerialization['nestedDataList'] as List?)
          ?.map((e) => (e as List)
              .map((e) => _i2.SimpleData.fromJson((e as Map<String, dynamic>)))
              .toList())
          .toList(),
      nestedDataListInMap: (jsonSerialization['nestedDataListInMap'] as Map?)
          ?.map((k, v) => MapEntry(
                k as String,
                (v as List)
                    .map((e) => (e as List?)
                        ?.map((e) => (e as List).fold<Map<int, _i2.SimpleData>>(
                            {},
                            (t, e) => {
                                  ...t,
                                  e['k'] as int: _i2.SimpleData.fromJson(
                                      (e['v'] as Map<String, dynamic>))
                                }))
                        .toList())
                    .toList(),
              )),
      nestedDataMap:
          (jsonSerialization['nestedDataMap'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                (v as List).fold<Map<int, _i2.SimpleData>>(
                    {},
                    (t, e) => {
                          ...t,
                          e['k'] as int: _i2.SimpleData.fromJson(
                              (e['v'] as Map<String, dynamic>))
                        }),
              )),
    );
  }

  static final t = ObjectWithObjectTable();

  static const db = ObjectWithObjectRepository._();

  @override
  int? id;

  _i2.SimpleData data;

  _i2.SimpleData? nullableData;

  List<_i2.SimpleData> dataList;

  List<_i2.SimpleData>? nullableDataList;

  List<_i2.SimpleData?> listWithNullableData;

  List<_i2.SimpleData?>? nullableListWithNullableData;

  List<List<_i2.SimpleData>>? nestedDataList;

  Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap;

  Map<String, Map<int, _i2.SimpleData>>? nestedDataMap;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ObjectWithObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithObject copyWith({
    int? id,
    _i2.SimpleData? data,
    _i2.SimpleData? nullableData,
    List<_i2.SimpleData>? dataList,
    List<_i2.SimpleData>? nullableDataList,
    List<_i2.SimpleData?>? listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
    List<List<_i2.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap,
    Map<String, Map<int, _i2.SimpleData>>? nestedDataMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'data': data.toJson(),
      if (nullableData != null) 'nullableData': nullableData?.toJson(),
      'dataList': dataList.toJson(valueToJson: (v) => v.toJson()),
      if (nullableDataList != null)
        'nullableDataList':
            nullableDataList?.toJson(valueToJson: (v) => v.toJson()),
      'listWithNullableData':
          listWithNullableData.toJson(valueToJson: (v) => v?.toJson()),
      if (nullableListWithNullableData != null)
        'nullableListWithNullableData': nullableListWithNullableData?.toJson(
            valueToJson: (v) => v?.toJson()),
      if (nestedDataList != null)
        'nestedDataList': nestedDataList?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
      if (nestedDataListInMap != null)
        'nestedDataListInMap': nestedDataListInMap?.toJson(
            valueToJson: (v) => v.toJson(
                valueToJson: (v) => v?.toJson(
                    valueToJson: (v) =>
                        v.toJson(valueToJson: (v) => v.toJson())))),
      if (nestedDataMap != null)
        'nestedDataMap': nestedDataMap?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'data': data.toJsonForProtocol(),
      if (nullableData != null)
        'nullableData': nullableData?.toJsonForProtocol(),
      'dataList': dataList.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nullableDataList != null)
        'nullableDataList':
            nullableDataList?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'listWithNullableData': listWithNullableData.toJson(
          valueToJson: (v) => v?.toJsonForProtocol()),
      if (nullableListWithNullableData != null)
        'nullableListWithNullableData': nullableListWithNullableData?.toJson(
            valueToJson: (v) => v?.toJsonForProtocol()),
      if (nestedDataList != null)
        'nestedDataList': nestedDataList?.toJson(
            valueToJson: (v) =>
                v.toJson(valueToJson: (v) => v.toJsonForProtocol())),
      if (nestedDataListInMap != null)
        'nestedDataListInMap': nestedDataListInMap?.toJson(
            valueToJson: (v) => v.toJson(
                valueToJson: (v) => v?.toJson(
                    valueToJson: (v) =>
                        v.toJson(valueToJson: (v) => v.toJsonForProtocol())))),
      if (nestedDataMap != null)
        'nestedDataMap': nestedDataMap?.toJson(
            valueToJson: (v) =>
                v.toJson(valueToJson: (v) => v.toJsonForProtocol())),
    };
  }

  static ObjectWithObjectInclude include() {
    return ObjectWithObjectInclude._();
  }

  static ObjectWithObjectIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    ObjectWithObjectInclude? include,
  }) {
    return ObjectWithObjectIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithObject.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithObjectImpl extends ObjectWithObject {
  _ObjectWithObjectImpl({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
    List<List<_i2.SimpleData>>? nestedDataList,
    Map<String, List<List<Map<int, _i2.SimpleData>>?>>? nestedDataListInMap,
    Map<String, Map<int, _i2.SimpleData>>? nestedDataMap,
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
  @_i1.useResult
  @override
  ObjectWithObject copyWith({
    Object? id = _Undefined,
    _i2.SimpleData? data,
    Object? nullableData = _Undefined,
    List<_i2.SimpleData>? dataList,
    Object? nullableDataList = _Undefined,
    List<_i2.SimpleData?>? listWithNullableData,
    Object? nullableListWithNullableData = _Undefined,
    Object? nestedDataList = _Undefined,
    Object? nestedDataListInMap = _Undefined,
    Object? nestedDataMap = _Undefined,
  }) {
    return ObjectWithObject(
      id: id is int? ? id : this.id,
      data: data ?? this.data.copyWith(),
      nullableData: nullableData is _i2.SimpleData?
          ? nullableData
          : this.nullableData?.copyWith(),
      dataList: dataList ?? this.dataList.map((e0) => e0.copyWith()).toList(),
      nullableDataList: nullableDataList is List<_i2.SimpleData>?
          ? nullableDataList
          : this.nullableDataList?.map((e0) => e0.copyWith()).toList(),
      listWithNullableData: listWithNullableData ??
          this.listWithNullableData.map((e0) => e0?.copyWith()).toList(),
      nullableListWithNullableData:
          nullableListWithNullableData is List<_i2.SimpleData?>?
              ? nullableListWithNullableData
              : this
                  .nullableListWithNullableData
                  ?.map((e0) => e0?.copyWith())
                  .toList(),
      nestedDataList: nestedDataList is List<List<_i2.SimpleData>>?
          ? nestedDataList
          : this
              .nestedDataList
              ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
              .toList(),
      nestedDataListInMap: nestedDataListInMap
              is Map<String, List<List<Map<int, _i2.SimpleData>>?>>?
          ? nestedDataListInMap
          : this.nestedDataListInMap?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0
                        .map((e1) => e1
                            ?.map((e2) => e2.map((
                                  key3,
                                  value3,
                                ) =>
                                    MapEntry(
                                      key3,
                                      value3.copyWith(),
                                    )))
                            .toList())
                        .toList(),
                  )),
      nestedDataMap: nestedDataMap is Map<String, Map<int, _i2.SimpleData>>?
          ? nestedDataMap
          : this.nestedDataMap?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.map((
                      key1,
                      value1,
                    ) =>
                        MapEntry(
                          key1,
                          value1.copyWith(),
                        )),
                  )),
    );
  }
}

class ObjectWithObjectTable extends _i1.Table {
  ObjectWithObjectTable({super.tableRelation})
      : super(tableName: 'object_with_object') {
    data = _i1.ColumnSerializable(
      'data',
      this,
    );
    nullableData = _i1.ColumnSerializable(
      'nullableData',
      this,
    );
    dataList = _i1.ColumnSerializable(
      'dataList',
      this,
    );
    nullableDataList = _i1.ColumnSerializable(
      'nullableDataList',
      this,
    );
    listWithNullableData = _i1.ColumnSerializable(
      'listWithNullableData',
      this,
    );
    nullableListWithNullableData = _i1.ColumnSerializable(
      'nullableListWithNullableData',
      this,
    );
    nestedDataList = _i1.ColumnSerializable(
      'nestedDataList',
      this,
    );
    nestedDataListInMap = _i1.ColumnSerializable(
      'nestedDataListInMap',
      this,
    );
    nestedDataMap = _i1.ColumnSerializable(
      'nestedDataMap',
      this,
    );
  }

  late final _i1.ColumnSerializable data;

  late final _i1.ColumnSerializable nullableData;

  late final _i1.ColumnSerializable dataList;

  late final _i1.ColumnSerializable nullableDataList;

  late final _i1.ColumnSerializable listWithNullableData;

  late final _i1.ColumnSerializable nullableListWithNullableData;

  late final _i1.ColumnSerializable nestedDataList;

  late final _i1.ColumnSerializable nestedDataListInMap;

  late final _i1.ColumnSerializable nestedDataMap;

  @override
  List<_i1.Column> get columns => [
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

class ObjectWithObjectInclude extends _i1.IncludeObject {
  ObjectWithObjectInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithObject.t;
}

class ObjectWithObjectIncludeList extends _i1.IncludeList {
  ObjectWithObjectIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithObject.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithObject.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithObjectTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithObjectTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      orderBy: orderBy?.call(ObjectWithObject.t),
      orderByList: orderByList?.call(ObjectWithObject.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithObject] by its [id] or null if no such row exists.
  Future<ObjectWithObject?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithObject>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithObject]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithObject]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithObject>> insert(
    _i1.Session session,
    List<ObjectWithObject> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithObject>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithObject] and returns the inserted row.
  ///
  /// The returned [ObjectWithObject] will have its `id` field set.
  Future<ObjectWithObject> insertRow(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithObject>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithObject]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithObject>> update(
    _i1.Session session,
    List<ObjectWithObject> rows, {
    _i1.ColumnSelections<ObjectWithObjectTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithObject>(
      rows,
      columns: columns?.call(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithObject]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithObject> updateRow(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.ColumnSelections<ObjectWithObjectTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithObject>(
      row,
      columns: columns?.call(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithObject]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithObject>> delete(
    _i1.Session session,
    List<ObjectWithObject> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithObject>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithObject].
  Future<ObjectWithObject> deleteRow(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithObject>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithObject>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithObjectTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithObject>(
      where: where(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithObjectTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithObject>(
      where: where?.call(ObjectWithObject.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
