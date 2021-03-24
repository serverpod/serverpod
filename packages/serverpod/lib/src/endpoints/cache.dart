import 'package:serverpod_service_client/serverpod_service_client.dart';

import '../../server.dart';
import '../cache/local_cache.dart';
import '../cache/distributed_cache.dart';

class CacheEndpoint extends Endpoint {
  bool get logSessions => false;

  LocalCache _cache;
  LocalCache _cachePrio;

  @override
  void initialize(Server server, String name) {
    super.initialize(server, name);
    DistributedCache distributedCache = pod.caches.distributed;
    DistributedCache distributedCachePrio = pod.caches.distributedPrio;
    _cache = distributedCache?.localCache;
    _cachePrio = distributedCachePrio?.localCache;
  }

  Future<Null> put(Session session, bool priority, String key, String data, String group, DateTime expiration) async {
    Duration lifetime;
    if (expiration != null)
      lifetime = expiration.difference(DateTime.now());

    await (priority ? _cachePrio : _cache).put(key, DistributedCacheEntry(data: data), group: group, lifetime: lifetime);
  }

  Future<String> get(Session session, bool priority, String key) async {
    DistributedCacheEntry entry = await (priority ? _cachePrio : _cache).get(key);
    if (entry == null)
      return null;
    return entry.data;
  }

  Future<Null> invalidateKey(Session session, bool priority, String key) async {
    await (priority ? _cachePrio : _cache).invalidateKey(key);
  }

  Future< Null> invalidateGroup(Session session, bool priority, String group) async {
    await (priority ? _cachePrio : _cache).invalidateGroup(group);
  }

  Future<Null> clear(Session session, bool priority) async {
    await (priority ? _cachePrio : _cache).clear();
  }
}