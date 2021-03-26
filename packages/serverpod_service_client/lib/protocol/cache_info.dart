/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class CacheInfo extends SerializableEntity {
  String get className => 'CacheInfo';

  int? id;
  int? numEntries;
  int? maxEntries;
  List<String>? keys;

  CacheInfo({
    this.id,
    this.numEntries,
    this.maxEntries,
    this.keys,
});

  CacheInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    numEntries = _data['numEntries'];
    maxEntries = _data['maxEntries'];
    keys = _data['keys']?.cast<String>();
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      'keys': keys,
    });
  }
}

