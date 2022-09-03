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

class SimpleDataMap extends SerializableEntity {
  @override
  String get className => 'SimpleDataMap';

  int? id;
  late Map<String,SimpleData> dataMap;
  late Map<String,int> intMap;
  late Map<String,DateTime> dateTimeMap;
  late Map<String,ByteData> byteDataMap;

  SimpleDataMap({
    this.id,
    required this.dataMap,
    required this.intMap,
    required this.dateTimeMap,
    required this.byteDataMap,
});

  SimpleDataMap.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    dataMap = _data['dataMap']!.map<String, SimpleData>((key, value) => MapEntry(key, SimpleData.fromSerialization(value)));
    intMap = _data['intMap']!.cast<String, int>();
    dateTimeMap = _data['dateTimeMap']!.map<String, DateTime>((String key, String value) => MapEntry(key, DateTime.tryParse(a)!)));
    byteDataMap = _data['byteDataMap']!.map<String, ByteData?>((String key, String value) => MapEntry(key, value.base64DecodedByteData()));
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'dataMap': dataMap.map<String, Map<String, dynamic>>((String key, SimpleData value) => MapEntry(key, value.serialize())),
      'intMap': intMap,
      'dateTimeMap': dateTimeMap.map<String,String?>((key, value) => MapEntry(key, value.toIso8601String())),
      'byteDataMap': byteDataMap.map<String,String>((key, value) => MapEntry(key, value.base64encodedString())),
    });
  }
}

