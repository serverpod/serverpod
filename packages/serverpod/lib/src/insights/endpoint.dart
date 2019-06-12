import '../../server.dart';
import '../generated/protocol.dart';
import '../cache/cache.dart';

const endpointNameInsights = 'insights';

class InsightsEndpoint extends Endpoint {
  final Serverpod pod;
  InsightsEndpoint(this.pod);

  Future<LogResult> getLog(Session session, int numEntries) async {
    print('getLog $numEntries');

    var rows = await server.database.find(
      tLogEntry,
      limit: numEntries,
      orderBy: tLogEntry.id,
      orderDescending: true,
    );
    return LogResult(
      entries: rows.cast<LogEntry>(),
    );
  }

  Future<CachesInfo> getCachesInfo(Session session, bool fetchKeys) async {
    print('getCachesInfo fetchKeys: $fetchKeys');
    return CachesInfo(
      local: _getCacheInfo(pod.caches.local, fetchKeys),
      localPrio: _getCacheInfo(pod.caches.localPrio, fetchKeys),
      distributed: _getCacheInfo(pod.caches.distributed, fetchKeys),
      distributedPrio: _getCacheInfo(pod.caches.distributedPrio, fetchKeys),
    );
  }

  CacheInfo _getCacheInfo(Cache cache, bool fetchKeys) {
    return CacheInfo(
      numEntries: cache.localSize,
      maxEntries: cache.maxLocalEntries,
      keys: fetchKeys ? cache.localKeys : null,
    );
  }

  Future<Null> shutdown(Session session) async {
    server.serverpod.shutdown();
  }
}
