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
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import 'simple_data.dart' as _i0zisc0t;

abstract class ObjectWithMaps
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required Map<String, _i0zisc0t.SimpleData> dataMap,
    required Map<String, int> intMap,
    required Map<String, String> stringMap,
    required Map<String, DateTime> dateTimeMap,
    required Map<String, _idt.ByteData> byteDataMap,
    required Map<String, Duration> durationMap,
    required Map<String, _isc.UuidValue> uuidMap,
    required Map<String, _i0zisc0t.SimpleData?> nullableDataMap,
    required Map<String, int?> nullableIntMap,
    required Map<String, String?> nullableStringMap,
    required Map<String, DateTime?> nullableDateTimeMap,
    required Map<String, _idt.ByteData?> nullableByteDataMap,
    required Map<String, Duration?> nullableDurationMap,
    required Map<String, _isc.UuidValue?> nullableUuidMap,
    required Map<int, int> intIntMap,
  }) = _ObjectWithMapsImpl;

  factory ObjectWithMaps.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithMaps(
      dataMap: _i0ntutnq.Protocol()
          .deserialize<Map<String, _i0zisc0t.SimpleData>>(
            jsonSerialization['dataMap'],
          ),
      intMap: _i0ntutnq.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['intMap'],
      ),
      stringMap: _i0ntutnq.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['stringMap'],
      ),
      dateTimeMap: _i0ntutnq.Protocol().deserialize<Map<String, DateTime>>(
        jsonSerialization['dateTimeMap'],
      ),
      byteDataMap: _i0ntutnq.Protocol().deserialize<Map<String, _idt.ByteData>>(
        jsonSerialization['byteDataMap'],
      ),
      durationMap: _i0ntutnq.Protocol().deserialize<Map<String, Duration>>(
        jsonSerialization['durationMap'],
      ),
      uuidMap: _i0ntutnq.Protocol().deserialize<Map<String, _isc.UuidValue>>(
        jsonSerialization['uuidMap'],
      ),
      nullableDataMap: _i0ntutnq.Protocol()
          .deserialize<Map<String, _i0zisc0t.SimpleData?>>(
            jsonSerialization['nullableDataMap'],
          ),
      nullableIntMap: _i0ntutnq.Protocol().deserialize<Map<String, int?>>(
        jsonSerialization['nullableIntMap'],
      ),
      nullableStringMap: _i0ntutnq.Protocol().deserialize<Map<String, String?>>(
        jsonSerialization['nullableStringMap'],
      ),
      nullableDateTimeMap: _i0ntutnq.Protocol()
          .deserialize<Map<String, DateTime?>>(
            jsonSerialization['nullableDateTimeMap'],
          ),
      nullableByteDataMap: _i0ntutnq.Protocol()
          .deserialize<Map<String, _idt.ByteData?>>(
            jsonSerialization['nullableByteDataMap'],
          ),
      nullableDurationMap: _i0ntutnq.Protocol()
          .deserialize<Map<String, Duration?>>(
            jsonSerialization['nullableDurationMap'],
          ),
      nullableUuidMap: _i0ntutnq.Protocol()
          .deserialize<Map<String, _isc.UuidValue?>>(
            jsonSerialization['nullableUuidMap'],
          ),
      intIntMap: _i0ntutnq.Protocol().deserialize<Map<int, int>>(
        jsonSerialization['intIntMap'],
      ),
    );
  }

  Map<String, _i0zisc0t.SimpleData> dataMap;

  Map<String, int> intMap;

  Map<String, String> stringMap;

  Map<String, DateTime> dateTimeMap;

  Map<String, _idt.ByteData> byteDataMap;

  Map<String, Duration> durationMap;

  Map<String, _isc.UuidValue> uuidMap;

  Map<String, _i0zisc0t.SimpleData?> nullableDataMap;

  Map<String, int?> nullableIntMap;

  Map<String, String?> nullableStringMap;

  Map<String, DateTime?> nullableDateTimeMap;

  Map<String, _idt.ByteData?> nullableByteDataMap;

  Map<String, Duration?> nullableDurationMap;

  Map<String, _isc.UuidValue?> nullableUuidMap;

  Map<int, int> intIntMap;

  /// Returns a shallow copy of this [ObjectWithMaps]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithMaps copyWith({
    Map<String, _i0zisc0t.SimpleData>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _idt.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _isc.UuidValue>? uuidMap,
    Map<String, _i0zisc0t.SimpleData?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _idt.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _isc.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithMaps',
      'dataMap': dataMap.toJson(valueToJson: (v) => v.toJson()),
      'intMap': intMap.toJson(),
      'stringMap': stringMap.toJson(),
      'dateTimeMap': dateTimeMap.toJson(valueToJson: (v) => v.toJson()),
      'byteDataMap': byteDataMap.toJson(valueToJson: (v) => v.toJson()),
      'durationMap': durationMap.toJson(valueToJson: (v) => v.toJson()),
      'uuidMap': uuidMap.toJson(valueToJson: (v) => v.toJson()),
      'nullableDataMap': nullableDataMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'nullableIntMap': nullableIntMap.toJson(),
      'nullableStringMap': nullableStringMap.toJson(),
      'nullableDateTimeMap': nullableDateTimeMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'nullableByteDataMap': nullableByteDataMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'nullableDurationMap': nullableDurationMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'nullableUuidMap': nullableUuidMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'intIntMap': intIntMap.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithMaps',
      'dataMap': dataMap.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'intMap': intMap.toJson(),
      'stringMap': stringMap.toJson(),
      'dateTimeMap': dateTimeMap.toJson(valueToJson: (v) => v.toJson()),
      'byteDataMap': byteDataMap.toJson(valueToJson: (v) => v.toJson()),
      'durationMap': durationMap.toJson(valueToJson: (v) => v.toJson()),
      'uuidMap': uuidMap.toJson(valueToJson: (v) => v.toJson()),
      'nullableDataMap': nullableDataMap.toJson(
        valueToJson: (v) => v?.toJsonForProtocol(),
      ),
      'nullableIntMap': nullableIntMap.toJson(),
      'nullableStringMap': nullableStringMap.toJson(),
      'nullableDateTimeMap': nullableDateTimeMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'nullableByteDataMap': nullableByteDataMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'nullableDurationMap': nullableDurationMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'nullableUuidMap': nullableUuidMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'intIntMap': intIntMap.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ObjectWithMapsImpl extends ObjectWithMaps {
  _ObjectWithMapsImpl({
    required Map<String, _i0zisc0t.SimpleData> dataMap,
    required Map<String, int> intMap,
    required Map<String, String> stringMap,
    required Map<String, DateTime> dateTimeMap,
    required Map<String, _idt.ByteData> byteDataMap,
    required Map<String, Duration> durationMap,
    required Map<String, _isc.UuidValue> uuidMap,
    required Map<String, _i0zisc0t.SimpleData?> nullableDataMap,
    required Map<String, int?> nullableIntMap,
    required Map<String, String?> nullableStringMap,
    required Map<String, DateTime?> nullableDateTimeMap,
    required Map<String, _idt.ByteData?> nullableByteDataMap,
    required Map<String, Duration?> nullableDurationMap,
    required Map<String, _isc.UuidValue?> nullableUuidMap,
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
  @_isc.useResult
  @override
  ObjectWithMaps copyWith({
    Map<String, _i0zisc0t.SimpleData>? dataMap,
    Map<String, int>? intMap,
    Map<String, String>? stringMap,
    Map<String, DateTime>? dateTimeMap,
    Map<String, _idt.ByteData>? byteDataMap,
    Map<String, Duration>? durationMap,
    Map<String, _isc.UuidValue>? uuidMap,
    Map<String, _i0zisc0t.SimpleData?>? nullableDataMap,
    Map<String, int?>? nullableIntMap,
    Map<String, String?>? nullableStringMap,
    Map<String, DateTime?>? nullableDateTimeMap,
    Map<String, _idt.ByteData?>? nullableByteDataMap,
    Map<String, Duration?>? nullableDurationMap,
    Map<String, _isc.UuidValue?>? nullableUuidMap,
    Map<int, int>? intIntMap,
  }) {
    return ObjectWithMaps(
      dataMap:
          dataMap ??
          this.dataMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
      intMap:
          intMap ??
          this.intMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      stringMap:
          stringMap ??
          this.stringMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      dateTimeMap:
          dateTimeMap ??
          this.dateTimeMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      byteDataMap:
          byteDataMap ??
          this.byteDataMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.clone(),
            ),
          ),
      durationMap:
          durationMap ??
          this.durationMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      uuidMap:
          uuidMap ??
          this.uuidMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      nullableDataMap:
          nullableDataMap ??
          this.nullableDataMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0?.copyWith(),
            ),
          ),
      nullableIntMap:
          nullableIntMap ??
          this.nullableIntMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      nullableStringMap:
          nullableStringMap ??
          this.nullableStringMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      nullableDateTimeMap:
          nullableDateTimeMap ??
          this.nullableDateTimeMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      nullableByteDataMap:
          nullableByteDataMap ??
          this.nullableByteDataMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0?.clone(),
            ),
          ),
      nullableDurationMap:
          nullableDurationMap ??
          this.nullableDurationMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      nullableUuidMap:
          nullableUuidMap ??
          this.nullableUuidMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      intIntMap:
          intIntMap ??
          this.intIntMap.map(
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
