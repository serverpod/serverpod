/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

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
  _EndpointCache cache;

  Client(host, {SecurityContext context, ServerpodClientErrorCallback errorHandler, AuthorizationKeyManager authorizationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authorizationKeyManager: authorizationKeyManager) {
    cache = _EndpointCache(this);
  }

}
