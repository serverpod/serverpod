/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

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
      metrics:
          serializationManager.deserializeJson<List<_i2.ServerHealthMetric>>(
              jsonSerialization['metrics']),
      connectionInfos: serializationManager
          .deserializeJson<List<_i2.ServerHealthConnectionInfo>>(
              jsonSerialization['connectionInfos']),
    );
  }

  List<_i2.ServerHealthMetric> metrics;

  List<_i2.ServerHealthConnectionInfo> connectionInfos;

  @override
  String get className => 'ServerHealthResult';
  @override
  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics,
      'connectionInfos': connectionInfos,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'metrics': metrics,
      'connectionInfos': connectionInfos,
    };
  }
}
