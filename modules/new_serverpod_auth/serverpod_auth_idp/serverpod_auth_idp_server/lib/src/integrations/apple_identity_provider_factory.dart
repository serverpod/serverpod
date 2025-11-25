import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../providers/apple/apple.dart';

/// AuthServices factory for creating [AppleIDP] instances.
class AppleIdentityProviderFactory extends IdentityProviderFactory<AppleIDP> {
  /// The configuration that will be used to create the AppleIDP.
  final AppleIDPConfig config;

  /// Creates a new [AppleIdentityProviderFactory].
  AppleIdentityProviderFactory(
    this.config,
  );

  @override
  AppleIDP construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
    required final Serverpod? pod,
  }) {
    if (pod == null) {
      throw Exception('Serverpod instance is required to create an AppleIDP.');
    }

    return AppleIDP(
      config,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    )..initialize(pod);
  }

  /// Creates a new [AppleIdentityProviderFactory] from keys.
  factory AppleIdentityProviderFactory.fromKeys(
    final String? Function(String key) getConfig,
  ) {
    return AppleIdentityProviderFactory(
      AppleIDPConfig.fromKeys(getConfig),
    );
  }
}

/// Extension to get the AppleIDP instance from the AuthServices.
extension AppleIDPGetter on AuthServices {
  /// Returns the AppleIDP instance from the AuthServices.
  AppleIDP get appleIDP => AuthServices.getIdentityProvider<AppleIDP>();
}
