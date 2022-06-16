import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// The cluster manager keeps track of other servers within the same cluster.
class ClusterManager {
  /// Creates a new cluster manager.
  ClusterManager(this._server);

  /// The server this manager is attached to.
  final Server _server;

  static const _clusterInfoCacheKey = 'serverpod_cluster_info';

  /// Gets information about the server cluster this server is running within.
  /// The information can be up to two minutes old.
  Future<ClusterInfo> get getClusterInfo async {
    var info = await _server.caches.localPrio.get(_clusterInfoCacheKey)
        as ClusterInfo?;
    if (info != null) {
      return info;
    }

    var session = await _server.serverpod.createSession(enableLogging: false);

    /// Select connection infos form the last two minutes
    var connectionInfos = await ServerHealthConnectionInfo.find(
      session,
      where: (t) => (t.timestamp >
          DateTime.now().subtract(
            const Duration(minutes: 2),
          )),
    );

    var serverIds = <String>{};
    for (var connectionInfo in connectionInfos) {
      serverIds.add(connectionInfo.serverId);
    }

    var serverInfos = <ClusterServerInfo>[];
    for (var serverId in serverIds) {
      serverInfos.add(ClusterServerInfo(serverId: serverId));
    }

    var clusterInfo = ClusterInfo(servers: serverInfos);
    await _server.caches.localPrio.put(
      _clusterInfoCacheKey,
      clusterInfo,
      lifetime: const Duration(minutes: 1),
    );

    return clusterInfo;
  }
}
