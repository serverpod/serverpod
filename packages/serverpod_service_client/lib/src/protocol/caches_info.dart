/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class CachesInfo extends SerializableEntity {
  @override
  String get className => 'CachesInfo';

  int? id;
  late CacheInfo local;
  late CacheInfo localPrio;
  late CacheInfo distributed;
  late CacheInfo distributedPrio;

  CachesInfo({
    this.id,
    required this.local,
    required this.localPrio,
    required this.distributed,
    required this.distributedPrio,
});

  CachesInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    local = CacheInfo.fromSerialization(_data['local']);
    localPrio = CacheInfo.fromSerialization(_data['localPrio']);
    distributed = CacheInfo.fromSerialization(_data['distributed']);
    distributedPrio = CacheInfo.fromSerialization(_data['distributedPrio']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'local': local.serialize(),
      'localPrio': localPrio.serialize(),
      'distributed': distributed.serialize(),
      'distributedPrio': distributedPrio.serialize(),
    });
  }
}

