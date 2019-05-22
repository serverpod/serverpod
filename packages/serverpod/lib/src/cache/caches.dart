import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'cache.dart';

class Caches {
  final SerializationManager _serializationManager;

  Caches(this._serializationManager) {
    _local = Cache(100, _serializationManager);
    _localPrio = Cache(100, _serializationManager);
    _distributed = Cache(100, _serializationManager);
    _distributedPrio = Cache(100, _serializationManager);
    _query = Cache(100, _serializationManager);
  }

  Cache _local;
  Cache get local => _local;

  Cache _localPrio;
  Cache get localPrio => _localPrio;

  Cache _distributed;
  Cache get distributed => _distributed;

  Cache _distributedPrio;
  Cache get distributedPrio => _distributedPrio;

  Cache _query;
  Cache get query => _query;
}