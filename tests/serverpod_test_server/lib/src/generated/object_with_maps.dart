/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

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
    required this.nullableDataMap,
    required this.nullableIntMap,
    required this.nullableStringMap,
    required this.nullableDateTimeMap,
    required this.nullableByteDataMap,
    required this.intIntMap,
  });

  factory ObjectWithMaps.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithMaps(
      dataMap:
          serializationManager.deserializeJson<Map<String, _i2.SimpleData>>(
              jsonSerialization['dataMap']),
      intMap: serializationManager
          .deserializeJson<Map<String, int>>(jsonSerialization['intMap']),
      stringMap: serializationManager
          .deserializeJson<Map<String, String>>(jsonSerialization['stringMap']),
      dateTimeMap: serializationManager.deserializeJson<Map<String, DateTime>>(
          jsonSerialization['dateTimeMap']),
      byteDataMap:
          serializationManager.deserializeJson<Map<String, _i3.ByteData>>(
              jsonSerialization['byteDataMap']),
      nullableDataMap:
          serializationManager.deserializeJson<Map<String, _i2.SimpleData?>>(
              jsonSerialization['nullableDataMap']),
      nullableIntMap: serializationManager.deserializeJson<Map<String, int?>>(
          jsonSerialization['nullableIntMap']),
      nullableStringMap:
          serializationManager.deserializeJson<Map<String, String?>>(
              jsonSerialization['nullableStringMap']),
      nullableDateTimeMap:
          serializationManager.deserializeJson<Map<String, DateTime?>>(
              jsonSerialization['nullableDateTimeMap']),
      nullableByteDataMap:
          serializationManager.deserializeJson<Map<String, _i3.ByteData?>>(
              jsonSerialization['nullableByteDataMap']),
      intIntMap: serializationManager
          .deserializeJson<Map<int, int>>(jsonSerialization['intIntMap']),
    );
  }

  Map<String, _i2.SimpleData> dataMap;

  Map<String, int> intMap;

  Map<String, String> stringMap;

  Map<String, DateTime> dateTimeMap;

  Map<String, _i3.ByteData> byteDataMap;

  Map<String, _i2.SimpleData?> nullableDataMap;

  Map<String, int?> nullableIntMap;

  Map<String, String?> nullableStringMap;

  Map<String, DateTime?> nullableDateTimeMap;

  Map<String, _i3.ByteData?> nullableByteDataMap;

  Map<int, int> intIntMap;

  @override
  Map<String, dynamic> toJson() {
    return {
      'dataMap': dataMap,
      'intMap': intMap,
      'stringMap': stringMap,
      'dateTimeMap': dateTimeMap,
      'byteDataMap': byteDataMap,
      'nullableDataMap': nullableDataMap,
      'nullableIntMap': nullableIntMap,
      'nullableStringMap': nullableStringMap,
      'nullableDateTimeMap': nullableDateTimeMap,
      'nullableByteDataMap': nullableByteDataMap,
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
      'nullableDataMap': nullableDataMap,
      'nullableIntMap': nullableIntMap,
      'nullableStringMap': nullableStringMap,
      'nullableDateTimeMap': nullableDateTimeMap,
      'nullableByteDataMap': nullableByteDataMap,
      'intIntMap': intIntMap,
    };
  }
}
