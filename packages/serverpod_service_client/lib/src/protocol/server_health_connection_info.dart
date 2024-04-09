/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

/// Represents a snapshot of the number of open connections the server currently
/// is handling. An entry is written every minute for each server. All health
/// data can be accessed through Serverpod Insights.
abstract class ServerHealthConnectionInfo extends _i1.SerializableEntity {
  ServerHealthConnectionInfo._({
    this.id,
    required this.serverId,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
    required this.granularity,
  });

  factory ServerHealthConnectionInfo({
    int? id,
    required String serverId,
    required DateTime timestamp,
    required int active,
    required int closing,
    required int idle,
    required int granularity,
  }) = _ServerHealthConnectionInfoImpl;

  factory ServerHealthConnectionInfo.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ServerHealthConnectionInfo(
      id: jsonSerialization['id'] as int?,
      serverId: jsonSerialization['serverId'] as String,
      timestamp: _i2.DateTimeExt.getDateTime<DateTime>(
          jsonSerialization['timestamp'])!,
      active: jsonSerialization['active'] as int,
      closing: jsonSerialization['closing'] as int,
      idle: jsonSerialization['idle'] as int,
      granularity: jsonSerialization['granularity'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The server associated with this connection info.
  String serverId;

  /// The time when the connections was checked, granularity is one minute.
  DateTime timestamp;

  /// Number of active connections currently open.
  int active;

  /// Number of connections currently closing.
  int closing;

  /// Number of connections currently idle.
  int idle;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  int granularity;

  ServerHealthConnectionInfo copyWith({
    int? id,
    String? serverId,
    DateTime? timestamp,
    int? active,
    int? closing,
    int? idle,
    int? granularity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'serverId': serverId,
      'timestamp': timestamp.toJson(),
      'active': active,
      'closing': closing,
      'idle': idle,
      'granularity': granularity,
    };
  }
}

class _Undefined {}

class _ServerHealthConnectionInfoImpl extends ServerHealthConnectionInfo {
  _ServerHealthConnectionInfoImpl({
    int? id,
    required String serverId,
    required DateTime timestamp,
    required int active,
    required int closing,
    required int idle,
    required int granularity,
  }) : super._(
          id: id,
          serverId: serverId,
          timestamp: timestamp,
          active: active,
          closing: closing,
          idle: idle,
          granularity: granularity,
        );

  @override
  ServerHealthConnectionInfo copyWith({
    Object? id = _Undefined,
    String? serverId,
    DateTime? timestamp,
    int? active,
    int? closing,
    int? idle,
    int? granularity,
  }) {
    return ServerHealthConnectionInfo(
      id: id is int? ? id : this.id,
      serverId: serverId ?? this.serverId,
      timestamp: timestamp ?? this.timestamp,
      active: active ?? this.active,
      closing: closing ?? this.closing,
      idle: idle ?? this.idle,
      granularity: granularity ?? this.granularity,
    );
  }
}
