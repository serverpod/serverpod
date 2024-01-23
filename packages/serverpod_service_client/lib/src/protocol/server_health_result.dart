/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Information about health and connection metrics.
abstract class ServerHealthResult extends _i1.SerializableEntity {
  ServerHealthResult._({
    required this.metrics,
    required this.connectionInfos,
  });

  factory ServerHealthResult({
    required List<_i2.ServerHealthMetric> metrics,
    required List<_i2.ServerHealthConnectionInfo> connectionInfos,
  }) = _ServerHealthResultImpl;

  factory ServerHealthResult.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerHealthResult(
      metrics: serializationManager.deserialize<List<_i2.ServerHealthMetric>>(
          jsonSerialization['metrics']),
      connectionInfos: serializationManager
          .deserialize<List<_i2.ServerHealthConnectionInfo>>(
              jsonSerialization['connectionInfos']),
    );
  }

  /// List of health metrics.
  List<_i2.ServerHealthMetric> metrics;

  /// List of connection metrics.
  List<_i2.ServerHealthConnectionInfo> connectionInfos;

  ServerHealthResult copyWith({
    List<_i2.ServerHealthMetric>? metrics,
    List<_i2.ServerHealthConnectionInfo>? connectionInfos,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics.toJson(valueToJson: (v) => v.toJson()),
      'connectionInfos': connectionInfos.toJson(valueToJson: (v) => v.toJson()),
    };
  }
}

class _ServerHealthResultImpl extends ServerHealthResult {
  _ServerHealthResultImpl({
    required List<_i2.ServerHealthMetric> metrics,
    required List<_i2.ServerHealthConnectionInfo> connectionInfos,
  }) : super._(
          metrics: metrics,
          connectionInfos: connectionInfos,
        );

  @override
  ServerHealthResult copyWith({
    List<_i2.ServerHealthMetric>? metrics,
    List<_i2.ServerHealthConnectionInfo>? connectionInfos,
  }) {
    return ServerHealthResult(
      metrics: metrics ?? this.metrics.clone(),
      connectionInfos: connectionInfos ?? this.connectionInfos.clone(),
    );
  }
}
