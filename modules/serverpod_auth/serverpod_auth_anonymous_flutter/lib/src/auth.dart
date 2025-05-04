import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generate_password.dart';

/// Controller for email authentication.
class AnonymousAuthController {
  /// A reference to the auth module as retrieved from the client object.
  final Caller caller;

  late Future<SharedPreferences> _prefs;

  /// Creates a new email authentication controller.
  AnonymousAuthController(this.caller, SessionManager sessionManager) {
    _prefs = SharedPreferences.getInstance();

    sessionManager.addListener(() {
      if (isLoggedIn && sessionManager.isSignedIn) {
        clearCredentials();
        isLoggedIn = false;
      }
    });
  }

  bool isLoggedIn = false;

  /// Shared Preferences key an anonymous user's password.
  static const String passwordKey = 'ANONYMOUS_USER_PASSWORD';

  /// Shared Preferences key an anonymous user's Id.
  static const String userIdKey = 'ANONYMOUS_USER_ID';

  /// Loads the (userId, password,) combination of login credentials. The user
  /// should only required use of these if their session is cleared by a
  /// destructive migration on the server.
  Future<(int?, String?)> getCredentials() async {
    final credentials = await Future.wait([getUserId(), getPassword()]);
    return (credentials[0] as int?, credentials[1] as String?);
  }

  Future<bool> anonymousAccountExists() => _prefs.then(
        (p) async {
          final credentials = await getCredentials();
          return credentials.$1 != null && credentials.$2 != null;
        },
      );

  Future<String> createAndStorePassword() => _prefs.then(
        (p) async {
          final password = generatePassword();
          await p.setString(AnonymousAuthController.passwordKey, password);
          return password;
        },
      );

  Future<String?> getPassword() =>
      _prefs.then((p) => p.getString(AnonymousAuthController.passwordKey));

  Future<void> storeUserId(int userId) =>
      _prefs.then((p) => p.setInt(AnonymousAuthController.userIdKey, userId));

  Future<int?> getUserId() =>
      _prefs.then((p) => p.getInt(AnonymousAuthController.userIdKey));

  Future<void> clearCredentials() async {
    _prefs.then(
      (p) => Future.wait(
        [
          p.remove(AnonymousAuthController.userIdKey),
          p.remove(AnonymousAuthController.passwordKey),
        ],
      ),
    );
  }

  /// Attempts to sign in with email and password. If successful, a [UserInfo]
  /// is returned. If the attempt is not a success, null is returned.
  Future<UserInfo?> signIn() async {
    try {
      final credentials = await getCredentials();
      assert(
        credentials.$1 != null && credentials.$2 != null,
        'Should not call `signIn` without an existing account. Verify by '
        'calling `anonymousAccountExists()` first.',
      );
      var serverResponse = await caller.anonymous
          .authenticate(userId: credentials.$1!, password: credentials.$2!);
      return _registerUserInfo(serverResponse);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('$e');
        print('$stackTrace');
      }
      return null;
    }
  }

  /// Attempts to create a new account. If successful, the user info is returned.
  /// If unsuccessful, null is returned.
  Future<UserInfo?> createAccount() async {
    final password = await createAndStorePassword();
    try {
      final account = await caller.anonymous.createAccount(password: password);

      if (account == null) {
        if (kDebugMode) {
          print('Failed to create anonymous account');
        }
        return null;
      }

      if (account.id != null) {
        await storeUserId(account.id!);
        return signIn();
      } else {
        if (kDebugMode) {
          print('Created anonymous account without an Id');
        }
        return null;
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('$e');
        print('$st');
      }
      return null;
    }
  }

  Future<UserInfo?> _registerUserInfo(
    AuthenticationResponse serverResponse,
  ) async {
    if (!serverResponse.success ||
        serverResponse.userInfo == null ||
        serverResponse.keyId == null ||
        serverResponse.key == null) {
      if (kDebugMode) {
        print(
          'serverpod_auth_anonymous: Failed to authenticate with '
          'Serverpod backend: '
          '${serverResponse.failReason ?? 'reason unknown'}'
          '. Aborting.',
        );
      }
      isLoggedIn = false;
      return null;
    }

    // Authentication was successful, store the key.
    var sessionManager = await SessionManager.instance;
    sessionManager.registerSignedInUser(
      serverResponse.userInfo!,
      serverResponse.keyId!,
      serverResponse.key!,
    );
    isLoggedIn = true;
    return serverResponse.userInfo;
  }
}
