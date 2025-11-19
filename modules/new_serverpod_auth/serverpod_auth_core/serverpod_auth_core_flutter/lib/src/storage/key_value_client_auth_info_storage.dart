import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

import 'client_auth_info_storage.dart';

/// Implements the [ClientAuthInfoStorage] for key-value based storages.
class KeyValueClientAuthInfoStorage implements ClientAuthInfoStorage {
  /// The key on the storage where the [AuthSuccess] will be stored.
  final String _storageKey;

  /// The key-value storage delegate to perform the actual storage operations.
  final KeyValueStorage keyValueStorage;

  /// Creates a new [KeyValueClientAuthInfoStorage].
  KeyValueClientAuthInfoStorage({
    required this.keyValueStorage,

    /// Override the default key name to store the auth info on the storage.
    String? authSuccessStorageKey,
  }) : _storageKey = authSuccessStorageKey ?? 'serverpod_auth_success_key';

  @override
  Future<void> set(AuthSuccess? data) async {
    await keyValueStorage.set(
      _storageKey,
      data != null ? SerializationManager.encode(data) : null,
    );
  }

  @override
  Future<AuthSuccess?> get() async {
    final data = await keyValueStorage.get(_storageKey);
    return data != null ? Protocol().decode<AuthSuccess>(data) : null;
  }
}

/// Basic string-based key/value store interface.
abstract interface class KeyValueStorage {
  /// Gets the stored value for [key].
  Future<String?> get(String key);

  /// Sets [key] to the new [value].
  Future<void> set(String key, String? value);
}
