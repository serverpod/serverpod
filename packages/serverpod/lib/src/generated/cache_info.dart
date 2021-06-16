/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class CacheInfo extends SerializableEntity {
  @override
  String get className => 'CacheInfo';

  int? id;
  late int numEntries;
  late int maxEntries;
  List<String>? keys;

  CacheInfo({
    this.id,
    required this.numEntries,
    required this.maxEntries,
    this.keys,
});

  CacheInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    numEntries = _data['numEntries']!;
    maxEntries = _data['maxEntries']!;
    keys = _data['keys']?.cast<String>();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      'keys': keys,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      'keys': keys,
    });
  }
}

