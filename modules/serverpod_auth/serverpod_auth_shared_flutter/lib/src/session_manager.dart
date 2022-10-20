import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

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

  final Storage _storage;

  /// Creates a new session manager.
  SessionManager({
    required this.caller,
    Storage? storage,
  }) : _storage = storage ?? SharedPreferenceStorage() {
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

  @Deprecated('Use setSignedInUser instead.')
  set signedInUser(UserInfo? userInfo) {
    _signedInUser = userInfo;
    // TODO: Avoid doing asynchronously.
    keyManager.get().then((String? key) async {
      await caller.client.updateStreamingConnectionAuthenticationKey(key);
    });
    _storeSharedPrefs();
    notifyListeners();
  }

  /// Registers the signed in user, updates the [keyManager], and upgrades the
  /// streaming connection if it is open.
  Future<void> registerSignedInUser(
    UserInfo userInfo,
    int authenticationKeyId,
    String authenticationKey,
  ) async {
    _signedInUser = userInfo;
    var key = '$authenticationKeyId:$authenticationKey';

    // Store in key manager.
    await keyManager.put(
      key,
    );
    await _storeSharedPrefs();

    // Update streaming connection, if it's open.
    await caller.client.updateStreamingConnectionAuthenticationKey(key);
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
      await caller.client.updateStreamingConnectionAuthenticationKey(null);

      _signedInUser = null;
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
    var version =
        await _storage.getInt('${_prefsKey}_${keyManager.runMode}_version');
    if (version != _prefsVersion) return;

    var json = await _storage.getString('${_prefsKey}_${keyManager.runMode}');
    if (json == null) return;

    _signedInUser =
        Protocol.instance.deserializeJson<UserInfo>(jsonDecode(json));

    notifyListeners();
  }

  Future<void> _storeSharedPrefs() async {
    await _storage.setInt(
        '${_prefsKey}_${keyManager.runMode}_version', _prefsVersion);
    if (signedInUser == null) {
      await _storage.remove('${_prefsKey}_${keyManager.runMode}');
    } else {
      await _storage.setString('${_prefsKey}_${keyManager.runMode}',
          SerializationManager.serializeToJson(signedInUser));
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
