import 'package:serverpod_serialization/serverpod_serialization.dart';

import '../../server.dart';
import '../generated/protocol.dart';
import 'local_cache.dart';
import 'distributed_cache.dart';

const endpointNameCache = 'cache';
const endpointNameCachePrio = 'cachePrio';

class CacheEndpoint extends Endpoint {
  LocalCache _cache;

  CacheEndpoint(int maxEntries, SerializationManager serializationManager, DistributedCache distributedCache) {
    _cache = distributedCache?.localCache;
  }

  Future<Null> put(Session session, String key, String data, String group, DateTime expiration) async {
    await _cache.put(key, DistributedCacheEntry(data: data));
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