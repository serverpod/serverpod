import 'package:serverpod/database.dart';
import 'package:serverpod/src/server/health_check.dart';

import '../../serverpod.dart';
import '../cache/cache.dart';
import '../generated/protocol.dart';

/// The [InsightsEndpoint] provides a way to access real time information from
/// the running server or to change settings.
class InsightsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  bool get logSessions => server.serverpod.runtimeSettings.logServiceCalls;

  /// Get the current [RuntimeSettings] from the running [Server].
  Future<RuntimeSettings> getRuntimeSettings(Session session) async {
    return server.serverpod.runtimeSettings;
  }

  /// Update the current [RuntimeSettings] in the running [Server].
  Future<void> setRuntimeSettings(
      Session session, RuntimeSettings runtimeSettings) async {
    server.serverpod.runtimeSettings = runtimeSettings;
  }

  /// Reload the current [RuntimeSettings] in the running [Server] from what's
  /// stored in the database.
  Future<void> reloadRuntimeSettings(Session session) async {
    await server.serverpod.reloadRuntimeSettings();
  }

  /// Clear all server logs.
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

  /// Get the latest [numEntries] from the message log.
  // Future<LogResult> getLog(Session session, int? numEntries) async {
  //   var rows = await session.db.find(
  //     tLogEntry,
  //     limit: numEntries,
  //     orderBy: tLogEntry.id,
  //     orderDescending: true,
  //   );
  //   return LogResult(
  //     entries: rows.cast<LogEntry>(),
  //   );
  // }

  /// Get the latest [numEntries] from the session log.
  Future<SessionLogResult> getSessionLog(
      Session session, int? numEntries, SessionLogFilter? filter) async {
    // Filter for errors and slow
    Expression where;
    if (filter == null || (!filter.slow && !filter.error)) {
      where = Constant(true);
    } else {
      if (filter.slow && filter.error)
        where = tSessionLogEntry.slow.equals(true) |
            tSessionLogEntry.error.notEquals(null);
      else if (filter.slow)
        where = tSessionLogEntry.slow.equals(true);
      else
        where = tSessionLogEntry.error.notEquals(null);
    }

    // Filter for endpoint
    if (filter != null && filter.endpoint != null) {
      where = where & tSessionLogEntry.endpoint.equals(filter.endpoint);
    }

    // Filter for method
    if (filter != null && filter.method != null && filter.method != '') {
      where = where & tSessionLogEntry.method.equals(filter.method);
    }

    // Filter for starting point
    if (filter != null && filter.lastSessionLogId != null) {
      where = where & (tSessionLogEntry.id < filter.lastSessionLogId);
    }

    var rows = (await session.db.find(
      tSessionLogEntry,
      where: where,
      limit: numEntries,
      orderBy: tSessionLogEntry.id,
      orderDescending: true,
    ))
        .cast<SessionLogEntry>();

    var sessionLogInfo = <SessionLogInfo>[];
    for (var logEntry in rows) {
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

  /// Retrieve information about the state of the caches on this server.
  Future<CachesInfo> getCachesInfo(Session session, bool fetchKeys) async {
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

  /// Safely shuts down this [ServerPod].
  Future<void> shutdown(Session session) async {
    server.serverpod.shutdown();
  }

  /// Performs a health check on the running [ServerPod].
  Future<ServerHealthResult> checkHealth(Session session) async {
    return await performHealthChecks(pod);
  }
}
