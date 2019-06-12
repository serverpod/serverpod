/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class CacheInfo extends SerializableEntity {
  String get className => 'CacheInfo';

  int id;
  List<String> keys;
  int maxEntries;
  int numEntries;

  CacheInfo({
    this.id,
    this.keys,
    this.maxEntries,
    this.numEntries,
});

  CacheInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    keys = _data['keys'].cast<String>();
    maxEntries = _data['maxEntries'];
    numEntries = _data['numEntries'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'keys': keys,
      'maxEntries': maxEntries,
      'numEntries': numEntries,
    });
  }
}

