import 'package:serverpod_auth_core_flutter/src/storage/base.dart';
import 'package:serverpod_auth_core_flutter/src/storage/key_value.dart';

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
  T? lastSetValue;
  bool shouldThrowOnGet = false;
  bool shouldThrowOnSet = false;

  Future<T?> _get(String key) async {
    if (shouldThrowOnGet) {
      throw Exception('Storage error on get');
    }
    return values[key];
  }

  Future<void> _set(String key, T? value) async {
    if (shouldThrowOnSet) {
      throw Exception('Storage error on set');
    }

    lastSetValue = value;
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}
