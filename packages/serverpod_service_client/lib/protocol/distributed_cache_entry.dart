/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
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
    var data = unwrapSerializationData(serialization);
    id = data['id'];
    data = data['data'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'data': data,
    });
  }
}

