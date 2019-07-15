import '../../server.dart';
import '../generated/protocol.dart';
import '../cache/cache.dart';

import 'health_check.dart';

const endpointNameInsights = 'insights';

class InsightsEndpoint extends Endpoint {
  final Serverpod pod;
  InsightsEndpoint(this.pod);

  bool get requireLogin => true;

  Future<LogResult> getLog(Session session, int numEntries) async {
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

  Future<SessionLogResult> getSessionLog(Session session, int numEntries) async {
    var rows = await server.database.find(
      tSessionLogEntry,
      limit: numEntries,
      orderBy: tSessionLogEntry.id,
      orderDescending: true,
    );

    var sessionLogInfo = <SessionLogInfo>[];
    for (SessionLogEntry logEntry in rows) {
      var messageLogRows = await server.database.find(
        tLogEntry,
        where: tLogEntry.sessionLogId.equals(logEntry.id),
        orderBy: tLogEntry.id,
        orderDescending: true,
      );

      var queryLogRows = await server.database.find(
        tQueryLogEntry,
        where: tQueryLogEntry.sessionLogId.equals(logEntry.id),
        orderBy: tQueryLogEntry.id,
        orderDescending: true,
      );

      sessionLogInfo.add(
        SessionLogInfo(
          sessionLogEntry: logEntry,
          messageLog: messageLogRows.cast<LogEntry>(),
          queries: queryLogRows.cast<QueryLogEntry>(),
        ),
      );
    }

    return SessionLogResult(sessionLog: sessionLogInfo);
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

  Future<ServerHealthResult> checkHealth(Session session) async {
    var metrics = <ServerHealthMetric>[];
    if (pod.healthCheckHandler != null) {
      metrics.addAll(await pod.healthCheckHandler(pod));
    }

    metrics.addAll(await healthCheck(pod));

    return ServerHealthResult(
      serverName: pod.server.name,
      metrics: metrics,
    );
  }
}
