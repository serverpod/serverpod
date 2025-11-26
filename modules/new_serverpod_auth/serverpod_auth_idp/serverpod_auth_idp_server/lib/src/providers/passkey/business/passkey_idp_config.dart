import '../../../../../core.dart';
import 'passkey_idp.dart';

/// Configuration for the Passkey account module.
class PasskeyIdpConfig implements IdentityProviderBuilder<PasskeyIdp> {
  /// The hostname to be used on the web and associated with any apps.
  ///
  /// This is also known as the "relying party".
  final String hostname;

  /// Maximum time after which a challenge must have been solved.
  ///
  /// Default is 5 minutes.
  final Duration challengeLifetime;

  /// Creates a new configuration.
  const PasskeyIdpConfig({
    required this.hostname,
    this.challengeLifetime = const Duration(minutes: 5),
  });

  @override
  PasskeyIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return PasskeyIdp(
      this,
      tokenManager: tokenManager,
      authUsers: authUsers,
    );
  }
}
