/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Represents a snapshot of a specific health metric. An entry is written every
/// minute for each server. All health data can be accessed through Serverpod
/// Insights.
abstract class ServerHealthMetric extends _i1.SerializableEntity {
  ServerHealthMetric._({
    this.id,
    required this.name,
    required this.serverId,
    required this.timestamp,
    required this.isHealthy,
    required this.value,
    required this.granularity,
  });

  factory ServerHealthMetric({
    int? id,
    required String name,
    required String serverId,
    required DateTime timestamp,
    required bool isHealthy,
    required double value,
    required int granularity,
  }) = _ServerHealthMetricImpl;

  factory ServerHealthMetric.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerHealthMetric(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      timestamp: serializationManager
          .deserialize<DateTime>(jsonSerialization['timestamp']),
      isHealthy: serializationManager
          .deserialize<bool>(jsonSerialization['isHealthy']),
      value:
          serializationManager.deserialize<double>(jsonSerialization['value']),
      granularity: serializationManager
          .deserialize<int>(jsonSerialization['granularity']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The name of the metric.
  String name;

  /// The server associated with this metric.
  String serverId;

  /// The time when the connections was checked, granularity is one minute.
  DateTime timestamp;

  /// True if the metric is healthy.
  bool isHealthy;

  /// The value of the metric.
  double value;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  int granularity;

  ServerHealthMetric copyWith({
    int? id,
    String? name,
    String? serverId,
    DateTime? timestamp,
    bool? isHealthy,
    double? value,
    int? granularity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp.toJson(),
      'isHealthy': isHealthy,
      'value': value,
      'granularity': granularity,
    };
  }
}

class _Undefined {}

class _ServerHealthMetricImpl extends ServerHealthMetric {
  _ServerHealthMetricImpl({
    int? id,
    required String name,
    required String serverId,
    required DateTime timestamp,
    required bool isHealthy,
    required double value,
    required int granularity,
  }) : super._(
          id: id,
          name: name,
          serverId: serverId,
          timestamp: timestamp,
          isHealthy: isHealthy,
          value: value,
          granularity: granularity,
        );

  @override
  ServerHealthMetric copyWith({
    Object? id = _Undefined,
    String? name,
    String? serverId,
    DateTime? timestamp,
    bool? isHealthy,
    double? value,
    int? granularity,
  }) {
    return ServerHealthMetric(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      serverId: serverId ?? this.serverId,
      timestamp: timestamp ?? this.timestamp,
      isHealthy: isHealthy ?? this.isHealthy,
      value: value ?? this.value,
      granularity: granularity ?? this.granularity,
    );
  }
}
