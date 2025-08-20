import 'package:shared_preferences/shared_preferences.dart';

import '/src/storage/base.dart';

/// A [ClientAuthInfoStorage] based on Flutter secure storage.
class SecureClientAuthInfoStorage extends KeyValueClientAuthInfoStorage {
  /// The key on the storage where the [AuthSuccess] will be stored.
  final String _storageKey;

  /// The secure storage to keep user authentication info.
  final KeyValueStorage storage;

  /// Creates a [SecureClientAuthInfoStorage] instance.
  SecureClientAuthInfoStorage({
    // TODO: Change the default to use the `flutter_secure_storage`.
    /// Custom secure storage. Defaults to [SharedPreferencesKeyValueStorage].
    KeyValueStorage? storage,

    /// OVerride the default key name to store the auth info on the storage.
    String? authInfoStorageKey,
  })  : storage = storage ?? SharedPreferencesKeyValueStorage(),
        _storageKey = authInfoStorageKey ?? 'serverpod_userinfo_key';

  @override
  Future<void> setValue(String? value) => storage.set(_storageKey, value);

  @override
  Future<String?> getValue() => storage.get(_storageKey);
}

// TODO: Change the `shared_preferences` package by `flutter_secure_storage`.
/// A [KeyValueStorage] based on Flutter secure storage.
class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  @override
  Future<String?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> set(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }
}

/// Basic string-based key/value store interface.
abstract interface class KeyValueStorage {
  /// Gets the stored value for [key].
  Future<String?> get(String key);

  /// Sets [key] to the new [value].
  Future<void> set(String key, String? value);
}
