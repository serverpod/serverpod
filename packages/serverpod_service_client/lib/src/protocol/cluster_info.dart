/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

/// Information about a cluster of servers.
abstract class ClusterInfo extends _i1.SerializableEntity {
  const ClusterInfo._();

  const factory ClusterInfo({required List<_i2.ClusterServerInfo> servers}) =
      _ClusterInfo;

  factory ClusterInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ClusterInfo(
        servers: serializationManager.deserialize<List<_i2.ClusterServerInfo>>(
            jsonSerialization['servers']));
  }

  ClusterInfo copyWith({List<_i2.ClusterServerInfo>? servers});

  /// List of servers in the cluster.
  List<_i2.ClusterServerInfo> get servers;
}

/// Information about a cluster of servers.
class _ClusterInfo extends ClusterInfo {
  const _ClusterInfo({required this.servers}) : super._();

  /// List of servers in the cluster.
  @override
  final List<_i2.ClusterServerInfo> servers;

  @override
  Map<String, dynamic> toJson() {
    return {'servers': servers};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ClusterInfo &&
            const _i3.DeepCollectionEquality().equals(
              servers,
              other.servers,
            ));
  }

  @override
  int get hashCode => const _i3.DeepCollectionEquality().hash(servers);

  @override
  ClusterInfo copyWith({List<_i2.ClusterServerInfo>? servers}) {
    return ClusterInfo(servers: servers ?? this.servers);
  }
}
