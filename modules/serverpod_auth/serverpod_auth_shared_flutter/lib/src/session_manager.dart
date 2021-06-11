import 'dart:convert';

import 'package:serverpod_auth_client/module.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_key_manager.dart';

const _prefsKey = 'serverpod_userinfo_key';

/// The [SessionManager] keeps track of and manages the signed-in state of the
/// user. Use the [instance] method to get access to the singleton instance.
/// Users are typically authenticated with Google, Apple, or other methods.
/// Please refer to the documentation to see supported methods. Session
/// information is stored in the shared preferences of the app and persists
/// between restarts of the app.
class SessionManager {
  static SessionManager? _instance;

  /// Returns a singleton instance of the session manager
  static Future<SessionManager> get instance async {
    if (_instance == null) {
      _instance = SessionManager();
      await _instance!._initialize();
    }
    return _instance!;
  }

  /// The [AuthenticationKeyManager] associated with this session manager.
  final AuthenticationKeyManager keyManager = FlutterAuthenticationKeyManager();

  UserInfo? _signedInUser;

  /// Returns information about the signed in user or null if no user is
  /// currently signed in.
  UserInfo? get signedInUser => _signedInUser;
  set signedInUser(UserInfo? userInfo) {
    _signedInUser = userInfo;
    _storeSharedPrefs();
  }

  /// Returns true if the user is currently signed in.
  bool get isSignedIn => signedInUser != null;

  Future<void> _initialize() async {
    await _loadSharedPrefs();
  }

  /// Signs the user out from all connected devices. Returns true if successful.
  Future<bool> signOut(Caller caller) async {
    if (!isSignedIn)
      return true;

    try {
      await caller.user.signOut();
      signedInUser = null;
      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<void> _loadSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();

    var json = prefs.getString(_prefsKey);
    if (json == null)
      return;

    _signedInUser = Protocol.instance.createEntityFromSerialization(jsonDecode(json)) as UserInfo;
  }

  Future<void> _storeSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();

    if (signedInUser == null) {
      await prefs.remove(_prefsKey);
    }
    else {
      await prefs.setString(_prefsKey, jsonEncode(signedInUser!.serialize()));
    }
  }
}