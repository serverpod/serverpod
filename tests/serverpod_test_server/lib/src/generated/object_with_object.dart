/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ObjectWithObject extends TableRow {
  @override
  String get className => 'ObjectWithObject';
  @override
  String get tableName => 'object_with_object';

  static final t = ObjectWithObjectTable();

  @override
  int? id;
  late SimpleData data;
  SimpleData? nullableData;
  late List<SimpleData> dataList;
  List<SimpleData>? nullableDataList;
  late List<SimpleData?> listWithNullableData;
  List<SimpleData?>? nullableListWithNullableData;

  ObjectWithObject({
    this.id,
    required this.data,
    this.nullableData,
    required this.dataList,
    this.nullableDataList,
    required this.listWithNullableData,
    this.nullableListWithNullableData,
  });

  ObjectWithObject.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    data = SimpleData.fromSerialization(_data['data']);
    nullableData = _data['nullableData'] != null
        ? SimpleData?.fromSerialization(_data['nullableData'])
        : null;
    dataList = _data['dataList']!
        .map<SimpleData>((a) => SimpleData.fromSerialization(a))
        ?.toList();
    nullableDataList = _data['nullableDataList']
        ?.map<SimpleData>((a) => SimpleData.fromSerialization(a))
        ?.toList();
    listWithNullableData = _data['listWithNullableData']!
        .map<SimpleData?>(
            (a) => a != null ? SimpleData?.fromSerialization(a) : null)
        ?.toList();
    nullableListWithNullableData = _data['nullableListWithNullableData']
        ?.map<SimpleData?>(
            (a) => a != null ? SimpleData?.fromSerialization(a) : null)
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'data': data.serialize(),
      'nullableData': nullableData?.serialize(),
      'dataList': dataList.map((SimpleData a) => a.serialize()).toList(),
      'nullableDataList':
          nullableDataList?.map((SimpleData a) => a.serialize()).toList(),
      'listWithNullableData':
          listWithNullableData.map((SimpleData? a) => a?.serialize()).toList(),
      'nullableListWithNullableData': nullableListWithNullableData
          ?.map((SimpleData? a) => a?.serialize())
          .toList(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'data': data.serialize(),
      'nullableData': nullableData?.serialize(),
      'dataList': dataList.map((SimpleData a) => a.serialize()).toList(),
      'nullableDataList':
          nullableDataList?.map((SimpleData a) => a.serialize()).toList(),
      'listWithNullableData':
          listWithNullableData.map((SimpleData? a) => a?.serialize()).toList(),
      'nullableListWithNullableData': nullableListWithNullableData
          ?.map((SimpleData? a) => a?.serialize())
          .toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'data': data.serialize(),
      'nullableData': nullableData?.serialize(),
      'dataList': dataList.map((SimpleData a) => a.serialize()).toList(),
      'nullableDataList':
          nullableDataList?.map((SimpleData a) => a.serialize()).toList(),
      'listWithNullableData':
          listWithNullableData.map((SimpleData? a) => a?.serialize()).toList(),
      'nullableListWithNullableData': nullableListWithNullableData
          ?.map((SimpleData? a) => a?.serialize())
          .toList(),
    });
  }

  @override
  void setColumn(String columnName, value) {
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
    Session session, {
    ObjectWithObjectExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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
    Session session, {
    ObjectWithObjectExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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

  static Future<ObjectWithObject?> findById(Session session, int id) async {
    return session.db.findById<ObjectWithObject>(id);
  }

  static Future<int> delete(
    Session session, {
    required ObjectWithObjectExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithObject>(
      where: where(ObjectWithObject.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ObjectWithObject row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ObjectWithObject row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ObjectWithObject row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ObjectWithObjectExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithObject>(
      where: where != null ? where(ObjectWithObject.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ObjectWithObjectExpressionBuilder = Expression Function(
    ObjectWithObjectTable t);

class ObjectWithObjectTable extends Table {
  ObjectWithObjectTable() : super(tableName: 'object_with_object');

  @override
  String tableName = 'object_with_object';
  final id = ColumnInt('id');
  final data = ColumnSerializable('data');
  final nullableData = ColumnSerializable('nullableData');
  final dataList = ColumnSerializable('dataList');
  final nullableDataList = ColumnSerializable('nullableDataList');
  final listWithNullableData = ColumnSerializable('listWithNullableData');
  final nullableListWithNullableData =
      ColumnSerializable('nullableListWithNullableData');

  @override
  List<Column> get columns => [
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
