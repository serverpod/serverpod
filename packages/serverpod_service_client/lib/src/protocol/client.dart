/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointInsights extends EndpointRef {
  @override
  String get name => 'insights';

  _EndpointInsights(EndpointCaller caller) : super(caller);

  Future<RuntimeSettings> getRuntimeSettings() async {
    return await caller.callServerEndpoint(
        'insights', 'getRuntimeSettings', 'RuntimeSettings', {});
  }

  Future<void> setRuntimeSettings(
    RuntimeSettings runtimeSettings,
  ) async {
    return await caller
        .callServerEndpoint('insights', 'setRuntimeSettings', 'void', {
      'runtimeSettings': runtimeSettings,
    });
  }

  Future<void> reloadRuntimeSettings() async {
    return await caller
        .callServerEndpoint('insights', 'reloadRuntimeSettings', 'void', {});
  }

  Future<void> clearAllLogs() async {
    return await caller
        .callServerEndpoint('insights', 'clearAllLogs', 'void', {});
  }

  Future<SessionLogResult> getSessionLog(
    int? numEntries,
    SessionLogFilter? filter,
  ) async {
    return await caller
        .callServerEndpoint('insights', 'getSessionLog', 'SessionLogResult', {
      'numEntries': numEntries,
      'filter': filter,
    });
  }

  Future<SessionLogResult> getOpenSessionLog(
    int? numEntries,
    SessionLogFilter? filter,
  ) async {
    return await caller.callServerEndpoint(
        'insights', 'getOpenSessionLog', 'SessionLogResult', {
      'numEntries': numEntries,
      'filter': filter,
    });
  }

  Future<CachesInfo> getCachesInfo(
    bool fetchKeys,
  ) async {
    return await caller
        .callServerEndpoint('insights', 'getCachesInfo', 'CachesInfo', {
      'fetchKeys': fetchKeys,
    });
  }

  Future<void> shutdown() async {
    return await caller.callServerEndpoint('insights', 'shutdown', 'void', {});
  }

  Future<ServerHealthResult> checkHealth() async {
    return await caller.callServerEndpoint(
        'insights', 'checkHealth', 'ServerHealthResult', {});
  }

  Future<void> hotReload() async {
    return await caller.callServerEndpoint('insights', 'hotReload', 'void', {});
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
