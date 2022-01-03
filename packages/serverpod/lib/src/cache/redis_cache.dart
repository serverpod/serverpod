import 'dart:convert';

import 'package:serverpod/src/cache/global_cache.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

class RedisCache extends GlobalCache {
  final RedisController redisConnection;

  RedisCache(
    int maxEntries,
    SerializationManager serializationManager,
    this.redisConnection,
  ) : super(
          maxEntries,
          serializationManager,
        );

  @override
  Future<void> clear() async {
    await redisConnection.clear();
  }

  @override
  Future<SerializableEntity?> get(String key) async {
    final data = await redisConnection.get(key);
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
    await redisConnection.del(key);
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
    await redisConnection.set(key, data, lifetime: lifetime);
  }
}
