import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'local_cache.dart';

class Caches {
  final SerializationManager _serializationManager;

  Caches(this._serializationManager) {
    _local = LocalCache(100, _serializationManager);
    _localPrio = LocalCache(100, _serializationManager);
    _distributed = LocalCache(100, _serializationManager);
    _distributedPrio = LocalCache(100, _serializationManager);
    _query = LocalCache(100, _serializationManager);
  }

  LocalCache _local;
  LocalCache get local => _local;

  LocalCache _localPrio;
  LocalCache get localPrio => _localPrio;

  LocalCache _distributed;
  LocalCache get distributed => _distributed;

  LocalCache _distributedPrio;
  LocalCache get distributedPrio => _distributedPrio;

  LocalCache _query;
  LocalCache get query => _query;
}