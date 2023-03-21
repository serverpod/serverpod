import 'dart:io';

import 'package:serverpod/src/hot_reload/hot_reload.dart';
import 'package:serverpod/src/server/health_check.dart';
import 'package:serverpod/src/util/column_type_extension.dart';

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
    Session session,
    RuntimeSettings runtimeSettings,
  ) async {
    await server.serverpod.updateRuntimeSettings(runtimeSettings);
  }

  /// Clear all server logs.
  Future<void> clearAllLogs(Session session) async {
    await session.db.delete<SessionLogEntry>(
      where: Constant(true),
    );
  }

  /// Get the latest [numEntries] from the session log.
  Future<SessionLogResult> getSessionLog(
      Session session, int? numEntries, SessionLogFilter? filter) async {
    // Filter for errors and slow
    Expression where;
    if (filter == null || (!filter.slow && !filter.error && !filter.open)) {
      where = Constant(true);
    } else if (filter.open) {
      where = SessionLogEntry.t.isOpen.equals(true);
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
      var logRows = await session.db.find<LogEntry>(
        where: LogEntry.t.sessionLogId.equals(logEntry.id),
      );

      var queryRows = await session.db.find<QueryLogEntry>(
        where: QueryLogEntry.t.sessionLogId.equals(logEntry.id),
      );

      var messageRows = await session.db.find<MessageLogEntry>(
        where: MessageLogEntry.t.sessionLogId.equals(logEntry.id),
      );

      sessionLogInfo.add(
        SessionLogInfo(
          sessionLogEntry: logEntry,
          logs: logRows.cast<LogEntry>(),
          queries: queryRows.cast<QueryLogEntry>(),
          messages: messageRows,
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
      orderBy: ServerHealthMetric.t.timestamp,
    );

    var connectionInfos = await ServerHealthConnectionInfo.find(
      session,
      where: (t) => (t.timestamp >= start) & (t.timestamp <= end),
      orderBy: ServerHealthMetric.t.timestamp,
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

  /// Returns the desired structure of the database.
  /// See also:
  /// - [getCurrentDatabaseDefinition]
  Future<DatabaseDefinition> getDesiredDatabaseDefinition(
      Session session) async {
    return session.serverpod.serializationManager
        .getDesiredDatabaseDefinition();
  }

  /// Returns the current structure of the database.
  /// See also:
  /// - [getDesiredDatabaseDefinition]
  Future<DatabaseDefinition> getCurrentDatabaseDefinition(
      Session session) async {
    try {
      return DatabaseDefinition(
        name:
            (await session.db.query('SELECT current_database();')).first.first,
        tables: await Future.wait((await session.db.query(
                "SELECT schemaname, tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';"))
            .map((tableInfo) async {
          var schemaName = tableInfo.first;
          var tableName = tableInfo.last;

          var columns = (await session.db.query(
                  '''
SELECT column_name, column_default, is_nullable, data_type
FROM information_schema.columns
WHERE table_schema = '$schemaName' AND table_name = '$tableName'
ORDER BY ordinal_position;
'''))
              .map((e) => ColumnDefinition(
                  name: e[0],
                  columnDefault: e[1],
                  columnType: ExtendedColumnType.fromSqlType(e[3]),
                  isNullable: e[2] == 'YES'))
              .toList();

          var indexes = (await session.db.query(
                  '''
SELECT i.relname, ts.spcname, indisunique, indisprimary,
ARRAY(
       SELECT pg_get_indexdef(indexrelid, k + 1, true)
       FROM generate_subscripts(indkey, 1) as k
       ) as indkey_names,
ARRAY(SELECT i > 0 FROM unnest(indkey::int[]) as i) indkey_is_column,
pg_get_expr(indpred, indrelid), am.amname
FROM pg_index
JOIN pg_class t ON t.oid = indrelid
JOIN pg_namespace n ON n.oid = t.relnamespace
JOIN pg_class i ON i.oid = indexrelid
LEFT JOIN pg_tablespace as ts ON i.reltablespace = ts.oid
JOIN pg_am am ON am.oid=i.relam
WHERE t.relname = '$tableName' AND n.nspname = '$schemaName';
'''))
              .map((index) {
            return IndexDefinition(
              indexName: index[0],
              tableSpace: index[1],
              elements: List.generate(
                  index[4].length,
                  (i) => IndexElementDefinition(
                      type: index[5][i]
                          ? IndexElementDefinitionType.column
                          : IndexElementDefinitionType.expression,
                      definition: index[4][i])),
              type: index[7],
              isUnique: index[2],
              isPrimary: index[3],
              predicate: index[6],
            );
          }).toList();

          var foreignKeys = (await session.db.query(
                  '''
SELECT conname, confupdtype, confdeltype, confmatchtype,
ARRAY(
       SELECT attname::text
       FROM unnest(conkey) as i
       JOIN pg_attribute ON attrelid = t.oid AND attnum = i
       ) as conkey,
r.relname,
ARRAY(
       SELECT attname::text
       FROM unnest(confkey) as i
       JOIN pg_attribute ON attrelid = r.oid AND attnum = i
       ) as confkey
FROM pg_constraint
JOIN pg_class t ON t.oid = conrelid
JOIN pg_class r ON r.oid = confrelid
JOIN pg_namespace n ON n.oid = t.relnamespace
WHERE contype = 'f' AND t.relname = '$tableName' AND n.nspname = '$schemaName';
'''))
              .map((key) => ForeignKeyDefinition(
                    constraintName: key[0],
                    columns: key[4],
                    referenceTable: key[5],
                    referenceColumns: key[6],
                    onUpdate: (key[1] as String).toForeignKeyAction(),
                    onDelete: (key[2] as String).toForeignKeyAction(),
                    matchType: (key[3] as String).toForeignKeyMatchType(),
                  ))
              .toList();

          return TableDefinition(
            name: tableName,
            schema: schemaName,
            columns: columns,
            foreignKeys: foreignKeys,
            indexes: indexes,
          );
        })),
      );
    } catch (e) {
      //TODO: remove this... Only used for debugging
      print(e);
      rethrow;
    }
  }
}

extension on String {
  ForeignKeyAction? toForeignKeyAction() {
    switch (this) {
      case 'a':
        return ForeignKeyAction.noAction;

      case 'r':
        return ForeignKeyAction.restrict;
      case 'c':
        return ForeignKeyAction.cascade;
      case 'n':
        return ForeignKeyAction.setNull;
      case 'd':
        return ForeignKeyAction.setDefault;
      default:
        return null;
    }
  }

  ForeignKeyMatchType? toForeignKeyMatchType() {
    switch (this) {
      case 'f':
        return ForeignKeyMatchType.full;
      case 'p':
        return ForeignKeyMatchType.partial;
      case 's':
        return ForeignKeyMatchType.simple;
      default:
        return null;
    }
  }
}
