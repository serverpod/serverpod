/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class DistributedCacheEntry extends SerializableEntity {
  String get className => 'DistributedCacheEntry';

  int id;
  String data;

  DistributedCacheEntry({
    this.id,
    this.data,
});

  DistributedCacheEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    data = _data['data'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'data': data,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'data': data,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'data': data,
    });
  }
}

