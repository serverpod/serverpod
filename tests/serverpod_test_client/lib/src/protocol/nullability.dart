/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;
import 'package:collection/collection.dart' as _i4;

abstract class Nullability extends _i1.SerializableEntity {
  const Nullability._();

  const factory Nullability({
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
  }) = _Nullability;

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
  int get anInt;
  int? get aNullableInt;
  double get aDouble;
  double? get aNullableDouble;
  bool get aBool;
  bool? get aNullableBool;
  String get aString;
  String? get aNullableString;
  DateTime get aDateTime;
  DateTime? get aNullableDateTime;
  _i2.ByteData get aByteData;
  _i2.ByteData? get aNullableByteData;
  Duration get aDuration;
  Duration? get aNullableDuration;
  _i1.UuidValue get aUuid;
  _i1.UuidValue? get aNullableUuid;
  _i3.SimpleData get anObject;
  _i3.SimpleData? get aNullableObject;
  List<int> get anIntList;
  List<int>? get aNullableIntList;
  List<int?> get aListWithNullableInts;
  List<int?>? get aNullableListWithNullableInts;
  List<_i3.SimpleData> get anObjectList;
  List<_i3.SimpleData>? get aNullableObjectList;
  List<_i3.SimpleData?> get aListWithNullableObjects;
  List<_i3.SimpleData?>? get aNullableListWithNullableObjects;
  List<DateTime> get aDateTimeList;
  List<DateTime>? get aNullableDateTimeList;
  List<DateTime?> get aListWithNullableDateTimes;
  List<DateTime?>? get aNullableListWithNullableDateTimes;
  List<_i2.ByteData> get aByteDataList;
  List<_i2.ByteData>? get aNullableByteDataList;
  List<_i2.ByteData?> get aListWithNullableByteDatas;
  List<_i2.ByteData?>? get aNullableListWithNullableByteDatas;
  List<Duration> get aDurationList;
  List<Duration>? get aNullableDurationList;
  List<Duration?> get aListWithNullableDurations;
  List<Duration?>? get aNullableListWithNullableDurations;
  List<_i1.UuidValue> get aUuidList;
  List<_i1.UuidValue>? get aNullableUuidList;
  List<_i1.UuidValue?> get aListWithNullableUuids;
  List<_i1.UuidValue?>? get aNullableListWithNullableUuids;
  Map<String, int> get anIntMap;
  Map<String, int>? get aNullableIntMap;
  Map<String, int?> get aMapWithNullableInts;
  Map<String, int?>? get aNullableMapWithNullableInts;
}

class _Undefined {}

class _Nullability extends Nullability {
  const _Nullability({
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
  }) : super._();

  @override
  final int anInt;

  @override
  final int? aNullableInt;

  @override
  final double aDouble;

  @override
  final double? aNullableDouble;

  @override
  final bool aBool;

  @override
  final bool? aNullableBool;

  @override
  final String aString;

  @override
  final String? aNullableString;

  @override
  final DateTime aDateTime;

  @override
  final DateTime? aNullableDateTime;

  @override
  final _i2.ByteData aByteData;

  @override
  final _i2.ByteData? aNullableByteData;

  @override
  final Duration aDuration;

  @override
  final Duration? aNullableDuration;

  @override
  final _i1.UuidValue aUuid;

  @override
  final _i1.UuidValue? aNullableUuid;

  @override
  final _i3.SimpleData anObject;

  @override
  final _i3.SimpleData? aNullableObject;

  @override
  final List<int> anIntList;

  @override
  final List<int>? aNullableIntList;

  @override
  final List<int?> aListWithNullableInts;

  @override
  final List<int?>? aNullableListWithNullableInts;

  @override
  final List<_i3.SimpleData> anObjectList;

  @override
  final List<_i3.SimpleData>? aNullableObjectList;

  @override
  final List<_i3.SimpleData?> aListWithNullableObjects;

  @override
  final List<_i3.SimpleData?>? aNullableListWithNullableObjects;

  @override
  final List<DateTime> aDateTimeList;

  @override
  final List<DateTime>? aNullableDateTimeList;

  @override
  final List<DateTime?> aListWithNullableDateTimes;

  @override
  final List<DateTime?>? aNullableListWithNullableDateTimes;

  @override
  final List<_i2.ByteData> aByteDataList;

  @override
  final List<_i2.ByteData>? aNullableByteDataList;

  @override
  final List<_i2.ByteData?> aListWithNullableByteDatas;

  @override
  final List<_i2.ByteData?>? aNullableListWithNullableByteDatas;

  @override
  final List<Duration> aDurationList;

  @override
  final List<Duration>? aNullableDurationList;

  @override
  final List<Duration?> aListWithNullableDurations;

  @override
  final List<Duration?>? aNullableListWithNullableDurations;

  @override
  final List<_i1.UuidValue> aUuidList;

  @override
  final List<_i1.UuidValue>? aNullableUuidList;

  @override
  final List<_i1.UuidValue?> aListWithNullableUuids;

  @override
  final List<_i1.UuidValue?>? aNullableListWithNullableUuids;

  @override
  final Map<String, int> anIntMap;

  @override
  final Map<String, int>? aNullableIntMap;

  @override
  final Map<String, int?> aMapWithNullableInts;

  @override
  final Map<String, int?>? aNullableMapWithNullableInts;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is Nullability &&
            (identical(
                  other.anInt,
                  anInt,
                ) ||
                other.anInt == anInt) &&
            (identical(
                  other.aNullableInt,
                  aNullableInt,
                ) ||
                other.aNullableInt == aNullableInt) &&
            (identical(
                  other.aDouble,
                  aDouble,
                ) ||
                other.aDouble == aDouble) &&
            (identical(
                  other.aNullableDouble,
                  aNullableDouble,
                ) ||
                other.aNullableDouble == aNullableDouble) &&
            (identical(
                  other.aBool,
                  aBool,
                ) ||
                other.aBool == aBool) &&
            (identical(
                  other.aNullableBool,
                  aNullableBool,
                ) ||
                other.aNullableBool == aNullableBool) &&
            (identical(
                  other.aString,
                  aString,
                ) ||
                other.aString == aString) &&
            (identical(
                  other.aNullableString,
                  aNullableString,
                ) ||
                other.aNullableString == aNullableString) &&
            (identical(
                  other.aDateTime,
                  aDateTime,
                ) ||
                other.aDateTime == aDateTime) &&
            (identical(
                  other.aNullableDateTime,
                  aNullableDateTime,
                ) ||
                other.aNullableDateTime == aNullableDateTime) &&
            (identical(
                  other.aByteData,
                  aByteData,
                ) ||
                other.aByteData == aByteData) &&
            (identical(
                  other.aNullableByteData,
                  aNullableByteData,
                ) ||
                other.aNullableByteData == aNullableByteData) &&
            (identical(
                  other.aDuration,
                  aDuration,
                ) ||
                other.aDuration == aDuration) &&
            (identical(
                  other.aNullableDuration,
                  aNullableDuration,
                ) ||
                other.aNullableDuration == aNullableDuration) &&
            (identical(
                  other.aUuid,
                  aUuid,
                ) ||
                other.aUuid == aUuid) &&
            (identical(
                  other.aNullableUuid,
                  aNullableUuid,
                ) ||
                other.aNullableUuid == aNullableUuid) &&
            (identical(
                  other.anObject,
                  anObject,
                ) ||
                other.anObject == anObject) &&
            (identical(
                  other.aNullableObject,
                  aNullableObject,
                ) ||
                other.aNullableObject == aNullableObject) &&
            const _i4.DeepCollectionEquality().equals(
              anIntList,
              other.anIntList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableIntList,
              other.aNullableIntList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aListWithNullableInts,
              other.aListWithNullableInts,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableListWithNullableInts,
              other.aNullableListWithNullableInts,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              anObjectList,
              other.anObjectList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableObjectList,
              other.aNullableObjectList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aListWithNullableObjects,
              other.aListWithNullableObjects,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableListWithNullableObjects,
              other.aNullableListWithNullableObjects,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aDateTimeList,
              other.aDateTimeList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableDateTimeList,
              other.aNullableDateTimeList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aListWithNullableDateTimes,
              other.aListWithNullableDateTimes,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableListWithNullableDateTimes,
              other.aNullableListWithNullableDateTimes,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aByteDataList,
              other.aByteDataList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableByteDataList,
              other.aNullableByteDataList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aListWithNullableByteDatas,
              other.aListWithNullableByteDatas,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableListWithNullableByteDatas,
              other.aNullableListWithNullableByteDatas,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aDurationList,
              other.aDurationList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableDurationList,
              other.aNullableDurationList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aListWithNullableDurations,
              other.aListWithNullableDurations,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableListWithNullableDurations,
              other.aNullableListWithNullableDurations,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aUuidList,
              other.aUuidList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableUuidList,
              other.aNullableUuidList,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aListWithNullableUuids,
              other.aListWithNullableUuids,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableListWithNullableUuids,
              other.aNullableListWithNullableUuids,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              anIntMap,
              other.anIntMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableIntMap,
              other.aNullableIntMap,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aMapWithNullableInts,
              other.aMapWithNullableInts,
            ) &&
            const _i4.DeepCollectionEquality().equals(
              aNullableMapWithNullableInts,
              other.aNullableMapWithNullableInts,
            ));
  }

  @override
  int get hashCode => Object.hashAll([
        anInt,
        aNullableInt,
        aDouble,
        aNullableDouble,
        aBool,
        aNullableBool,
        aString,
        aNullableString,
        aDateTime,
        aNullableDateTime,
        aByteData,
        aNullableByteData,
        aDuration,
        aNullableDuration,
        aUuid,
        aNullableUuid,
        anObject,
        aNullableObject,
        const _i4.DeepCollectionEquality().hash(anIntList),
        const _i4.DeepCollectionEquality().hash(aNullableIntList),
        const _i4.DeepCollectionEquality().hash(aListWithNullableInts),
        const _i4.DeepCollectionEquality().hash(aNullableListWithNullableInts),
        const _i4.DeepCollectionEquality().hash(anObjectList),
        const _i4.DeepCollectionEquality().hash(aNullableObjectList),
        const _i4.DeepCollectionEquality().hash(aListWithNullableObjects),
        const _i4.DeepCollectionEquality()
            .hash(aNullableListWithNullableObjects),
        const _i4.DeepCollectionEquality().hash(aDateTimeList),
        const _i4.DeepCollectionEquality().hash(aNullableDateTimeList),
        const _i4.DeepCollectionEquality().hash(aListWithNullableDateTimes),
        const _i4.DeepCollectionEquality()
            .hash(aNullableListWithNullableDateTimes),
        const _i4.DeepCollectionEquality().hash(aByteDataList),
        const _i4.DeepCollectionEquality().hash(aNullableByteDataList),
        const _i4.DeepCollectionEquality().hash(aListWithNullableByteDatas),
        const _i4.DeepCollectionEquality()
            .hash(aNullableListWithNullableByteDatas),
        const _i4.DeepCollectionEquality().hash(aDurationList),
        const _i4.DeepCollectionEquality().hash(aNullableDurationList),
        const _i4.DeepCollectionEquality().hash(aListWithNullableDurations),
        const _i4.DeepCollectionEquality()
            .hash(aNullableListWithNullableDurations),
        const _i4.DeepCollectionEquality().hash(aUuidList),
        const _i4.DeepCollectionEquality().hash(aNullableUuidList),
        const _i4.DeepCollectionEquality().hash(aListWithNullableUuids),
        const _i4.DeepCollectionEquality().hash(aNullableListWithNullableUuids),
        const _i4.DeepCollectionEquality().hash(anIntMap),
        const _i4.DeepCollectionEquality().hash(aNullableIntMap),
        const _i4.DeepCollectionEquality().hash(aMapWithNullableInts),
        const _i4.DeepCollectionEquality().hash(aNullableMapWithNullableInts),
      ]);

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
      aNullableInt: aNullableInt == _Undefined
          ? this.aNullableInt
          : (aNullableInt as int?),
      aDouble: aDouble ?? this.aDouble,
      aNullableDouble: aNullableDouble == _Undefined
          ? this.aNullableDouble
          : (aNullableDouble as double?),
      aBool: aBool ?? this.aBool,
      aNullableBool: aNullableBool == _Undefined
          ? this.aNullableBool
          : (aNullableBool as bool?),
      aString: aString ?? this.aString,
      aNullableString: aNullableString == _Undefined
          ? this.aNullableString
          : (aNullableString as String?),
      aDateTime: aDateTime ?? this.aDateTime,
      aNullableDateTime: aNullableDateTime == _Undefined
          ? this.aNullableDateTime
          : (aNullableDateTime as DateTime?),
      aByteData: aByteData ?? this.aByteData,
      aNullableByteData: aNullableByteData == _Undefined
          ? this.aNullableByteData
          : (aNullableByteData as _i2.ByteData?),
      aDuration: aDuration ?? this.aDuration,
      aNullableDuration: aNullableDuration == _Undefined
          ? this.aNullableDuration
          : (aNullableDuration as Duration?),
      aUuid: aUuid ?? this.aUuid,
      aNullableUuid: aNullableUuid == _Undefined
          ? this.aNullableUuid
          : (aNullableUuid as _i1.UuidValue?),
      anObject: anObject ?? this.anObject,
      aNullableObject: aNullableObject == _Undefined
          ? this.aNullableObject
          : (aNullableObject as _i3.SimpleData?),
      anIntList: anIntList ?? this.anIntList,
      aNullableIntList: aNullableIntList == _Undefined
          ? this.aNullableIntList
          : (aNullableIntList as List<int>?),
      aListWithNullableInts:
          aListWithNullableInts ?? this.aListWithNullableInts,
      aNullableListWithNullableInts: aNullableListWithNullableInts == _Undefined
          ? this.aNullableListWithNullableInts
          : (aNullableListWithNullableInts as List<int?>?),
      anObjectList: anObjectList ?? this.anObjectList,
      aNullableObjectList: aNullableObjectList == _Undefined
          ? this.aNullableObjectList
          : (aNullableObjectList as List<_i3.SimpleData>?),
      aListWithNullableObjects:
          aListWithNullableObjects ?? this.aListWithNullableObjects,
      aNullableListWithNullableObjects:
          aNullableListWithNullableObjects == _Undefined
              ? this.aNullableListWithNullableObjects
              : (aNullableListWithNullableObjects as List<_i3.SimpleData?>?),
      aDateTimeList: aDateTimeList ?? this.aDateTimeList,
      aNullableDateTimeList: aNullableDateTimeList == _Undefined
          ? this.aNullableDateTimeList
          : (aNullableDateTimeList as List<DateTime>?),
      aListWithNullableDateTimes:
          aListWithNullableDateTimes ?? this.aListWithNullableDateTimes,
      aNullableListWithNullableDateTimes:
          aNullableListWithNullableDateTimes == _Undefined
              ? this.aNullableListWithNullableDateTimes
              : (aNullableListWithNullableDateTimes as List<DateTime?>?),
      aByteDataList: aByteDataList ?? this.aByteDataList,
      aNullableByteDataList: aNullableByteDataList == _Undefined
          ? this.aNullableByteDataList
          : (aNullableByteDataList as List<_i2.ByteData>?),
      aListWithNullableByteDatas:
          aListWithNullableByteDatas ?? this.aListWithNullableByteDatas,
      aNullableListWithNullableByteDatas:
          aNullableListWithNullableByteDatas == _Undefined
              ? this.aNullableListWithNullableByteDatas
              : (aNullableListWithNullableByteDatas as List<_i2.ByteData?>?),
      aDurationList: aDurationList ?? this.aDurationList,
      aNullableDurationList: aNullableDurationList == _Undefined
          ? this.aNullableDurationList
          : (aNullableDurationList as List<Duration>?),
      aListWithNullableDurations:
          aListWithNullableDurations ?? this.aListWithNullableDurations,
      aNullableListWithNullableDurations:
          aNullableListWithNullableDurations == _Undefined
              ? this.aNullableListWithNullableDurations
              : (aNullableListWithNullableDurations as List<Duration?>?),
      aUuidList: aUuidList ?? this.aUuidList,
      aNullableUuidList: aNullableUuidList == _Undefined
          ? this.aNullableUuidList
          : (aNullableUuidList as List<_i1.UuidValue>?),
      aListWithNullableUuids:
          aListWithNullableUuids ?? this.aListWithNullableUuids,
      aNullableListWithNullableUuids:
          aNullableListWithNullableUuids == _Undefined
              ? this.aNullableListWithNullableUuids
              : (aNullableListWithNullableUuids as List<_i1.UuidValue?>?),
      anIntMap: anIntMap ?? this.anIntMap,
      aNullableIntMap: aNullableIntMap == _Undefined
          ? this.aNullableIntMap
          : (aNullableIntMap as Map<String, int>?),
      aMapWithNullableInts: aMapWithNullableInts ?? this.aMapWithNullableInts,
      aNullableMapWithNullableInts: aNullableMapWithNullableInts == _Undefined
          ? this.aNullableMapWithNullableInts
          : (aNullableMapWithNullableInts as Map<String, int?>?),
    );
  }
}
