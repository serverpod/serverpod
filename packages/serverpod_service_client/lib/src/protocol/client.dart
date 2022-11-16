/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

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
import 'dart:io' as _i8;
import 'protocol.dart' as _i9;

/// The [InsightsEndpoint] provides a way to access real time information from
/// the running server or to change settings.
class _EndpointInsights extends _i1.EndpointRef {
  _EndpointInsights(_i1.EndpointCaller caller) : super(caller);

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
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i8.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i9.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {
    insights = _EndpointInsights(this);
  }

  late final _EndpointInsights insights;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'insights': insights};
  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
