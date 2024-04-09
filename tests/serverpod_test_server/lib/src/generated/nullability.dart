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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i4;
import 'package:uuid/uuid_value.dart' as _i5;
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  factory Nullability.fromJson(Map<String, dynamic> jsonSerialization) {
    return Nullability(
      anInt: jsonSerialization['anInt'] as int,
      aNullableInt: jsonSerialization['aNullableInt'] as int?,
      aDouble: jsonSerialization['aDouble'] as double,
      aNullableDouble: jsonSerialization['aNullableDouble'] as double?,
      aBool: jsonSerialization['aBool'] as bool,
      aNullableBool: jsonSerialization['aNullableBool'] as bool?,
      aString: jsonSerialization['aString'] as String,
      aNullableString: jsonSerialization['aNullableString'] as String?,
      aDateTime: _i4.DateTimeExt.getDateTime<DateTime>(
          jsonSerialization['aDateTime'])!,
      aNullableDateTime: _i4.DateTimeExt.getDateTime<DateTime?>(
          jsonSerialization['aNullableDateTime']),
      aByteData: _i4.ByteDataExt.getByteData<_i2.ByteData>(
          jsonSerialization['aByteData'])!,
      aNullableByteData: _i4.ByteDataExt.getByteData<_i2.ByteData?>(
          jsonSerialization['aNullableByteData']),
      aDuration: _i4.DurationExt.getDuration<Duration>(
          jsonSerialization['aDuration'])!,
      aNullableDuration: _i4.DurationExt.getDuration<Duration?>(
          jsonSerialization['aNullableDuration']),
      aUuid: _i4.UuidValueExt.getUuIdValue<_i5.UuidValue>(
          jsonSerialization['aUuid'])!,
      aNullableUuid: _i4.UuidValueExt.getUuIdValue<_i5.UuidValue?>(
          jsonSerialization['aNullableUuid']),
      anObject: _i3.SimpleData.fromJson(
          jsonSerialization['anObject'] as Map<String, dynamic>),
      aNullableObject: jsonSerialization.containsKey('aNullableObject')
          ? jsonSerialization['aNullableObject'] != null
              ? _i3.SimpleData.fromJson(
                  jsonSerialization['aNullableObject'] as Map<String, dynamic>)
              : null
          : null,
      anIntList: (jsonSerialization['anIntList'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      aNullableIntList:
          (jsonSerialization['aNullableIntList'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList(),
      aListWithNullableInts:
          (jsonSerialization['aListWithNullableInts'] as List<dynamic>)
              .map((e) => e as int?)
              .toList(),
      aNullableListWithNullableInts:
          (jsonSerialization['aNullableListWithNullableInts'] as List<dynamic>?)
              ?.map((e) => e as int?)
              .toList(),
      anObjectList: (jsonSerialization['anObjectList'] as List<dynamic>)
          .map((e) => _i3.SimpleData.fromJson(e as Map<String, dynamic>))
          .toList(),
      aNullableObjectList:
          (jsonSerialization['aNullableObjectList'] as List<dynamic>?)
              ?.map((e) => _i3.SimpleData.fromJson(e as Map<String, dynamic>))
              .toList(),
      aListWithNullableObjects:
          (jsonSerialization['aListWithNullableObjects'] as List<dynamic>)
              .map((e) => e != null
                  ? _i3.SimpleData.fromJson(e as Map<String, dynamic>)
                  : null)
              .toList(),
      aNullableListWithNullableObjects:
          (jsonSerialization['aNullableListWithNullableObjects']
                  as List<dynamic>?)
              ?.map((e) => e != null
                  ? _i3.SimpleData.fromJson(e as Map<String, dynamic>)
                  : null)
              .toList(),
      aDateTimeList: (jsonSerialization['aDateTimeList'] as List<dynamic>)
          .map((e) => _i4.DateTimeExt.getDateTime<DateTime>(e)!)
          .toList(),
      aNullableDateTimeList:
          (jsonSerialization['aNullableDateTimeList'] as List<dynamic>?)
              ?.map((e) => _i4.DateTimeExt.getDateTime<DateTime>(e)!)
              .toList(),
      aListWithNullableDateTimes:
          (jsonSerialization['aListWithNullableDateTimes'] as List<dynamic>)
              .map((e) => _i4.DateTimeExt.getDateTime<DateTime?>(e))
              .toList(),
      aNullableListWithNullableDateTimes:
          (jsonSerialization['aNullableListWithNullableDateTimes']
                  as List<dynamic>?)
              ?.map((e) => _i4.DateTimeExt.getDateTime<DateTime?>(e))
              .toList(),
      aByteDataList: (jsonSerialization['aByteDataList'] as List<dynamic>)
          .map((e) => _i4.ByteDataExt.getByteData<_i2.ByteData>(e)!)
          .toList(),
      aNullableByteDataList:
          (jsonSerialization['aNullableByteDataList'] as List<dynamic>?)
              ?.map((e) => _i4.ByteDataExt.getByteData<_i2.ByteData>(e)!)
              .toList(),
      aListWithNullableByteDatas:
          (jsonSerialization['aListWithNullableByteDatas'] as List<dynamic>)
              .map((e) => _i4.ByteDataExt.getByteData<_i2.ByteData?>(e))
              .toList(),
      aNullableListWithNullableByteDatas:
          (jsonSerialization['aNullableListWithNullableByteDatas']
                  as List<dynamic>?)
              ?.map((e) => _i4.ByteDataExt.getByteData<_i2.ByteData?>(e))
              .toList(),
      aDurationList: (jsonSerialization['aDurationList'] as List<dynamic>)
          .map((e) => _i4.DurationExt.getDuration<Duration>(e)!)
          .toList(),
      aNullableDurationList:
          (jsonSerialization['aNullableDurationList'] as List<dynamic>?)
              ?.map((e) => _i4.DurationExt.getDuration<Duration>(e)!)
              .toList(),
      aListWithNullableDurations:
          (jsonSerialization['aListWithNullableDurations'] as List<dynamic>)
              .map((e) => _i4.DurationExt.getDuration<Duration?>(e))
              .toList(),
      aNullableListWithNullableDurations:
          (jsonSerialization['aNullableListWithNullableDurations']
                  as List<dynamic>?)
              ?.map((e) => _i4.DurationExt.getDuration<Duration?>(e))
              .toList(),
      aUuidList: (jsonSerialization['aUuidList'] as List<dynamic>)
          .map((e) => _i4.UuidValueExt.getUuIdValue<_i5.UuidValue>(e)!)
          .toList(),
      aNullableUuidList:
          (jsonSerialization['aNullableUuidList'] as List<dynamic>?)
              ?.map((e) => _i4.UuidValueExt.getUuIdValue<_i5.UuidValue>(e)!)
              .toList(),
      aListWithNullableUuids:
          (jsonSerialization['aListWithNullableUuids'] as List<dynamic>)
              .map((e) => _i4.UuidValueExt.getUuIdValue<_i5.UuidValue?>(e))
              .toList(),
      aNullableListWithNullableUuids:
          (jsonSerialization['aNullableListWithNullableUuids']
                  as List<dynamic>?)
              ?.map((e) => _i4.UuidValueExt.getUuIdValue<_i5.UuidValue?>(e))
              .toList(),
      anIntMap: (jsonSerialization['anIntMap'] as Map<dynamic, dynamic>)
          .map((k, v) => MapEntry(
                k as String,
                v as int,
              )),
      aNullableIntMap:
          (jsonSerialization['aNullableIntMap'] as Map<dynamic, dynamic>?)
              ?.map((k, v) => MapEntry(
                    k as String,
                    v as int,
                  )),
      aMapWithNullableInts:
          (jsonSerialization['aMapWithNullableInts'] as Map<dynamic, dynamic>)
              .map((k, v) => MapEntry(
                    k as String,
                    v as int?,
                  )),
      aNullableMapWithNullableInts:
          (jsonSerialization['aNullableMapWithNullableInts']
                  as Map<dynamic, dynamic>?)
              ?.map((k, v) => MapEntry(
                    k as String,
                    v as int?,
                  )),
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
      if (aNullableInt != null) 'aNullableInt': aNullableInt,
      'aDouble': aDouble,
      if (aNullableDouble != null) 'aNullableDouble': aNullableDouble,
      'aBool': aBool,
      if (aNullableBool != null) 'aNullableBool': aNullableBool,
      'aString': aString,
      if (aNullableString != null) 'aNullableString': aNullableString,
      'aDateTime': aDateTime.toJson(),
      if (aNullableDateTime != null)
        'aNullableDateTime': aNullableDateTime?.toJson(),
      'aByteData': aByteData.toJson(),
      if (aNullableByteData != null)
        'aNullableByteData': aNullableByteData?.toJson(),
      'aDuration': aDuration.toJson(),
      if (aNullableDuration != null)
        'aNullableDuration': aNullableDuration?.toJson(),
      'aUuid': aUuid.toJson(),
      if (aNullableUuid != null) 'aNullableUuid': aNullableUuid?.toJson(),
      'anObject': anObject.toJson(),
      if (aNullableObject != null) 'aNullableObject': aNullableObject?.toJson(),
      'anIntList': anIntList.toJson(),
      if (aNullableIntList != null)
        'aNullableIntList': aNullableIntList?.toJson(),
      'aListWithNullableInts': aListWithNullableInts.toJson(),
      if (aNullableListWithNullableInts != null)
        'aNullableListWithNullableInts':
            aNullableListWithNullableInts?.toJson(),
      'anObjectList': anObjectList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableObjectList != null)
        'aNullableObjectList':
            aNullableObjectList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableObjects':
          aListWithNullableObjects.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableObjects != null)
        'aNullableListWithNullableObjects': aNullableListWithNullableObjects
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aDateTimeList': aDateTimeList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDateTimeList != null)
        'aNullableDateTimeList':
            aNullableDateTimeList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableDateTimes':
          aListWithNullableDateTimes.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableDateTimes != null)
        'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aByteDataList': aByteDataList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableByteDataList != null)
        'aNullableByteDataList':
            aNullableByteDataList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableByteDatas':
          aListWithNullableByteDatas.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableByteDatas != null)
        'aNullableListWithNullableByteDatas': aNullableListWithNullableByteDatas
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aDurationList': aDurationList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDurationList != null)
        'aNullableDurationList':
            aNullableDurationList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableDurations':
          aListWithNullableDurations.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableDurations != null)
        'aNullableListWithNullableDurations': aNullableListWithNullableDurations
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aUuidList': aUuidList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableUuidList != null)
        'aNullableUuidList':
            aNullableUuidList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableUuids':
          aListWithNullableUuids.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableUuids != null)
        'aNullableListWithNullableUuids': aNullableListWithNullableUuids
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'anIntMap': anIntMap.toJson(),
      if (aNullableIntMap != null) 'aNullableIntMap': aNullableIntMap?.toJson(),
      'aMapWithNullableInts': aMapWithNullableInts.toJson(),
      if (aNullableMapWithNullableInts != null)
        'aNullableMapWithNullableInts': aNullableMapWithNullableInts?.toJson(),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'anInt': anInt,
      if (aNullableInt != null) 'aNullableInt': aNullableInt,
      'aDouble': aDouble,
      if (aNullableDouble != null) 'aNullableDouble': aNullableDouble,
      'aBool': aBool,
      if (aNullableBool != null) 'aNullableBool': aNullableBool,
      'aString': aString,
      if (aNullableString != null) 'aNullableString': aNullableString,
      'aDateTime': aDateTime.toJson(),
      if (aNullableDateTime != null)
        'aNullableDateTime': aNullableDateTime?.toJson(),
      'aByteData': aByteData.toJson(),
      if (aNullableByteData != null)
        'aNullableByteData': aNullableByteData?.toJson(),
      'aDuration': aDuration.toJson(),
      if (aNullableDuration != null)
        'aNullableDuration': aNullableDuration?.toJson(),
      'aUuid': aUuid.toJson(),
      if (aNullableUuid != null) 'aNullableUuid': aNullableUuid?.toJson(),
      'anObject': anObject.allToJson(),
      if (aNullableObject != null)
        'aNullableObject': aNullableObject?.allToJson(),
      'anIntList': anIntList.toJson(),
      if (aNullableIntList != null)
        'aNullableIntList': aNullableIntList?.toJson(),
      'aListWithNullableInts': aListWithNullableInts.toJson(),
      if (aNullableListWithNullableInts != null)
        'aNullableListWithNullableInts':
            aNullableListWithNullableInts?.toJson(),
      'anObjectList': anObjectList.toJson(valueToJson: (v) => v.allToJson()),
      if (aNullableObjectList != null)
        'aNullableObjectList':
            aNullableObjectList?.toJson(valueToJson: (v) => v.allToJson()),
      'aListWithNullableObjects':
          aListWithNullableObjects.toJson(valueToJson: (v) => v?.allToJson()),
      if (aNullableListWithNullableObjects != null)
        'aNullableListWithNullableObjects': aNullableListWithNullableObjects
            ?.toJson(valueToJson: (v) => v?.allToJson()),
      'aDateTimeList': aDateTimeList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDateTimeList != null)
        'aNullableDateTimeList':
            aNullableDateTimeList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableDateTimes':
          aListWithNullableDateTimes.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableDateTimes != null)
        'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aByteDataList': aByteDataList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableByteDataList != null)
        'aNullableByteDataList':
            aNullableByteDataList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableByteDatas':
          aListWithNullableByteDatas.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableByteDatas != null)
        'aNullableListWithNullableByteDatas': aNullableListWithNullableByteDatas
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aDurationList': aDurationList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDurationList != null)
        'aNullableDurationList':
            aNullableDurationList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableDurations':
          aListWithNullableDurations.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableDurations != null)
        'aNullableListWithNullableDurations': aNullableListWithNullableDurations
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aUuidList': aUuidList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableUuidList != null)
        'aNullableUuidList':
            aNullableUuidList?.toJson(valueToJson: (v) => v.toJson()),
      'aListWithNullableUuids':
          aListWithNullableUuids.toJson(valueToJson: (v) => v?.toJson()),
      if (aNullableListWithNullableUuids != null)
        'aNullableListWithNullableUuids': aNullableListWithNullableUuids
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'anIntMap': anIntMap.toJson(),
      if (aNullableIntMap != null) 'aNullableIntMap': aNullableIntMap?.toJson(),
      'aMapWithNullableInts': aMapWithNullableInts.toJson(),
      if (aNullableMapWithNullableInts != null)
        'aNullableMapWithNullableInts': aNullableMapWithNullableInts?.toJson(),
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
