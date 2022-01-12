import 'package:serverpod_client/serverpod_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'serverpod_authentication_key';

/// Implementation of a Serverpod [AuthenticationKeyManager] specifically for
/// Flutter. Authentication key is stored in the [SharedPreferences].
class FlutterAuthenticationKeyManager extends AuthenticationKeyManager {
  bool _initialized = false;
  String? _authenticationKey;

  final String runMode;

  final Storage _storage;

  FlutterAuthenticationKeyManager({
    this.runMode = 'production',
    Storage? storage,
  }) : _storage = storage ?? SharedPreferenceStorage();

  @override
  Future<String?> get() async {
    if (!_initialized) {
      _authenticationKey = await _storage.getString(_prefsKey + '_$runMode');
      _initialized = true;
    }

    return _authenticationKey;
  }

  @override
  Future<void> put(String key) async {
    _authenticationKey = key;

    await _storage.setString(_prefsKey + '_$runMode', key);
  }

  @override
  Future<void> remove() async {
    _authenticationKey = null;

    await _storage.remove(_prefsKey + '_$runMode');
  }
}

abstract class Storage {
  Future<void> setInt(String key, int value);

  Future<int?> getInt(String key);

  Future<void> setString(String key, String value);

  Future<String?> getString(String key);

  Future<void> remove(String key);
}

class SharedPreferenceStorage implements Storage {
  @override
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(key, value);
  }

  @override
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }
}
