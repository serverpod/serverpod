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

  final int anInt;

  final int? aNullableInt;

  final double aDouble;

  final double? aNullableDouble;

  final bool aBool;

  final bool? aNullableBool;

  final String aString;

  final String? aNullableString;

  final DateTime aDateTime;

  final DateTime? aNullableDateTime;

  final _i2.ByteData aByteData;

  final _i2.ByteData? aNullableByteData;

  final Duration aDuration;

  final Duration? aNullableDuration;

  final _i1.UuidValue aUuid;

  final _i1.UuidValue? aNullableUuid;

  final _i3.SimpleData anObject;

  final _i3.SimpleData? aNullableObject;

  final List<int> anIntList;

  final List<int>? aNullableIntList;

  final List<int?> aListWithNullableInts;

  final List<int?>? aNullableListWithNullableInts;

  final List<_i3.SimpleData> anObjectList;

  final List<_i3.SimpleData>? aNullableObjectList;

  final List<_i3.SimpleData?> aListWithNullableObjects;

  final List<_i3.SimpleData?>? aNullableListWithNullableObjects;

  final List<DateTime> aDateTimeList;

  final List<DateTime>? aNullableDateTimeList;

  final List<DateTime?> aListWithNullableDateTimes;

  final List<DateTime?>? aNullableListWithNullableDateTimes;

  final List<_i2.ByteData> aByteDataList;

  final List<_i2.ByteData>? aNullableByteDataList;

  final List<_i2.ByteData?> aListWithNullableByteDatas;

  final List<_i2.ByteData?>? aNullableListWithNullableByteDatas;

  final List<Duration> aDurationList;

  final List<Duration>? aNullableDurationList;

  final List<Duration?> aListWithNullableDurations;

  final List<Duration?>? aNullableListWithNullableDurations;

  final List<_i1.UuidValue> aUuidList;

  final List<_i1.UuidValue>? aNullableUuidList;

  final List<_i1.UuidValue?> aListWithNullableUuids;

  final List<_i1.UuidValue?>? aNullableListWithNullableUuids;

  final Map<String, int> anIntMap;

  final Map<String, int>? aNullableIntMap;

  final Map<String, int?> aMapWithNullableInts;

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
    return identical(this, other) ||
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
  }) {
    return Nullability(
      anInt: anInt ?? this.anInt,
      aNullableInt: aNullableInt ?? this.aNullableInt,
      aDouble: aDouble ?? this.aDouble,
      aNullableDouble: aNullableDouble ?? this.aNullableDouble,
      aBool: aBool ?? this.aBool,
      aNullableBool: aNullableBool ?? this.aNullableBool,
      aString: aString ?? this.aString,
      aNullableString: aNullableString ?? this.aNullableString,
      aDateTime: aDateTime ?? this.aDateTime,
      aNullableDateTime: aNullableDateTime ?? this.aNullableDateTime,
      aByteData: aByteData ?? this.aByteData,
      aNullableByteData: aNullableByteData ?? this.aNullableByteData,
      aDuration: aDuration ?? this.aDuration,
      aNullableDuration: aNullableDuration ?? this.aNullableDuration,
      aUuid: aUuid ?? this.aUuid,
      aNullableUuid: aNullableUuid ?? this.aNullableUuid,
      anObject: anObject ?? this.anObject,
      aNullableObject: aNullableObject ?? this.aNullableObject,
      anIntList: anIntList ?? this.anIntList,
      aNullableIntList: aNullableIntList ?? this.aNullableIntList,
      aListWithNullableInts:
          aListWithNullableInts ?? this.aListWithNullableInts,
      aNullableListWithNullableInts:
          aNullableListWithNullableInts ?? this.aNullableListWithNullableInts,
      anObjectList: anObjectList ?? this.anObjectList,
      aNullableObjectList: aNullableObjectList ?? this.aNullableObjectList,
      aListWithNullableObjects:
          aListWithNullableObjects ?? this.aListWithNullableObjects,
      aNullableListWithNullableObjects: aNullableListWithNullableObjects ??
          this.aNullableListWithNullableObjects,
      aDateTimeList: aDateTimeList ?? this.aDateTimeList,
      aNullableDateTimeList:
          aNullableDateTimeList ?? this.aNullableDateTimeList,
      aListWithNullableDateTimes:
          aListWithNullableDateTimes ?? this.aListWithNullableDateTimes,
      aNullableListWithNullableDateTimes: aNullableListWithNullableDateTimes ??
          this.aNullableListWithNullableDateTimes,
      aByteDataList: aByteDataList ?? this.aByteDataList,
      aNullableByteDataList:
          aNullableByteDataList ?? this.aNullableByteDataList,
      aListWithNullableByteDatas:
          aListWithNullableByteDatas ?? this.aListWithNullableByteDatas,
      aNullableListWithNullableByteDatas: aNullableListWithNullableByteDatas ??
          this.aNullableListWithNullableByteDatas,
      aDurationList: aDurationList ?? this.aDurationList,
      aNullableDurationList:
          aNullableDurationList ?? this.aNullableDurationList,
      aListWithNullableDurations:
          aListWithNullableDurations ?? this.aListWithNullableDurations,
      aNullableListWithNullableDurations: aNullableListWithNullableDurations ??
          this.aNullableListWithNullableDurations,
      aUuidList: aUuidList ?? this.aUuidList,
      aNullableUuidList: aNullableUuidList ?? this.aNullableUuidList,
      aListWithNullableUuids:
          aListWithNullableUuids ?? this.aListWithNullableUuids,
      aNullableListWithNullableUuids:
          aNullableListWithNullableUuids ?? this.aNullableListWithNullableUuids,
      anIntMap: anIntMap ?? this.anIntMap,
      aNullableIntMap: aNullableIntMap ?? this.aNullableIntMap,
      aMapWithNullableInts: aMapWithNullableInts ?? this.aMapWithNullableInts,
      aNullableMapWithNullableInts:
          aNullableMapWithNullableInts ?? this.aNullableMapWithNullableInts,
    );
  }
}
