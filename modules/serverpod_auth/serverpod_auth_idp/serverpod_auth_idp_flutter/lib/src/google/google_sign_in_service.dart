import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'google_web_sign_in_service.dart';

/// Service to manage Google Sign-In and ensure it is only initialized once
/// throughout the app lifetime.
class GoogleSignInService {
  /// Singleton instance of the [GoogleSignInService].
  static final GoogleSignInService instance = GoogleSignInService._internal();

  /// Convenience getter for the [GoogleSignIn.instance]. Be sure to call
  /// [ensureInitialized] before calling methods on the returned instance.
  static final googleSignIn = GoogleSignIn.instance;

  GoogleSignInService._internal();

  final _initializedClients = <int>{};

  /// Ensures that Google Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times for the same
  /// client. Multiple clients can be registered by calling this method multiple
  /// times with different clients. However, note that only the first call will
  /// initialize the Google Sign-In.
  ///
  /// The [auth] is used to register a sign-out hook to logout from Google
  /// when the user signs out from the app. This prevents the user from being
  /// signed in back automatically, which would undo the signing out.
  ///
  /// The returned [GoogleSignIn] can be used to attach listeners to the events
  /// emitted by [GoogleSignIn.instance]. If [clientId] and [serverClientId] are
  /// not provided, will try to load the values from the environment variables
  /// `GOOGLE_CLIENT_ID` and `GOOGLE_SERVER_CLIENT_ID` respectively. If the
  /// values are not provided by any means, an error will be thrown by the
  /// underlying [GoogleSignIn].
  ///
  /// The parameters [nonce] and [hostedDomain] are optional and will be passed
  /// directly to the [GoogleSignIn] initialize method. See the documentation
  /// of [GoogleSignIn.initialize] for more details.
  Future<GoogleSignIn> ensureInitialized({
    required FlutterAuthSessionManager auth,
    String? clientId,
    String? serverClientId,
    String? nonce,
    String? hostedDomain,
  }) async {
    if (_initializedClients.contains(identityHashCode(auth))) {
      return googleSignIn;
    }

    await _withMutexOneTimeInit(() async {
      clientId ??= _getClientIdFromEnvVar();
      serverClientId ??= _getServerClientIdFromEnvVar();

      await googleSignIn.initialize(
        clientId: clientId,
        serverClientId: !kIsWeb ? serverClientId : null,
        nonce: nonce,
        hostedDomain: hostedDomain,
      );
    });

    _initializeClient(auth);
    return googleSignIn;
  }

  void _initializeClient(FlutterAuthSessionManager auth) {
    auth.authInfoListenable.addListener(() {
      if (!auth.isAuthenticated) {
        unawaited(
          googleSignIn.signOut().onError(
            (e, _) =>
                debugPrint('Failed to sign out from Google: ${e.toString()}'),
          ),
        );
      }
    });

    _initializedClients.add(identityHashCode(auth));
  }

  Completer<void>? _googleSignInInit;

  Future<void> _withMutexOneTimeInit(Future<void> Function() initFunc) async {
    if (_googleSignInInit?.isCompleted ?? false) return;

    var signInInitCompleter = _googleSignInInit;
    if (signInInitCompleter != null) {
      await signInInitCompleter.future;
    } else {
      signInInitCompleter = Completer();
      _googleSignInInit = signInInitCompleter;

      try {
        await initFunc();
        signInInitCompleter.complete();
      } catch (e) {
        signInInitCompleter.completeError(e);
        _googleSignInInit = null;
        rethrow;
      }
    }
  }
}

/// Expose convenient methods on [FlutterAuthSessionManager].
extension DisconnectGoogleSignIn on FlutterAuthSessionManager {
  /// Initializes Google Sign-In for the client.
  ///
  /// This method is idempotent and can be called multiple times and from
  /// multiple clients. However, note that only the first call will initialize
  /// the Google Sign-In.
  ///
  /// Upon initialization, a sign-out hook is registered to sign out from Google
  /// when the user signs out from the app. This prevents the user from being
  /// signed in back automatically, which would undo the signing out.
  ///
  /// If [clientId] and [serverClientId] are not provided, will try to load the
  /// values from `GOOGLE_CLIENT_ID` and `GOOGLE_SERVER_CLIENT_ID` environment
  /// variables, respectively. If the values are not provided by any means, an
  /// error will be thrown by the underlying [GoogleSignIn].
  ///
  /// The parameters [nonce] and [hostedDomain] are optional and will be passed
  /// directly to the [GoogleSignIn] initialize method. See the documentation
  /// of [GoogleSignIn.initialize] for more details.
  ///
  /// The [redirectUri] is optional and will be used to configure the OAuth2
  /// PKCE redirect flow on web - which provides a better user experience than
  /// the [google_sign_in_web] package. When [redirectUri] is absent on web,
  /// the initialization will fallback to the [google_sign_in] package.
  Future<void> initializeGoogleSignIn({
    String? clientId,
    String? serverClientId,
    String? nonce,
    String? hostedDomain,
    String? redirectUri,
    Map<String, String> additionalAuthParams = const {},
  }) async {
    if (kIsWeb && redirectUri != null) {
      clientId ??= _getClientIdFromEnvVar();
      if (clientId == null) {
        throw ArgumentError.notNull(
          'clientId is required when initializing Google Sign-In on web '
          'with a redirect URI. Provide clientId parameter or set '
          'GOOGLE_CLIENT_ID environment variable.',
        );
      }

      await GoogleWebSignInService.instance.ensureInitialized(
        clientId: clientId,
        redirectUri: redirectUri,
        additionalAuthParams: additionalAuthParams,
      );

      return;
    }

    await GoogleSignInService.instance.ensureInitialized(
      auth: this,
      clientId: clientId,
      serverClientId: serverClientId,
      nonce: nonce,
      hostedDomain: hostedDomain,
    );
  }

  /// Completely disconnects the user's Google account from your app and revokes
  /// all previous authorizations. This removes the app's access permissions
  /// entirely, meaning the user will need to go through the full authorization
  /// flow again on the next sign-in, including the account picker and consent
  /// screens.
  ///
  /// On web with the redirect URI configured, only signs out from the current
  /// device without revoking Google access (native disconnect is not available
  /// in the web flow).
  Future<void> disconnectGoogleAccount() async {
    if (kIsWeb && GoogleWebSignInService.instance.isInitialized) {
      await signOutDevice();
      return;
    }

    final signIn = await GoogleSignInService.instance.ensureInitialized(
      auth: this,
    );
    await signIn.disconnect();

    // NOTE: This delay prevents the Google Sign-In web button to render before
    // the disconnect process is complete. Without this, the Sign-In screen will
    // render the button on web still showing the user as signed in.
    await Future.delayed(const Duration(milliseconds: 300));
    await signOutDevice();
  }
}

String? _getClientIdFromEnvVar() {
  return const bool.hasEnvironment('GOOGLE_CLIENT_ID')
      ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
      : null;
}

String? _getServerClientIdFromEnvVar() {
  return const bool.hasEnvironment('GOOGLE_SERVER_CLIENT_ID')
      ? const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID')
      : null;
}
