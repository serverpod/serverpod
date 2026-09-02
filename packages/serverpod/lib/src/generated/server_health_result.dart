/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;
import 'server_health_connection_info.dart' as _igb3a02z;
import 'server_health_metric.dart' as _i8823art;

/// Information about health and connection metrics.
abstract class ServerHealthResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ServerHealthResult._({
    required this.metrics,
    required this.connectionInfos,
  });

  factory ServerHealthResult({
    required List<_i8823art.ServerHealthMetric> metrics,
    required List<_igb3a02z.ServerHealthConnectionInfo> connectionInfos,
  }) = _ServerHealthResultImpl;

  factory ServerHealthResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerHealthResult(
      metrics: _ic00rqxb.Protocol()
          .deserialize<List<_i8823art.ServerHealthMetric>>(
            jsonSerialization['metrics'],
          ),
      connectionInfos: _ic00rqxb.Protocol()
          .deserialize<List<_igb3a02z.ServerHealthConnectionInfo>>(
            jsonSerialization['connectionInfos'],
          ),
    );
  }

  /// List of health metrics.
  List<_i8823art.ServerHealthMetric> metrics;

  /// List of connection metrics.
  List<_igb3a02z.ServerHealthConnectionInfo> connectionInfos;

  /// Returns a shallow copy of this [ServerHealthResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServerHealthResult copyWith({
    List<_i8823art.ServerHealthMetric>? metrics,
    List<_igb3a02z.ServerHealthConnectionInfo>? connectionInfos,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.ServerHealthResult',
      'metrics': metrics.toJson(valueToJson: (v) => v.toJson()),
      'connectionInfos': connectionInfos.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.ServerHealthResult',
      'metrics': metrics.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'connectionInfos': connectionInfos.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ServerHealthResultImpl extends ServerHealthResult {
  _ServerHealthResultImpl({
    required List<_i8823art.ServerHealthMetric> metrics,
    required List<_igb3a02z.ServerHealthConnectionInfo> connectionInfos,
  }) : super._(
         metrics: metrics,
         connectionInfos: connectionInfos,
       );

  /// Returns a shallow copy of this [ServerHealthResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServerHealthResult copyWith({
    List<_i8823art.ServerHealthMetric>? metrics,
    List<_igb3a02z.ServerHealthConnectionInfo>? connectionInfos,
  }) {
    return ServerHealthResult(
      metrics: metrics ?? this.metrics.map((e0) => e0.copyWith()).toList(),
      connectionInfos:
          connectionInfos ??
          this.connectionInfos.map((e0) => e0.copyWith()).toList(),
    );
  }
}
