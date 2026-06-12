import 'package:serverpod/src/cache/cache_miss_handler.dart';
import 'package:serverpod/src/cache/global_cache.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// A [GlobalCache] managed by Redis. The cache is shared by the servers in
/// a cluster.
class RedisCache extends GlobalCache {
  /// Holds the Redis controller.
  final RedisController? redisController;

  /// Creates a new RedisCache. The size of the cache and eviction policy needs
  /// to be setup manually in Redis.
  RedisCache(
    SerializationManager serializationManager,
    this.redisController,
  ) : super(
        -1,
        serializationManager,
      );

  @override
  Future<void> clear() async {
    if (redisController == null) {
      throw StateError('Redis is not enabled for this Serverpod instance.');
    }
    await redisController!.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    if (redisController == null) {
      throw StateError('Redis is not enabled for this Serverpod instance.');
    }
    var data = await redisController!.get(key);

    return data != null;
  }

  @override
  Future<T?> get<T extends Object>(
    String key, [
    CacheMissHandler<T>? cacheMissHandler,
  ]) async {
    if (redisController == null) {
      throw StateError('Redis is not enabled for this Serverpod instance.');
    }

    var data = await redisController!.get(key);
    if (data != null) {
      return serializationManager.decode<T>(data);
    }

    if (cacheMissHandler == null) return null;

    var value = await cacheMissHandler.valueProvider();
    if (value == null) return null;

    await put(
      key,
      value,
      lifetime: cacheMissHandler.lifetime,
      group: cacheMissHandler.group,
    );

    return value;
  }

  @override
  Future<void> invalidateGroup(String group) {
    throw UnimplementedError('Groups are not yet supported in RedisCache');
  }

  @override
  Future<void> invalidateKey(String key) async {
    if (redisController == null) {
      throw StateError('Redis is not enabled for this Serverpod instance.');
    }
    await redisController!.del(key);
  }

  @override
  List<String> get localKeys =>
      throw UnimplementedError('No local keys are used in RedisCache');

  @override
  int get localSize =>
      throw UnimplementedError('No local keys are used in RedisCache');

  @override
  Future<void> put<T extends Object>(
    String key,
    T object, {
    Duration? lifetime,
    String? group,
  }) async {
    if (group != null) {
      throw UnimplementedError('Groups are not yet supported in RedisCache');
    }

    if (redisController == null) {
      throw StateError('Redis is not enabled for this Serverpod instance.');
    }

    var data = SerializationManager.encode(object);
    await redisController!.set(key, data, lifetime: lifetime);
  }
}
