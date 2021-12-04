/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointCache extends EndpointRef {
  @override
  String get name => 'cache';

  _EndpointCache(EndpointCaller caller) : super(caller);

  Future<void> put(bool priority,String key,String data,String? group,DateTime? expiration,) async {
    return await caller.callServerEndpoint('cache', 'put', 'void', {
      'priority':priority,
      'key':key,
      'data':data,
      'group':group,
      'expiration':expiration,
    });
  }

  Future<String?> get(bool priority,String key,) async {
    return await caller.callServerEndpoint('cache', 'get', 'String', {
      'priority':priority,
      'key':key,
    });
  }

  Future<void> invalidateKey(bool priority,String key,) async {
    return await caller.callServerEndpoint('cache', 'invalidateKey', 'void', {
      'priority':priority,
      'key':key,
    });
  }

  Future<void> invalidateGroup(bool priority,String group,) async {
    return await caller.callServerEndpoint('cache', 'invalidateGroup', 'void', {
      'priority':priority,
      'group':group,
    });
  }

  Future<void> clear(bool priority,) async {
    return await caller.callServerEndpoint('cache', 'clear', 'void', {
      'priority':priority,
    });
  }
}

class _EndpointInsights extends EndpointRef {
  @override
  String get name => 'insights';

  _EndpointInsights(EndpointCaller caller) : super(caller);

  Future<RuntimeSettings> getRuntimeSettings() async {
    return await caller.callServerEndpoint('insights', 'getRuntimeSettings', 'RuntimeSettings', {
    });
  }

  Future<void> setRuntimeSettings(RuntimeSettings runtimeSettings,) async {
    return await caller.callServerEndpoint('insights', 'setRuntimeSettings', 'void', {
      'runtimeSettings':runtimeSettings,
    });
  }

  Future<void> reloadRuntimeSettings() async {
    return await caller.callServerEndpoint('insights', 'reloadRuntimeSettings', 'void', {
    });
  }

  Future<void> clearAllLogs() async {
    return await caller.callServerEndpoint('insights', 'clearAllLogs', 'void', {
    });
  }

  Future<SessionLogResult> getSessionLog([int? numEntries,SessionLogFilter? filter,]) async {
    return await caller.callServerEndpoint('insights', 'getSessionLog', 'SessionLogResult', {
      'numEntries': numEntries,
      'filter': filter,
    });
  }

  Future<CachesInfo> getCachesInfo(bool fetchKeys,) async {
    return await caller.callServerEndpoint('insights', 'getCachesInfo', 'CachesInfo', {
      'fetchKeys':fetchKeys,
    });
  }

  Future<void> shutdown() async {
    return await caller.callServerEndpoint('insights', 'shutdown', 'void', {
    });
  }

  Future<ServerHealthResult> checkHealth() async {
    return await caller.callServerEndpoint('insights', 'checkHealth', 'ServerHealthResult', {
    });
  }
}

class Client extends ServerpodClient {
  late final _EndpointCache cache;
  late final _EndpointInsights insights;

  Client(String host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {
    cache = _EndpointCache(this);
    insights = _EndpointInsights(this);
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'cache' : cache,
    'insights' : insights,
  };

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {
  };
}
