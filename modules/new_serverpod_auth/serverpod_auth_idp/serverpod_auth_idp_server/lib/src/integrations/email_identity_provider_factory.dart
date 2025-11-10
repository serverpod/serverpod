import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../../providers/email.dart';

/// AuthServices factory for creating [EmailIDP] instances.
class EmailIdentityProviderFactory extends IdentityProviderFactory<EmailIDP> {
  /// The configuration that will be used to create the [EmailIDP].
  final EmailIDPConfig config;

  /// Creates a new [EmailIdentityProviderFactory].
  EmailIdentityProviderFactory(
    this.config, {
    super.tokenManagerOverride,
    super.authUsersOverride,
    super.userProfilesOverride,
  });

  @override
  EmailIDP construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return EmailIDP(
      config,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Extension to get the EmailIDP instance from the AuthServices.
extension EmailIDPGetter on AuthServices {
  /// Returns the EmailIDP instance from the AuthServices.
  EmailIDP get emailIDP => AuthServices.getIdentityProvider<EmailIDP>();
}
