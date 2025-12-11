import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

/// Exposes the [FlutterSecureStorage] class for convenience.
export 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A [ClientAuthSuccessStorage] based on [FlutterSecureStorage].
class SecureClientAuthSuccessStorage extends CachedClientAuthSuccessStorage {
  /// Creates a [SecureClientAuthSuccessStorage] instance.
  SecureClientAuthSuccessStorage({
    /// Custom secure storage to use.
    FlutterSecureStorage? secureStorage,

    /// Override the default key name to store the auth info on the storage.
    String? authSuccessStorageKey,
  }) : super(
         delegate: KeyValueClientAuthSuccessStorage(
           keyValueStorage: FlutterSecureKeyValueStorage(secureStorage),
           authSuccessStorageKey: authSuccessStorageKey,
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
          // ignore: deprecated_member_use
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
