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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_service_client/src/protocol/protocol.dart'
    as _ian793c4;
import 'cluster_server_info.dart' as _i0iseagh;

/// Information about a cluster of servers.
abstract class ClusterInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ClusterInfo._({required this.servers});

  factory ClusterInfo({required List<_i0iseagh.ClusterServerInfo> servers}) =
      _ClusterInfoImpl;

  factory ClusterInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClusterInfo(
      servers: _ian793c4.Protocol()
          .deserialize<List<_i0iseagh.ClusterServerInfo>>(
            jsonSerialization['servers'],
          ),
    );
  }

  /// List of servers in the cluster.
  List<_i0iseagh.ClusterServerInfo> servers;

  /// Returns a shallow copy of this [ClusterInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ClusterInfo copyWith({List<_i0iseagh.ClusterServerInfo>? servers});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.ClusterInfo',
      'servers': servers.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.ClusterInfo',
      'servers': servers.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ClusterInfoImpl extends ClusterInfo {
  _ClusterInfoImpl({required List<_i0iseagh.ClusterServerInfo> servers})
    : super._(servers: servers);

  /// Returns a shallow copy of this [ClusterInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ClusterInfo copyWith({List<_i0iseagh.ClusterServerInfo>? servers}) {
    return ClusterInfo(
      servers: servers ?? this.servers.map((e0) => e0.copyWith()).toList(),
    );
  }
}
