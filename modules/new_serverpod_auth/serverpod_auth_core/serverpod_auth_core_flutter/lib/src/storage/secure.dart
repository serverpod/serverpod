import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/src/storage/base.dart';
import '/src/storage/cached.dart';
import '/src/storage/key_value.dart';

/// Exposes the [FlutterSecureStorage] class for convenience.
export 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A [ClientAuthInfoStorage] based on [FlutterSecureStorage].
class SecureClientAuthInfoStorage extends CachedClientAuthInfoStorage {
  /// Creates a [SecureClientAuthInfoStorage] instance.
  SecureClientAuthInfoStorage({
    /// Custom secure storage to use.
    FlutterSecureStorage? secureStorage,

    /// Override the default key name to store the auth info on the storage.
    String? authInfoStorageKey,
  }) : super(
          delegate: KeyValueClientAuthInfoStorage(
            keyValueStorage: FlutterSecureKeyValueStorage(secureStorage),
            authInfoStorageKey: authInfoStorageKey,
          ),
        );
}

/// A [KeyValueStorage] wrapper for [FlutterSecureStorage].
class FlutterSecureKeyValueStorage implements KeyValueStorage {
  final FlutterSecureStorage _storage;

  /// Creates a new [FlutterSecureKeyValueStorage].
  FlutterSecureKeyValueStorage(FlutterSecureStorage? storage)
      : _storage = storage ?? _defaultSecureStorage();

  static FlutterSecureStorage _defaultSecureStorage() =>
      const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
        mOptions: MacOsOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  @override
  Future<String?> get(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> set(String key, String? value) async {
    if (value == null) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value);
    }
  }
}
