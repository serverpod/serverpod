import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

export 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    show AuthSuccess;

/// Exposes a method for the session manager to update the [AuthSuccess].
abstract interface class ClientAuthInfoStorage {
  /// Cached authentication info to ensure low access on storage.
  AuthSuccess? get cachedAuthInfo;

  /// Set the authentication info.
  Future<void> set(AuthSuccess? data);

  /// Get the stored authentication info, if any.
  Future<AuthSuccess?> get();
}

/// Implements the cache layer for a [ClientAuthInfoStorage] implementation. The
/// [get] methods return is cached, so the operation can be performed with no
/// performance concerns.
abstract class CachedClientAuthInfoStorage implements ClientAuthInfoStorage {
  /// Control whether the value can be recovered from the internal cache on
  /// [get] method. Will be false only before the first method call.
  var _cached = false;

  AuthSuccess? _cachedData;

  /// Returns the cached [AuthSuccess] instance. Will raise an error if trying to
  /// access this attributed before any call to [get] or [set].
  @override
  AuthSuccess? get cachedAuthInfo {
    if (!_cached) {
      throw StateError(
        'Tried to access the cached info before initializing. Call "set" or '
        '"get" method to cache the value.',
      );
    }
    return _cachedData;
  }

  /// A function to set directly in the storage.
  Future<void> setOnStorage(AuthSuccess? data);

  /// A get function that never hits the cache.
  Future<AuthSuccess?> getFromStorage();

  @override
  Future<void> set(AuthSuccess? data) async {
    await setOnStorage(data);
    _cachedData = data;
    _cached = true;
  }

  @override
  Future<AuthSuccess?> get() async {
    if (_cached) return _cachedData;
    final data = await getFromStorage();
    _cachedData = data;
    _cached = true;
    return _cachedData;
  }
}

/// Implements the [ClientAuthInfoStorage] for key-value based storages.
abstract class KeyValueClientAuthInfoStorage
    extends CachedClientAuthInfoStorage {
  /// Set the [AuthSuccess] as JSON-encoded string value in the storage.
  Future<void> setValue(String? value);

  /// Get the [AuthSuccess] as JSON-encoded string from the storage.
  Future<String?> getValue();

  @override
  Future<void> setOnStorage(AuthSuccess? data) async {
    await setValue(data != null ? SerializationManager.encode(data) : null);
  }

  @override
  Future<AuthSuccess?> getFromStorage() async {
    final data = await getValue();
    return data != null ? Protocol().decode<AuthSuccess>(data) : null;
  }
}
