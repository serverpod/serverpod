import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../providers/passkey/passkey.dart';

/// AuthServices factory for creating [PasskeyIDP] instances.
class PasskeyIdentityProviderFactory
    extends IdentityProviderFactory<PasskeyIDP> {
  /// The configuration for the Passkey identity provider.
  final PasskeyIDPConfig config;

  /// Creates a new [PasskeyIdentityProviderFactory].
  PasskeyIdentityProviderFactory(
    this.config, {
    super.tokenManagerOverride,
  });

  @override
  PasskeyIDP construct({required final TokenManager tokenManager}) {
    return PasskeyIDP(config, tokenIssuer: tokenManager);
  }
}
