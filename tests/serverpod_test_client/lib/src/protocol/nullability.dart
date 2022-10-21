/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;

class Nullability extends _i1.SerializableEntity {
  Nullability({
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
    this.aNullableIntMap,
    required this.aMapWithNullableInts,
    this.aNullableMapWithNullableInts,
  });

  factory Nullability.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Nullability(
      anInt:
          serializationManager.deserializeJson<int>(jsonSerialization['anInt']),
      aNullableInt: serializationManager
          .deserializeJson<int?>(jsonSerialization['aNullableInt']),
      aDouble: serializationManager
          .deserializeJson<double>(jsonSerialization['aDouble']),
      aNullableDouble: serializationManager
          .deserializeJson<double?>(jsonSerialization['aNullableDouble']),
      aBool: serializationManager
          .deserializeJson<bool>(jsonSerialization['aBool']),
      aNullableBool: serializationManager
          .deserializeJson<bool?>(jsonSerialization['aNullableBool']),
      aString: serializationManager
          .deserializeJson<String>(jsonSerialization['aString']),
      aNullableString: serializationManager
          .deserializeJson<String?>(jsonSerialization['aNullableString']),
      aDateTime: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['aDateTime']),
      aNullableDateTime: serializationManager
          .deserializeJson<DateTime?>(jsonSerialization['aNullableDateTime']),
      aByteData: serializationManager
          .deserializeJson<_i2.ByteData>(jsonSerialization['aByteData']),
      aNullableByteData: serializationManager.deserializeJson<_i2.ByteData?>(
          jsonSerialization['aNullableByteData']),
      anObject: serializationManager
          .deserializeJson<_i3.SimpleData>(jsonSerialization['anObject']),
      aNullableObject: serializationManager.deserializeJson<_i3.SimpleData?>(
          jsonSerialization['aNullableObject']),
      anIntList: serializationManager
          .deserializeJson<List<int>>(jsonSerialization['anIntList']),
      aNullableIntList: serializationManager
          .deserializeJson<List<int>?>(jsonSerialization['aNullableIntList']),
      aListWithNullableInts: serializationManager.deserializeJson<List<int?>>(
          jsonSerialization['aListWithNullableInts']),
      aNullableListWithNullableInts:
          serializationManager.deserializeJson<List<int?>?>(
              jsonSerialization['aNullableListWithNullableInts']),
      anObjectList: serializationManager.deserializeJson<List<_i3.SimpleData>>(
          jsonSerialization['anObjectList']),
      aNullableObjectList:
          serializationManager.deserializeJson<List<_i3.SimpleData>?>(
              jsonSerialization['aNullableObjectList']),
      aListWithNullableObjects:
          serializationManager.deserializeJson<List<_i3.SimpleData?>>(
              jsonSerialization['aListWithNullableObjects']),
      aNullableListWithNullableObjects:
          serializationManager.deserializeJson<List<_i3.SimpleData?>?>(
              jsonSerialization['aNullableListWithNullableObjects']),
      aDateTimeList: serializationManager
          .deserializeJson<List<DateTime>>(jsonSerialization['aDateTimeList']),
      aNullableDateTimeList:
          serializationManager.deserializeJson<List<DateTime>?>(
              jsonSerialization['aNullableDateTimeList']),
      aListWithNullableDateTimes:
          serializationManager.deserializeJson<List<DateTime?>>(
              jsonSerialization['aListWithNullableDateTimes']),
      aNullableListWithNullableDateTimes:
          serializationManager.deserializeJson<List<DateTime?>?>(
              jsonSerialization['aNullableListWithNullableDateTimes']),
      aByteDataList: serializationManager.deserializeJson<List<_i2.ByteData>>(
          jsonSerialization['aByteDataList']),
      aNullableByteDataList:
          serializationManager.deserializeJson<List<_i2.ByteData>?>(
              jsonSerialization['aNullableByteDataList']),
      aListWithNullableByteDatas:
          serializationManager.deserializeJson<List<_i2.ByteData?>>(
              jsonSerialization['aListWithNullableByteDatas']),
      aNullableListWithNullableByteDatas:
          serializationManager.deserializeJson<List<_i2.ByteData?>?>(
              jsonSerialization['aNullableListWithNullableByteDatas']),
      anIntMap: serializationManager
          .deserializeJson<Map<String, int>>(jsonSerialization['anIntMap']),
      aNullableIntMap: serializationManager.deserializeJson<Map<String, int>?>(
          jsonSerialization['aNullableIntMap']),
      aMapWithNullableInts:
          serializationManager.deserializeJson<Map<String, int?>>(
              jsonSerialization['aMapWithNullableInts']),
      aNullableMapWithNullableInts:
          serializationManager.deserializeJson<Map<String, int?>?>(
              jsonSerialization['aNullableMapWithNullableInts']),
    );
  }

  int anInt;

  int? aNullableInt;

  double aDouble;

  double? aNullableDouble;

  bool aBool;

  bool? aNullableBool;

  String aString;

  String? aNullableString;

  DateTime aDateTime;

  DateTime? aNullableDateTime;

  _i2.ByteData aByteData;

  _i2.ByteData? aNullableByteData;

  _i3.SimpleData anObject;

  _i3.SimpleData? aNullableObject;

  List<int> anIntList;

  List<int>? aNullableIntList;

  List<int?> aListWithNullableInts;

  List<int?>? aNullableListWithNullableInts;

  List<_i3.SimpleData> anObjectList;

  List<_i3.SimpleData>? aNullableObjectList;

  List<_i3.SimpleData?> aListWithNullableObjects;

  List<_i3.SimpleData?>? aNullableListWithNullableObjects;

  List<DateTime> aDateTimeList;

  List<DateTime>? aNullableDateTimeList;

  List<DateTime?> aListWithNullableDateTimes;

  List<DateTime?>? aNullableListWithNullableDateTimes;

  List<_i2.ByteData> aByteDataList;

  List<_i2.ByteData>? aNullableByteDataList;

  List<_i2.ByteData?> aListWithNullableByteDatas;

  List<_i2.ByteData?>? aNullableListWithNullableByteDatas;

  Map<String, int> anIntMap;

  Map<String, int>? aNullableIntMap;

  Map<String, int?> aMapWithNullableInts;

  Map<String, int?>? aNullableMapWithNullableInts;

  @override
  String get className => 'Nullability';
  @override
  Map<String, dynamic> toJson() {
    return {
      'anInt': anInt,
      'aNullableInt': aNullableInt,
      'aDouble': aDouble,
      'aNullableDouble': aNullableDouble,
      'aBool': aBool,
      'aNullableBool': aNullableBool,
      'aString': aString,
      'aNullableString': aNullableString,
      'aDateTime': aDateTime,
      'aNullableDateTime': aNullableDateTime,
      'aByteData': aByteData,
      'aNullableByteData': aNullableByteData,
      'anObject': anObject,
      'aNullableObject': aNullableObject,
      'anIntList': anIntList,
      'aNullableIntList': aNullableIntList,
      'aListWithNullableInts': aListWithNullableInts,
      'aNullableListWithNullableInts': aNullableListWithNullableInts,
      'anObjectList': anObjectList,
      'aNullableObjectList': aNullableObjectList,
      'aListWithNullableObjects': aListWithNullableObjects,
      'aNullableListWithNullableObjects': aNullableListWithNullableObjects,
      'aDateTimeList': aDateTimeList,
      'aNullableDateTimeList': aNullableDateTimeList,
      'aListWithNullableDateTimes': aListWithNullableDateTimes,
      'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes,
      'aByteDataList': aByteDataList,
      'aNullableByteDataList': aNullableByteDataList,
      'aListWithNullableByteDatas': aListWithNullableByteDatas,
      'aNullableListWithNullableByteDatas': aNullableListWithNullableByteDatas,
      'anIntMap': anIntMap,
      'aNullableIntMap': aNullableIntMap,
      'aMapWithNullableInts': aMapWithNullableInts,
      'aNullableMapWithNullableInts': aNullableMapWithNullableInts,
    };
  }
}
