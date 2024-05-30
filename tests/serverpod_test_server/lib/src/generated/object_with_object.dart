/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class ObjectWithObject extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  ObjectWithObject._({
    int? id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
  }) : super(id);

  factory ObjectWithObject({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
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
    );
  }

  static final t = ObjectWithObjectTable();

  static const db = ObjectWithObjectRepository._();

  _i2.SimpleData data;

  _i2.SimpleData? nullableData;

  List<_i2.SimpleData> dataList;

  List<_i2.SimpleData>? nullableDataList;

  List<_i2.SimpleData?> listWithNullableData;

  List<_i2.SimpleData?>? nullableListWithNullableData;

  @override
  _i1.Table get table => t;

  ObjectWithObject copyWith({
    int? id,
    _i2.SimpleData? data,
    _i2.SimpleData? nullableData,
    List<_i2.SimpleData>? dataList,
    List<_i2.SimpleData>? nullableDataList,
    List<_i2.SimpleData?>? listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
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
  }) : super._(
          id: id,
          data: data,
          nullableData: nullableData,
          dataList: dataList,
          nullableDataList: nullableDataList,
          listWithNullableData: listWithNullableData,
          nullableListWithNullableData: nullableListWithNullableData,
        );

  @override
  ObjectWithObject copyWith({
    Object? id = _Undefined,
    _i2.SimpleData? data,
    Object? nullableData = _Undefined,
    List<_i2.SimpleData>? dataList,
    Object? nullableDataList = _Undefined,
    List<_i2.SimpleData?>? listWithNullableData,
    Object? nullableListWithNullableData = _Undefined,
  }) {
    return ObjectWithObject(
      id: id is int? ? id : this.id,
      data: data ?? this.data.copyWith(),
      nullableData: nullableData is _i2.SimpleData?
          ? nullableData
          : this.nullableData?.copyWith(),
      dataList: dataList ?? this.dataList.clone(),
      nullableDataList: nullableDataList is List<_i2.SimpleData>?
          ? nullableDataList
          : this.nullableDataList?.clone(),
      listWithNullableData:
          listWithNullableData ?? this.listWithNullableData.clone(),
      nullableListWithNullableData:
          nullableListWithNullableData is List<_i2.SimpleData?>?
              ? nullableListWithNullableData
              : this.nullableListWithNullableData?.clone(),
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
  }

  late final _i1.ColumnSerializable data;

  late final _i1.ColumnSerializable nullableData;

  late final _i1.ColumnSerializable dataList;

  late final _i1.ColumnSerializable nullableDataList;

  late final _i1.ColumnSerializable listWithNullableData;

  late final _i1.ColumnSerializable nullableListWithNullableData;

  @override
  List<_i1.Column> get columns => [
        id,
        data,
        nullableData,
        dataList,
        nullableDataList,
        listWithNullableData,
        nullableListWithNullableData,
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
