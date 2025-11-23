import 'package:serverpod_auth_idp_server/core.dart';

import '../providers/passkey/passkey.dart';

/// AuthServices factory for creating [PasskeyIdp] instances.
class PasskeyIdentityProviderFactory
    extends IdentityProviderFactory<PasskeyIdp> {
  /// The configuration for the Passkey identity provider.
  final PasskeyIdpConfig config;

  /// Creates a new [PasskeyIdentityProviderFactory].
  PasskeyIdentityProviderFactory(
    this.config,
  );

  @override
  PasskeyIdp construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return PasskeyIdp(
      config,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
    );
  }
}
