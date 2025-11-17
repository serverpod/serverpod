import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';

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
  }) {
    return AppleIDP(
      config,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Extension to get the AppleIDP instance from the AuthServices.
extension AppleIDPGetter on AuthServices {
  /// Returns the AppleIDP instance from the AuthServices.
  AppleIDP get appleIDP => AuthServices.getIdentityProvider<AppleIDP>();
}
