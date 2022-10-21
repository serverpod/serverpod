/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ServerHealthMetric extends _i1.SerializableEntity {
  ServerHealthMetric({
    this.id,
    required this.name,
    required this.serverId,
    required this.timestamp,
    required this.isHealthy,
    required this.value,
  });

  factory ServerHealthMetric.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerHealthMetric(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      name: serializationManager
          .deserializeJson<String>(jsonSerialization['name']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      timestamp: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['timestamp']),
      isHealthy: serializationManager
          .deserializeJson<bool>(jsonSerialization['isHealthy']),
      value: serializationManager
          .deserializeJson<double>(jsonSerialization['value']),
    );
  }

  int? id;

  String name;

  String serverId;

  DateTime timestamp;

  bool isHealthy;

  double value;

  @override
  String get className => 'ServerHealthMetric';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp,
      'isHealthy': isHealthy,
      'value': value,
    };
  }
}
