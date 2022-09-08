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

class ClusterInfo extends SerializableEntity {
  @override
  String get className => 'ClusterInfo';

  late List<ClusterServerInfo> servers;

  ClusterInfo({
    required this.servers,
  });

  ClusterInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    servers = _data['servers']!
        .map<ClusterServerInfo>((a) => ClusterServerInfo.fromSerialization(a))
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'servers': servers.map((ClusterServerInfo a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'servers': servers.map((ClusterServerInfo a) => a.serialize()).toList(),
    });
  }
}
