import 'dart:io';

import 'package:serverpod/src/hot_reload/hot_reload.dart';
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
    await server.serverpod.reloadRuntimeSettings();
    return server.serverpod.runtimeSettings;
  }

  /// Update the current [RuntimeSettings] in the running [Server].
  Future<void> setRuntimeSettings(
      Session session, RuntimeSettings runtimeSettings) async {
    server.serverpod.runtimeSettings = runtimeSettings;
  }

  /// Clear all server logs.
  Future<void> clearAllLogs(Session session) async {
    await session.db.delete<SessionLogEntry>(
      where: Constant(true),
    );
    await session.db.delete<QueryLogEntry>(
      where: Constant(true),
    );
    await session.db.delete<LogEntry>(
      where: Constant(true),
    );
  }

  /// Get the latest [numEntries] from the session log.
  Future<SessionLogResult> getSessionLog(
      Session session, int? numEntries, SessionLogFilter? filter) async {
    // Filter for errors and slow
    Expression where;
    if (filter == null || (!filter.slow && !filter.error)) {
      where = Constant(true);
    } else {
      if (filter.slow && filter.error) {
        where = SessionLogEntry.t.slow.equals(true) |
            SessionLogEntry.t.error.notEquals(null);
      } else if (filter.slow) {
        where = SessionLogEntry.t.slow.equals(true);
      } else {
        where = SessionLogEntry.t.error.notEquals(null);
      }
    }

    // Filter for endpoint
    if (filter != null && filter.endpoint != null) {
      where = where & SessionLogEntry.t.endpoint.equals(filter.endpoint);
    }

    // Filter for method
    if (filter != null && filter.method != null && filter.method != '') {
      where = where & SessionLogEntry.t.method.equals(filter.method);
    }

    // Filter for starting point
    if (filter != null && filter.lastSessionLogId != null) {
      where = where & (SessionLogEntry.t.id < filter.lastSessionLogId);
    }

    var rows = (await session.db.find<SessionLogEntry>(
      where: where,
      limit: numEntries,
      orderBy: SessionLogEntry.t.id,
      orderDescending: true,
    ))
        .cast<SessionLogEntry>();

    var sessionLogInfo = <SessionLogInfo>[];
    for (var logEntry in rows) {
      var messageLogRows = await session.db.find<LogEntry>(
        where: LogEntry.t.sessionLogId.equals(logEntry.id),
        orderBy: LogEntry.t.id,
        orderDescending: false,
      );

      var queryLogRows = await session.db.find<QueryLogEntry>(
        where: QueryLogEntry.t.sessionLogId.equals(logEntry.id),
        orderBy: QueryLogEntry.t.id,
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

  /// Get the latest [numEntries] from the session log.
  Future<SessionLogResult> getOpenSessionLog(
      Session session, int? numEntries, SessionLogFilter? filter) async {
    var logs = session.serverpod.logManager
        .getOpenSessionLogs(numEntries ?? 100, filter);
    return SessionLogResult(sessionLog: logs);
  }

  /// Retrieve information about the state of the caches on this server.
  Future<CachesInfo> getCachesInfo(Session session, bool fetchKeys) async {
    return CachesInfo(
      local: _getCacheInfo(pod.caches.local, fetchKeys),
      localPrio: _getCacheInfo(pod.caches.localPrio, fetchKeys),
      global: _getCacheInfo(pod.caches.global, fetchKeys),
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
    await server.serverpod.shutdown();
  }

  /// Performs a health check on the running [ServerPod].
  Future<ServerHealthResult> checkHealth(Session session) async {
    return await performHealthChecks(pod);
  }

  /// Gets historical health check data. Returns data for the whole cluster.
  Future<ServerHealthResult> getHealthData(
    Session session,
    DateTime start,
    DateTime end,
  ) async {
    // Load metrics and connection information.
    var metrics = await ServerHealthMetric.find(
      session,
      where: (t) => (t.timestamp >= start) & (t.timestamp <= end),
    );

    var connectionInfos = await ServerHealthConnectionInfo.find(
      session,
      where: (t) => (t.timestamp >= start) & (t.timestamp <= end),
    );

    return ServerHealthResult(
      metrics: metrics,
      connectionInfos: connectionInfos,
    );
  }

  /// Performs a hot reload of the server.
  Future<bool> hotReload(Session session) async {
    if (!await HotReloader.isHotReloadAvailable()) {
      stderr.writeln(
        'Hot reload is not available. You need to run dart with --enable-vm-service.',
      );
      return false;
    }
    return await HotReloader.hotReload();
  }
}
