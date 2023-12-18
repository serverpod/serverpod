/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;

abstract class Nullability extends _i1.SerializableEntity {
  Nullability._({
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

  factory Nullability({
    required int anInt,
    int? aNullableInt,
    required double aDouble,
    double? aNullableDouble,
    required bool aBool,
    bool? aNullableBool,
    required String aString,
    String? aNullableString,
    required DateTime aDateTime,
    DateTime? aNullableDateTime,
    required _i2.ByteData aByteData,
    _i2.ByteData? aNullableByteData,
    required Duration aDuration,
    Duration? aNullableDuration,
    required _i1.UuidValue aUuid,
    _i1.UuidValue? aNullableUuid,
    required _i3.SimpleData anObject,
    _i3.SimpleData? aNullableObject,
    required List<int> anIntList,
    List<int>? aNullableIntList,
    required List<int?> aListWithNullableInts,
    List<int?>? aNullableListWithNullableInts,
    required List<_i3.SimpleData> anObjectList,
    List<_i3.SimpleData>? aNullableObjectList,
    required List<_i3.SimpleData?> aListWithNullableObjects,
    List<_i3.SimpleData?>? aNullableListWithNullableObjects,
    required List<DateTime> aDateTimeList,
    List<DateTime>? aNullableDateTimeList,
    required List<DateTime?> aListWithNullableDateTimes,
    List<DateTime?>? aNullableListWithNullableDateTimes,
    required List<_i2.ByteData> aByteDataList,
    List<_i2.ByteData>? aNullableByteDataList,
    required List<_i2.ByteData?> aListWithNullableByteDatas,
    List<_i2.ByteData?>? aNullableListWithNullableByteDatas,
    required List<Duration> aDurationList,
    List<Duration>? aNullableDurationList,
    required List<Duration?> aListWithNullableDurations,
    List<Duration?>? aNullableListWithNullableDurations,
    required List<_i1.UuidValue> aUuidList,
    List<_i1.UuidValue>? aNullableUuidList,
    required List<_i1.UuidValue?> aListWithNullableUuids,
    List<_i1.UuidValue?>? aNullableListWithNullableUuids,
    required Map<String, int> anIntMap,
    Map<String, int>? aNullableIntMap,
    required Map<String, int?> aMapWithNullableInts,
    Map<String, int?>? aNullableMapWithNullableInts,
  }) = _NullabilityImpl;

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

  Nullability copyWith({
    int? anInt,
    int? aNullableInt,
    double? aDouble,
    double? aNullableDouble,
    bool? aBool,
    bool? aNullableBool,
    String? aString,
    String? aNullableString,
    DateTime? aDateTime,
    DateTime? aNullableDateTime,
    _i2.ByteData? aByteData,
    _i2.ByteData? aNullableByteData,
    Duration? aDuration,
    Duration? aNullableDuration,
    _i1.UuidValue? aUuid,
    _i1.UuidValue? aNullableUuid,
    _i3.SimpleData? anObject,
    _i3.SimpleData? aNullableObject,
    List<int>? anIntList,
    List<int>? aNullableIntList,
    List<int?>? aListWithNullableInts,
    List<int?>? aNullableListWithNullableInts,
    List<_i3.SimpleData>? anObjectList,
    List<_i3.SimpleData>? aNullableObjectList,
    List<_i3.SimpleData?>? aListWithNullableObjects,
    List<_i3.SimpleData?>? aNullableListWithNullableObjects,
    List<DateTime>? aDateTimeList,
    List<DateTime>? aNullableDateTimeList,
    List<DateTime?>? aListWithNullableDateTimes,
    List<DateTime?>? aNullableListWithNullableDateTimes,
    List<_i2.ByteData>? aByteDataList,
    List<_i2.ByteData>? aNullableByteDataList,
    List<_i2.ByteData?>? aListWithNullableByteDatas,
    List<_i2.ByteData?>? aNullableListWithNullableByteDatas,
    List<Duration>? aDurationList,
    List<Duration>? aNullableDurationList,
    List<Duration?>? aListWithNullableDurations,
    List<Duration?>? aNullableListWithNullableDurations,
    List<_i1.UuidValue>? aUuidList,
    List<_i1.UuidValue>? aNullableUuidList,
    List<_i1.UuidValue?>? aListWithNullableUuids,
    List<_i1.UuidValue?>? aNullableListWithNullableUuids,
    Map<String, int>? anIntMap,
    Map<String, int>? aNullableIntMap,
    Map<String, int?>? aMapWithNullableInts,
    Map<String, int?>? aNullableMapWithNullableInts,
  });
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

  @override
  Map<String, dynamic> allToJson() {
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

class _Undefined {}

class _NullabilityImpl extends Nullability {
  _NullabilityImpl({
    required int anInt,
    int? aNullableInt,
    required double aDouble,
    double? aNullableDouble,
    required bool aBool,
    bool? aNullableBool,
    required String aString,
    String? aNullableString,
    required DateTime aDateTime,
    DateTime? aNullableDateTime,
    required _i2.ByteData aByteData,
    _i2.ByteData? aNullableByteData,
    required Duration aDuration,
    Duration? aNullableDuration,
    required _i1.UuidValue aUuid,
    _i1.UuidValue? aNullableUuid,
    required _i3.SimpleData anObject,
    _i3.SimpleData? aNullableObject,
    required List<int> anIntList,
    List<int>? aNullableIntList,
    required List<int?> aListWithNullableInts,
    List<int?>? aNullableListWithNullableInts,
    required List<_i3.SimpleData> anObjectList,
    List<_i3.SimpleData>? aNullableObjectList,
    required List<_i3.SimpleData?> aListWithNullableObjects,
    List<_i3.SimpleData?>? aNullableListWithNullableObjects,
    required List<DateTime> aDateTimeList,
    List<DateTime>? aNullableDateTimeList,
    required List<DateTime?> aListWithNullableDateTimes,
    List<DateTime?>? aNullableListWithNullableDateTimes,
    required List<_i2.ByteData> aByteDataList,
    List<_i2.ByteData>? aNullableByteDataList,
    required List<_i2.ByteData?> aListWithNullableByteDatas,
    List<_i2.ByteData?>? aNullableListWithNullableByteDatas,
    required List<Duration> aDurationList,
    List<Duration>? aNullableDurationList,
    required List<Duration?> aListWithNullableDurations,
    List<Duration?>? aNullableListWithNullableDurations,
    required List<_i1.UuidValue> aUuidList,
    List<_i1.UuidValue>? aNullableUuidList,
    required List<_i1.UuidValue?> aListWithNullableUuids,
    List<_i1.UuidValue?>? aNullableListWithNullableUuids,
    required Map<String, int> anIntMap,
    Map<String, int>? aNullableIntMap,
    required Map<String, int?> aMapWithNullableInts,
    Map<String, int?>? aNullableMapWithNullableInts,
  }) : super._(
          anInt: anInt,
          aNullableInt: aNullableInt,
          aDouble: aDouble,
          aNullableDouble: aNullableDouble,
          aBool: aBool,
          aNullableBool: aNullableBool,
          aString: aString,
          aNullableString: aNullableString,
          aDateTime: aDateTime,
          aNullableDateTime: aNullableDateTime,
          aByteData: aByteData,
          aNullableByteData: aNullableByteData,
          aDuration: aDuration,
          aNullableDuration: aNullableDuration,
          aUuid: aUuid,
          aNullableUuid: aNullableUuid,
          anObject: anObject,
          aNullableObject: aNullableObject,
          anIntList: anIntList,
          aNullableIntList: aNullableIntList,
          aListWithNullableInts: aListWithNullableInts,
          aNullableListWithNullableInts: aNullableListWithNullableInts,
          anObjectList: anObjectList,
          aNullableObjectList: aNullableObjectList,
          aListWithNullableObjects: aListWithNullableObjects,
          aNullableListWithNullableObjects: aNullableListWithNullableObjects,
          aDateTimeList: aDateTimeList,
          aNullableDateTimeList: aNullableDateTimeList,
          aListWithNullableDateTimes: aListWithNullableDateTimes,
          aNullableListWithNullableDateTimes:
              aNullableListWithNullableDateTimes,
          aByteDataList: aByteDataList,
          aNullableByteDataList: aNullableByteDataList,
          aListWithNullableByteDatas: aListWithNullableByteDatas,
          aNullableListWithNullableByteDatas:
              aNullableListWithNullableByteDatas,
          aDurationList: aDurationList,
          aNullableDurationList: aNullableDurationList,
          aListWithNullableDurations: aListWithNullableDurations,
          aNullableListWithNullableDurations:
              aNullableListWithNullableDurations,
          aUuidList: aUuidList,
          aNullableUuidList: aNullableUuidList,
          aListWithNullableUuids: aListWithNullableUuids,
          aNullableListWithNullableUuids: aNullableListWithNullableUuids,
          anIntMap: anIntMap,
          aNullableIntMap: aNullableIntMap,
          aMapWithNullableInts: aMapWithNullableInts,
          aNullableMapWithNullableInts: aNullableMapWithNullableInts,
        );

  @override
  Nullability copyWith({
    int? anInt,
    Object? aNullableInt = _Undefined,
    double? aDouble,
    Object? aNullableDouble = _Undefined,
    bool? aBool,
    Object? aNullableBool = _Undefined,
    String? aString,
    Object? aNullableString = _Undefined,
    DateTime? aDateTime,
    Object? aNullableDateTime = _Undefined,
    _i2.ByteData? aByteData,
    Object? aNullableByteData = _Undefined,
    Duration? aDuration,
    Object? aNullableDuration = _Undefined,
    _i1.UuidValue? aUuid,
    Object? aNullableUuid = _Undefined,
    _i3.SimpleData? anObject,
    Object? aNullableObject = _Undefined,
    List<int>? anIntList,
    Object? aNullableIntList = _Undefined,
    List<int?>? aListWithNullableInts,
    Object? aNullableListWithNullableInts = _Undefined,
    List<_i3.SimpleData>? anObjectList,
    Object? aNullableObjectList = _Undefined,
    List<_i3.SimpleData?>? aListWithNullableObjects,
    Object? aNullableListWithNullableObjects = _Undefined,
    List<DateTime>? aDateTimeList,
    Object? aNullableDateTimeList = _Undefined,
    List<DateTime?>? aListWithNullableDateTimes,
    Object? aNullableListWithNullableDateTimes = _Undefined,
    List<_i2.ByteData>? aByteDataList,
    Object? aNullableByteDataList = _Undefined,
    List<_i2.ByteData?>? aListWithNullableByteDatas,
    Object? aNullableListWithNullableByteDatas = _Undefined,
    List<Duration>? aDurationList,
    Object? aNullableDurationList = _Undefined,
    List<Duration?>? aListWithNullableDurations,
    Object? aNullableListWithNullableDurations = _Undefined,
    List<_i1.UuidValue>? aUuidList,
    Object? aNullableUuidList = _Undefined,
    List<_i1.UuidValue?>? aListWithNullableUuids,
    Object? aNullableListWithNullableUuids = _Undefined,
    Map<String, int>? anIntMap,
    Object? aNullableIntMap = _Undefined,
    Map<String, int?>? aMapWithNullableInts,
    Object? aNullableMapWithNullableInts = _Undefined,
  }) {
    return Nullability(
      anInt: anInt ?? this.anInt,
      aNullableInt: aNullableInt is int? ? aNullableInt : this.aNullableInt,
      aDouble: aDouble ?? this.aDouble,
      aNullableDouble:
          aNullableDouble is double? ? aNullableDouble : this.aNullableDouble,
      aBool: aBool ?? this.aBool,
      aNullableBool:
          aNullableBool is bool? ? aNullableBool : this.aNullableBool,
      aString: aString ?? this.aString,
      aNullableString:
          aNullableString is String? ? aNullableString : this.aNullableString,
      aDateTime: aDateTime ?? this.aDateTime,
      aNullableDateTime: aNullableDateTime is DateTime?
          ? aNullableDateTime
          : this.aNullableDateTime,
      aByteData: aByteData ?? this.aByteData.clone(),
      aNullableByteData: aNullableByteData is _i2.ByteData?
          ? aNullableByteData
          : this.aNullableByteData?.clone(),
      aDuration: aDuration ?? this.aDuration,
      aNullableDuration: aNullableDuration is Duration?
          ? aNullableDuration
          : this.aNullableDuration,
      aUuid: aUuid ?? this.aUuid,
      aNullableUuid:
          aNullableUuid is _i1.UuidValue? ? aNullableUuid : this.aNullableUuid,
      anObject: anObject ?? this.anObject.copyWith(),
      aNullableObject: aNullableObject is _i3.SimpleData?
          ? aNullableObject
          : this.aNullableObject?.copyWith(),
      anIntList: anIntList ?? this.anIntList.clone(),
      aNullableIntList: aNullableIntList is List<int>?
          ? aNullableIntList
          : this.aNullableIntList?.clone(),
      aListWithNullableInts:
          aListWithNullableInts ?? this.aListWithNullableInts.clone(),
      aNullableListWithNullableInts:
          aNullableListWithNullableInts is List<int?>?
              ? aNullableListWithNullableInts
              : this.aNullableListWithNullableInts?.clone(),
      anObjectList: anObjectList ?? this.anObjectList.clone(),
      aNullableObjectList: aNullableObjectList is List<_i3.SimpleData>?
          ? aNullableObjectList
          : this.aNullableObjectList?.clone(),
      aListWithNullableObjects:
          aListWithNullableObjects ?? this.aListWithNullableObjects.clone(),
      aNullableListWithNullableObjects:
          aNullableListWithNullableObjects is List<_i3.SimpleData?>?
              ? aNullableListWithNullableObjects
              : this.aNullableListWithNullableObjects?.clone(),
      aDateTimeList: aDateTimeList ?? this.aDateTimeList.clone(),
      aNullableDateTimeList: aNullableDateTimeList is List<DateTime>?
          ? aNullableDateTimeList
          : this.aNullableDateTimeList?.clone(),
      aListWithNullableDateTimes:
          aListWithNullableDateTimes ?? this.aListWithNullableDateTimes.clone(),
      aNullableListWithNullableDateTimes:
          aNullableListWithNullableDateTimes is List<DateTime?>?
              ? aNullableListWithNullableDateTimes
              : this.aNullableListWithNullableDateTimes?.clone(),
      aByteDataList: aByteDataList ?? this.aByteDataList.clone(),
      aNullableByteDataList: aNullableByteDataList is List<_i2.ByteData>?
          ? aNullableByteDataList
          : this.aNullableByteDataList?.clone(),
      aListWithNullableByteDatas:
          aListWithNullableByteDatas ?? this.aListWithNullableByteDatas.clone(),
      aNullableListWithNullableByteDatas:
          aNullableListWithNullableByteDatas is List<_i2.ByteData?>?
              ? aNullableListWithNullableByteDatas
              : this.aNullableListWithNullableByteDatas?.clone(),
      aDurationList: aDurationList ?? this.aDurationList.clone(),
      aNullableDurationList: aNullableDurationList is List<Duration>?
          ? aNullableDurationList
          : this.aNullableDurationList?.clone(),
      aListWithNullableDurations:
          aListWithNullableDurations ?? this.aListWithNullableDurations.clone(),
      aNullableListWithNullableDurations:
          aNullableListWithNullableDurations is List<Duration?>?
              ? aNullableListWithNullableDurations
              : this.aNullableListWithNullableDurations?.clone(),
      aUuidList: aUuidList ?? this.aUuidList.clone(),
      aNullableUuidList: aNullableUuidList is List<_i1.UuidValue>?
          ? aNullableUuidList
          : this.aNullableUuidList?.clone(),
      aListWithNullableUuids:
          aListWithNullableUuids ?? this.aListWithNullableUuids.clone(),
      aNullableListWithNullableUuids:
          aNullableListWithNullableUuids is List<_i1.UuidValue?>?
              ? aNullableListWithNullableUuids
              : this.aNullableListWithNullableUuids?.clone(),
      anIntMap: anIntMap ?? this.anIntMap.clone(),
      aNullableIntMap: aNullableIntMap is Map<String, int>?
          ? aNullableIntMap
          : this.aNullableIntMap?.clone(),
      aMapWithNullableInts:
          aMapWithNullableInts ?? this.aMapWithNullableInts.clone(),
      aNullableMapWithNullableInts:
          aNullableMapWithNullableInts is Map<String, int?>?
              ? aNullableMapWithNullableInts
              : this.aNullableMapWithNullableInts?.clone(),
    );
  }
}
