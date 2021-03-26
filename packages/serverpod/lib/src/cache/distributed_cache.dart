import 'dart:convert';
import 'dart:io';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/config.dart';

import 'cache.dart';
import 'local_cache.dart';

class DistributedCache extends Cache {
  LocalCache _localCache;
  List<RemoteServerConfig> _cluster = <RemoteServerConfig>[];
  List<Client> _clients = <Client>[];
  int _serverId;
  bool _isPrio;
  
  DistributedCache(int maxEntries, SerializationManager serializationManager, ServerConfig config, int serverId, this._isPrio) : super(maxEntries, serializationManager) {
    _localCache = LocalCache(maxEntries, Protocol());
    _serverId = serverId;
    
    var serverKeys = config.cluster.keys.toList();
    serverKeys.sort();
    
    for (int key in serverKeys) {
      _cluster.add(config.cluster[key]);

      var context = SecurityContext();
      context.setTrustedCertificates(sslCertificatePath(config.runMode, key));
      _clients.add(Client('https://${config.cluster[key].address}:${config.cluster[key].servicePort}/', context: context));
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

    String data = jsonEncode(object.serializeAll());

    if (client == null) {
      await _localCache.put(key, DistributedCacheEntry(data: data), lifetime: lifetime, group: group);
    }
    else {
      try {
        await client.cache.put(_isPrio, key, data, group, expiration);
      }
      catch (e) {}
    }
  }

  Future<SerializableEntity> get(String key) async {
    assert(key != null, 'Cannot use a null key');
    var client = _clientFromKey(key);

    if (client == null) {
      DistributedCacheEntry entry = await _localCache.get(key);
      if (entry == null)
        return null;

      Map<String, dynamic> serialization = jsonDecode(entry.data).cast<String, dynamic>();
      return serializationManager.createEntityFromSerialization(serialization);
    }
    else {
      String value;
      try {
        value = await client.cache.get(_isPrio, key);
      }
      catch(e) {
        // Failed to contact cache server
        return null;
      }
      if (value == null || value == 'null')
        return null;

      Map<String, dynamic> serialization = jsonDecode(value).cast<String, dynamic>();
      return serializationManager.createEntityFromSerialization(serialization);
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
        await client.cache.invalidateKey(_isPrio, key);
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
          await _clients[serverNum].cache.invalidateGroup(_isPrio, group);
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
          await _clients[serverNum].cache.clear(_isPrio);
        }
        catch (e) {
          continue;
        }
      }
    }
  }

  LocalCache get localCache => _localCache;

  int get localSize => _localCache.localSize;

  List<String> get localKeys => _localCache.localKeys;
}