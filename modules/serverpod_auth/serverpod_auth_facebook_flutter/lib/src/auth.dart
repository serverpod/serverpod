import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

var _initialized = false;

_initialize(String? appId) async {
  if (!_initialized) {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      if (appId == null) {
        throw Exception('Please provide Facebook appId');
      }
      // Initialiaze the facebook javascript SDK
      await FacebookAuth.instance.webAndDesktopInitialize(
        appId: appId,
        cookie: true,
        xfbml: true,
        version: 'v15.0',
      );
    }
    _initialized = true;
  }
}

/// Attempts to Sign in with Facebook. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
///
/// `appIdForWebOrDesktop` is the Facebook app_id, and it only needs to be
/// provided for Web and desktop builds. Android and iOS builds will read this
/// from their property files.
Future<UserInfo?> signInWithFacebook(
  Caller caller, {
  bool debug = false,
  String? appIdForWebOrDesktop,
  List<String> additionalScopes = const [],
  required Uri redirectUri,
}) async {
  await _initialize(appIdForWebOrDesktop);

  var scopes = [
    'public_profile',
    'email',
  ];
  scopes.addAll(additionalScopes);

  if (kDebugMode) print('serverpod_auth_facebook: FacebookSignIn');

  try {
    // Sign in with Facebook.
    var result = await FacebookAuth.instance.login(permissions: scopes);
    if (result.status != LoginStatus.success) {
      if (kDebugMode) {
        print(
          'serverpod_auth_facebook: FacebookSignIn.signIn() failed: '
          '${result.status}',
        );
      }
      return null;
    }

    // Check permissions were all accepted
    var permissions = await FacebookAuth.instance.permissions;
    if (permissions == null) {
      if (kDebugMode) {
        print('serverpod_auth_facebook: exceeded request limit');
      }
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {/* ignore */}
      return null;
    }
    if (permissions.declined.isNotEmpty) {
      if (kDebugMode) {
        print(
          'serverpod_auth_facebook: permissions declined: '
          '${permissions.declined}',
        );
      }
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {/* ignore */}
      return null;
    }

    // Get Facebook access token
    var accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken == null) {
      if (kDebugMode) {
        print('serverpod_auth_facebook: did not get access token');
      }
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {/* ignore */}
      return null;
    }

    // Authenticate with the Serverpod server.
    var serverResponse = await caller.facebook.authenticateWithAccessToken(
      accessToken.token,
      redirectUri.toString(),
    );

    if (!serverResponse.success) {
      if (kDebugMode) {
        print(
          'serverpod_auth_facebook: Failed to authenticate with '
          'Serverpod backend: '
          '${serverResponse.failReason ?? 'reason unknown'}'
          '. Aborting.',
        );
      }
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {/* ignore */}
      return null;
    }

    // Store the user info in the session manager.
    var sessionManager = await SessionManager.instance;

    await sessionManager.registerSignedInUser(
      serverResponse.userInfo!,
      serverResponse.keyId!,
      serverResponse.key!,
    );

    if (kDebugMode) {
      print(
        'serverpod_auth_facebook: Authentication was successful. '
        'Saved credentials to SessionManager',
      );
    }

    // Return the user info.
    return serverResponse.userInfo;
  } catch (e, stackTrace) {
    if (kDebugMode) print('serverpod_auth_facebook: $e');
    if (kDebugMode) print('$stackTrace');
    return null;
  }
}
