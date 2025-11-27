import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

/// A [ClientAuthSuccessStorage] implementation for testing.
class TestClientAuthSuccessStorage
    with _TestMapStorage<AuthSuccess>
    implements ClientAuthSuccessStorage {
  static const _keyName = 'test_key';

  @override
  Future<void> set(AuthSuccess? data) async => _set(_keyName, data);

  @override
  Future<AuthSuccess?> get() async => _get(_keyName);
}

/// A [CachedClientAuthSuccessStorage] wrapper for testing.
class TestCachedAuthSuccessStorage extends CachedClientAuthSuccessStorage {
  final TestClientAuthSuccessStorage delegate;

  TestCachedAuthSuccessStorage._({
    required this.delegate,
  }) : super(delegate: delegate);

  factory TestCachedAuthSuccessStorage.create() {
    return TestCachedAuthSuccessStorage._(
      delegate: TestClientAuthSuccessStorage(),
    );
  }
}

/// A [KeyValueClientAuthSuccessStorage] wrapper for testing.
class TestKeyValueAuthSuccessStorage extends KeyValueClientAuthSuccessStorage {
  final TestKeyValueStorage delegate;

  TestKeyValueAuthSuccessStorage._({
    required this.delegate,
    super.authSuccessStorageKey,
  }) : super(keyValueStorage: delegate);

  factory TestKeyValueAuthSuccessStorage.create({
    String? authSuccessStorageKey,
  }) {
    return TestKeyValueAuthSuccessStorage._(
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
