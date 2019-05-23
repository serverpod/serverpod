import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class Cache {
  final int maxEntries;
  SerializationManager serializationManager;

  Cache(this.maxEntries, this.serializationManager);

  Future<Null> put(String key, SerializableEntity object, {Duration lifetime, String group});

  Future<SerializableEntity> get(String key);

  Future<Null> invalidateKey(String key);

  Future< Null> invalidateGroup(String group);

  Future<Null> clear();

  int get size;
}
