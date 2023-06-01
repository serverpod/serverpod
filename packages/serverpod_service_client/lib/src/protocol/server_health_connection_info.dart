/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Represents a snapshot of the number of open connections the server currently
/// is handling. An entry is written every minute for each server. All health
/// data can be accessed through Serverpod Insights.
class ServerHealthConnectionInfo extends _i1.SerializableEntity {
  ServerHealthConnectionInfo({
    this.id,
    required this.serverId,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
    required this.granularity,
  });

  factory ServerHealthConnectionInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerHealthConnectionInfo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      timestamp: serializationManager
          .deserialize<DateTime>(jsonSerialization['timestamp']),
      active:
          serializationManager.deserialize<int>(jsonSerialization['active']),
      closing:
          serializationManager.deserialize<int>(jsonSerialization['closing']),
      idle: serializationManager.deserialize<int>(jsonSerialization['idle']),
      granularity: serializationManager
          .deserialize<int>(jsonSerialization['granularity']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// The server associated with this connection info.
  final String serverId;

  /// The time when the connections was checked, granularity is one minute.
  final DateTime timestamp;

  /// Number of active connections currently open.
  final int active;

  /// Number of connections currently closing.
  final int closing;

  /// Number of connections currently idle.
  final int idle;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  final int granularity;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'timestamp': timestamp,
      'active': active,
      'closing': closing,
      'idle': idle,
      'granularity': granularity,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ServerHealthConnectionInfo &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.timestamp,
                  timestamp,
                ) ||
                other.timestamp == timestamp) &&
            (identical(
                  other.active,
                  active,
                ) ||
                other.active == active) &&
            (identical(
                  other.closing,
                  closing,
                ) ||
                other.closing == closing) &&
            (identical(
                  other.idle,
                  idle,
                ) ||
                other.idle == idle) &&
            (identical(
                  other.granularity,
                  granularity,
                ) ||
                other.granularity == granularity));
  }

  @override
  int get hashCode => Object.hash(
        id,
        serverId,
        timestamp,
        active,
        closing,
        idle,
        granularity,
      );

  ServerHealthConnectionInfo copyWith({
    int? id,
    String? serverId,
    DateTime? timestamp,
    int? active,
    int? closing,
    int? idle,
    int? granularity,
  }) {
    return ServerHealthConnectionInfo(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      timestamp: timestamp ?? this.timestamp,
      active: active ?? this.active,
      closing: closing ?? this.closing,
      idle: idle ?? this.idle,
      granularity: granularity ?? this.granularity,
    );
  }
}
