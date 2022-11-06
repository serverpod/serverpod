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
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      type: serializationManager.deserialize<int>(jsonSerialization['type']),
      timestamp: serializationManager
          .deserialize<DateTime>(jsonSerialization['timestamp']),
      active:
          serializationManager.deserialize<int>(jsonSerialization['active']),
      closing:
          serializationManager.deserialize<int>(jsonSerialization['closing']),
      idle: serializationManager.deserialize<int>(jsonSerialization['idle']),
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
