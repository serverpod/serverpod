import 'package:serverpod/serverpod.dart';

/// A [CacheMissHandler] is used to define a function that is called when a
/// cache miss occurs. The function is expected to return a new object that
/// will be stored in the cache.
class CacheMissHandler<T extends SerializableEntity> {
  /// Function called when a cache miss occurs.
  /// If the function returns null, no object will be stored in the cache.
  final Future<T?> Function() valueProvider;

  /// The maximum lifetime of the object in the cache.
  final Duration? lifetime;

  /// The group of the object in the cache.
  final String? group;

  /// Creates a new [CacheMissHandler].
  const CacheMissHandler(this.valueProvider, {this.lifetime, this.group});
}
