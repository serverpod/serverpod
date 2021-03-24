/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class CachesInfo extends SerializableEntity {
  String get className => 'CachesInfo';

  int id;
  CacheInfo local;
  CacheInfo localPrio;
  CacheInfo distributed;
  CacheInfo distributedPrio;

  CachesInfo({
    this.id,
    this.local,
    this.localPrio,
    this.distributed,
    this.distributedPrio,
});

  CachesInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    local = _data['local'] != null ? CacheInfo.fromSerialization(_data['local']) : null;
    localPrio = _data['localPrio'] != null ? CacheInfo.fromSerialization(_data['localPrio']) : null;
    distributed = _data['distributed'] != null ? CacheInfo.fromSerialization(_data['distributed']) : null;
    distributedPrio = _data['distributedPrio'] != null ? CacheInfo.fromSerialization(_data['distributedPrio']) : null;
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'local': local?.serialize(),
      'localPrio': localPrio?.serialize(),
      'distributed': distributed?.serialize(),
      'distributedPrio': distributedPrio?.serialize(),
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'local': local?.serialize(),
      'localPrio': localPrio?.serialize(),
      'distributed': distributed?.serialize(),
      'distributedPrio': distributedPrio?.serialize(),
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'local': local?.serialize(),
      'localPrio': localPrio?.serialize(),
      'distributed': distributed?.serialize(),
      'distributedPrio': distributedPrio?.serialize(),
    });
  }
}

