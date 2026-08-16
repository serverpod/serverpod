import 'package:serverpod/src/cache/cache_miss_handler.dart';
import 'package:serverpod/src/cache/global_cache.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// A [GlobalCache] managed by Redis. The cache is shared by the servers in
/// a cluster.
class RedisCache extends GlobalCache {
  final RedisController? _redisController;

  /// Creates a new RedisCache. The size of the cache and eviction policy needs
  /// to be setup manually in Redis.
  RedisCache(
    SerializationManager serializationManager,
    this._redisController,
  ) : super(
        -1,
        serializationManager,
      );

  /// The [RedisController] backing this cache.
  ///
  /// Throws a [StateError] if Redis is not enabled for this Serverpod instance.
  RedisController get redisController {
    var controller = _redisController;
    if (controller == null) {
      throw StateError('Redis is not enabled for this Serverpod instance.');
    }
    return controller;
  }

  @override
  Future<void> clear() async {
    await redisController.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    var data = await redisController.get(key);

    return data != null;
  }

  @override
  Future<T?> get<T extends Object>(
    String key, [
    CacheMissHandler<T>? cacheMissHandler,
  ]) async {
    var data = await redisController.get(key);
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
    await redisController.del(key);
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

    var controller = redisController;
    var data = SerializationManager.encode(object);
    await controller.set(key, data, lifetime: lifetime);
  }
}
