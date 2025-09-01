import 'package:serverpod_auth_core_flutter/src/storage/client_auth_info_storage.dart';
import 'package:serverpod_auth_core_flutter/src/storage/key_value_client_auth_info_storage.dart';

/// A [ClientAuthInfoStorage] implementation for testing.
class TestClientAuthInfoStorage
    with _TestMapStorage<AuthSuccess>
    implements ClientAuthInfoStorage {
  static const _keyName = 'test_key';

  @override
  Future<void> set(AuthSuccess? data) async => _set(_keyName, data);

  @override
  Future<AuthSuccess?> get() async => _get(_keyName);
}

/// A [KeyValueStorage] implementation for testing.
class TestKeyValueStorage
    with _TestMapStorage<String>
    implements KeyValueStorage {
  @override
  Future<String?> get(String key) async => _get(key);

  @override
  Future<void> set(String key, String? value) async => _set(key, value);
}

mixin class _TestMapStorage<T> {
  final Map<String, T?> values = {};
  int storageGetHitCount = 0;

  Future<T?> Function()? getOverride;
  Future<void> Function()? setOverride;

  Future<T?> _get(String key) async {
    if (getOverride != null) return getOverride!();

    storageGetHitCount++;
    return values[key];
  }

  Future<void> _set(String key, T? value) async {
    if (setOverride != null) return setOverride!();

    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}
