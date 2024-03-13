import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cache/cache.dart';

/// The [GlobalCache] provides a mean to cache [SerializableEntity]s across
/// multiple clustered servers. When accessing an entity it will either be in a
/// cache local to the server, or on another server, or in Redis. If it resides
/// in another server it will be retrieved through an access call to that
/// server. The caches are typically automatically setup and managed by
/// Serverpod.
abstract class GlobalCache extends Cache {
  /// Creates a new global cache.
  GlobalCache(
    super.maxLocalEntries,
    super.serializationManager,
  );
}
