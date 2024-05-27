import 'dart:async';

import 'package:serverpod_auth_server/src/firebase/auth/credential.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';

import 'package:clock/clock.dart';

/// Holds Firebase app internal informations
class FirebaseAppInternals {
  /// Firebase App Credentials
  final Credential credential;
  bool _isDeleted = false;

  AccessToken? _cachedToken;
  Future<AccessToken>? _cachedTokenFuture;
  Timer? _tokenRefreshTimeout;
  final List<void Function(String token)> _tokenListeners = [];

  /// Creates new [FirebaseAppInternals] with given [credential]
  FirebaseAppInternals(this.credential);

  /// tells if app internals are deleted or not
  bool get isDeleted => _isDeleted;

  /// Gets an auth token for the associated app.
  Future<AccessToken> getToken([bool forceRefresh = false]) {
    var expired = _cachedToken == null ||
        _cachedToken!.expirationTime.isBefore(clock.now());

    if (_cachedTokenFuture != null && !forceRefresh && !expired) {
      return _cachedTokenFuture!.catchError((error) {
        // Update the cached token future to avoid caching errors. Set it to resolve with the
        // cached token if we have one (and return that future since the token has still not
        // expired).
        if (_cachedToken != null) {
          return _cachedTokenFuture = Future.value(_cachedToken);
        }

        // Otherwise, set the cached token future to null so that it will force a refresh next
        // time getToken() is called.
        _cachedTokenFuture = null;

        // And re-throw the caught error.
        throw error;
      });
    } else {
      // Clear the outstanding token refresh timeout. This is a noop if the timeout is undefined.
      _tokenRefreshTimeout?.cancel();

      // this.credential_ may be an external class; resolving it in a future helps us
      // protect against exceptions and upgrades the result to a future in all cases.
      return _cachedTokenFuture = Future.microtask(() async {
        var token = await credential.getAccessToken();

        var hasAccessTokenChanged =
            _cachedToken?.accessToken != token.accessToken;
        var hasExpirationChanged =
            _cachedToken?.expirationTime != token.expirationTime;
        if (_cachedToken == null ||
            hasAccessTokenChanged ||
            hasExpirationChanged) {
          _cachedToken = token;
          for (var listener in _tokenListeners) {
            listener(token.accessToken);
          }
        }

        var expiresIn = token.expirationTime.difference(clock.now());
        // Establish a timeout to proactively refresh the token every minute starting at five
        // minutes before it expires. Once a token refresh succeeds, no further retries are
        // needed; if it fails, retry every minute until the token expires (resulting in a total
        // of four retries: at 4, 3, 2, and 1 minutes).
        var refreshTime = expiresIn - const Duration(minutes: 5);
        var numRetries = 4;

        // In the rare cases the token is short-lived (that is, it expires in less than five
        // minutes from when it was fetched), establish the timeout to refresh it after the
        // current minute ends and update the number of retries that should be attempted before
        // the token expires.
        if (refreshTime.isNegative) {
          refreshTime = Duration(seconds: expiresIn.inSeconds % 60);
          numRetries = expiresIn.inMinutes - 1;
        }

        // The token refresh timeout keeps the Node.js process alive, so only create it if this
        // instance has not already been deleted.
        if (numRetries != 0 && !_isDeleted) {
          _setTokenRefreshTimeout(refreshTime, numRetries);
        }

        return token;
      }).catchError((error, tr) {
        var errorMessage =
            'Credential implementation provided to initializeApp() via the '
            '"credential" property failed to fetch a valid Google OAuth2 access token with the '
            'following error: "${error is FirebaseException ? error.message : error}".';

        if (errorMessage.contains('invalid_grant')) {
          errorMessage +=
              ' There are two likely causes: (1) your server time is not properly '
              'synced or (2) your certificate key file has been revoked. To solve (1), re-sync the '
              'time on your server. To solve (2), make sure the key ID for your key file is still '
              'present at https://console.firebase.google.com/iam-admin/serviceaccounts/project. If '
              'not, generate a key file at '
              'https://console.firebase.google.com/project/_/settings/serviceaccounts/adminsdk.';
        }

        throw FirebaseAppError.invalidCredential(errorMessage);
      }, test: (e) => e is! FirebaseException);
    }
  }

  /// Adds a listener that is called each time a token changes.
  void addAuthTokenListener(void Function(String token) listener) {
    _tokenListeners.add(listener);
    if (_cachedToken != null) {
      listener(_cachedToken!.accessToken);
    }
  }

  /// Removes a token listener.
  void removeAuthTokenListener(void Function(String token) listener) {
    _tokenListeners.remove(listener);
  }

  /// Deletes the FirebaseAppInternals instance.
  void delete() {
    _isDeleted = true;

    // Clear the token refresh timeout so it doesn't keep the Node.js process alive.
    _tokenRefreshTimeout?.cancel();
  }

  /// Establishes timeout to refresh the Google OAuth2 access token used by the SDK.
  void _setTokenRefreshTimeout(Duration delay, int numRetries) {
    _tokenRefreshTimeout = Timer(delay, () async {
      try {
        await getToken(/* forceRefresh */ true);
      } catch (error) {
        // Ignore the error since this might just be an intermittent failure. If we really cannot
        // refresh the token, an error will be logged once the existing token expires and we try
        // to fetch a fresh one.
        if (numRetries > 0) {
          _setTokenRefreshTimeout(const Duration(minutes: 1), numRetries - 1);
        }
      }
    });
  }
}
