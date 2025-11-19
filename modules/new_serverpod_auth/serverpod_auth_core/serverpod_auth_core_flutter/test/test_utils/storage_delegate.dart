import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

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

/// A [CachedClientAuthInfoStorage] wrapper for testing.
class TestCachedAuthInfoStorage extends CachedClientAuthInfoStorage {
  final TestClientAuthInfoStorage delegate;

  TestCachedAuthInfoStorage._({
    required this.delegate,
  }) : super(delegate: delegate);

  factory TestCachedAuthInfoStorage.create() {
    return TestCachedAuthInfoStorage._(
      delegate: TestClientAuthInfoStorage(),
    );
  }
}

/// A [KeyValueClientAuthInfoStorage] wrapper for testing.
class TestKeyValueAuthInfoStorage extends KeyValueClientAuthInfoStorage {
  final TestKeyValueStorage delegate;

  TestKeyValueAuthInfoStorage._({
    required this.delegate,
    super.authSuccessStorageKey,
  }) : super(keyValueStorage: delegate);

  factory TestKeyValueAuthInfoStorage.create({
    String? authSuccessStorageKey,
  }) {
    return TestKeyValueAuthInfoStorage._(
      delegate: TestKeyValueStorage(),
      authSuccessStorageKey: authSuccessStorageKey,
    );
  }
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
