/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class ObjectWithObject extends TableRow {
  @override
  String get className => 'ObjectWithObject';
  @override
  String get tableName => 'object_with_object';

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
    nullableData = _data['nullableData'] != null ? SimpleData?.fromSerialization(_data['nullableData']) : null;
    dataList = _data['dataList']!.map<SimpleData>((a) => SimpleData.fromSerialization(a))?.toList();
    nullableDataList = _data['nullableDataList']?.map<SimpleData>((a) => SimpleData.fromSerialization(a))?.toList();
    listWithNullableData = _data['listWithNullableData']!.map<SimpleData?>((a) => a != null ? SimpleData?.fromSerialization(a) : null)?.toList();
    nullableListWithNullableData = _data['nullableListWithNullableData']?.map<SimpleData?>((a) => a != null ? SimpleData?.fromSerialization(a) : null)?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'data': data.serialize(),
      'nullableData': nullableData?.serialize(),
      'dataList': dataList.map((SimpleData a) => a.serialize()).toList(),
      'nullableDataList': nullableDataList?.map((SimpleData a) => a.serialize()).toList(),
      'listWithNullableData': listWithNullableData.map((SimpleData? a) => a?.serialize()).toList(),
      'nullableListWithNullableData': nullableListWithNullableData?.map((SimpleData? a) => a?.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'data': data.serialize(),
      'nullableData': nullableData?.serialize(),
      'dataList': dataList.map((SimpleData a) => a.serialize()).toList(),
      'nullableDataList': nullableDataList?.map((SimpleData a) => a.serialize()).toList(),
      'listWithNullableData': listWithNullableData.map((SimpleData? a) => a?.serialize()).toList(),
      'nullableListWithNullableData': nullableListWithNullableData?.map((SimpleData? a) => a?.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'data': data.serialize(),
      'nullableData': nullableData?.serialize(),
      'dataList': dataList.map((SimpleData a) => a.serialize()).toList(),
      'nullableDataList': nullableDataList?.map((SimpleData a) => a.serialize()).toList(),
      'listWithNullableData': listWithNullableData.map((SimpleData? a) => a?.serialize()).toList(),
      'nullableListWithNullableData': nullableListWithNullableData?.map((SimpleData? a) => a?.serialize()).toList(),
    });
  }
}

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
  final nullableListWithNullableData = ColumnSerializable('nullableListWithNullableData');

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

ObjectWithObjectTable tObjectWithObject = ObjectWithObjectTable();
