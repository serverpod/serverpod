/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ObjectWithMaps extends SerializableEntity {
  @override
  String get className => 'ObjectWithMaps';

  int? id;
  late Map<String, SimpleData> dataMap;
  late Map<String, int> intMap;
  late Map<String, String> stringMap;
  late Map<String, DateTime> dateTimeMap;
  late Map<String, ByteData> byteDataMap;
  late Map<String, SimpleData?> nullableDataMap;
  late Map<String, int?> nullableIntMap;
  late Map<String, String?> nullableStringMap;
  late Map<String, DateTime?> nullableDateTimeMap;
  late Map<String, ByteData?> nullableByteDataMap;

  ObjectWithMaps({
    this.id,
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
  });

  ObjectWithMaps.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    dataMap = _data['dataMap']!.map<String, SimpleData>(
        (String key, dynamic value) =>
            MapEntry(key, SimpleData.fromSerialization(value)));
    intMap = _data['intMap']!.cast<String, int>();
    stringMap = _data['stringMap']!.cast<String, String>();
    dateTimeMap = _data['dateTimeMap']!.map<String, DateTime>(
        (String key, dynamic value) =>
            MapEntry(key, DateTime.tryParse(value as String)!));
    byteDataMap = _data['byteDataMap']!.map<String, ByteData>(
        (String key, dynamic value) =>
            MapEntry(key, (value as String).base64DecodedByteData()!));
    nullableDataMap = _data['nullableDataMap']!.map<String, SimpleData?>(
        (String key, dynamic value) => MapEntry(
            key, value != null ? SimpleData?.fromSerialization(value) : null));
    nullableIntMap = _data['nullableIntMap']!.cast<String, int?>();
    nullableStringMap = _data['nullableStringMap']!.cast<String, String?>();
    nullableDateTimeMap = _data['nullableDateTimeMap']!.map<String, DateTime?>(
        (String key, dynamic value) => MapEntry(
            key, value == null ? null : DateTime.tryParse(value as String)));
    nullableByteDataMap = _data['nullableByteDataMap']!.map<String, ByteData?>(
        (String key, dynamic value) =>
            MapEntry(key, (value as String?)?.base64DecodedByteData()));
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'dataMap': dataMap.map<String, Map<String, dynamic>>(
          (String key, SimpleData value) => MapEntry(key, value.serialize())),
      'intMap': intMap,
      'stringMap': stringMap,
      'dateTimeMap': dateTimeMap.map<String, String?>(
          (key, value) => MapEntry(key, value.toIso8601String())),
      'byteDataMap': byteDataMap.map<String, String>(
          (key, value) => MapEntry(key, value.base64encodedString())),
      'nullableDataMap': nullableDataMap.map<String, Map<String, dynamic>?>(
          (String key, SimpleData? value) => MapEntry(key, value?.serialize())),
      'nullableIntMap': nullableIntMap,
      'nullableStringMap': nullableStringMap,
      'nullableDateTimeMap': nullableDateTimeMap.map<String, String?>(
          (key, value) => MapEntry(key, value?.toIso8601String())),
      'nullableByteDataMap': nullableByteDataMap.map<String, String?>(
          (key, value) => MapEntry(key, value?.base64encodedString())),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'dataMap': dataMap.map<String, Map<String, dynamic>>(
          (String key, SimpleData value) => MapEntry(key, value.serialize())),
      'intMap': intMap,
      'stringMap': stringMap,
      'dateTimeMap': dateTimeMap.map<String, String?>(
          (key, value) => MapEntry(key, value.toIso8601String())),
      'byteDataMap': byteDataMap.map<String, String>(
          (key, value) => MapEntry(key, value.base64encodedString())),
      'nullableDataMap': nullableDataMap.map<String, Map<String, dynamic>?>(
          (String key, SimpleData? value) => MapEntry(key, value?.serialize())),
      'nullableIntMap': nullableIntMap,
      'nullableStringMap': nullableStringMap,
      'nullableDateTimeMap': nullableDateTimeMap.map<String, String?>(
          (key, value) => MapEntry(key, value?.toIso8601String())),
      'nullableByteDataMap': nullableByteDataMap.map<String, String?>(
          (key, value) => MapEntry(key, value?.base64encodedString())),
    });
  }
}
