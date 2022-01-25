import 'dart:convert';

import 'package:serverpod/src/cache/global_cache.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// A [GlobalCache] managed by Redis. The cache is shared by the servers in
/// a cluster.
class RedisCache extends GlobalCache {
  /// Holds the Redis controller.
  final RedisController redisController;

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
    await redisController.clear();
  }

  @override
  Future<SerializableEntity?> get(String key) async {
    var data = await redisController.get(key);
    if (data == null) {
      return null;
    }

    Map<String, dynamic>? serialization =
        jsonDecode(data).cast<String, dynamic>();
    return serializationManager.createEntityFromSerialization(serialization);
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
  // TODO: implement localKeys
  List<String> get localKeys =>
      throw UnimplementedError('No local keys are used in RedisCache');

  @override
  // TODO: implement localSize
  int get localSize =>
      throw UnimplementedError('No local keys are used in RedisCache');

  @override
  Future<void> put(String key, SerializableEntity object,
      {Duration? lifetime, String? group}) async {
    if (group != null) {
      throw UnimplementedError('Groups are not yet supported in RedisCache');
    }
    var data = jsonEncode(object.serializeAll());
    await redisController.set(key, data, lifetime: lifetime);
  }
}
