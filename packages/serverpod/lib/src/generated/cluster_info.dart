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
import 'cluster_server_info.dart' as _i0iseagh;

/// Information about a cluster of servers.
abstract class ClusterInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ClusterInfo._({required this.servers});

  factory ClusterInfo({required List<_i0iseagh.ClusterServerInfo> servers}) =
      _ClusterInfoImpl;

  factory ClusterInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClusterInfo(
      servers: _ic00rqxb.Protocol()
          .deserialize<List<_i0iseagh.ClusterServerInfo>>(
            jsonSerialization['servers'],
          ),
    );
  }

  /// List of servers in the cluster.
  List<_i0iseagh.ClusterServerInfo> servers;

  /// Returns a shallow copy of this [ClusterInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
    return _is.SerializationManager.encode(this);
  }
}

class _ClusterInfoImpl extends ClusterInfo {
  _ClusterInfoImpl({required List<_i0iseagh.ClusterServerInfo> servers})
    : super._(servers: servers);

  /// Returns a shallow copy of this [ClusterInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ClusterInfo copyWith({List<_i0iseagh.ClusterServerInfo>? servers}) {
    return ClusterInfo(
      servers: servers ?? this.servers.map((e0) => e0.copyWith()).toList(),
    );
  }
}
