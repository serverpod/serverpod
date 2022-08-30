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

class SimpleDataMap extends SerializableEntity {
  @override
  String get className => 'SimpleDataMap';

  int? id;
  late Map<String,SimpleData> dataMap;

  SimpleDataMap({
    this.id,
    required this.dataMap,
});

  SimpleDataMap.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    dataMap = Map<String,SimpleData>.fromSerialization(_data['dataMap']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'dataMap': dataMap.map(MapEntry<String,SimpleData> a) => MapEntry<String, String>(a.key, a.value.serialize())),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'dataMap': dataMap.map(MapEntry<String,SimpleData> a) => MapEntry<String, String>(a.key, a.value.serialize())),
    });
  }
}

