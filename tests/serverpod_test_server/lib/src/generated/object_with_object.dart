/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

typedef ObjectWithObjectExpressionBuilder = _i1.Expression Function(
    ObjectWithObjectTable);

abstract class ObjectWithObject extends _i1.TableRow {
  const ObjectWithObject._();

  const factory ObjectWithObject({
    int? id,
    required _i2.SimpleData data,
    _i2.SimpleData? nullableData,
    required List<_i2.SimpleData> dataList,
    List<_i2.SimpleData>? nullableDataList,
    required List<_i2.SimpleData?> listWithNullableData,
    List<_i2.SimpleData?>? nullableListWithNullableData,
  }) = _ObjectWithObject;

  factory ObjectWithObject.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithObject(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      data: serializationManager
          .deserialize<_i2.SimpleData>(jsonSerialization['data']),
      nullableData: serializationManager
          .deserialize<_i2.SimpleData?>(jsonSerialization['nullableData']),
      dataList: serializationManager
          .deserialize<List<_i2.SimpleData>>(jsonSerialization['dataList']),
      nullableDataList: serializationManager.deserialize<List<_i2.SimpleData>?>(
          jsonSerialization['nullableDataList']),
      listWithNullableData:
          serializationManager.deserialize<List<_i2.SimpleData?>>(
              jsonSerialization['listWithNullableData']),
      nullableListWithNullableData:
          serializationManager.deserialize<List<_i2.SimpleData?>?>(
              jsonSerialization['nullableListWithNullableData']),
    );
  }

  static const t = ObjectWithObjectTable();

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
  String get tableName => 'object_with_object';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'data': data,
      'nullableData': nullableData,
      'dataList': dataList,
      'nullableDataList': nullableDataList,
      'listWithNullableData': listWithNullableData,
      'nullableListWithNullableData': nullableListWithNullableData,
    };
  }

  static Future<List<ObjectWithObject>> find(
    _i1.Session session, {
    ObjectWithObjectExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithObject>(
      where: where != null ? where(ObjectWithObject.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithObject?> findSingleRow(
    _i1.Session session, {
    ObjectWithObjectExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithObject>(
      where: where != null ? where(ObjectWithObject.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithObject?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithObject>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithObjectExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithObject>(
      where: where(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<ObjectWithObject> insert(
    _i1.Session session,
    ObjectWithObject row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ObjectWithObjectExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithObject>(
      where: where != null ? where(ObjectWithObject.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  _i2.SimpleData get data;
  _i2.SimpleData? get nullableData;
  List<_i2.SimpleData> get dataList;
  List<_i2.SimpleData>? get nullableDataList;
  List<_i2.SimpleData?> get listWithNullableData;
  List<_i2.SimpleData?>? get nullableListWithNullableData;
}

class _Undefined {}

class _ObjectWithObject extends ObjectWithObject {
  const _ObjectWithObject({
    int? id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
  }) : super._();

  @override
  final _i2.SimpleData data;

  @override
  final _i2.SimpleData? nullableData;

  @override
  final List<_i2.SimpleData> dataList;

  @override
  final List<_i2.SimpleData>? nullableDataList;

  @override
  final List<_i2.SimpleData?> listWithNullableData;

  @override
  final List<_i2.SimpleData?>? nullableListWithNullableData;

  @override
  String get tableName => 'object_with_object';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'nullableData': nullableData,
      'dataList': dataList,
      'nullableDataList': nullableDataList,
      'listWithNullableData': listWithNullableData,
      'nullableListWithNullableData': nullableListWithNullableData,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithObject &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.data,
                  data,
                ) ||
                other.data == data) &&
            (identical(
                  other.nullableData,
                  nullableData,
                ) ||
                other.nullableData == nullableData) &&
            const _i3.DeepCollectionEquality().equals(
              dataList,
              other.dataList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              nullableDataList,
              other.nullableDataList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              listWithNullableData,
              other.listWithNullableData,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              nullableListWithNullableData,
              other.nullableListWithNullableData,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        data,
        nullableData,
        const _i3.DeepCollectionEquality().hash(dataList),
        const _i3.DeepCollectionEquality().hash(nullableDataList),
        const _i3.DeepCollectionEquality().hash(listWithNullableData),
        const _i3.DeepCollectionEquality().hash(nullableListWithNullableData),
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
      id: id == _Undefined ? this.id : (id as int?),
      data: data ?? this.data,
      nullableData: nullableData == _Undefined
          ? this.nullableData
          : (nullableData as _i2.SimpleData?),
      dataList: dataList ?? this.dataList,
      nullableDataList: nullableDataList == _Undefined
          ? this.nullableDataList
          : (nullableDataList as List<_i2.SimpleData>?),
      listWithNullableData: listWithNullableData ?? this.listWithNullableData,
      nullableListWithNullableData: nullableListWithNullableData == _Undefined
          ? this.nullableListWithNullableData
          : (nullableListWithNullableData as List<_i2.SimpleData?>?),
    );
  }
}

class ObjectWithObjectTable extends _i1.Table {
  const ObjectWithObjectTable() : super(tableName: 'object_with_object');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  final data = const _i1.ColumnSerializable('data');

  final nullableData = const _i1.ColumnSerializable('nullableData');

  final dataList = const _i1.ColumnSerializable('dataList');

  final nullableDataList = const _i1.ColumnSerializable('nullableDataList');

  final listWithNullableData =
      const _i1.ColumnSerializable('listWithNullableData');

  final nullableListWithNullableData =
      const _i1.ColumnSerializable('nullableListWithNullableData');

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

@Deprecated('Use ObjectWithObjectTable.t instead.')
ObjectWithObjectTable tObjectWithObject = const ObjectWithObjectTable();
