/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ObjectWithMaps extends SerializableEntity {
  @override
  String get className => 'ObjectWithMaps';

  int? id;
  late Map<String dataMap;
  late Map<String intMap;
  late Map<String stringMap;
  late Map<String dateTimeMap;
  late Map<String byteDataMap;
  late Map<String nullableDataMap;
  late Map<String nullableIntMap;
  late Map<String nullableStringMap;
  late Map<String nullableDateTimeMap;
  late Map<String nullableByteDataMap;
  late Map<int intIntMap;

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
    required this.intIntMap,
});

  ObjectWithMaps.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    dataMap = Map<String.fromSerialization(_data['dataMap']);
    intMap = Map<String.fromSerialization(_data['intMap']);
    stringMap = Map<String.fromSerialization(_data['stringMap']);
    dateTimeMap = Map<String.fromSerialization(_data['dateTimeMap']);
    byteDataMap = Map<String.fromSerialization(_data['byteDataMap']);
    nullableDataMap = Map<String.fromSerialization(_data['nullableDataMap']);
    nullableIntMap = Map<String.fromSerialization(_data['nullableIntMap']);
    nullableStringMap = Map<String.fromSerialization(_data['nullableStringMap']);
    nullableDateTimeMap = Map<String.fromSerialization(_data['nullableDateTimeMap']);
    nullableByteDataMap = Map<String.fromSerialization(_data['nullableByteDataMap']);
    intIntMap = Map<int.fromSerialization(_data['intIntMap']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'dataMap': dataMap.serialize(),
      'intMap': intMap.serialize(),
      'stringMap': stringMap.serialize(),
      'dateTimeMap': dateTimeMap.serialize(),
      'byteDataMap': byteDataMap.serialize(),
      'nullableDataMap': nullableDataMap.serialize(),
      'nullableIntMap': nullableIntMap.serialize(),
      'nullableStringMap': nullableStringMap.serialize(),
      'nullableDateTimeMap': nullableDateTimeMap.serialize(),
      'nullableByteDataMap': nullableByteDataMap.serialize(),
      'intIntMap': intIntMap.serialize(),
    });
  }
}

