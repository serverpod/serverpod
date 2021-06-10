import 'package:serverpod_client/serverpod_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'serverpod_authentication_key';

/// Implementation of a Serverpod [AuthenticationKeyManager] specifically for
/// Flutter. Authentication key is stored in the [SharedPreferences].
class FlutterAuthenticationKeyManager extends AuthenticationKeyManager {
  bool _initialized = false;
  String? _authenticationKey;

  @override
  Future<String?> get() async {
    if (!_initialized) {
      var prefs = await SharedPreferences.getInstance();
      _authenticationKey = prefs.getString(_prefsKey);
      _initialized = true;
    }
    return _authenticationKey;
  }

  @override
  Future<void> put(String key) async {
    _authenticationKey = key;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, key);
  }
}