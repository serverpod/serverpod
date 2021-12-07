import 'dart:convert';
import 'dart:io';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'cache.dart';
import 'local_cache.dart';

/// The [DistributedCache] provides a mean to cache [SerializableEntity]s
/// across multiple clustered servers. When accessing an entity it will either
/// be in a cache local to the server, or on another server. If it resides in
/// another server it will be retrieved through an access call to that server.
/// The caches are typically automatically setup and managed by the [Server].
class DistributedCache extends Cache {
  final LocalCache _localCache;
  final List<RemoteServerConfig?> _cluster = <RemoteServerConfig?>[];
  final List<Client> _clients = <Client>[];
  int? _serverId;
  final bool _isPrio;

  /// Creates a new [DistributedCache].
  DistributedCache(int maxEntries, SerializationManager serializationManager,
      ServerConfig config, int serverId, this._isPrio)
      : _localCache = LocalCache(maxEntries, Protocol()),
        super(maxEntries, serializationManager) {
    _serverId = serverId;

    var serverKeys = config.cluster.keys.toList();
    serverKeys.sort();

    for (var key in serverKeys) {
      _cluster.add(config.cluster[key]);

      var context = SecurityContext();
      context.setTrustedCertificates(sslCertificatePath(config.runMode, key));
      _clients.add(Client(
          'https://${config.cluster[key]!.address}:${config.cluster[key]!.servicePort}/',
          context: context));
    }
  }

  Client? _clientFromKey(String key) {
    var serverNum = key.hashCode % _cluster.length;

    if (_cluster[serverNum]!.serverId == _serverId) return null;

    return _clients[serverNum];
  }

  @override
  Future<void> put(String key, SerializableEntity object,
      {Duration? lifetime, String? group}) async {
    var client = _clientFromKey(key);

    DateTime? expiration;
    if (lifetime != null) expiration = DateTime.now().add(lifetime);

    var data = jsonEncode(object.serializeAll());

    if (client == null) {
      await _localCache.put(key, DistributedCacheEntry(data: data),
          lifetime: lifetime, group: group);
    } else {
      try {
        await client.cache.put(_isPrio, key, data, group, expiration);
      } catch (e) {
        return;
      }
    }
  }

  @override
  Future<SerializableEntity?> get(String key) async {
    var client = _clientFromKey(key);

    if (client == null) {
      var entry = await _localCache.get(key) as DistributedCacheEntry?;
      if (entry == null) return null;

      Map<String, dynamic>? serialization =
          jsonDecode(entry.data).cast<String, dynamic>();
      return serializationManager.createEntityFromSerialization(serialization);
    } else {
      String? value;
      try {
        value = await client.cache.get(_isPrio, key);
      } catch (e) {
        // Failed to contact cache server
        return null;
      }
      if (value == null || value == 'null') return null;

      Map<String, dynamic>? serialization =
          jsonDecode(value).cast<String, dynamic>();
      return serializationManager.createEntityFromSerialization(serialization);
    }
  }

  @override
  Future<void> invalidateKey(String key) async {
    var client = _clientFromKey(key);

    if (client == null) {
      await _localCache.invalidateKey(key);
    } else {
      try {
        await client.cache.invalidateKey(_isPrio, key);
      } catch (e) {
        return;
      }
    }
  }

  @override
  Future<void> invalidateGroup(String group) async {
    for (var serverNum = 0; serverNum < _cluster.length; serverNum += 1) {
      if (_cluster[serverNum]!.serverId == _serverId) {
        await _localCache.invalidateGroup(group);
      } else {
        try {
          await _clients[serverNum].cache.invalidateGroup(_isPrio, group);
        } catch (e) {
          continue;
        }
      }
    }
  }

  @override
  Future<void> clear() async {
    for (var serverNum = 0; serverNum < _cluster.length; serverNum += 1) {
      if (_cluster[serverNum]!.serverId == _serverId) {
        await _localCache.clear();
      } else {
        try {
          await _clients[serverNum].cache.clear(_isPrio);
        } catch (e) {
          continue;
        }
      }
    }
  }

  /// Returns the local cache used by the distributed cache. A fraction of the
  /// objects will be stored in the local cache, and can also be sent to other
  /// servers in the server cluster.
  LocalCache get localCache => _localCache;

  @override
  int get localSize => _localCache.localSize;

  @override
  List<String> get localKeys => _localCache.localKeys;
}
