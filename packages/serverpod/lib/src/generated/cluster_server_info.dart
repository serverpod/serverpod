/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Information about a single server in a cluster.
abstract class ClusterServerInfo extends _i1.SerializableEntity {
  const ClusterServerInfo._();

  const factory ClusterServerInfo({required String serverId}) =
      _ClusterServerInfo;

  factory ClusterServerInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ClusterServerInfo(
        serverId: serializationManager
            .deserialize<String>(jsonSerialization['serverId']));
  }

  ClusterServerInfo copyWith({String? serverId});

  /// The id of the server.
  String get serverId;
}

/// Information about a single server in a cluster.
class _ClusterServerInfo extends ClusterServerInfo {
  const _ClusterServerInfo({required this.serverId}) : super._();

  /// The id of the server.
  @override
  final String serverId;

  @override
  Map<String, dynamic> toJson() {
    return {'serverId': serverId};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ClusterServerInfo &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId));
  }

  @override
  int get hashCode => serverId.hashCode;

  @override
  ClusterServerInfo copyWith({String? serverId}) {
    return ClusterServerInfo(serverId: serverId ?? this.serverId);
  }
}
