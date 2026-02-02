import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

/// Service to manage Facebook Sign-In and ensure it is only initialized once
/// throughout the app lifetime.
class FacebookSignInService {
  /// Singleton instance of the [FacebookSignInService].
  static final FacebookSignInService instance =
      FacebookSignInService._internal();

  /// Convenience getter for the [FacebookAuth.instance]. Be sure to call
  /// [ensureInitialized] before calling methods on the returned instance.
  static final facebookAuth = FacebookAuth.instance;

  FacebookSignInService._internal();

  final _initializedClients = <int>{};

  /// Ensures that Facebook Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times for the same
  /// client. Multiple clients can be registered by calling this method multiple
  /// times with different clients. However, note that only the first call will
  /// initialize the Facebook Sign-In SDK.
  ///
  /// The [auth] is used to register a sign-out hook to logout from Facebook
  /// when the user signs out from the app. This prevents the user from being
  /// signed in back automatically, which would undo the signing out.
  ///
  /// **Important**: [FacebookAuth] is a singleton, meaning there is only one
  /// Facebook session across your entire app. If multiple auth managers are
  /// initialized, they will all share the same Facebook authentication state.
  ///
  /// For web and macOS platforms, the [appId] is required for initialization.
  /// If not provided, will try to load from the `FACEBOOK_APP_ID` environment
  /// variable. If the value is not provided by any means, an error will be
  /// thrown during initialization. For Android and iOS, configuration is done
  /// through native files and this parameter is ignored.
  ///
  /// The optional [cookie], [xfbml], and [version] parameters are used only for
  /// web and macOS platforms. See [FacebookAuth.webAndDesktopInitialize] for
  /// more details.
  Future<FacebookAuth> ensureInitialized({
    required FlutterAuthSessionManager auth,
    String? appId,
    bool cookie = true,
    bool xfbml = true,
    String version = 'v15.0',
  }) async {
    if (_initializedClients.contains(identityHashCode(auth))) {
      return facebookAuth;
    }

    await _withMutexOneTimeInit(() async {
      if (kIsWeb || defaultTargetPlatform == TargetPlatform.macOS) {
        if (facebookAuth.isWebSdkInitialized) return;

        appId ??= _getAppIdFromEnvVar();

        if (appId == null) {
          throw ArgumentError(
            'Facebook App ID is required for web and macOS platforms. '
            'Either provide it as a parameter or set the "FACEBOOK_APP_ID" '
            'environment variable.',
          );
        }

        await facebookAuth.webAndDesktopInitialize(
          appId: appId!,
          cookie: cookie,
          xfbml: xfbml,
          version: version,
        );
      }
    });

    _initializeClient(auth);
    return facebookAuth;
  }

  void _initializeClient(FlutterAuthSessionManager auth) {
    auth.authInfoListenable.addListener(() {
      if (!auth.isAuthenticated) {
        unawaited(
          facebookAuth.logOut().onError(
            (e, _) => debugPrint(
              'Failed to sign out from Facebook: ${e.toString()}',
            ),
          ),
        );
      }
    });

    _initializedClients.add(identityHashCode(auth));
  }

  Completer<void>? _facebookSignInInit;

  Future<void> _withMutexOneTimeInit(Future<void> Function() initFunc) async {
    if (_facebookSignInInit?.isCompleted ?? false) return;

    var signInInitCompleter = _facebookSignInInit;
    if (signInInitCompleter != null) {
      await signInInitCompleter.future;
    } else {
      signInInitCompleter = Completer();
      _facebookSignInInit = signInInitCompleter;

      try {
        await initFunc();
        signInInitCompleter.complete();
      } catch (e) {
        signInInitCompleter.completeError(e);
        _facebookSignInInit = null;
        rethrow;
      }
    }
  }

  /// Signs in with Facebook and returns the access token.
  ///
  /// On iOS, requests App Tracking Transparency (ATT) permission
  /// to obtain a classic access token required for server-side Graph API validation.
  /// On other platforms (Android, Web, MacOS), classic tokens are provided by default.
  ///
  /// Requests the specified [permissions] from Facebook. By default, requests
  /// `public_profile` and `email` permissions.
  ///
  /// Returns the access token if sign-in is successful, or null if the user
  /// cancels the login.
  ///
  /// Throws an exception if the login fails for any other reason.
  Future<String?> signIn({
    List<String> permissions = const ['public_profile', 'email'],
  }) async {
    final LoginResult result = await facebookAuth.login(
      permissions: permissions,
      loginTracking: defaultTargetPlatform == TargetPlatform.iOS
          ? LoginTracking.enabled
          : LoginTracking.limited,
    );

    if (result.status == LoginStatus.success) {
      if (result.accessToken?.type == AccessTokenType.limited) {
        throw FacebookLimitedAccessTokenException();
      }

      return result.accessToken?.tokenString;
    } else if (result.status == LoginStatus.cancelled) {
      return null;
    } else {
      throw Exception('Facebook login failed: ${result.message}');
    }
  }

  /// Signs out from Facebook and clears the session.
  Future<void> signOut() async {
    await facebookAuth.logOut();
  }
}

/// Expose convenient methods on [FlutterAuthSessionManager].
extension FacebookSignInExtension on FlutterAuthSessionManager {
  /// Initializes Facebook Sign-In for the client.
  ///
  /// This method is idempotent and can be called multiple times and from
  /// multiple clients. However, note that only the first call will initialize
  /// the Facebook Sign-In SDK.
  ///
  /// Upon initialization, a sign-out hook is registered to sign out from Facebook
  /// when the user signs out from the app. This prevents the user from being
  /// signed in back automatically, which would undo the signing out.
  ///
  /// For web and macOS platforms, the [appId] is required. If not provided, will
  /// try to load from the `FACEBOOK_APP_ID` environment variable. For Android and
  /// iOS, configuration is done through native files and this parameter is ignored.
  ///
  /// The optional [cookie], [xfbml], and [version] parameters are used only for
  /// web and macOS platforms. See [FacebookAuth.webAndDesktopInitialize] for
  /// more details.
  Future<void> initializeFacebookSignIn({
    String? appId,
    bool cookie = true,
    bool xfbml = true,
    String version = 'v15.0',
  }) async {
    await FacebookSignInService.instance.ensureInitialized(
      auth: this,
      appId: appId,
      cookie: cookie,
      xfbml: xfbml,
      version: version,
    );
  }

  /// Signs out from the singleton Facebook session and from the current device.
  ///
  /// **Important**: Since [FacebookAuth] is a singleton, signing out will clear
  /// the Facebook session for the entire app. Any subsequent sign-in attempts,
  /// even from other auth managers, will require the user to go through the
  /// full authorization flow again.
  ///
  /// This method:
  /// 1. Signs out from the Facebook SDK (affects all parts of the app)
  /// 2. Signs out the current device from Serverpod
  Future<void> signOutFacebookAccount() async {
    final signIn = await FacebookSignInService.instance.ensureInitialized(
      auth: this,
    );
    await signIn.logOut();

    // Delay prevents rendering issues where the button may still show the
    // user as signed in before the sign-out process completes.
    await Future.delayed(const Duration(milliseconds: 300));
    await signOutDevice();
  }
}

String? _getAppIdFromEnvVar() {
  return const bool.hasEnvironment('FACEBOOK_APP_ID')
      ? const String.fromEnvironment('FACEBOOK_APP_ID')
      : null;
}

/// Exception thrown when a limited access token is received from Facebook.
///
/// Limited access tokens cannot be validated on the server side and occur when:
/// - User denies App Tracking Transparency (ATT) permission on iOS 14.5+
/// - App doesn't request tracking permission properly
///
/// To avoid this, the app must:
/// 1. Request ATT permission before Facebook sign-in
/// 2. Use LoginTracking.enabled on iOS/macOS platforms
class FacebookLimitedAccessTokenException implements Exception {
  @override
  String toString() =>
      'Facebook returned a limited access token which cannot be validated on '
      'the server. On iOS and macOS, App Tracking Transparency permission is '
      'required to obtain a standard access token. Please enable tracking '
      'permission and try again.';
}
