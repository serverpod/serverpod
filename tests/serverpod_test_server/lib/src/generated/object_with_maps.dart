/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'simple_data.dart' as _i2;
import 'dart:typed_data' as _i3;

abstract class ObjectWithMaps
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ObjectWithMaps._({
    required this.dataMap,
    required this.intMap,
    required this.stringMap,
    required this.dateTimeMap,
    required this.byteDataMap,
    required this.durationMap,
    required this.uuidMap,
    required this.nullableDataMap,
    required this.nullableIntMap,
    required this.nullableStringMap,
    required this.nullableDateTimeMap,
    required this.nullableByteDataMap,
    required this.nullableDurationMap,
    required this.nullableUuidMap,
    required this.intIntMap,
  });

  factory ObjectWithMaps({
    required Map<String, _i2.SimpleData> dataMap,
    required Map<String, int> intMap,
    required Map<String, String> stringMap,
    required Map<String, DateTime> dateTimeMap,
    required Map<String, _i3.ByteData> byteDataMap,
    required Map<String, Duration> durationMap,
    required Map<String, _i1.UuidValue> uuidMap,
    required Map<String, _i2.SimpleData?> nullableDataMap,
    required Map<String, int?> nullableIntMap,
    required Map<String, String?> nullableStringMap,
    required Map<String, DateTime?> nullableDateTimeMap,
    required Map<String, _i3.ByteData?> nullableByteDataMap,
    required Map<String, Duration?> nullableDurationMap,
    required Map<String, _i1.UuidValue?> nullableUuidMap,
    required Map<int, int> intIntMap,
  }) = _ObjectWithMapsImpl;

  factory ObjectWithMaps.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithMaps(
      dataMap: (jsonSerialization['dataMap'] as Map).map((k, v) => MapEntry(
            k as String,
            _i2.SimpleData.fromJson((v as Map<String, dynamic>)),
          )),
      intMap: (jsonSerialization['intMap'] as Map).map((k, v) => MapEntry(
            k as String,
            v as int,
          )),
      stringMap: (jsonSerialization['stringMap'] as Map).map((k, v) => MapEntry(
            k as String,
            v as String,
          )),
      dateTimeMap:
          (jsonSerialization['dateTimeMap'] as Map).map((k, v) => MapEntry(
                k as String,
                _i1.DateTimeJsonExtension.fromJson(v),
              )),
      byteDataMap:
          (jsonSerialization['byteDataMap'] as Map).map((k, v) => MapEntry(
                k as String,
                _i1.ByteDataJsonExtension.fromJson(v),
              )),
      durationMap:
          (jsonSerialization['durationMap'] as Map).map((k, v) => MapEntry(
                k as String,
                _i1.DurationJsonExtension.fromJson(v),
              )),
      uuidMap: (jsonSerialization['uuidMap'] as Map).map((k, v) => MapEntry(
            k as String,
            _i1.UuidValueJsonExtension.fromJson(v),
          )),
      nullableDataMap:
          (jsonSerialization['nullableDataMap'] as Map).map((k, v) => MapEntry(
                k as String,
                v == null
                    ? null
                    : _i2.SimpleData.fromJson((v as Map<String, dynamic>)),
              )),
      nullableIntMap:
          (jsonSerialization['nullableIntMap'] as Map).map((k, v) => MapEntry(
                k as String,
                v as int?,
              )),
      nullableStringMap: (jsonSerialization['nullableStringMap'] as Map)
          .map((k, v) => MapEntry(
                k as String,
                v as String?,
              )),
      nullableDateTimeMap: (jsonSerialization['nullableDateTimeMap'] as Map)
          .map((k, v) => MapEntry(
                k as String,
                v == null ? null : _i1.DateTimeJsonExtension.fromJson(v),
              )),
      nullableByteDataMap: (jsonSerialization['nullableByteDataMap'] as Map)
          .map((k, v) => MapEntry(
                k as String,
                v == null ? null : _i1.ByteDataJsonExtension.fromJson(v),
              )),
      nullableDurationMap: (jsonSerialization['nullableDurationMap'] as Map)
          .map((k, v) => MapEntry(
                k as String,
                v == null ? null : _i1.DurationJsonExtension.fromJson(v),
              )),
      nullableUuidMap:
          (jsonSerialization['nullableUuidMap'] as Map).map((k, v) => MapEntry(
                k as String,
                v == null ? null : _i1.UuidValueJsonExtension.fromJson(v),
              )),
      intIntMap: (jsonSerialization['intIntMap'] as List).fold<Map<int, int>>(
          {}, (t, e) => {...t, e['k'] as int: e['v'] as int}),
    );
  }

  Map<String, _i2.SimpleData> dataMap;

  Map<String, int> intMap;

  Map<String, String> stringMap;

  Map<String, DateTime> dateTimeMap;

  Map<String, _i3.ByteData> byteDataMap;

  Map<String, Duration> durationMap;

  Map<String, _i1.UuidValue> uuidMap;

  Map<String, _i2.SimpleData?> nullableDataMap;

  Map<String, int?> nullableIntMap;

  Map<String, String?> nullableStringMap;

  Map<String, DateTime?> nullableDateTimeMap;

  Map<String, _i3.ByteData?> nullableByteDataMap;

  Map<String, Duration?> nullableDurationMap;

  Map<String, _i1.UuidValue?> nullableUuidMap;

  Map<int, int> intIntMap;

  /// Returns a shallow copy of this [ObjectWithMaps]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithMaps copyWith({
    Map<String, _i2.SimpleData>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _i3.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _i1.UuidValue>? uuidMap,
    Map<String, _i2.SimpleData?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _i3.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _i1.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'dataMap': dataMap.toJson(valueToJson: (v) => v.toJson()),
      'intMap': intMap.toJson(),
      'stringMap': stringMap.toJson(),
      'dateTimeMap': dateTimeMap.toJson(valueToJson: (v) => v.toJson()),
      'byteDataMap': byteDataMap.toJson(valueToJson: (v) => v.toJson()),
      'durationMap': durationMap.toJson(valueToJson: (v) => v.toJson()),
      'uuidMap': uuidMap.toJson(valueToJson: (v) => v.toJson()),
      'nullableDataMap':
          nullableDataMap.toJson(valueToJson: (v) => v?.toJson()),
      'nullableIntMap': nullableIntMap.toJson(),
      'nullableStringMap': nullableStringMap.toJson(),
      'nullableDateTimeMap':
          nullableDateTimeMap.toJson(valueToJson: (v) => v?.toJson()),
      'nullableByteDataMap':
          nullableByteDataMap.toJson(valueToJson: (v) => v?.toJson()),
      'nullableDurationMap':
          nullableDurationMap.toJson(valueToJson: (v) => v?.toJson()),
      'nullableUuidMap':
          nullableUuidMap.toJson(valueToJson: (v) => v?.toJson()),
      'intIntMap': intIntMap.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'dataMap': dataMap.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'intMap': intMap.toJson(),
      'stringMap': stringMap.toJson(),
      'dateTimeMap': dateTimeMap.toJson(valueToJson: (v) => v.toJson()),
      'byteDataMap': byteDataMap.toJson(valueToJson: (v) => v.toJson()),
      'durationMap': durationMap.toJson(valueToJson: (v) => v.toJson()),
      'uuidMap': uuidMap.toJson(valueToJson: (v) => v.toJson()),
      'nullableDataMap':
          nullableDataMap.toJson(valueToJson: (v) => v?.toJsonForProtocol()),
      'nullableIntMap': nullableIntMap.toJson(),
      'nullableStringMap': nullableStringMap.toJson(),
      'nullableDateTimeMap':
          nullableDateTimeMap.toJson(valueToJson: (v) => v?.toJson()),
      'nullableByteDataMap':
          nullableByteDataMap.toJson(valueToJson: (v) => v?.toJson()),
      'nullableDurationMap':
          nullableDurationMap.toJson(valueToJson: (v) => v?.toJson()),
      'nullableUuidMap':
          nullableUuidMap.toJson(valueToJson: (v) => v?.toJson()),
      'intIntMap': intIntMap.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ObjectWithMapsImpl extends ObjectWithMaps {
  _ObjectWithMapsImpl({
    required Map<String, _i2.SimpleData> dataMap,
    required Map<String, int> intMap,
    required Map<String, String> stringMap,
    required Map<String, DateTime> dateTimeMap,
    required Map<String, _i3.ByteData> byteDataMap,
    required Map<String, Duration> durationMap,
    required Map<String, _i1.UuidValue> uuidMap,
    required Map<String, _i2.SimpleData?> nullableDataMap,
    required Map<String, int?> nullableIntMap,
    required Map<String, String?> nullableStringMap,
    required Map<String, DateTime?> nullableDateTimeMap,
    required Map<String, _i3.ByteData?> nullableByteDataMap,
    required Map<String, Duration?> nullableDurationMap,
    required Map<String, _i1.UuidValue?> nullableUuidMap,
    required Map<int, int> intIntMap,
  }) : super._(
          dataMap: dataMap,
          intMap: intMap,
          stringMap: stringMap,
          dateTimeMap: dateTimeMap,
          byteDataMap: byteDataMap,
          durationMap: durationMap,
          uuidMap: uuidMap,
          nullableDataMap: nullableDataMap,
          nullableIntMap: nullableIntMap,
          nullableStringMap: nullableStringMap,
          nullableDateTimeMap: nullableDateTimeMap,
          nullableByteDataMap: nullableByteDataMap,
          nullableDurationMap: nullableDurationMap,
          nullableUuidMap: nullableUuidMap,
          intIntMap: intIntMap,
        );

  /// Returns a shallow copy of this [ObjectWithMaps]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithMaps copyWith({
    Map<String, _i2.SimpleData>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _i3.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _i1.UuidValue>? uuidMap,
    Map<String, _i2.SimpleData?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _i3.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _i1.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  }) {
    return ObjectWithMaps(
      dataMap: dataMap ??
          this.dataMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.copyWith(),
                  )),
      intMap: intMap ??
          this.intMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      stringMap: stringMap ??
          this.stringMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      dateTimeMap: dateTimeMap ??
          this.dateTimeMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      byteDataMap: byteDataMap ??
          this.byteDataMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0.clone(),
                  )),
      durationMap: durationMap ??
          this.durationMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      uuidMap: uuidMap ??
          this.uuidMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      nullableDataMap: nullableDataMap ??
          this.nullableDataMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0?.copyWith(),
                  )),
      nullableIntMap: nullableIntMap ??
          this.nullableIntMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      nullableStringMap: nullableStringMap ??
          this.nullableStringMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      nullableDateTimeMap: nullableDateTimeMap ??
          this.nullableDateTimeMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      nullableByteDataMap: nullableByteDataMap ??
          this.nullableByteDataMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0?.clone(),
                  )),
      nullableDurationMap: nullableDurationMap ??
          this.nullableDurationMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      nullableUuidMap: nullableUuidMap ??
          this.nullableUuidMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      intIntMap: intIntMap ??
          this.intIntMap.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
    );
  }
}
