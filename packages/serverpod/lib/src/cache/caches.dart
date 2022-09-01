import 'package:serverpod/server.dart';
import 'package:serverpod/src/cache/global_cache.dart';
import 'package:serverpod/src/cache/redis_cache.dart';
import 'package:serverpod/src/redis/controller.dart';
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
    _global = RedisCache(
      _serializationManager,
      redisController,
    );
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

  late GlobalCache _global;

  /// Used to cache objects that are of lower priority, and need to stay
  /// consistent across servers. Provides slower access than the local cache,
  /// but objects are guaranteed to be the same across servers.
  GlobalCache get global => _global;

  late LocalCache _query;

  /// Cache used to automatically save cachable database queries.
  LocalCache get query => _query;
}
