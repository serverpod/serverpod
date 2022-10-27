/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ServerHealthConnectionInfo extends _i1.SerializableEntity {
  ServerHealthConnectionInfo({
    this.id,
    required this.serverId,
    required this.type,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
  });

  factory ServerHealthConnectionInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerHealthConnectionInfo(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      type:
          serializationManager.deserializeJson<int>(jsonSerialization['type']),
      timestamp: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['timestamp']),
      active: serializationManager
          .deserializeJson<int>(jsonSerialization['active']),
      closing: serializationManager
          .deserializeJson<int>(jsonSerialization['closing']),
      idle:
          serializationManager.deserializeJson<int>(jsonSerialization['idle']),
    );
  }

  int? id;

  String serverId;

  int type;

  DateTime timestamp;

  int active;

  int closing;

  int idle;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp,
      'active': active,
      'closing': closing,
      'idle': idle,
    };
  }
}
