/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_service_client/src/protocol/caches_info.dart'
    as _i6gd0gov;
import 'package:serverpod_service_client/src/protocol/runtime_settings.dart'
    as _ipr165ix;
import 'package:serverpod_service_client/src/protocol/server_health_result.dart'
    as _i5svn267;
import 'package:serverpod_service_client/src/protocol/session_log_filter.dart'
    as _i215g5d9;
import 'package:serverpod_service_client/src/protocol/session_log_result.dart'
    as _iizgo6ax;
import 'protocol.dart' as _il2as5qe;

/// The [InsightsEndpoint] provides a way to access real time information from
/// the running server or to change settings.
/// {@category Endpoint}
class EndpointInsights extends _isc.EndpointRef {
  EndpointInsights(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insights';

  /// Get the current [RuntimeSettings] from the running [Server].
  _ida.Future<_ipr165ix.RuntimeSettings> getRuntimeSettings() =>
      caller.callServerEndpoint<_ipr165ix.RuntimeSettings>(
        'insights',
        'getRuntimeSettings',
        {},
      );

  /// Update the current [RuntimeSettings] in the running [Server].
  _ida.Future<void> setRuntimeSettings(
    _ipr165ix.RuntimeSettings runtimeSettings,
  ) => caller.callServerEndpoint<void>(
    'insights',
    'setRuntimeSettings',
    {'runtimeSettings': runtimeSettings},
  );

  /// Clear all server logs.
  _ida.Future<void> clearAllLogs() => caller.callServerEndpoint<void>(
    'insights',
    'clearAllLogs',
    {},
  );

  /// Get the latest [numEntries] from the session log.
  _ida.Future<_iizgo6ax.SessionLogResult> getSessionLog(
    int? numEntries,
    _i215g5d9.SessionLogFilter? filter,
  ) => caller.callServerEndpoint<_iizgo6ax.SessionLogResult>(
    'insights',
    'getSessionLog',
    {
      'numEntries': numEntries,
      'filter': filter,
    },
  );

  /// Retrieve information about the state of the caches on this server.
  _ida.Future<_i6gd0gov.CachesInfo> getCachesInfo(bool fetchKeys) =>
      caller.callServerEndpoint<_i6gd0gov.CachesInfo>(
        'insights',
        'getCachesInfo',
        {'fetchKeys': fetchKeys},
      );

  /// Performs a health check on the running [ServerPod].
  _ida.Future<_i5svn267.ServerHealthResult> checkHealth() =>
      caller.callServerEndpoint<_i5svn267.ServerHealthResult>(
        'insights',
        'checkHealth',
        {},
      );

  /// Gets historical health check data. Returns data for the whole cluster.
  _ida.Future<_i5svn267.ServerHealthResult> getHealthData(
    DateTime start,
    DateTime end,
  ) => caller.callServerEndpoint<_i5svn267.ServerHealthResult>(
    'insights',
    'getHealthData',
    {
      'start': start,
      'end': end,
    },
  );

  /// Returns the target structure of the database defined in the
  /// yaml files of the protocol folder.
  /// This includes the developers project, all used modules
  /// and the main serverpod package.
  ///
  /// This information can be used for database migration.
  ///
  /// See also:
  /// - [getLiveDatabaseDefinition]
  _ida.Future<List<_isd.TableDefinition>> getTargetTableDefinition() =>
      caller.callServerEndpoint<List<_isd.TableDefinition>>(
        'insights',
        'getTargetTableDefinition',
        {},
      );

  /// Returns the structure of the live database by
  /// extracting it using SQL.
  ///
  /// This information can be used for database migration.
  ///
  /// See also:
  /// - [getTargetTableDefinition]
  _ida.Future<_isd.DatabaseDefinition> getLiveDatabaseDefinition() =>
      caller.callServerEndpoint<_isd.DatabaseDefinition>(
        'insights',
        'getLiveDatabaseDefinition',
        {},
      );

  /// Applies pending database migrations to the running pod, mirroring the
  /// boot-time path triggered by `--apply-migrations` and
  /// `--apply-repair-migration`. Verifies database integrity after applying.
  ///
  /// Expects pending and/or repair migrations to be available in the
  /// project's `migrations/` folder. The pod's serialization manager
  /// (which reflects the latest hot-reloaded code) is used as the source
  /// of truth for the target schema during verification.
  ///
  /// Used by `serverpod start`'s watch loop to apply newly generated
  /// migrations without restarting the pod.
  _ida.Future<_isd.MigrationsApplyResult> applyMigrations({
    required bool applyRepairMigration,
    required bool applyMigrations,
  }) => caller.callServerEndpoint<_isd.MigrationsApplyResult>(
    'insights',
    'applyMigrations',
    {
      'applyRepairMigration': applyRepairMigration,
      'applyMigrations': applyMigrations,
    },
  );

  /// Returns the target and live database definitions. See
  /// [getTargetTableDefinition] and [getLiveDatabaseDefinition] for more
  /// details.
  _ida.Future<_isd.DatabaseDefinitions> getDatabaseDefinitions() =>
      caller.callServerEndpoint<_isd.DatabaseDefinitions>(
        'insights',
        'getDatabaseDefinitions',
        {},
      );

  /// Exports raw data serialized in JSON from the database.
  ///
  /// Requires database access to be enabled through the server configuration,
  /// see [_requireDatabaseAccess].
  _ida.Future<_isd.BulkData> fetchDatabaseBulkData({
    required String table,
    required int startingId,
    required int limit,
    _isd.Filter? filter,
  }) => caller.callServerEndpoint<_isd.BulkData>(
    'insights',
    'fetchDatabaseBulkData',
    {
      'table': table,
      'startingId': startingId,
      'limit': limit,
      'filter': filter,
    },
  );

  /// Executes a list of queries on the database and returns the last result.
  /// The queries are executed in a single transaction.
  ///
  /// Requires database access to be enabled through the server configuration,
  /// see [_requireDatabaseAccess].
  _ida.Future<_isd.BulkQueryResult> runQueries(List<String> queries) =>
      caller.callServerEndpoint<_isd.BulkQueryResult>(
        'insights',
        'runQueries',
        {'queries': queries},
      );

  /// Returns the approximate number of rows in the provided [table].
  ///
  /// Requires database access to be enabled through the server configuration,
  /// see [_requireDatabaseAccess].
  _ida.Future<int> getDatabaseRowCount({required String table}) =>
      caller.callServerEndpoint<int>(
        'insights',
        'getDatabaseRowCount',
        {'table': table},
      );

  /// Executes SQL commands. Returns the number of rows affected.
  ///
  /// Requires database access to be enabled through the server configuration,
  /// see [_requireDatabaseAccess].
  _ida.Future<int> executeSql(String sql) => caller.callServerEndpoint<int>(
    'insights',
    'executeSql',
    {'sql': sql},
  );

  /// Fetches a file from the server. Only whitelisted files in
  /// [Serverpod.filesWhitelistedForInsights] can be fetched.
  /// The file path must be in unix format and relative to the servers root
  /// directory.
  _ida.Future<String> fetchFile(String path) =>
      caller.callServerEndpoint<String>(
        'insights',
        'fetchFile',
        {'path': path},
      );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    insights = EndpointInsights(this);
  }

  late final EndpointInsights insights;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {'insights': insights};

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
