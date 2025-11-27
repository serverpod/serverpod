import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

/// A [KeyValueClientAuthSuccessStorage] implementation for testing that exposes
/// the underlying delegate instance.
class TestStorage extends KeyValueClientAuthSuccessStorage {
  TestStorage({super.authSuccessStorageKey})
    : super(keyValueStorage: TestKeyValueStorage());
}

/// A [KeyValueStorage] implementation for testing.
class TestKeyValueStorage implements KeyValueStorage {
  final Map<String, String?> values = {};

  @override
  Future<String?> get(String key) async => values[key];

  @override
  Future<void> set(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}
