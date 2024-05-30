/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Information about a single server in a cluster.
abstract class ClusterServerInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ClusterServerInfo._({required this.serverId});

  factory ClusterServerInfo({required String serverId}) =
      _ClusterServerInfoImpl;

  factory ClusterServerInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClusterServerInfo(serverId: jsonSerialization['serverId'] as String);
  }

  /// The id of the server.
  String serverId;

  ClusterServerInfo copyWith({String? serverId});
  @override
  Map<String, dynamic> toJson() {
    return {'serverId': serverId};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'serverId': serverId};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ClusterServerInfoImpl extends ClusterServerInfo {
  _ClusterServerInfoImpl({required String serverId})
      : super._(serverId: serverId);

  @override
  ClusterServerInfo copyWith({String? serverId}) {
    return ClusterServerInfo(serverId: serverId ?? this.serverId);
  }
}
