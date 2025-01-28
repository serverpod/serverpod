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
import 'cluster_server_info.dart' as _i2;

/// Information about a cluster of servers.
abstract class ClusterInfo implements _i1.SerializableModel {
  ClusterInfo._({required this.servers});

  factory ClusterInfo({required List<_i2.ClusterServerInfo> servers}) =
      _ClusterInfoImpl;

  factory ClusterInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClusterInfo(
        servers: (jsonSerialization['servers'] as List)
            .map((e) =>
                _i2.ClusterServerInfo.fromJson((e as Map<String, dynamic>)))
            .toList());
  }

  /// List of servers in the cluster.
  List<_i2.ClusterServerInfo> servers;

  /// Returns a shallow copy of this [ClusterInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ClusterInfo copyWith({List<_i2.ClusterServerInfo>? servers});
  @override
  Map<String, dynamic> toJson() {
    return {'servers': servers.toJson(valueToJson: (v) => v.toJson())};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ClusterInfoImpl extends ClusterInfo {
  _ClusterInfoImpl({required List<_i2.ClusterServerInfo> servers})
      : super._(servers: servers);

  /// Returns a shallow copy of this [ClusterInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ClusterInfo copyWith({List<_i2.ClusterServerInfo>? servers}) {
    return ClusterInfo(
        servers: servers ?? this.servers.map((e0) => e0.copyWith()).toList());
  }
}
