/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

/// The [InsightsEndpoint] provides a way to access real time information from
/// the running server or to change settings.
class _EndpointInsights extends EndpointRef {
  @override
  String get name => 'insights';

  _EndpointInsights(EndpointCaller caller) : super(caller);

  /// Get the current [RuntimeSettings] from the running [Server].
  Future<RuntimeSettings> getRuntimeSettings() async {
    var retval = await caller.callServerEndpoint(
        'insights', 'getRuntimeSettings', 'RuntimeSettings', {});
    return retval;
  }

  /// Update the current [RuntimeSettings] in the running [Server].
  Future<void> setRuntimeSettings(
    RuntimeSettings runtimeSettings,
  ) async {
    var retval = await caller
        .callServerEndpoint('insights', 'setRuntimeSettings', 'void', {
      'runtimeSettings': runtimeSettings,
    });
    return retval;
  }

  /// Clear all server logs.
  Future<void> clearAllLogs() async {
    var retval =
        await caller.callServerEndpoint('insights', 'clearAllLogs', 'void', {});
    return retval;
  }

  /// Get the latest [numEntries] from the session log.
  Future<SessionLogResult> getSessionLog(
    int? numEntries,
    SessionLogFilter? filter,
  ) async {
    var retval = await caller
        .callServerEndpoint('insights', 'getSessionLog', 'SessionLogResult', {
      'numEntries': numEntries,
      'filter': filter,
    });
    return retval;
  }

  /// Get the latest [numEntries] from the session log.
  Future<SessionLogResult> getOpenSessionLog(
    int? numEntries,
    SessionLogFilter? filter,
  ) async {
    var retval = await caller.callServerEndpoint(
        'insights', 'getOpenSessionLog', 'SessionLogResult', {
      'numEntries': numEntries,
      'filter': filter,
    });
    return retval;
  }

  /// Retrieve information about the state of the caches on this server.
  Future<CachesInfo> getCachesInfo(
    bool fetchKeys,
  ) async {
    var retval = await caller
        .callServerEndpoint('insights', 'getCachesInfo', 'CachesInfo', {
      'fetchKeys': fetchKeys,
    });
    return retval;
  }

  /// Safely shuts down this [ServerPod].
  Future<void> shutdown() async {
    var retval =
        await caller.callServerEndpoint('insights', 'shutdown', 'void', {});
    return retval;
  }

  /// Performs a health check on the running [ServerPod].
  Future<ServerHealthResult> checkHealth() async {
    var retval = await caller.callServerEndpoint(
        'insights', 'checkHealth', 'ServerHealthResult', {});
    return retval;
  }

  /// Gets historical health check data. Returns data for the whole cluster.
  Future<ServerHealthResult> getHealthData(
    DateTime start,
    DateTime end,
  ) async {
    var retval = await caller
        .callServerEndpoint('insights', 'getHealthData', 'ServerHealthResult', {
      'start': start,
      'end': end,
    });
    return retval;
  }

  /// Performs a hot reload of the server.
  Future<bool> hotReload() async {
    var retval =
        await caller.callServerEndpoint('insights', 'hotReload', 'bool', {});
    return retval;
  }
}

class Client extends ServerpodClient {
  late final _EndpointInsights insights;

  Client(String host,
      {SecurityContext? context,
      ServerpodClientErrorCallback? errorHandler,
      AuthenticationKeyManager? authenticationKeyManager})
      : super(host, Protocol.instance,
            context: context,
            errorHandler: errorHandler,
            authenticationKeyManager: authenticationKeyManager) {
    insights = _EndpointInsights(this);
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
        'insights': insights,
      };

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};
}
