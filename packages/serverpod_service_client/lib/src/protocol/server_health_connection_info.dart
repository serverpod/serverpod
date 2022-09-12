/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ServerHealthConnectionInfo extends SerializableEntity {
  @override
  String get className => 'ServerHealthConnectionInfo';

  int? id;
  late String serverId;
  late int type;
  late DateTime timestamp;
  late int active;
  late int closing;
  late int idle;

  ServerHealthConnectionInfo({
    this.id,
    required this.serverId,
    required this.type,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
  });

  ServerHealthConnectionInfo.fromSerialization(
      Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    type = _data['type']!;
    timestamp = DateTime.tryParse(_data['timestamp'])!;
    active = _data['active']!;
    closing = _data['closing']!;
    idle = _data['idle']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'active': active,
      'closing': closing,
      'idle': idle,
    });
  }
}
