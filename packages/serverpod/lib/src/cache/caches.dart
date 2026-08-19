import 'package:serverpod/server.dart';
import 'package:serverpod/src/cache/cache.dart';
import 'package:serverpod/src/cache/global_cache.dart';
import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'local_cache.dart';

/// Collection of [Cache] objects used by the [Server].
class Caches {
  final SerializationManager _serializationManager;

  /// Creates a collection of caches. Typically, this is created automatically
  /// by the [Server].
  Caches(
    this._serializationManager,
    ServerpodConfig config,
    String serverId,
    RedisController? redisController,
  ) {
    _local = LocalCache(10000, _serializationManager);
    _localPrio = LocalCache(10000, _serializationManager);
    if (redisController != null) {
      _redis = RedisCache(_serializationManager, redisController);
    } else {
      _localFallback = LocalCache(10000, _serializationManager);
    }
    _query = LocalCache(10000, _serializationManager);
  }

  late LocalCache _local;

  /// Used to cache objects that are of lower priority, and may vary between
  /// servers in a cluster. Provides faster access than the distributed cache,
  /// but objects are not guaranteed to be the same across servers.
  LocalCache get local => _local;

  late LocalCache _localPrio;

  /// Used to cache objects that are of high priority, and may vary between
  /// servers in a cluster. Provides faster access than the distributed cache,
  /// but objects are not guaranteed to be the same across servers.
  LocalCache get localPrio => _localPrio;

  GlobalCache? _redis;

  /// Separate local cache used as a fallback if Redis is not configured. Must
  /// not be the same as the main local cache to avoid introducing bugs in which
  /// a locally cached object can be globally accessed in development.
  LocalCache? _localFallback;

  /// Used to cache objects that are of lower priority, and need to stay
  /// consistent across servers. Provides slower access than the local cache,
  /// but objects are guaranteed to be the same across servers.
  ///
  /// Fallback to a separate local cache if Redis is not configured or not
  /// available in development or testing run modes. In fallback mode, the
  /// cache will not guarantee consistency across servers.
  Cache get global => _redis ?? _localFallback!;

  late LocalCache _query;

  /// Cache used to automatically save cacheable database queries.
  LocalCache get query => _query;

  /// Clears all caches.
  Future<void> clear() async {
    await _local.clear();
    await _localPrio.clear();
    await _redis?.clear();
    await _localFallback?.clear();
    await _query.clear();
  }
}
