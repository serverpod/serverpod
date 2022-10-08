import 'package:serverpod/src/cache/local_cache.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Abstract super class for the [LocalCache] and [DistributedCache] classes.
abstract class Cache {
  /// Maximum number of entries this cache will hold.
  final int maxLocalEntries;

  /// The [SerializationManager] used to serialize entries in the cache before
  /// they are stored.
  SerializationManager serializationManager;

  /// Creates a new [Cache] of the specified size.
  Cache(this.maxLocalEntries, this.serializationManager);

  /// Stores a copy of a [SerializableEntity] in the cache using the specified
  /// [key]. It's also possible to set the maximum [lifetime] of the stored
  /// [object]. If a [group] is specified, all entities of the same group can be
  /// invalidated at the same time using the [invalidateGroup] method.
  Future<void> put(String key, SerializableEntity object,
      {Duration? lifetime, String? group});

  /// Retrieves a cached [SerializableEntity] using the specified [key]. If no
  /// matching object can be found, null is returned.
  Future<T?> get<T extends SerializableEntity>(String key, [Type? t]);

  /// Removes a single object from the cache if it matches the [key].
  Future<void> invalidateKey(String key);

  /// Removes all objects from the cache that has the matching [group] set when
  /// added with [put] method.
  Future<void> invalidateGroup(String group);

  /// Removes all objects from the cache.
  Future<void> clear();

  /// Get the number of objects in the cache that are locally stored. For a
  /// [LocalCache] this is the count of all cached objects. For a
  /// [DistributedCache] this may be a fraction of stored objects.
  int get localSize;

  /// Get all keys that are locally used in this cache.
  List<String> get localKeys;
}
