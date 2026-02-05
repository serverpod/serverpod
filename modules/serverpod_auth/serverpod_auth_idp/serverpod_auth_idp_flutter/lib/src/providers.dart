import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

/// Exposes information about available identity providers.
class AvailableIdps {
  /// The client instance.
  final ServerpodClientShared client;

  /// Creates a new instance of [AvailableIdps].
  const AvailableIdps(this.client);

  /// Whether the identity provider is available.
  bool has<T extends EndpointRef>([String? name]) {
    try {
      client.getEndpointOfType<T>(name);
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
  bool get hasAnonymous => has<EndpointAnonymousIdpBase>();

  /// Whether the email authentication provider is available.
  bool get hasEmail => has<EndpointEmailIdpBase>();

  /// Whether the Google authentication provider is available.
  bool get hasGoogle => has<EndpointGoogleIdpBase>();

  /// Whether the Apple authentication provider is available.
  bool get hasApple => has<EndpointAppleIdpBase>();

  /// Whether the Firebase authentication provider is available.
  bool get hasFirebase => has<EndpointFirebaseIdpBase>();

  /// Whether the GitHub authentication provider is available.
  bool get hasGitHub => has<EndpointGitHubIdpBase>();

  /// Provides information about connected identity providers.
  ///
  /// Use this getter to check which identity providers are connected to the
  /// current user's account.
  ///
  /// Example usage:
  /// ```dart
  /// final connectedIdps = await client.auth.idp.getConnectedIdps();
  /// if (connectedIdps.email.hasAccount) {
  ///   // Show email sign-in option.
  /// }
  Future<ConnectedIdps> getConnectedIdps() async {
    final connectedProviders = <EndpointIdpBase>{};

    for (final endpoint in client.endpointRefLookup.values) {
      if (endpoint is EndpointIdpBase) {
        try {
          if (await endpoint.hasAccount()) {
            connectedProviders.add(endpoint);
          }
        } catch (_) {
          continue;
        }
      }
    }

    return ConnectedIdps(client, connectedProviders);
  }
}

/// Provides information about connected identity providers.
class ConnectedIdps extends AvailableIdps {
  /// Creates a new instance of [ConnectedIdps].
  const ConnectedIdps(super.client, this._connectedIdps);

  final Iterable<EndpointIdpBase> _connectedIdps;

  /// The names of the endpoints of the connected identity providers.
  Iterable<String> get names => _connectedIdps.map((e) => e.name);

  @override
  bool has<T extends EndpointRef>([String? name]) {
    return _connectedIdps
        .whereType<T>()
        .where((e) => name == null || e.name == name)
        .isNotEmpty;
  }
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
