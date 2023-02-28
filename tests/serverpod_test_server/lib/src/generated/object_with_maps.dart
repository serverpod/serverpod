/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'dart:typed_data' as _i3;

class ObjectWithMaps extends _i1.SerializableEntity {
  ObjectWithMaps({
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

  factory ObjectWithMaps.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithMaps(
      dataMap: serializationManager.deserialize<Map<String, _i2.SimpleData>>(
          jsonSerialization['dataMap']),
      intMap: serializationManager
          .deserialize<Map<String, int>>(jsonSerialization['intMap']),
      stringMap: serializationManager
          .deserialize<Map<String, String>>(jsonSerialization['stringMap']),
      dateTimeMap: serializationManager
          .deserialize<Map<String, DateTime>>(jsonSerialization['dateTimeMap']),
      byteDataMap: serializationManager.deserialize<Map<String, _i3.ByteData>>(
          jsonSerialization['byteDataMap']),
      durationMap: serializationManager
          .deserialize<Map<String, Duration>>(jsonSerialization['durationMap']),
      uuidMap: serializationManager.deserialize<Map<String, _i1.UuidValue>>(
          jsonSerialization['uuidMap']),
      nullableDataMap:
          serializationManager.deserialize<Map<String, _i2.SimpleData?>>(
              jsonSerialization['nullableDataMap']),
      nullableIntMap: serializationManager
          .deserialize<Map<String, int?>>(jsonSerialization['nullableIntMap']),
      nullableStringMap: serializationManager.deserialize<Map<String, String?>>(
          jsonSerialization['nullableStringMap']),
      nullableDateTimeMap:
          serializationManager.deserialize<Map<String, DateTime?>>(
              jsonSerialization['nullableDateTimeMap']),
      nullableByteDataMap:
          serializationManager.deserialize<Map<String, _i3.ByteData?>>(
              jsonSerialization['nullableByteDataMap']),
      nullableDurationMap:
          serializationManager.deserialize<Map<String, Duration?>>(
              jsonSerialization['nullableDurationMap']),
      nullableUuidMap:
          serializationManager.deserialize<Map<String, _i1.UuidValue?>>(
              jsonSerialization['nullableUuidMap']),
      intIntMap: serializationManager
          .deserialize<Map<int, int>>(jsonSerialization['intIntMap']),
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'dataMap': dataMap,
      'intMap': intMap,
      'stringMap': stringMap,
      'dateTimeMap': dateTimeMap,
      'byteDataMap': byteDataMap,
      'durationMap': durationMap,
      'uuidMap': uuidMap,
      'nullableDataMap': nullableDataMap,
      'nullableIntMap': nullableIntMap,
      'nullableStringMap': nullableStringMap,
      'nullableDateTimeMap': nullableDateTimeMap,
      'nullableByteDataMap': nullableByteDataMap,
      'nullableDurationMap': nullableDurationMap,
      'nullableUuidMap': nullableUuidMap,
      'intIntMap': intIntMap,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'dataMap': dataMap,
      'intMap': intMap,
      'stringMap': stringMap,
      'dateTimeMap': dateTimeMap,
      'byteDataMap': byteDataMap,
      'durationMap': durationMap,
      'uuidMap': uuidMap,
      'nullableDataMap': nullableDataMap,
      'nullableIntMap': nullableIntMap,
      'nullableStringMap': nullableStringMap,
      'nullableDateTimeMap': nullableDateTimeMap,
      'nullableByteDataMap': nullableByteDataMap,
      'nullableDurationMap': nullableDurationMap,
      'nullableUuidMap': nullableUuidMap,
      'intIntMap': intIntMap,
    };
  }
}
