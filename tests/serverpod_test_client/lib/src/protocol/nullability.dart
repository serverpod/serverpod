/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class Nullability extends SerializableEntity {
  @override
  String get className => 'Nullability';

  int? id;
  late int anInt;
  int? aNullableInt;
  late double aDouble;
  double? aNullableDouble;
  late bool aBool;
  bool? aNullableBool;
  late String aString;
  String? aNullableString;
  late DateTime aDateTime;
  DateTime? aNullableDateTime;
  late ByteData aByteData;
  ByteData? aNullableByteData;
  late SimpleData anObject;
  SimpleData? aNullableObject;
  late List<int> anIntList;
  List<int>? aNullableIntList;
  late List<int?> aListWithNullableInts;
  List<int?>? aNullableListWithNullableInts;
  late List<SimpleData> anObjectList;
  List<SimpleData>? aNullableObjectList;
  late List<SimpleData?> aListWithNullableObjects;
  List<SimpleData?>? aNullableListWithNullableObjects;
  late List<DateTime> aDateTimeList;
  List<DateTime>? aNullableDateTimeList;
  late List<DateTime?> aListWithNullableDateTimes;
  List<DateTime?>? aNullableListWithNullableDateTimes;
  late List<ByteData> aByteDataList;
  List<ByteData>? aNullableByteDataList;
  late List<ByteData?> aListWithNullableByteDatas;
  List<ByteData?>? aNullableListWithNullableByteDatas;
  late Map<String anIntMap;
  late Map<String aNullableIntMap;
  late Map<String aMapWithNullableInts;
  late Map<String aNullableMapWithNullableInts;

  Nullability({
    this.id,
    required this.anInt,
    this.aNullableInt,
    required this.aDouble,
    this.aNullableDouble,
    required this.aBool,
    this.aNullableBool,
    required this.aString,
    this.aNullableString,
    required this.aDateTime,
    this.aNullableDateTime,
    required this.aByteData,
    this.aNullableByteData,
    required this.anObject,
    this.aNullableObject,
    required this.anIntList,
    this.aNullableIntList,
    required this.aListWithNullableInts,
    this.aNullableListWithNullableInts,
    required this.anObjectList,
    this.aNullableObjectList,
    required this.aListWithNullableObjects,
    this.aNullableListWithNullableObjects,
    required this.aDateTimeList,
    this.aNullableDateTimeList,
    required this.aListWithNullableDateTimes,
    this.aNullableListWithNullableDateTimes,
    required this.aByteDataList,
    this.aNullableByteDataList,
    required this.aListWithNullableByteDatas,
    this.aNullableListWithNullableByteDatas,
    required this.anIntMap,
    required this.aNullableIntMap,
    required this.aMapWithNullableInts,
    required this.aNullableMapWithNullableInts,
});

  Nullability.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt']!;
    aNullableInt = _data['aNullableInt'];
    aDouble = _data['aDouble']!;
    aNullableDouble = _data['aNullableDouble'];
    aBool = _data['aBool']!;
    aNullableBool = _data['aNullableBool'];
    aString = _data['aString']!;
    aNullableString = _data['aNullableString'];
    aDateTime = DateTime.tryParse(_data['aDateTime'])!;
    aNullableDateTime = _data['aNullableDateTime'] != null ? DateTime.tryParse(_data['aNullableDateTime']) : null;
    aByteData = _data['aByteData'] is String ? (_data['aByteData'] as String).base64DecodedByteData()! : ByteData.view((_data['aByteData'] as Uint8List).buffer);
    aNullableByteData = _data['aNullableByteData'] == null ? null : (_data['aNullableByteData'] is String ? (_data['aNullableByteData'] as String).base64DecodedByteData() : ByteData.view((_data['aNullableByteData'] as Uint8List).buffer));
    anObject = SimpleData.fromSerialization(_data['anObject']);
    aNullableObject = _data['aNullableObject'] != null ? SimpleData?.fromSerialization(_data['aNullableObject']) : null;
    anIntList = _data['anIntList']!.cast<int>();
    aNullableIntList = _data['aNullableIntList']?.cast<int>();
    aListWithNullableInts = _data['aListWithNullableInts']!.cast<int?>();
    aNullableListWithNullableInts = _data['aNullableListWithNullableInts']?.cast<int?>();
    anObjectList = _data['anObjectList']!.map<SimpleData>((a) => SimpleData.fromSerialization(a))?.toList();
    aNullableObjectList = _data['aNullableObjectList']?.map<SimpleData>((a) => SimpleData.fromSerialization(a))?.toList();
    aListWithNullableObjects = _data['aListWithNullableObjects']!.map<SimpleData?>((a) => a != null ? SimpleData?.fromSerialization(a) : null)?.toList();
    aNullableListWithNullableObjects = _data['aNullableListWithNullableObjects']?.map<SimpleData?>((a) => a != null ? SimpleData?.fromSerialization(a) : null)?.toList();
    aDateTimeList = _data['aDateTimeList']!.map<DateTime>((a) => DateTime.tryParse(a)!).toList();
    aNullableDateTimeList = _data['aNullableDateTimeList']?.map<DateTime>((a) => DateTime.tryParse(a)!).toList();
    aListWithNullableDateTimes = _data['aListWithNullableDateTimes']!.map<DateTime?>((a) => a != null ? DateTime.tryParse(a) : null).toList();
    aNullableListWithNullableDateTimes = _data['aNullableListWithNullableDateTimes']?.map<DateTime?>((a) => a != null ? DateTime.tryParse(a) : null).toList();
    aByteDataList = _data['aByteDataList']!.map<ByteData>((a) => (a as String).base64DecodedByteData()!).toList();
    aNullableByteDataList = _data['aNullableByteDataList']?.map<ByteData>((a) => (a as String).base64DecodedByteData()!).toList();
    aListWithNullableByteDatas = _data['aListWithNullableByteDatas']!.map<ByteData?>((a) => (a as String?)?.base64DecodedByteData()).toList();
    aNullableListWithNullableByteDatas = _data['aNullableListWithNullableByteDatas']?.map<ByteData?>((a) => (a as String?)?.base64DecodedByteData()).toList();
    anIntMap = Map<String.fromSerialization(_data['anIntMap']);
    aNullableIntMap = Map<String.fromSerialization(_data['aNullableIntMap']);
    aMapWithNullableInts = Map<String.fromSerialization(_data['aMapWithNullableInts']);
    aNullableMapWithNullableInts = Map<String.fromSerialization(_data['aNullableMapWithNullableInts']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aNullableInt': aNullableInt,
      'aDouble': aDouble,
      'aNullableDouble': aNullableDouble,
      'aBool': aBool,
      'aNullableBool': aNullableBool,
      'aString': aString,
      'aNullableString': aNullableString,
      'aDateTime': aDateTime.toUtc().toIso8601String(),
      'aNullableDateTime': aNullableDateTime?.toUtc().toIso8601String(),
      'aByteData': aByteData.base64encodedString(),
      'aNullableByteData': aNullableByteData?.base64encodedString(),
      'anObject': anObject.serialize(),
      'aNullableObject': aNullableObject?.serialize(),
      'anIntList': anIntList,
      'aNullableIntList': aNullableIntList,
      'aListWithNullableInts': aListWithNullableInts,
      'aNullableListWithNullableInts': aNullableListWithNullableInts,
      'anObjectList': anObjectList.map((SimpleData a) => a.serialize()).toList(),
      'aNullableObjectList': aNullableObjectList?.map((SimpleData a) => a.serialize()).toList(),
      'aListWithNullableObjects': aListWithNullableObjects.map((SimpleData? a) => a?.serialize()).toList(),
      'aNullableListWithNullableObjects': aNullableListWithNullableObjects?.map((SimpleData? a) => a?.serialize()).toList(),
      'aDateTimeList': aDateTimeList.map<String>((a) => a.toIso8601String()).toList(),
      'aNullableDateTimeList': aNullableDateTimeList?.map<String>((a) => a.toIso8601String()).toList(),
      'aListWithNullableDateTimes': aListWithNullableDateTimes.map<String?>((a) => a?.toIso8601String()).toList(),
      'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes?.map<String?>((a) => a?.toIso8601String()).toList(),
      'aByteDataList': aByteDataList.map<String>((a) => a.base64encodedString()).toList(),
      'aNullableByteDataList': aNullableByteDataList?.map<String>((a) => a.base64encodedString()).toList(),
      'aListWithNullableByteDatas': aListWithNullableByteDatas.map<String?>((a) => a?.base64encodedString()).toList(),
      'aNullableListWithNullableByteDatas': aNullableListWithNullableByteDatas?.map<String?>((a) => a?.base64encodedString()).toList(),
      'anIntMap': anIntMap.serialize(),
      'aNullableIntMap': aNullableIntMap.serialize(),
      'aMapWithNullableInts': aMapWithNullableInts.serialize(),
      'aNullableMapWithNullableInts': aNullableMapWithNullableInts.serialize(),
    });
  }
}

