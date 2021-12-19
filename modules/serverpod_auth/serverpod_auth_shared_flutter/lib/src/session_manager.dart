import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'serverpod_userinfo_key';
const _prefsVersion = 1;

/// The [SessionManager] keeps track of and manages the signed-in state of the
/// user. Use the [instance] method to get access to the singleton instance.
/// Users are typically authenticated with Google, Apple, or other methods.
/// Please refer to the documentation to see supported methods. Session
/// information is stored in the shared preferences of the app and persists
/// between restarts of the app.
class SessionManager with ChangeNotifier {
  static SessionManager? _instance;

  /// The auth module's caller.
  Caller caller;

  /// The key manager, holding the key's of the user, if signed in.
  late FlutterAuthenticationKeyManager keyManager;

  /// Creates a new session manager.
  SessionManager({
    required this.caller,
  }) {
    _instance = this;
    assert(caller.client.authenticationKeyManager != null,
        'The client needs an associated key manager');
    keyManager = caller.client.authenticationKeyManager!
        as FlutterAuthenticationKeyManager;
  }

  /// Returns a singleton instance of the session manager
  static Future<SessionManager> get instance async {
    assert(_instance != null,
        'You need to create a SessionManager before the instance method can be called');
    return _instance!;
  }

  UserInfo? _signedInUser;

  /// Returns information about the signed in user or null if no user is
  /// currently signed in.
  UserInfo? get signedInUser => _signedInUser;
  set signedInUser(UserInfo? userInfo) {
    _signedInUser = userInfo;
    _storeSharedPrefs();
    caller.client.reconnectWebSocket();
    notifyListeners();
  }

  /// Returns true if the user is currently signed in.
  bool get isSignedIn => signedInUser != null;

  /// Initializes the session manager by reading the current state from
  /// shared preferences.
  Future<void> initialize() async {
    await _loadSharedPrefs();
    unawaited(refreshSession());
  }

  /// Signs the user out from all connected devices. Returns true if successful.
  Future<bool> signOut() async {
    if (!isSignedIn) return true;

    try {
      await caller.status.signOut();
      await caller.client.reconnectWebSocket();
      signedInUser = null;
      await keyManager.remove();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify the current sign in status with the server and update the UserInfo.
  /// Returns true if successful.
  Future<bool> refreshSession() async {
    try {
      _signedInUser = await caller.status.getUserInfo();
      await _storeSharedPrefs();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();

    var version =
        prefs.getInt(_prefsKey + '_' + keyManager.runMode + '_version');
    if (version != _prefsVersion) return;

    var json = prefs.getString(_prefsKey + '_' + keyManager.runMode);
    if (json == null) return;

    _signedInUser = Protocol.instance
        .createEntityFromSerialization(jsonDecode(json)) as UserInfo;
    notifyListeners();
  }

  Future<void> _storeSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
        _prefsKey + '_' + keyManager.runMode + '_version', _prefsVersion);
    if (signedInUser == null) {
      await prefs.remove(_prefsKey + '_' + keyManager.runMode);
    } else {
      await prefs.setString(_prefsKey + '_' + keyManager.runMode,
          jsonEncode(signedInUser!.serialize()));
    }
  }

  /// Uploads a new user image if the user is signed in. Returns true if upload
  /// was successful.
  Future<bool> uploadUserImage(ByteData image) async {
    if (_signedInUser == null) return false;

    try {
      var success = await caller.user.setUserImage(image);
      if (success) {
        _signedInUser = await caller.status.getUserInfo();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
