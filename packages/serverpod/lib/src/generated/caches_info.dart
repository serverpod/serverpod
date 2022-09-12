/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class CachesInfo extends SerializableEntity {
  @override
  String get className => 'CachesInfo';

  late CacheInfo local;
  late CacheInfo localPrio;
  late CacheInfo global;

  CachesInfo({
    required this.local,
    required this.localPrio,
    required this.global,
  });

  CachesInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    local = CacheInfo.fromSerialization(_data['local']);
    localPrio = CacheInfo.fromSerialization(_data['localPrio']);
    global = CacheInfo.fromSerialization(_data['global']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'local': local.serialize(),
      'localPrio': localPrio.serialize(),
      'global': global.serialize(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'local': local.serialize(),
      'localPrio': localPrio.serialize(),
      'global': global.serialize(),
    });
  }
}
