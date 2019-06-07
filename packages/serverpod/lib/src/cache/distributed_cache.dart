import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

import '../server/config.dart';

import 'cache.dart';
import 'local_cache.dart';

class DistributedCache extends Cache {
  LocalCache _localCache;
  List<RemoteServerConfig> _cluster = <RemoteServerConfig>[];
  List<Client> _clients = <Client>[];
  int _serverId;
  
  DistributedCache(int maxEntries, SerializationManager serializationManager, ServerConfig config, int serverId) : super(maxEntries, serializationManager) {
    _localCache = LocalCache(maxEntries, serializationManager);
    _serverId = serverId;
    
    var serverKeys = config.cluster.keys.toList();
    serverKeys.sort();
    
    for (int key in serverKeys) {
      _cluster.add(config.cluster[key]);
      _clients.add(Client('http://${config.cluster[key].address}:${config.cluster[key].servicePort}/'));
    }
  }
  
  Client _clientFromKey(String key) {
    int serverNum = key.hashCode % _cluster.length;

    if (_cluster[serverNum].serverId == _serverId)
      return null;

    return _clients[serverNum];
  }

  Future<Null> put(String key, SerializableEntity object, {Duration lifetime, String group}) async {
    assert(key != null, 'Cannot use a null key');
    assert(object != null, 'Cannot put a null object');
    var client = _clientFromKey(key);

    DateTime expiration;
    if (lifetime != null)
      expiration = DateTime.now().add(lifetime);

    if (client == null) {
      await _localCache.put(key, object);
    }
    else {
      try {
        await client.cache.put(
            key, jsonEncode(object.serializeAll()), group, expiration);
      }
      catch (e) {}
    }
  }

  Future<SerializableEntity> get(String key) async {
    assert(key != null, 'Cannot use a null key');
    var client = _clientFromKey(key);

    if (client == null) {
      return await _localCache.get(key);
    }
    else {
      String value;
      try {
        value = await client.cache.get(key);
      }
      catch(e) {
        print('caught exception $e');
        return null;
      }
      if (value == null || value == 'null')
        return null;

      Map<String, dynamic> serialization = jsonDecode(value).cast<
          String,
          dynamic>();
      return serializationManager.createEntityFromSerialization(
          serialization);
    }
  }

  Future<Null> invalidateKey(String key) async {
    assert(key != null, 'Cannot use a null key');
    var client = _clientFromKey(key);

    if (client == null) {
      await _localCache.invalidateKey(key);
    }
    else {
      try {
        await client.cache.invalidateKey(key);
      }
      catch (e) {
        return;
      }
    }
  }

  Future< Null> invalidateGroup(String group) async {
    for (var serverNum = 0; serverNum < _cluster.length; serverNum += 1) {
      if (_cluster[serverNum].serverId == _serverId) {
        await _localCache.invalidateGroup(group);
      }
      else {
        try {
          await _clients[serverNum].cache.invalidateGroup(group);
        }
        catch (e) {
          continue;
        }
      }
    }
  }

  Future<Null> clear() async {
    for (var serverNum = 0; serverNum < _cluster.length; serverNum += 1) {
      if (_cluster[serverNum].serverId == _serverId) {
        await _localCache.clear();
      }
      else {
        try {
          await _clients[serverNum].cache.clear();
        }
        catch (e) {
          continue;
        }
      }
    }
  }

  int get size => _localCache.size;
}