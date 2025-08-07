import 'dart:async';

/// String-based key/value store.
abstract class KeyValueStorage {
  /// Gets the stored value for [key].
  Future<String?> get(String key);

  /// Sets [key] to the new [value].
  Future<void> set(String key, String? value);
}
