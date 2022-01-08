// TODO: Implement the Redis-free distributed cache

// import 'package:serverpod_service_client/serverpod_service_client.dart';
//
// import '../../serverpod.dart';
// import '../cache/local_cache.dart';
//
// /// Endpoint used by the [DistributedCache]. Typically used internally by the
// /// [Server] only. You may be looking for the [Cache] documentation.
// class CacheEndpoint extends Endpoint {
//   @override
//   bool get logSessions => false;
//
//   late LocalCache _cache;
//   late LocalCache _cachePrio;
//
//   @override
//   void initialize(Server server, String name, String? moduleName) {
//     super.initialize(server, name, moduleName);
//     var distributedCache = pod.caches.global;
//     var distributedCachePrio = pod.caches.globalPrio;
//     _cache = distributedCache.localCache;
//     _cachePrio = distributedCachePrio.localCache;
//   }
//
//   /// Called remotely to store an object in the cache of this [Server].
//   Future<void> put(Session session, bool priority, String key, String data,
//       String? group, DateTime? expiration) async {
//     Duration? lifetime;
//     if (expiration != null) lifetime = expiration.difference(DateTime.now());
//
//     await (priority ? _cachePrio : _cache).put(
//         key, DistributedCacheEntry(data: data),
//         group: group, lifetime: lifetime);
//   }
//
//   /// Called remotely to retrieve an object from the cache of this [Server].
//   Future<String?> get(Session session, bool priority, String key) async {
//     var entry = await ((priority ? _cachePrio : _cache).get(key))
//         as DistributedCacheEntry?;
//     if (entry == null) return null;
//     return entry.data;
//   }
//
//   /// Called remotely to invalidate an object from the cache of this [Server].
//   Future<void> invalidateKey(Session session, bool priority, String key) async {
//     await (priority ? _cachePrio : _cache).invalidateKey(key);
//   }
//
//   /// Called remotely to invalidate a group of object from the cache of this
//   /// [Server].
//   Future<void> invalidateGroup(
//       Session session, bool priority, String group) async {
//     await (priority ? _cachePrio : _cache).invalidateGroup(group);
//   }
//
//   /// Called remotely to invalidate all objects from the cache of this
//   /// [Server].
//   Future<void> clear(Session session, bool priority) async {
//     await (priority ? _cachePrio : _cache).clear();
//   }
// }
