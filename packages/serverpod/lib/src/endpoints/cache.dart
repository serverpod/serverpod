import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

import '../../server.dart';
import '../cache/local_cache.dart';
import '../cache/distributed_cache.dart';

const endpointNameCache = 'cache';
const endpointNameCachePrio = 'cachePrio';

class CacheEndpoint extends Endpoint {
  bool get logSessions => false;

  LocalCache _cache;

  CacheEndpoint(int maxEntries, SerializationManager serializationManager, DistributedCache distributedCache) {
    _cache = distributedCache?.localCache;
  }

  Future<Null> put(Session session, String key, String data, String group, DateTime expiration) async {
    Duration lifetime;
    if (expiration != null)
      lifetime = expiration.difference(DateTime.now());

    await _cache.put(key, DistributedCacheEntry(data: data), group: group, lifetime: lifetime);
  }

  Future<String> get(Session session, String key) async {
    DistributedCacheEntry entry = await _cache.get(key);
    if (entry == null)
      return null;
    return entry.data;
  }

  Future<Null> invalidateKey(Session session, String key) async {
    await _cache.invalidateKey(key);
  }

  Future< Null> invalidateGroup(Session session, String group) async {
    await _cache.invalidateGroup(group);
  }

  Future<Null> clear(Session session, ) async {
    await _cache.clear();
  }
}