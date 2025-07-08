import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';

class TestStorage extends KeyValueStorage {
  final values = <String, String>{};

  @override
  Future<String?> get(String key) async {
    return values[key];
  }

  @override
  Future<void> set(String key, String? value) async {
    await Future.delayed(const Duration(microseconds: 1));

    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}
