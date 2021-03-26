/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointCache {
  Client client;
  _EndpointCache(this.client);

  Future<Null?> put(bool? priority,String? key,String? data,String? group,DateTime? expiration,) async {
    return await client.callServerEndpoint('cache', 'put', 'Null', {
      'priority':priority,
      'key':key,
      'data':data,
      'group':group,
      'expiration':expiration,
    });
  }

  Future<String?> get(bool? priority,String? key,) async {
    return await client.callServerEndpoint('cache', 'get', 'String', {
      'priority':priority,
      'key':key,
    });
  }

  Future<Null?> invalidateKey(bool? priority,String? key,) async {
    return await client.callServerEndpoint('cache', 'invalidateKey', 'Null', {
      'priority':priority,
      'key':key,
    });
  }

  Future<Null?> invalidateGroup(bool? priority,String? group,) async {
    return await client.callServerEndpoint('cache', 'invalidateGroup', 'Null', {
      'priority':priority,
      'group':group,
    });
  }

  Future<Null?> clear(bool? priority,) async {
    return await client.callServerEndpoint('cache', 'clear', 'Null', {
      'priority':priority,
    });
  }
}

class _EndpointInsights {
  Client client;
  _EndpointInsights(this.client);

  Future<LogResult?> getLog(int? numEntries,) async {
    return await client.callServerEndpoint('insights', 'getLog', 'LogResult', {
      'numEntries':numEntries,
    });
  }

  Future<SessionLogResult?> getSessionLog(int? numEntries,) async {
    return await client.callServerEndpoint('insights', 'getSessionLog', 'SessionLogResult', {
      'numEntries':numEntries,
    });
  }

  Future<CachesInfo?> getCachesInfo(bool? fetchKeys,) async {
    return await client.callServerEndpoint('insights', 'getCachesInfo', 'CachesInfo', {
      'fetchKeys':fetchKeys,
    });
  }

  Future<Null?> shutdown() async {
    return await client.callServerEndpoint('insights', 'shutdown', 'Null', {
    });
  }

  Future<ServerHealthResult?> checkHealth() async {
    return await client.callServerEndpoint('insights', 'checkHealth', 'ServerHealthResult', {
    });
  }
}

class Client extends ServerpodClient {
  late final _EndpointCache cache;
  late final _EndpointInsights insights;

  Client(host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {
    cache = _EndpointCache(this);
    insights = _EndpointInsights(this);
  }
}
