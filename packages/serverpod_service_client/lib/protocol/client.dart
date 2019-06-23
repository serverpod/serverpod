/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointCachePrio {
  Client client;
  _EndpointCachePrio(this.client);

  Future<Null> invalidateKey(String key,) async {
    return await client.callServerEndpoint('cachePrio', 'invalidateKey', 'Null', {
      'key':key,
    });
  }

  Future<Null> clear() async {
    return await client.callServerEndpoint('cachePrio', 'clear', 'Null', {
    });
  }

  Future<String> get(String key,) async {
    return await client.callServerEndpoint('cachePrio', 'get', 'String', {
      'key':key,
    });
  }

  Future<Null> put(String key,String data,String group,DateTime expiration,) async {
    return await client.callServerEndpoint('cachePrio', 'put', 'Null', {
      'key':key,
      'data':data,
      'group':group,
      'expiration':expiration,
    });
  }

  Future<Null> invalidateGroup(String group,) async {
    return await client.callServerEndpoint('cachePrio', 'invalidateGroup', 'Null', {
      'group':group,
    });
  }
}

class _EndpointInsights {
  Client client;
  _EndpointInsights(this.client);

  Future<LogResult> getLog(int numEntries,) async {
    return await client.callServerEndpoint('insights', 'getLog', 'LogResult', {
      'numEntries':numEntries,
    });
  }

  Future<CachesInfo> getCachesInfo(bool fetchKeys,) async {
    return await client.callServerEndpoint('insights', 'getCachesInfo', 'CachesInfo', {
      'fetchKeys':fetchKeys,
    });
  }

  Future<Null> shutdown() async {
    return await client.callServerEndpoint('insights', 'shutdown', 'Null', {
    });
  }

  Future<SessionLogResult> getSessionLog(int numEntries,) async {
    return await client.callServerEndpoint('insights', 'getSessionLog', 'SessionLogResult', {
      'numEntries':numEntries,
    });
  }
}

class _EndpointCache {
  Client client;
  _EndpointCache(this.client);

  Future<Null> invalidateKey(String key,) async {
    return await client.callServerEndpoint('cache', 'invalidateKey', 'Null', {
      'key':key,
    });
  }

  Future<Null> clear() async {
    return await client.callServerEndpoint('cache', 'clear', 'Null', {
    });
  }

  Future<String> get(String key,) async {
    return await client.callServerEndpoint('cache', 'get', 'String', {
      'key':key,
    });
  }

  Future<Null> put(String key,String data,String group,DateTime expiration,) async {
    return await client.callServerEndpoint('cache', 'put', 'Null', {
      'key':key,
      'data':data,
      'group':group,
      'expiration':expiration,
    });
  }

  Future<Null> invalidateGroup(String group,) async {
    return await client.callServerEndpoint('cache', 'invalidateGroup', 'Null', {
      'group':group,
    });
  }
}

class Client extends ServerpodClient {
  _EndpointCachePrio cachePrio;
  _EndpointInsights insights;
  _EndpointCache cache;

  Client(host, {SecurityContext context, ServerpodClientErrorCallback errorHandler, AuthenticationKeyManager authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {
    cachePrio = _EndpointCachePrio(this);
    insights = _EndpointInsights(this);
    cache = _EndpointCache(this);
  }

}
