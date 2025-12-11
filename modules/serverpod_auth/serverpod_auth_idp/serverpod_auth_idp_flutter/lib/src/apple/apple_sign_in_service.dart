import 'dart:async';

import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service to manage Apple Sign-In and ensure it is initialized.
class AppleSignInService {
  /// Singleton instance of the [AppleSignInService].
  static final AppleSignInService instance = AppleSignInService._internal();

  AppleSignInService._internal();

  WebAuthenticationOptions? _webAuthenticationOptions;

  /// Gets the web authentication options if configured.
  ///
  /// If [ensureInitialized] has not been called before, it will be called
  /// before returning the options.
  Future<WebAuthenticationOptions?> webAuthenticationOptions() async {
    await ensureInitialized();
    return _webAuthenticationOptions;
  }

  /// Ensures that Apple Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the Apple Sign-In configuration. It is only
  /// required to call this method once through the app lifetime.
  ///
  /// If [serviceIdentifier] and [redirectUri] are not provided, will try to
  /// load the values from `APPLE_SERVICE_IDENTIFIER` and `APPLE_REDIRECT_URI`
  /// environment variables, respectively. These parameters are required for
  /// web and Android platforms. On native Apple platforms (iOS/macOS), these
  /// parameters are ignored.
  Future<void> ensureInitialized({
    String? serviceIdentifier,
    String? redirectUri,
  }) async {
    if (!(await isAvailable())) return;
    if (_webAuthenticationOptions != null) return;

    serviceIdentifier ??= _getServiceIdentifierFromEnvVar();
    redirectUri ??= _getRedirectUriFromEnvVar();

    if (serviceIdentifier == null || redirectUri == null) {
      throw ArgumentError(
        'Both serviceIdentifier and redirectUri are required for web and '
        'Android platforms. Either provide them as parameters or set the '
        '"APPLE_SERVICE_IDENTIFIER" and "APPLE_REDIRECT_URI" environment '
        'variables.',
      );
    }

    _webAuthenticationOptions = WebAuthenticationOptions(
      clientId: serviceIdentifier,
      redirectUri: Uri.parse(redirectUri),
    );
  }

  /// Checks if Sign in with Apple is available on the current platform.
  Future<bool> isAvailable() async {
    return await SignInWithApple.isAvailable();
  }
}

/// Expose convenient methods on [FlutterAuthSessionManager].
extension AppleSignInExtension on FlutterAuthSessionManager {
  /// Initializes Apple Sign-In for the client.
  ///
  /// This method is idempotent and can be called multiple times, but only the
  /// first call will initialize the Apple Sign-In configuration. It is only
  /// required to call this method once through the app lifetime.
  ///
  /// If [serviceIdentifier] and [redirectUri] are not provided, will try to
  /// load the values from `APPLE_SERVICE_IDENTIFIER` and `APPLE_REDIRECT_URI`
  /// environment variables, respectively. These parameters are required for
  /// web and Android platforms. On native Apple platforms (iOS/macOS), these
  /// parameters are ignored.
  Future<void> initializeAppleSignIn({
    String? serviceIdentifier,
    String? redirectUri,
  }) async {
    await AppleSignInService.instance.ensureInitialized(
      serviceIdentifier: serviceIdentifier,
      redirectUri: redirectUri,
    );
  }
}

String? _getServiceIdentifierFromEnvVar() {
  return const bool.hasEnvironment('APPLE_SERVICE_IDENTIFIER')
      ? const String.fromEnvironment('APPLE_SERVICE_IDENTIFIER')
      : null;
}

String? _getRedirectUriFromEnvVar() {
  return const bool.hasEnvironment('APPLE_REDIRECT_URI')
      ? const String.fromEnvironment('APPLE_REDIRECT_URI')
      : null;
}
