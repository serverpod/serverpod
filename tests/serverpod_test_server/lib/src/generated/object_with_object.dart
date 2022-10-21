/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class ObjectWithObject extends _i1.TableRow {
  ObjectWithObject({
    int? id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
  }) : super(id);

  factory ObjectWithObject.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithObject(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      data: serializationManager
          .deserializeJson<_i2.SimpleData>(jsonSerialization['data']),
      nullableData: serializationManager
          .deserializeJson<_i2.SimpleData?>(jsonSerialization['nullableData']),
      dataList: serializationManager
          .deserializeJson<List<_i2.SimpleData>>(jsonSerialization['dataList']),
      nullableDataList:
          serializationManager.deserializeJson<List<_i2.SimpleData>?>(
              jsonSerialization['nullableDataList']),
      listWithNullableData:
          serializationManager.deserializeJson<List<_i2.SimpleData?>>(
              jsonSerialization['listWithNullableData']),
      nullableListWithNullableData:
          serializationManager.deserializeJson<List<_i2.SimpleData?>?>(
              jsonSerialization['nullableListWithNullableData']),
    );
  }

  static final t = ObjectWithObjectTable();

  _i2.SimpleData data;

  _i2.SimpleData? nullableData;

  List<_i2.SimpleData> dataList;

  List<_i2.SimpleData>? nullableDataList;

  List<_i2.SimpleData?> listWithNullableData;

  List<_i2.SimpleData?>? nullableListWithNullableData;

  @override
  String get className => 'ObjectWithObject';
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

  @override
  Map<String, dynamic> allToJson() {
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
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'data':
        data = value;
        return;
      case 'nullableData':
        nullableData = value;
        return;
      case 'dataList':
        dataList = value;
        return;
      case 'nullableDataList':
        nullableDataList = value;
        return;
      case 'listWithNullableData':
        listWithNullableData = value;
        return;
      case 'nullableListWithNullableData':
        nullableListWithNullableData = value;
        return;
      default:
        throw UnimplementedError();
    }
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

  static Future<void> insert(
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
}

typedef ObjectWithObjectExpressionBuilder = _i1.Expression Function(
    ObjectWithObjectTable);

class ObjectWithObjectTable extends _i1.Table {
  ObjectWithObjectTable() : super(tableName: 'object_with_object');

  final id = _i1.ColumnInt('id');

  final data = _i1.ColumnSerializable('data');

  final nullableData = _i1.ColumnSerializable('nullableData');

  final dataList = _i1.ColumnSerializable('dataList');

  final nullableDataList = _i1.ColumnSerializable('nullableDataList');

  final listWithNullableData = _i1.ColumnSerializable('listWithNullableData');

  final nullableListWithNullableData =
      _i1.ColumnSerializable('nullableListWithNullableData');

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
ObjectWithObjectTable tObjectWithObject = ObjectWithObjectTable();
