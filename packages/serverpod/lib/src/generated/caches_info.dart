/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class CachesInfo extends SerializableEntity {
  String get className => 'CachesInfo';

  int id;
  CacheInfo localPrio;
  CacheInfo distributedPrio;
  CacheInfo distributed;
  CacheInfo local;

  CachesInfo({
    this.id,
    this.localPrio,
    this.distributedPrio,
    this.distributed,
    this.local,
});

  CachesInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    localPrio = _data['localPrio'] != null ? CacheInfo.fromSerialization(_data['localPrio']) : null;
    distributedPrio = _data['distributedPrio'] != null ? CacheInfo.fromSerialization(_data['distributedPrio']) : null;
    distributed = _data['distributed'] != null ? CacheInfo.fromSerialization(_data['distributed']) : null;
    local = _data['local'] != null ? CacheInfo.fromSerialization(_data['local']) : null;
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'localPrio': localPrio?.serialize(),
      'distributedPrio': distributedPrio?.serialize(),
      'distributed': distributed?.serialize(),
      'local': local?.serialize(),
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'localPrio': localPrio?.serialize(),
      'distributedPrio': distributedPrio?.serialize(),
      'distributed': distributed?.serialize(),
      'local': local?.serialize(),
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'localPrio': localPrio?.serialize(),
      'distributedPrio': distributedPrio?.serialize(),
      'distributed': distributed?.serialize(),
      'local': local?.serialize(),
    });
  }
}

