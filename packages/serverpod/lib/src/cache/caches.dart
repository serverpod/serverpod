import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/config.dart';
import 'local_cache.dart';
import 'distributed_cache.dart';

/// Collection of [Cache] objects used by the [Server].
class Caches {
  final SerializationManager _serializationManager;

  /// Creates a collection of caches. Typically, this is created automatically
  /// by the [Server].
  Caches(this._serializationManager, ServerConfig config, int serverId) {
    _local = LocalCache(10000, _serializationManager);
    _localPrio = LocalCache(10000, _serializationManager);
    _distributed = DistributedCache(10000, _serializationManager, config, serverId, false);
    _distributedPrio = DistributedCache(10000, _serializationManager, config, serverId, true);
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

  late DistributedCache _distributed;
  /// Used to cache objects that are of lower priority, and need to stay
  /// consistent across servers. Provides slower access than the local cache,
  /// but objects are guaranteed to be the same across servers.
  DistributedCache get distributed => _distributed;

  late DistributedCache _distributedPrio;
  /// Used to cache objects that are of high priority, and need to stay
  /// consistent across servers. Provides slower access than the local cache,
  /// but objects are guaranteed to be the same across servers.
  DistributedCache get distributedPrio => _distributedPrio;

  late LocalCache _query;
  /// Cache used to automatically save cachable database queries.
  LocalCache get query => _query;
}