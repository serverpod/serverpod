import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class Cache {
  final int maxLocalEntries;
  SerializationManager serializationManager;

  Cache(this.maxLocalEntries, this.serializationManager);

  Future<Null> put(String key, SerializableEntity object, {Duration lifetime, String group});

  Future<SerializableEntity> get(String key);

  Future<Null> invalidateKey(String key);

  Future< Null> invalidateGroup(String group);

  Future<Null> clear();

  int get localSize;

  List<String> get localKeys;
}
