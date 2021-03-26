import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/config.dart';
import 'local_cache.dart';
import 'distributed_cache.dart';

class Caches {
  final SerializationManager _serializationManager;

  Caches(this._serializationManager, ServerConfig config, int serverId) {
    _local = LocalCache(10000, _serializationManager);
    _localPrio = LocalCache(10000, _serializationManager);
    _distributed = DistributedCache(10000, _serializationManager, config, serverId, false);
    _distributedPrio = DistributedCache(10000, _serializationManager, config, serverId, true);
    _query = LocalCache(10000, _serializationManager);
  }

  late LocalCache _local;
  LocalCache get local => _local;

  late LocalCache _localPrio;
  LocalCache get localPrio => _localPrio;

  late DistributedCache _distributed;
  DistributedCache get distributed => _distributed;

  late DistributedCache _distributedPrio;
  DistributedCache get distributedPrio => _distributedPrio;

  late LocalCache _query;
  LocalCache get query => _query;
}