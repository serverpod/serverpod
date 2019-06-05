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

    if (client == null)
      await _localCache.put(key, object);
    else
      await client.cache.put(key, jsonEncode(object.serializeAll()), group, expiration);
  }

  Future<SerializableEntity> get(String key) async {
    assert(key != null, 'Cannot use a null key');
    var client = _clientFromKey(key);

    try {
      if (client == null) {
        return await _localCache.get(key);
      }
      else {
        String value = await client.cache.get(key);
        if (value == null || value == 'null')
          return null;

        Map<String, dynamic> serialization = jsonDecode(value).cast<
            String,
            dynamic>();
        return serializationManager.createEntityFromSerialization(
            serialization);
      }
    }
    catch(e) {
      return null;
    }
  }

  Future<Null> invalidateKey(String key) async {
    assert(key != null, 'Cannot use a null key');
    var client = _clientFromKey(key);

    if (client == null)
      await _localCache.invalidateKey(key);
    else
      await client.cache.invalidateKey(key);
  }

  Future< Null> invalidateGroup(String group) async {
    for (var serverNum = 0; serverNum < _cluster.length; serverNum += 1) {
      if (_cluster[serverNum].serverId == _serverId)
        await _localCache.invalidateGroup(group);
      else
        await _clients[serverNum].cache.invalidateGroup(group);
    }
  }

  Future<Null> clear() async {
    for (var serverNum = 0; serverNum < _cluster.length; serverNum += 1) {
      if (_cluster[serverNum].serverId == _serverId)
        await _localCache.clear();
      else
        await _clients[serverNum].cache.clear();
    }
  }

  int get size => _localCache.size;
}