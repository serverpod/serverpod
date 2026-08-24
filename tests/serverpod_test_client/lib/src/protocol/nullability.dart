/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'simple_data.dart' as _i0zisc0t;

abstract class Nullability
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _idt.ByteData aByteData,
    _idt.ByteData? aNullableByteData,
    required Duration aDuration,
    Duration? aNullableDuration,
    required _isc.UuidValue aUuid,
    _isc.UuidValue? aNullableUuid,
    required _i0zisc0t.SimpleData anObject,
    _i0zisc0t.SimpleData? aNullableObject,
    required List<int> anIntList,
    List<int>? aNullableIntList,
    required List<int?> aListWithNullableInts,
    List<int?>? aNullableListWithNullableInts,
    required List<_i0zisc0t.SimpleData> anObjectList,
    List<_i0zisc0t.SimpleData>? aNullableObjectList,
    required List<_i0zisc0t.SimpleData?> aListWithNullableObjects,
    List<_i0zisc0t.SimpleData?>? aNullableListWithNullableObjects,
    required List<DateTime> aDateTimeList,
    List<DateTime>? aNullableDateTimeList,
    required List<DateTime?> aListWithNullableDateTimes,
    List<DateTime?>? aNullableListWithNullableDateTimes,
    required List<_idt.ByteData> aByteDataList,
    List<_idt.ByteData>? aNullableByteDataList,
    required List<_idt.ByteData?> aListWithNullableByteDatas,
    List<_idt.ByteData?>? aNullableListWithNullableByteDatas,
    required List<Duration> aDurationList,
    List<Duration>? aNullableDurationList,
    required List<Duration?> aListWithNullableDurations,
    List<Duration?>? aNullableListWithNullableDurations,
    required List<_isc.UuidValue> aUuidList,
    List<_isc.UuidValue>? aNullableUuidList,
    required List<_isc.UuidValue?> aListWithNullableUuids,
    List<_isc.UuidValue?>? aNullableListWithNullableUuids,
    required Map<String, int> anIntMap,
    Map<String, int>? aNullableIntMap,
    required Map<String, int?> aMapWithNullableInts,
    Map<String, int?>? aNullableMapWithNullableInts,
  }) = _NullabilityImpl;

  factory Nullability.fromJson(Map<String, dynamic> jsonSerialization) {
    return Nullability(
      anInt: jsonSerialization['anInt'] as int,
      aNullableInt: jsonSerialization['aNullableInt'] as int?,
      aDouble: (jsonSerialization['aDouble'] as num).toDouble(),
      aNullableDouble: (jsonSerialization['aNullableDouble'] as num?)
          ?.toDouble(),
      aBool: _isc.BoolJsonExtension.fromJson(jsonSerialization['aBool']),
      aNullableBool: jsonSerialization['aNullableBool'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['aNullableBool']),
      aString: jsonSerialization['aString'] as String,
      aNullableString: jsonSerialization['aNullableString'] as String?,
      aDateTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['aDateTime'],
      ),
      aNullableDateTime: jsonSerialization['aNullableDateTime'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['aNullableDateTime'],
            ),
      aByteData: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['aByteData'],
      ),
      aNullableByteData: jsonSerialization['aNullableByteData'] == null
          ? null
          : _isc.ByteDataJsonExtension.fromJson(
              jsonSerialization['aNullableByteData'],
            ),
      aDuration: _isc.DurationJsonExtension.fromJson(
        jsonSerialization['aDuration'],
      ),
      aNullableDuration: jsonSerialization['aNullableDuration'] == null
          ? null
          : _isc.DurationJsonExtension.fromJson(
              jsonSerialization['aNullableDuration'],
            ),
      aUuid: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['aUuid']),
      aNullableUuid: jsonSerialization['aNullableUuid'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['aNullableUuid'],
            ),
      anObject: _iza9lbb5.Protocol().deserialize<_i0zisc0t.SimpleData>(
        jsonSerialization['anObject'],
      ),
      aNullableObject: jsonSerialization['aNullableObject'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_i0zisc0t.SimpleData>(
              jsonSerialization['aNullableObject'],
            ),
      anIntList: _iza9lbb5.Protocol().deserialize<List<int>>(
        jsonSerialization['anIntList'],
      ),
      aNullableIntList: jsonSerialization['aNullableIntList'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<int>>(
              jsonSerialization['aNullableIntList'],
            ),
      aListWithNullableInts: _iza9lbb5.Protocol().deserialize<List<int?>>(
        jsonSerialization['aListWithNullableInts'],
      ),
      aNullableListWithNullableInts:
          jsonSerialization['aNullableListWithNullableInts'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<int?>>(
              jsonSerialization['aNullableListWithNullableInts'],
            ),
      anObjectList: _iza9lbb5.Protocol()
          .deserialize<List<_i0zisc0t.SimpleData>>(
            jsonSerialization['anObjectList'],
          ),
      aNullableObjectList: jsonSerialization['aNullableObjectList'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_i0zisc0t.SimpleData>>(
              jsonSerialization['aNullableObjectList'],
            ),
      aListWithNullableObjects: _iza9lbb5.Protocol()
          .deserialize<List<_i0zisc0t.SimpleData?>>(
            jsonSerialization['aListWithNullableObjects'],
          ),
      aNullableListWithNullableObjects:
          jsonSerialization['aNullableListWithNullableObjects'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_i0zisc0t.SimpleData?>>(
              jsonSerialization['aNullableListWithNullableObjects'],
            ),
      aDateTimeList: _iza9lbb5.Protocol().deserialize<List<DateTime>>(
        jsonSerialization['aDateTimeList'],
      ),
      aNullableDateTimeList: jsonSerialization['aNullableDateTimeList'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<DateTime>>(
              jsonSerialization['aNullableDateTimeList'],
            ),
      aListWithNullableDateTimes: _iza9lbb5.Protocol()
          .deserialize<List<DateTime?>>(
            jsonSerialization['aListWithNullableDateTimes'],
          ),
      aNullableListWithNullableDateTimes:
          jsonSerialization['aNullableListWithNullableDateTimes'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<DateTime?>>(
              jsonSerialization['aNullableListWithNullableDateTimes'],
            ),
      aByteDataList: _iza9lbb5.Protocol().deserialize<List<_idt.ByteData>>(
        jsonSerialization['aByteDataList'],
      ),
      aNullableByteDataList: jsonSerialization['aNullableByteDataList'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_idt.ByteData>>(
              jsonSerialization['aNullableByteDataList'],
            ),
      aListWithNullableByteDatas: _iza9lbb5.Protocol()
          .deserialize<List<_idt.ByteData?>>(
            jsonSerialization['aListWithNullableByteDatas'],
          ),
      aNullableListWithNullableByteDatas:
          jsonSerialization['aNullableListWithNullableByteDatas'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_idt.ByteData?>>(
              jsonSerialization['aNullableListWithNullableByteDatas'],
            ),
      aDurationList: _iza9lbb5.Protocol().deserialize<List<Duration>>(
        jsonSerialization['aDurationList'],
      ),
      aNullableDurationList: jsonSerialization['aNullableDurationList'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<Duration>>(
              jsonSerialization['aNullableDurationList'],
            ),
      aListWithNullableDurations: _iza9lbb5.Protocol()
          .deserialize<List<Duration?>>(
            jsonSerialization['aListWithNullableDurations'],
          ),
      aNullableListWithNullableDurations:
          jsonSerialization['aNullableListWithNullableDurations'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<Duration?>>(
              jsonSerialization['aNullableListWithNullableDurations'],
            ),
      aUuidList: _iza9lbb5.Protocol().deserialize<List<_isc.UuidValue>>(
        jsonSerialization['aUuidList'],
      ),
      aNullableUuidList: jsonSerialization['aNullableUuidList'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_isc.UuidValue>>(
              jsonSerialization['aNullableUuidList'],
            ),
      aListWithNullableUuids: _iza9lbb5.Protocol()
          .deserialize<List<_isc.UuidValue?>>(
            jsonSerialization['aListWithNullableUuids'],
          ),
      aNullableListWithNullableUuids:
          jsonSerialization['aNullableListWithNullableUuids'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_isc.UuidValue?>>(
              jsonSerialization['aNullableListWithNullableUuids'],
            ),
      anIntMap: _iza9lbb5.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['anIntMap'],
      ),
      aNullableIntMap: jsonSerialization['aNullableIntMap'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, int>>(
              jsonSerialization['aNullableIntMap'],
            ),
      aMapWithNullableInts: _iza9lbb5.Protocol().deserialize<Map<String, int?>>(
        jsonSerialization['aMapWithNullableInts'],
      ),
      aNullableMapWithNullableInts:
          jsonSerialization['aNullableMapWithNullableInts'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, int?>>(
              jsonSerialization['aNullableMapWithNullableInts'],
            ),
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

  _idt.ByteData aByteData;

  _idt.ByteData? aNullableByteData;

  Duration aDuration;

  Duration? aNullableDuration;

  _isc.UuidValue aUuid;

  _isc.UuidValue? aNullableUuid;

  _i0zisc0t.SimpleData anObject;

  _i0zisc0t.SimpleData? aNullableObject;

  List<int> anIntList;

  List<int>? aNullableIntList;

  List<int?> aListWithNullableInts;

  List<int?>? aNullableListWithNullableInts;

  List<_i0zisc0t.SimpleData> anObjectList;

  List<_i0zisc0t.SimpleData>? aNullableObjectList;

  List<_i0zisc0t.SimpleData?> aListWithNullableObjects;

  List<_i0zisc0t.SimpleData?>? aNullableListWithNullableObjects;

  List<DateTime> aDateTimeList;

  List<DateTime>? aNullableDateTimeList;

  List<DateTime?> aListWithNullableDateTimes;

  List<DateTime?>? aNullableListWithNullableDateTimes;

  List<_idt.ByteData> aByteDataList;

  List<_idt.ByteData>? aNullableByteDataList;

  List<_idt.ByteData?> aListWithNullableByteDatas;

  List<_idt.ByteData?>? aNullableListWithNullableByteDatas;

  List<Duration> aDurationList;

  List<Duration>? aNullableDurationList;

  List<Duration?> aListWithNullableDurations;

  List<Duration?>? aNullableListWithNullableDurations;

  List<_isc.UuidValue> aUuidList;

  List<_isc.UuidValue>? aNullableUuidList;

  List<_isc.UuidValue?> aListWithNullableUuids;

  List<_isc.UuidValue?>? aNullableListWithNullableUuids;

  Map<String, int> anIntMap;

  Map<String, int>? aNullableIntMap;

  Map<String, int?> aMapWithNullableInts;

  Map<String, int?>? aNullableMapWithNullableInts;

  /// Returns a shallow copy of this [Nullability]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
    _idt.ByteData? aByteData,
    _idt.ByteData? aNullableByteData,
    Duration? aDuration,
    Duration? aNullableDuration,
    _isc.UuidValue? aUuid,
    _isc.UuidValue? aNullableUuid,
    _i0zisc0t.SimpleData? anObject,
    _i0zisc0t.SimpleData? aNullableObject,
    List<int>? anIntList,
    List<int>? aNullableIntList,
    List<int?>? aListWithNullableInts,
    List<int?>? aNullableListWithNullableInts,
    List<_i0zisc0t.SimpleData>? anObjectList,
    List<_i0zisc0t.SimpleData>? aNullableObjectList,
    List<_i0zisc0t.SimpleData?>? aListWithNullableObjects,
    List<_i0zisc0t.SimpleData?>? aNullableListWithNullableObjects,
    List<DateTime>? aDateTimeList,
    List<DateTime>? aNullableDateTimeList,
    List<DateTime?>? aListWithNullableDateTimes,
    List<DateTime?>? aNullableListWithNullableDateTimes,
    List<_idt.ByteData>? aByteDataList,
    List<_idt.ByteData>? aNullableByteDataList,
    List<_idt.ByteData?>? aListWithNullableByteDatas,
    List<_idt.ByteData?>? aNullableListWithNullableByteDatas,
    List<Duration>? aDurationList,
    List<Duration>? aNullableDurationList,
    List<Duration?>? aListWithNullableDurations,
    List<Duration?>? aNullableListWithNullableDurations,
    List<_isc.UuidValue>? aUuidList,
    List<_isc.UuidValue>? aNullableUuidList,
    List<_isc.UuidValue?>? aListWithNullableUuids,
    List<_isc.UuidValue?>? aNullableListWithNullableUuids,
    Map<String, int>? anIntMap,
    Map<String, int>? aNullableIntMap,
    Map<String, int?>? aMapWithNullableInts,
    Map<String, int?>? aNullableMapWithNullableInts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Nullability',
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
        'aNullableListWithNullableInts': aNullableListWithNullableInts
            ?.toJson(),
      'anObjectList': anObjectList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableObjectList != null)
        'aNullableObjectList': aNullableObjectList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableObjects': aListWithNullableObjects.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (aNullableListWithNullableObjects != null)
        'aNullableListWithNullableObjects': aNullableListWithNullableObjects
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aDateTimeList': aDateTimeList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDateTimeList != null)
        'aNullableDateTimeList': aNullableDateTimeList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableDateTimes': aListWithNullableDateTimes.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (aNullableListWithNullableDateTimes != null)
        'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aByteDataList': aByteDataList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableByteDataList != null)
        'aNullableByteDataList': aNullableByteDataList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableByteDatas': aListWithNullableByteDatas.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (aNullableListWithNullableByteDatas != null)
        'aNullableListWithNullableByteDatas': aNullableListWithNullableByteDatas
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aDurationList': aDurationList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDurationList != null)
        'aNullableDurationList': aNullableDurationList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableDurations': aListWithNullableDurations.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (aNullableListWithNullableDurations != null)
        'aNullableListWithNullableDurations': aNullableListWithNullableDurations
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aUuidList': aUuidList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableUuidList != null)
        'aNullableUuidList': aNullableUuidList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableUuids': aListWithNullableUuids.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Nullability',
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
      'anObject': anObject.toJsonForProtocol(),
      if (aNullableObject != null)
        'aNullableObject': aNullableObject?.toJsonForProtocol(),
      'anIntList': anIntList.toJson(),
      if (aNullableIntList != null)
        'aNullableIntList': aNullableIntList?.toJson(),
      'aListWithNullableInts': aListWithNullableInts.toJson(),
      if (aNullableListWithNullableInts != null)
        'aNullableListWithNullableInts': aNullableListWithNullableInts
            ?.toJson(),
      'anObjectList': anObjectList.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (aNullableObjectList != null)
        'aNullableObjectList': aNullableObjectList?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'aListWithNullableObjects': aListWithNullableObjects.toJson(
        valueToJson: (v) => v?.toJsonForProtocol(),
      ),
      if (aNullableListWithNullableObjects != null)
        'aNullableListWithNullableObjects': aNullableListWithNullableObjects
            ?.toJson(valueToJson: (v) => v?.toJsonForProtocol()),
      'aDateTimeList': aDateTimeList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDateTimeList != null)
        'aNullableDateTimeList': aNullableDateTimeList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableDateTimes': aListWithNullableDateTimes.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (aNullableListWithNullableDateTimes != null)
        'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aByteDataList': aByteDataList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableByteDataList != null)
        'aNullableByteDataList': aNullableByteDataList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableByteDatas': aListWithNullableByteDatas.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (aNullableListWithNullableByteDatas != null)
        'aNullableListWithNullableByteDatas': aNullableListWithNullableByteDatas
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aDurationList': aDurationList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableDurationList != null)
        'aNullableDurationList': aNullableDurationList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableDurations': aListWithNullableDurations.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (aNullableListWithNullableDurations != null)
        'aNullableListWithNullableDurations': aNullableListWithNullableDurations
            ?.toJson(valueToJson: (v) => v?.toJson()),
      'aUuidList': aUuidList.toJson(valueToJson: (v) => v.toJson()),
      if (aNullableUuidList != null)
        'aNullableUuidList': aNullableUuidList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'aListWithNullableUuids': aListWithNullableUuids.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
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
  String toString() {
    return _isc.SerializationManager.encode(this);
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
    required _idt.ByteData aByteData,
    _idt.ByteData? aNullableByteData,
    required Duration aDuration,
    Duration? aNullableDuration,
    required _isc.UuidValue aUuid,
    _isc.UuidValue? aNullableUuid,
    required _i0zisc0t.SimpleData anObject,
    _i0zisc0t.SimpleData? aNullableObject,
    required List<int> anIntList,
    List<int>? aNullableIntList,
    required List<int?> aListWithNullableInts,
    List<int?>? aNullableListWithNullableInts,
    required List<_i0zisc0t.SimpleData> anObjectList,
    List<_i0zisc0t.SimpleData>? aNullableObjectList,
    required List<_i0zisc0t.SimpleData?> aListWithNullableObjects,
    List<_i0zisc0t.SimpleData?>? aNullableListWithNullableObjects,
    required List<DateTime> aDateTimeList,
    List<DateTime>? aNullableDateTimeList,
    required List<DateTime?> aListWithNullableDateTimes,
    List<DateTime?>? aNullableListWithNullableDateTimes,
    required List<_idt.ByteData> aByteDataList,
    List<_idt.ByteData>? aNullableByteDataList,
    required List<_idt.ByteData?> aListWithNullableByteDatas,
    List<_idt.ByteData?>? aNullableListWithNullableByteDatas,
    required List<Duration> aDurationList,
    List<Duration>? aNullableDurationList,
    required List<Duration?> aListWithNullableDurations,
    List<Duration?>? aNullableListWithNullableDurations,
    required List<_isc.UuidValue> aUuidList,
    List<_isc.UuidValue>? aNullableUuidList,
    required List<_isc.UuidValue?> aListWithNullableUuids,
    List<_isc.UuidValue?>? aNullableListWithNullableUuids,
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
         aNullableListWithNullableDateTimes: aNullableListWithNullableDateTimes,
         aByteDataList: aByteDataList,
         aNullableByteDataList: aNullableByteDataList,
         aListWithNullableByteDatas: aListWithNullableByteDatas,
         aNullableListWithNullableByteDatas: aNullableListWithNullableByteDatas,
         aDurationList: aDurationList,
         aNullableDurationList: aNullableDurationList,
         aListWithNullableDurations: aListWithNullableDurations,
         aNullableListWithNullableDurations: aNullableListWithNullableDurations,
         aUuidList: aUuidList,
         aNullableUuidList: aNullableUuidList,
         aListWithNullableUuids: aListWithNullableUuids,
         aNullableListWithNullableUuids: aNullableListWithNullableUuids,
         anIntMap: anIntMap,
         aNullableIntMap: aNullableIntMap,
         aMapWithNullableInts: aMapWithNullableInts,
         aNullableMapWithNullableInts: aNullableMapWithNullableInts,
       );

  /// Returns a shallow copy of this [Nullability]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
    _idt.ByteData? aByteData,
    Object? aNullableByteData = _Undefined,
    Duration? aDuration,
    Object? aNullableDuration = _Undefined,
    _isc.UuidValue? aUuid,
    Object? aNullableUuid = _Undefined,
    _i0zisc0t.SimpleData? anObject,
    Object? aNullableObject = _Undefined,
    List<int>? anIntList,
    Object? aNullableIntList = _Undefined,
    List<int?>? aListWithNullableInts,
    Object? aNullableListWithNullableInts = _Undefined,
    List<_i0zisc0t.SimpleData>? anObjectList,
    Object? aNullableObjectList = _Undefined,
    List<_i0zisc0t.SimpleData?>? aListWithNullableObjects,
    Object? aNullableListWithNullableObjects = _Undefined,
    List<DateTime>? aDateTimeList,
    Object? aNullableDateTimeList = _Undefined,
    List<DateTime?>? aListWithNullableDateTimes,
    Object? aNullableListWithNullableDateTimes = _Undefined,
    List<_idt.ByteData>? aByteDataList,
    Object? aNullableByteDataList = _Undefined,
    List<_idt.ByteData?>? aListWithNullableByteDatas,
    Object? aNullableListWithNullableByteDatas = _Undefined,
    List<Duration>? aDurationList,
    Object? aNullableDurationList = _Undefined,
    List<Duration?>? aListWithNullableDurations,
    Object? aNullableListWithNullableDurations = _Undefined,
    List<_isc.UuidValue>? aUuidList,
    Object? aNullableUuidList = _Undefined,
    List<_isc.UuidValue?>? aListWithNullableUuids,
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
      aNullableDouble: aNullableDouble is double?
          ? aNullableDouble
          : this.aNullableDouble,
      aBool: aBool ?? this.aBool,
      aNullableBool: aNullableBool is bool?
          ? aNullableBool
          : this.aNullableBool,
      aString: aString ?? this.aString,
      aNullableString: aNullableString is String?
          ? aNullableString
          : this.aNullableString,
      aDateTime: aDateTime ?? this.aDateTime,
      aNullableDateTime: aNullableDateTime is DateTime?
          ? aNullableDateTime
          : this.aNullableDateTime,
      aByteData: aByteData ?? this.aByteData.clone(),
      aNullableByteData: aNullableByteData is _idt.ByteData?
          ? aNullableByteData
          : this.aNullableByteData?.clone(),
      aDuration: aDuration ?? this.aDuration,
      aNullableDuration: aNullableDuration is Duration?
          ? aNullableDuration
          : this.aNullableDuration,
      aUuid: aUuid ?? this.aUuid,
      aNullableUuid: aNullableUuid is _isc.UuidValue?
          ? aNullableUuid
          : this.aNullableUuid,
      anObject: anObject ?? this.anObject.copyWith(),
      aNullableObject: aNullableObject is _i0zisc0t.SimpleData?
          ? aNullableObject
          : this.aNullableObject?.copyWith(),
      anIntList: anIntList ?? this.anIntList.map((e0) => e0).toList(),
      aNullableIntList: aNullableIntList is List<int>?
          ? aNullableIntList
          : this.aNullableIntList?.map((e0) => e0).toList(),
      aListWithNullableInts:
          aListWithNullableInts ??
          this.aListWithNullableInts.map((e0) => e0).toList(),
      aNullableListWithNullableInts:
          aNullableListWithNullableInts is List<int?>?
          ? aNullableListWithNullableInts
          : this.aNullableListWithNullableInts?.map((e0) => e0).toList(),
      anObjectList:
          anObjectList ?? this.anObjectList.map((e0) => e0.copyWith()).toList(),
      aNullableObjectList: aNullableObjectList is List<_i0zisc0t.SimpleData>?
          ? aNullableObjectList
          : this.aNullableObjectList?.map((e0) => e0.copyWith()).toList(),
      aListWithNullableObjects:
          aListWithNullableObjects ??
          this.aListWithNullableObjects.map((e0) => e0?.copyWith()).toList(),
      aNullableListWithNullableObjects:
          aNullableListWithNullableObjects is List<_i0zisc0t.SimpleData?>?
          ? aNullableListWithNullableObjects
          : this.aNullableListWithNullableObjects
                ?.map((e0) => e0?.copyWith())
                .toList(),
      aDateTimeList:
          aDateTimeList ?? this.aDateTimeList.map((e0) => e0).toList(),
      aNullableDateTimeList: aNullableDateTimeList is List<DateTime>?
          ? aNullableDateTimeList
          : this.aNullableDateTimeList?.map((e0) => e0).toList(),
      aListWithNullableDateTimes:
          aListWithNullableDateTimes ??
          this.aListWithNullableDateTimes.map((e0) => e0).toList(),
      aNullableListWithNullableDateTimes:
          aNullableListWithNullableDateTimes is List<DateTime?>?
          ? aNullableListWithNullableDateTimes
          : this.aNullableListWithNullableDateTimes?.map((e0) => e0).toList(),
      aByteDataList:
          aByteDataList ?? this.aByteDataList.map((e0) => e0.clone()).toList(),
      aNullableByteDataList: aNullableByteDataList is List<_idt.ByteData>?
          ? aNullableByteDataList
          : this.aNullableByteDataList?.map((e0) => e0.clone()).toList(),
      aListWithNullableByteDatas:
          aListWithNullableByteDatas ??
          this.aListWithNullableByteDatas.map((e0) => e0?.clone()).toList(),
      aNullableListWithNullableByteDatas:
          aNullableListWithNullableByteDatas is List<_idt.ByteData?>?
          ? aNullableListWithNullableByteDatas
          : this.aNullableListWithNullableByteDatas
                ?.map((e0) => e0?.clone())
                .toList(),
      aDurationList:
          aDurationList ?? this.aDurationList.map((e0) => e0).toList(),
      aNullableDurationList: aNullableDurationList is List<Duration>?
          ? aNullableDurationList
          : this.aNullableDurationList?.map((e0) => e0).toList(),
      aListWithNullableDurations:
          aListWithNullableDurations ??
          this.aListWithNullableDurations.map((e0) => e0).toList(),
      aNullableListWithNullableDurations:
          aNullableListWithNullableDurations is List<Duration?>?
          ? aNullableListWithNullableDurations
          : this.aNullableListWithNullableDurations?.map((e0) => e0).toList(),
      aUuidList: aUuidList ?? this.aUuidList.map((e0) => e0).toList(),
      aNullableUuidList: aNullableUuidList is List<_isc.UuidValue>?
          ? aNullableUuidList
          : this.aNullableUuidList?.map((e0) => e0).toList(),
      aListWithNullableUuids:
          aListWithNullableUuids ??
          this.aListWithNullableUuids.map((e0) => e0).toList(),
      aNullableListWithNullableUuids:
          aNullableListWithNullableUuids is List<_isc.UuidValue?>?
          ? aNullableListWithNullableUuids
          : this.aNullableListWithNullableUuids?.map((e0) => e0).toList(),
      anIntMap:
          anIntMap ??
          this.anIntMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      aNullableIntMap: aNullableIntMap is Map<String, int>?
          ? aNullableIntMap
          : this.aNullableIntMap?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      aMapWithNullableInts:
          aMapWithNullableInts ??
          this.aMapWithNullableInts.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      aNullableMapWithNullableInts:
          aNullableMapWithNullableInts is Map<String, int?>?
          ? aNullableMapWithNullableInts
          : this.aNullableMapWithNullableInts?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
    );
  }
}
