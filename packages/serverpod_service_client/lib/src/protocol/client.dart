/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_service_client/src/protocol/runtime_settings.dart'
    as _i3;
import 'package:serverpod_service_client/src/protocol/session_log_result.dart'
    as _i4;
import 'package:serverpod_service_client/src/protocol/session_log_filter.dart'
    as _i5;
import 'package:serverpod_service_client/src/protocol/caches_info.dart' as _i6;
import 'package:serverpod_service_client/src/protocol/server_health_result.dart'
    as _i7;
import 'package:serverpod_service_client/src/protocol/database/table_definition.dart'
    as _i8;
import 'package:serverpod_service_client/src/protocol/database/database_definition.dart'
    as _i9;
import 'package:serverpod_service_client/src/protocol/database/database_definitions.dart'
    as _i10;
import 'package:serverpod_service_client/src/protocol/database/bulk_data.dart'
    as _i11;
import 'package:serverpod_service_client/src/protocol/database/filter/filter.dart'
    as _i12;
import 'package:serverpod_service_client/src/protocol/database/bulk_query_result.dart'
    as _i13;
import 'dart:io' as _i14;
import 'protocol.dart' as _i15;

/// The [InsightsEndpoint] provides a way to access real time information from
/// the running server or to change settings.
/// {@category Endpoint}
class EndpointInsights extends _i1.EndpointRef {
  EndpointInsights(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insights';

  /// Get the current [RuntimeSettings] from the running [Server].
  _i2.Future<_i3.RuntimeSettings> getRuntimeSettings() =>
      caller.callServerEndpoint<_i3.RuntimeSettings>(
        'insights',
        'getRuntimeSettings',
        {},
      );

  /// Update the current [RuntimeSettings] in the running [Server].
  _i2.Future<void> setRuntimeSettings(_i3.RuntimeSettings runtimeSettings) =>
      caller.callServerEndpoint<void>(
        'insights',
        'setRuntimeSettings',
        {'runtimeSettings': runtimeSettings},
      );

  /// Clear all server logs.
  _i2.Future<void> clearAllLogs() => caller.callServerEndpoint<void>(
        'insights',
        'clearAllLogs',
        {},
      );

  /// Get the latest [numEntries] from the session log.
  _i2.Future<_i4.SessionLogResult> getSessionLog(
    int? numEntries,
    _i5.SessionLogFilter? filter,
  ) =>
      caller.callServerEndpoint<_i4.SessionLogResult>(
        'insights',
        'getSessionLog',
        {
          'numEntries': numEntries,
          'filter': filter,
        },
      );

  /// Get the latest [numEntries] from the session log.
  _i2.Future<_i4.SessionLogResult> getOpenSessionLog(
    int? numEntries,
    _i5.SessionLogFilter? filter,
  ) =>
      caller.callServerEndpoint<_i4.SessionLogResult>(
        'insights',
        'getOpenSessionLog',
        {
          'numEntries': numEntries,
          'filter': filter,
        },
      );

  /// Retrieve information about the state of the caches on this server.
  _i2.Future<_i6.CachesInfo> getCachesInfo(bool fetchKeys) =>
      caller.callServerEndpoint<_i6.CachesInfo>(
        'insights',
        'getCachesInfo',
        {'fetchKeys': fetchKeys},
      );

  /// Safely shuts down this [ServerPod].
  _i2.Future<void> shutdown() => caller.callServerEndpoint<void>(
        'insights',
        'shutdown',
        {},
      );

  /// Performs a health check on the running [ServerPod].
  _i2.Future<_i7.ServerHealthResult> checkHealth() =>
      caller.callServerEndpoint<_i7.ServerHealthResult>(
        'insights',
        'checkHealth',
        {},
      );

  /// Gets historical health check data. Returns data for the whole cluster.
  _i2.Future<_i7.ServerHealthResult> getHealthData(
    DateTime start,
    DateTime end,
  ) =>
      caller.callServerEndpoint<_i7.ServerHealthResult>(
        'insights',
        'getHealthData',
        {
          'start': start,
          'end': end,
        },
      );

  /// Performs a hot reload of the server.
  _i2.Future<bool> hotReload() => caller.callServerEndpoint<bool>(
        'insights',
        'hotReload',
        {},
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
  _i2.Future<List<_i8.TableDefinition>> getTargetTableDefinition() =>
      caller.callServerEndpoint<List<_i8.TableDefinition>>(
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
  _i2.Future<_i9.DatabaseDefinition> getLiveDatabaseDefinition() =>
      caller.callServerEndpoint<_i9.DatabaseDefinition>(
        'insights',
        'getLiveDatabaseDefinition',
        {},
      );

  /// Returns the target and live database definitions. See
  /// [getTargetTableDefinition] and [getLiveDatabaseDefinition] for more
  /// details.
  _i2.Future<_i10.DatabaseDefinitions> getDatabaseDefinitions() =>
      caller.callServerEndpoint<_i10.DatabaseDefinitions>(
        'insights',
        'getDatabaseDefinitions',
        {},
      );

  /// Exports raw data serialized in JSON from the database.
  _i2.Future<_i11.BulkData> fetchDatabaseBulkData({
    required String table,
    required int startingId,
    required int limit,
    _i12.Filter? filter,
  }) =>
      caller.callServerEndpoint<_i11.BulkData>(
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
  _i2.Future<_i13.BulkQueryResult> runQueries(List<String> queries) =>
      caller.callServerEndpoint<_i13.BulkQueryResult>(
        'insights',
        'runQueries',
        {'queries': queries},
      );

  /// Returns the approximate number of rows in the provided [table].
  _i2.Future<int> getDatabaseRowCount({required String table}) =>
      caller.callServerEndpoint<int>(
        'insights',
        'getDatabaseRowCount',
        {'table': table},
      );

  /// Executes SQL commands. Returns the number of rows affected.
  _i2.Future<int> executeSql(String sql) => caller.callServerEndpoint<int>(
        'insights',
        'executeSql',
        {'sql': sql},
      );

  /// Fetches a file from the server. Only whitelisted files in
  /// [Serverpod.filesWhitelistedForInsights] can be fetched.
  /// The file path must be in unix format and relative to the servers root
  /// directory.
  _i2.Future<String> fetchFile(String path) =>
      caller.callServerEndpoint<String>(
        'insights',
        'fetchFile',
        {'path': path},
      );
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i14.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? connectionTimeout,
  }) : super(
          host,
          _i15.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
          connectionTimeout: connectionTimeout,
        ) {
    insights = EndpointInsights(this);
  }

  late final EndpointInsights insights;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'insights': insights};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
