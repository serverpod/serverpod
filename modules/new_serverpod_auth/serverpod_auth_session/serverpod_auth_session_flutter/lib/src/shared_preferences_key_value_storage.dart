import 'package:meta/meta.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

@internal
class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  @override
  Future<String?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  @override
  Future<void> set(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }
}
