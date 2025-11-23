import 'package:serverpod_auth_idp_server/core.dart';

import '../providers/google/google.dart';

/// AuthServices factory for creating [GoogleIdp] instances.
class GoogleIdentityProviderFactory extends IdentityProviderFactory<GoogleIdp> {
  /// The configuration that will be used to create the [GoogleIdp].
  final GoogleIdpConfig config;

  /// Creates a new [GoogleIdentityProviderFactory].
  GoogleIdentityProviderFactory(
    this.config,
  );

  @override
  GoogleIdp construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return GoogleIdp(
      config,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Extension to get the GoogleIdp instance from the AuthServices.
extension GoogleIdpGetter on AuthServices {
  /// Returns the GoogleIdp instance from the AuthServices.
  GoogleIdp get googleIdp => AuthServices.getIdentityProvider<GoogleIdp>();
}
