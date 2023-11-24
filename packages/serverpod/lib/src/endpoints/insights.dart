import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:serverpod/src/database/analyze.dart';
import 'package:serverpod/src/database/bulk_data.dart';
import 'package:serverpod/src/database/migrations/migrations.dart';
import 'package:serverpod/src/hot_reload/hot_reload.dart';
import 'package:serverpod/src/server/health_check.dart';
import 'package:serverpod/src/util/path_util.dart';

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
    await session.dbNext.deleteWhere<SessionLogEntry>(
      where: Constant.bool(true),
    );
  }

  /// Get the latest [numEntries] from the session log.
  Future<SessionLogResult> getSessionLog(
      Session session, int? numEntries, SessionLogFilter? filter) async {
    // Filter for errors and slow
    Expression where;
    if (filter == null || (!filter.slow && !filter.error && !filter.open)) {
      where = Constant.bool(true);
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

    var rows = (await session.dbNext.find<SessionLogEntry>(
      where: where,
      limit: numEntries,
      orderBy: SessionLogEntry.t.id,
      orderDescending: true,
    ))
        .cast<SessionLogEntry>();

    var sessionLogInfo = <SessionLogInfo>[];
    for (var logEntry in rows) {
      var logRows = await session.dbNext.find<LogEntry>(
        where: LogEntry.t.sessionLogId.equals(logEntry.id),
      );

      var queryRows = await session.dbNext.find<QueryLogEntry>(
        where: QueryLogEntry.t.sessionLogId.equals(logEntry.id),
      );

      var messageRows = await session.dbNext.find<MessageLogEntry>(
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
    var metrics = await ServerHealthMetric.db.find(
      session,
      where: (t) => (t.timestamp >= start) & (t.timestamp <= end),
      orderBy: (t) => t.timestamp,
    );

    var connectionInfos = await ServerHealthConnectionInfo.db.find(
      session,
      where: (t) => (t.timestamp >= start) & (t.timestamp <= end),
      orderBy: (t) => t.timestamp,
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

  /// Returns the target structure of the database defined in the
  /// yaml files of the protocol folder.
  /// This includes the developers project, all used modules
  /// and the main serverpod package.
  ///
  /// This information can be used for database migration.
  ///
  /// See also:
  /// - [getLiveDatabaseDefinition]
  Future<DatabaseDefinition> getTargetDatabaseDefinition(
      Session session) async {
    return session.serverpod.serializationManager.getTargetDatabaseDefinition();
  }

  /// Returns the structure of the live database by
  /// extracting it using SQL.
  ///
  /// This information can be used for database migration.
  ///
  /// See also:
  /// - [getTargetDatabaseDefinition]
  Future<DatabaseDefinition> getLiveDatabaseDefinition(Session session) async {
    // Get database definition of the live database.
    var databaseDefinition = await DatabaseAnalyzer.analyze(session.dbNext);

    // Make sure that the migration manager is up-to-date.
    await session.serverpod.migrationManager.initialize(session);

    return databaseDefinition;
  }

  /// Returns the target and live database definitions. See
  /// [getTargetDatabaseDefinition] and [getLiveDatabaseDefinition] for more
  /// details.
  Future<DatabaseDefinitions> getDatabaseDefinitions(Session session) async {
    var target = await getTargetDatabaseDefinition(session);
    var live = await getLiveDatabaseDefinition(session);
    var installedMigrations =
        await DatabaseAnalyzer.getInstalledMigrationVersions(session);

    var modules = MigrationVersions.listAvailableModules();

    var latestAvailableMigrations = <DatabaseMigrationVersion>[];

    for (var module in modules) {
      var version =
          Serverpod.instance.migrationManager.getLatestVersion(module);
      latestAvailableMigrations.add(
        DatabaseMigrationVersion(
          module: module,
          version: version,
        ),
      );
    }

    return DatabaseDefinitions(
      target: target,
      live: live,
      installedMigrations: installedMigrations,
      latestAvailableMigrations: latestAvailableMigrations,
    );
  }

  /// Exports raw data serialized in JSON from the database.
  Future<BulkData> fetchDatabaseBulkData(
    Session session, {
    required String table,
    required int startingId,
    required int limit,
    Filter? filter,
  }) async {
    try {
      return DatabaseBulkData.exportTableData(
        database: session.dbNext,
        table: table,
        lastId: startingId,
        limit: limit,
        filter: filter,
      );
    } catch (e) {
      throw BulkDataException(
        message: 'Failed to fetch bulk data. ($e)',
      );
    }
  }

  /// Executes a list of queries on the database and returns the last result.
  /// The queries are executed in a single transaction.
  Future<BulkQueryResult> runQueries(
    Session session,
    List<String> queries,
  ) async {
    try {
      var result = await DatabaseBulkData.executeQueries(
        database: session.dbNext,
        queries: queries,
      );
      return result;
    } catch (e) {
      if (e is PostgreSQLException) {
        throw BulkDataException(
          message: 'Failed to execute query: ${e.message}',
        );
      } else {
        throw BulkDataException(
          message: 'Failed to execute query: $e',
        );
      }
    }
  }

  /// Returns the approximate number of rows in the provided [table].
  Future<int> getDatabaseRowCount(
    Session session, {
    required String table,
  }) async {
    return DatabaseBulkData.approximateRowCount(
      database: session.dbNext,
      table: table,
    );
  }

  /// Executes SQL commands. Returns the number of rows affected.
  Future<int> executeSql(Session session, String sql) async {
    try {
      return await session.dbNext.unsafeExecute(sql);
    } catch (e) {
      throw ServerpodSqlException(
        message: '$e',
        sql: sql,
      );
    }
  }

  /// Fetches a file from the server. Only whitelisted files in
  /// [Serverpod.filesWhitelistedForInsights] can be fetched.
  /// The file path must be in unix format and relative to the servers root
  /// directory.
  Future<String> fetchFile(Session session, String path) async {
    // Test the file in unix format.
    if (!PathUtil.isFileWhitelisted(
        path, session.serverpod.filesWhitelistedForInsights)) {
      throw AccessDeniedException(
        message: 'File is not in whitelist: $path',
      );
    }

    // Convert the path to platform specific format and fetch the file.
    var file = File(PathUtil.relativePathToPlatformPath(path));
    if (!await file.exists()) {
      throw FileNotFoundException(
        message: 'File not found: $path',
      );
    }

    return await file.readAsString();
  }
}
