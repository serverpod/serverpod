import '../../core.dart';
import '../../providers/email.dart';

/// AuthServices factory for creating [EmailIdp] instances.
class EmailIdentityProviderFactory extends IdentityProviderFactory<EmailIdp> {
  /// The configuration that will be used to create the [EmailIdp].
  final EmailIdpConfig config;

  /// Creates a new [EmailIdentityProviderFactory].
  EmailIdentityProviderFactory(
    this.config,
  );

  @override
  EmailIdp construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return EmailIdp(
      config,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Extension to get the EmailIdp instance from the AuthServices.
extension EmailIdpGetter on AuthServices {
  /// Returns the EmailIdp instance from the AuthServices.
  EmailIdp get emailIdp => AuthServices.getIdentityProvider<EmailIdp>();
}
