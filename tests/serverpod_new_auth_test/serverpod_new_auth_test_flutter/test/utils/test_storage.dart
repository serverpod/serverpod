import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

class TestStorage extends KeyValueClientAuthInfoStorage {
  final _storageKey = 'serverpod_userinfo_key';
  final values = <String, String>{};

  @override
  Future<String?> getValue() async {
    return values[_storageKey];
  }

  @override
  Future<void> setValue(String? value) async {
    await Future.delayed(const Duration(microseconds: 1));

    if (value == null) {
      values.remove(_storageKey);
    } else {
      values[_storageKey] = value;
    }
  }
}
