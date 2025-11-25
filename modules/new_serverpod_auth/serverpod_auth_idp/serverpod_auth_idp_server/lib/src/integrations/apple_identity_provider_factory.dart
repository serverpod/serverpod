import '../../core.dart';
import '../../providers/apple.dart';

/// AuthServices factory for creating [AppleIdp] instances.
class AppleIdentityProviderFactory extends IdentityProviderFactory<AppleIdp> {
  /// The configuration that will be used to create the AppleIdp.
  final AppleIdpConfig config;

  /// Creates a new [AppleIdentityProviderFactory].
  AppleIdentityProviderFactory(
    this.config,
  );

  @override
  AppleIdp construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return AppleIdp(
      config,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Extension to get the AppleIdp instance from the AuthServices.
extension AppleIdpGetter on AuthServices {
  /// Returns the AppleIdp instance from the AuthServices.
  AppleIdp get appleIdp => AuthServices.getIdentityProvider<AppleIdp>();
}
