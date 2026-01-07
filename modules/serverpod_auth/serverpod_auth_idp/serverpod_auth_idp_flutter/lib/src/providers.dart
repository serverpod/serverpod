import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

/// Exposes information about available identity providers.
class AvailableIdps {
  /// The client instance.
  final ServerpodClientShared client;

  /// Creates a new instance of [AvailableIdps].
  const AvailableIdps(this.client);

  bool _isProviderAvailable<T extends EndpointRef>() {
    try {
      client.getEndpointOfType<T>();
      return true;
    } on ServerpodClientEndpointNotFound {
      return false;
    } on ServerpodClientMultipleEndpointsFound {
      return true;
    }
  }

  /// Whether any identity providers are available.
  bool get hasAny => count > 0;

  /// The number of available identity providers.
  int get count => [
    hasEmail,
    hasGoogle,
    hasApple,
    hasFirebase,
    hasGitHub,
  ].where((e) => e).length;

  /// Whether the anonymous authentication provider is available.
  bool get hasAnonymous => _isProviderAvailable<EndpointAnonymousIdpBase>();

  /// Whether the email authentication provider is available.
  bool get hasEmail => _isProviderAvailable<EndpointEmailIdpBase>();

  /// Whether the Google authentication provider is available.
  bool get hasGoogle => _isProviderAvailable<EndpointGoogleIdpBase>();

  /// Whether the Apple authentication provider is available.
  bool get hasApple => _isProviderAvailable<EndpointAppleIdpBase>();

  /// Whether the Firebase authentication provider is available.
  bool get hasFirebase => _isProviderAvailable<EndpointFirebaseIdpBase>();

  /// Whether the GitHub authentication provider is available.
  bool get hasGitHub => _isProviderAvailable<EndpointGitHubIdpBase>();
}

/// Extension to provide information about available identity providers.
extension IdpExtension on FlutterAuthSessionManager {
  /// Provides information about available identity providers.
  ///
  /// Use this getter to check which identity providers are available on the
  /// server, and to display the appropriate sign-in options.
  ///
  /// Example usage:
  /// ```dart
  /// if (client.auth.idp.hasGoogle) {
  ///   // Show Google sign-in option.
  /// }
  /// ```
  AvailableIdps get idp => AvailableIdps(caller.client);
}
