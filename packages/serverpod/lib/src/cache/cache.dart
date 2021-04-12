import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class Cache {
  final int maxLocalEntries;
  SerializationManager serializationManager;

  Cache(this.maxLocalEntries, this.serializationManager);

  Future<void> put(String key, SerializableEntity object, {Duration? lifetime, String? group});

  Future<SerializableEntity?> get(String key);

  Future<void> invalidateKey(String key);

  Future<void> invalidateGroup(String group);

  Future<void> clear();

  int get localSize;

  List<String> get localKeys;
}
