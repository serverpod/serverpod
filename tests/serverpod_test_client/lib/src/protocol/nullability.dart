/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

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
    required this.aDuration,
    this.aNullableDuration,
    required this.aUuid,
    this.aNullableUuid,
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
    required this.aDurationList,
    this.aNullableDurationList,
    required this.aListWithNullableDurations,
    this.aNullableListWithNullableDurations,
    required this.aUuidList,
    this.aNullableUuidList,
    required this.aListWithNullableUuids,
    this.aNullableListWithNullableUuids,
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
      anInt: serializationManager.deserialize<int>(jsonSerialization['anInt']),
      aNullableInt: serializationManager
          .deserialize<int?>(jsonSerialization['aNullableInt']),
      aDouble: serializationManager
          .deserialize<double>(jsonSerialization['aDouble']),
      aNullableDouble: serializationManager
          .deserialize<double?>(jsonSerialization['aNullableDouble']),
      aBool: serializationManager.deserialize<bool>(jsonSerialization['aBool']),
      aNullableBool: serializationManager
          .deserialize<bool?>(jsonSerialization['aNullableBool']),
      aString: serializationManager
          .deserialize<String>(jsonSerialization['aString']),
      aNullableString: serializationManager
          .deserialize<String?>(jsonSerialization['aNullableString']),
      aDateTime: serializationManager
          .deserialize<DateTime>(jsonSerialization['aDateTime']),
      aNullableDateTime: serializationManager
          .deserialize<DateTime?>(jsonSerialization['aNullableDateTime']),
      aByteData: serializationManager
          .deserialize<_i2.ByteData>(jsonSerialization['aByteData']),
      aNullableByteData: serializationManager
          .deserialize<_i2.ByteData?>(jsonSerialization['aNullableByteData']),
      aDuration: serializationManager
          .deserialize<Duration>(jsonSerialization['aDuration']),
      aNullableDuration: serializationManager
          .deserialize<Duration?>(jsonSerialization['aNullableDuration']),
      aUuid: serializationManager
          .deserialize<_i1.UuidValue>(jsonSerialization['aUuid']),
      aNullableUuid: serializationManager
          .deserialize<_i1.UuidValue?>(jsonSerialization['aNullableUuid']),
      anObject: serializationManager
          .deserialize<_i3.SimpleData>(jsonSerialization['anObject']),
      aNullableObject: serializationManager
          .deserialize<_i3.SimpleData?>(jsonSerialization['aNullableObject']),
      anIntList: serializationManager
          .deserialize<List<int>>(jsonSerialization['anIntList']),
      aNullableIntList: serializationManager
          .deserialize<List<int>?>(jsonSerialization['aNullableIntList']),
      aListWithNullableInts: serializationManager
          .deserialize<List<int?>>(jsonSerialization['aListWithNullableInts']),
      aNullableListWithNullableInts:
          serializationManager.deserialize<List<int?>?>(
              jsonSerialization['aNullableListWithNullableInts']),
      anObjectList: serializationManager
          .deserialize<List<_i3.SimpleData>>(jsonSerialization['anObjectList']),
      aNullableObjectList:
          serializationManager.deserialize<List<_i3.SimpleData>?>(
              jsonSerialization['aNullableObjectList']),
      aListWithNullableObjects:
          serializationManager.deserialize<List<_i3.SimpleData?>>(
              jsonSerialization['aListWithNullableObjects']),
      aNullableListWithNullableObjects:
          serializationManager.deserialize<List<_i3.SimpleData?>?>(
              jsonSerialization['aNullableListWithNullableObjects']),
      aDateTimeList: serializationManager
          .deserialize<List<DateTime>>(jsonSerialization['aDateTimeList']),
      aNullableDateTimeList: serializationManager.deserialize<List<DateTime>?>(
          jsonSerialization['aNullableDateTimeList']),
      aListWithNullableDateTimes:
          serializationManager.deserialize<List<DateTime?>>(
              jsonSerialization['aListWithNullableDateTimes']),
      aNullableListWithNullableDateTimes:
          serializationManager.deserialize<List<DateTime?>?>(
              jsonSerialization['aNullableListWithNullableDateTimes']),
      aByteDataList: serializationManager
          .deserialize<List<_i2.ByteData>>(jsonSerialization['aByteDataList']),
      aNullableByteDataList:
          serializationManager.deserialize<List<_i2.ByteData>?>(
              jsonSerialization['aNullableByteDataList']),
      aListWithNullableByteDatas:
          serializationManager.deserialize<List<_i2.ByteData?>>(
              jsonSerialization['aListWithNullableByteDatas']),
      aNullableListWithNullableByteDatas:
          serializationManager.deserialize<List<_i2.ByteData?>?>(
              jsonSerialization['aNullableListWithNullableByteDatas']),
      aDurationList: serializationManager
          .deserialize<List<Duration>>(jsonSerialization['aDurationList']),
      aNullableDurationList: serializationManager.deserialize<List<Duration>?>(
          jsonSerialization['aNullableDurationList']),
      aListWithNullableDurations:
          serializationManager.deserialize<List<Duration?>>(
              jsonSerialization['aListWithNullableDurations']),
      aNullableListWithNullableDurations:
          serializationManager.deserialize<List<Duration?>?>(
              jsonSerialization['aNullableListWithNullableDurations']),
      aUuidList: serializationManager
          .deserialize<List<_i1.UuidValue>>(jsonSerialization['aUuidList']),
      aNullableUuidList: serializationManager.deserialize<List<_i1.UuidValue>?>(
          jsonSerialization['aNullableUuidList']),
      aListWithNullableUuids:
          serializationManager.deserialize<List<_i1.UuidValue?>>(
              jsonSerialization['aListWithNullableUuids']),
      aNullableListWithNullableUuids:
          serializationManager.deserialize<List<_i1.UuidValue?>?>(
              jsonSerialization['aNullableListWithNullableUuids']),
      anIntMap: serializationManager
          .deserialize<Map<String, int>>(jsonSerialization['anIntMap']),
      aNullableIntMap: serializationManager
          .deserialize<Map<String, int>?>(jsonSerialization['aNullableIntMap']),
      aMapWithNullableInts: serializationManager.deserialize<Map<String, int?>>(
          jsonSerialization['aMapWithNullableInts']),
      aNullableMapWithNullableInts:
          serializationManager.deserialize<Map<String, int?>?>(
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

  Duration aDuration;

  Duration? aNullableDuration;

  _i1.UuidValue aUuid;

  _i1.UuidValue? aNullableUuid;

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

  List<Duration> aDurationList;

  List<Duration>? aNullableDurationList;

  List<Duration?> aListWithNullableDurations;

  List<Duration?>? aNullableListWithNullableDurations;

  List<_i1.UuidValue> aUuidList;

  List<_i1.UuidValue>? aNullableUuidList;

  List<_i1.UuidValue?> aListWithNullableUuids;

  List<_i1.UuidValue?>? aNullableListWithNullableUuids;

  Map<String, int> anIntMap;

  Map<String, int>? aNullableIntMap;

  Map<String, int?> aMapWithNullableInts;

  Map<String, int?>? aNullableMapWithNullableInts;

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
      'aDuration': aDuration,
      'aNullableDuration': aNullableDuration,
      'aUuid': aUuid,
      'aNullableUuid': aNullableUuid,
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
      'aDurationList': aDurationList,
      'aNullableDurationList': aNullableDurationList,
      'aListWithNullableDurations': aListWithNullableDurations,
      'aNullableListWithNullableDurations': aNullableListWithNullableDurations,
      'aUuidList': aUuidList,
      'aNullableUuidList': aNullableUuidList,
      'aListWithNullableUuids': aListWithNullableUuids,
      'aNullableListWithNullableUuids': aNullableListWithNullableUuids,
      'anIntMap': anIntMap,
      'aNullableIntMap': aNullableIntMap,
      'aMapWithNullableInts': aMapWithNullableInts,
      'aNullableMapWithNullableInts': aNullableMapWithNullableInts,
    };
  }
}
