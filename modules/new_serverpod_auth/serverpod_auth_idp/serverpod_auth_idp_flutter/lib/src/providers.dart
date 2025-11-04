import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

/// Exposes information about available identity providers.
class AvailableIDPs {
  /// The client instance.
  final ServerpodClientShared client;

  /// Creates a new instance of [AvailableIDPs].
  const AvailableIDPs(this.client);

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
  int get count => [hasEmail, hasGoogle, hasApple].where((e) => e).length;

  /// Whether the email authentication provider is available.
  bool get hasEmail => _isProviderAvailable<EndpointEmailIDPBase>();

  /// Whether the Google authentication provider is available.
  bool get hasGoogle => _isProviderAvailable<EndpointGoogleIDPBase>();

  /// Whether the Apple authentication provider is available.
  bool get hasApple => _isProviderAvailable<EndpointAppleIDPBase>();
}

/// Extension to provide information about available identity providers.
extension IDPExtension on ClientAuthSessionManager {
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
  AvailableIDPs get idp => AvailableIDPs(caller.client);
}
