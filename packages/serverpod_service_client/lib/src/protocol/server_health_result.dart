/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'server_health_metric.dart' as _i2;
import 'server_health_connection_info.dart' as _i3;

/// Information about health and connection metrics.
abstract class ServerHealthResult implements _i1.SerializableModel {
  ServerHealthResult._({
    required this.metrics,
    required this.connectionInfos,
  });

  factory ServerHealthResult({
    required List<_i2.ServerHealthMetric> metrics,
    required List<_i3.ServerHealthConnectionInfo> connectionInfos,
  }) = _ServerHealthResultImpl;

  factory ServerHealthResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerHealthResult(
      metrics: (jsonSerialization['metrics'] as List)
          .map((e) =>
              _i2.ServerHealthMetric.fromJson((e as Map<String, dynamic>)))
          .toList(),
      connectionInfos: (jsonSerialization['connectionInfos'] as List)
          .map((e) => _i3.ServerHealthConnectionInfo.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// List of health metrics.
  List<_i2.ServerHealthMetric> metrics;

  /// List of connection metrics.
  List<_i3.ServerHealthConnectionInfo> connectionInfos;

  /// Returns a shallow copy of this [ServerHealthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerHealthResult copyWith({
    List<_i2.ServerHealthMetric>? metrics,
    List<_i3.ServerHealthConnectionInfo>? connectionInfos,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics.toJson(valueToJson: (v) => v.toJson()),
      'connectionInfos': connectionInfos.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ServerHealthResultImpl extends ServerHealthResult {
  _ServerHealthResultImpl({
    required List<_i2.ServerHealthMetric> metrics,
    required List<_i3.ServerHealthConnectionInfo> connectionInfos,
  }) : super._(
          metrics: metrics,
          connectionInfos: connectionInfos,
        );

  /// Returns a shallow copy of this [ServerHealthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerHealthResult copyWith({
    List<_i2.ServerHealthMetric>? metrics,
    List<_i3.ServerHealthConnectionInfo>? connectionInfos,
  }) {
    return ServerHealthResult(
      metrics: metrics ?? this.metrics.map((e0) => e0.copyWith()).toList(),
      connectionInfos: connectionInfos ??
          this.connectionInfos.map((e0) => e0.copyWith()).toList(),
    );
  }
}
