/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// Information about health and connection metrics.
class ServerHealthResult extends _i1.SerializableEntity {
  ServerHealthResult({
    required this.metrics,
    required this.connectionInfos,
  });

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
  final List<_i2.ServerHealthMetric> metrics;

  /// List of connection metrics.
  final List<_i2.ServerHealthConnectionInfo> connectionInfos;

  late Function({
    List<_i2.ServerHealthMetric>? metrics,
    List<_i2.ServerHealthConnectionInfo>? connectionInfos,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics,
      'connectionInfos': connectionInfos,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ServerHealthResult &&
            const _i3.DeepCollectionEquality().equals(
              metrics,
              other.metrics,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              connectionInfos,
              other.connectionInfos,
            ));
  }

  @override
  int get hashCode => Object.hash(
        const _i3.DeepCollectionEquality().hash(metrics),
        const _i3.DeepCollectionEquality().hash(connectionInfos),
      );

  ServerHealthResult _copyWith({
    List<_i2.ServerHealthMetric>? metrics,
    List<_i2.ServerHealthConnectionInfo>? connectionInfos,
  }) {
    return ServerHealthResult(
      metrics: metrics ?? this.metrics,
      connectionInfos: connectionInfos ?? this.connectionInfos,
    );
  }
}
