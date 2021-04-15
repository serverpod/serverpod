import 'package:serverpod/database.dart';

import '../../server.dart';
import '../generated/protocol.dart';
import '../cache/cache.dart';

import 'package:serverpod/src/server/health_check.dart';

const endpointNameInsights = 'insights';

class InsightsEndpoint extends Endpoint {
  bool get requireLogin => true;

  Future<RuntimeSettings> getRuntimeSettings(Session session) async {
    return server.serverpod.runtimeSettings;
  }

  Future<void> setRuntimeSettings(Session session, RuntimeSettings runtimeSettings) async {
    server.serverpod.runtimeSettings = runtimeSettings;
  }

  Future<void> reloadRuntimeSettings(Session session) async {
    await server.serverpod.reloadRuntimeSettings();
  }
  
  Future<void> clearAllLogs(Session session) async {
    await session.db.delete(
      tSessionLogEntry,
      where: Constant(true),
    );
    await session.db.delete(
      tQueryLogEntry,
      where: Constant(true),
    );
    await session.db.delete(
      tLogEntry,
      where: Constant(true),
    );
  }

  Future<LogResult> getLog(Session session, int? numEntries) async {
    var rows = await session.db.find(
      tLogEntry,
      limit: numEntries,
      orderBy: tLogEntry.id,
      orderDescending: true,
    );
    return LogResult(
      entries: rows.cast<LogEntry>(),
    );
  }

  Future<SessionLogResult> getSessionLog(Session session, int? numEntries) async {
    print('getSessionLog');
    var rows = (await session.db.find(
      tSessionLogEntry,
      limit: numEntries,
      orderBy: tSessionLogEntry.id,
      orderDescending: true,
    )).cast<SessionLogEntry>();

    var sessionLogInfo = <SessionLogInfo>[];
    for (SessionLogEntry logEntry in rows) {
      var messageLogRows = await session.db.find(
        tLogEntry,
        where: tLogEntry.sessionLogId.equals(logEntry.id),
        orderBy: tLogEntry.id,
        orderDescending: false,
      );

      var queryLogRows = await session.db.find(
        tQueryLogEntry,
        where: tQueryLogEntry.sessionLogId.equals(logEntry.id),
        orderBy: tQueryLogEntry.id,
        orderDescending: false,
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

  Future<void> shutdown(Session session) async {
    server.serverpod.shutdown();
  }

  Future<ServerHealthResult> checkHealth(Session session) async {
    return await performHealthChecks(pod);
  }
}
