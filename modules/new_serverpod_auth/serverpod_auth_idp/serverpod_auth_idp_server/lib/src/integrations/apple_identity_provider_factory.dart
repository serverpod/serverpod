import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';

/// AuthServices factory for creating [AppleIDP] instances.
class AppleIdentityProviderFactory extends IdentityProviderFactory<AppleIDP> {
  /// The configuration that will be used to create the AppleIDP.
  final AppleIDPConfig config;

  /// Creates a new [AppleIdentityProviderFactory].
  AppleIdentityProviderFactory(
    this.config, {
    super.tokenManagerOverride,
  });

  @override
  AppleIDP construct({required final TokenManager tokenManager}) {
    return AppleIDP(config: config, tokenIssuer: tokenManager);
  }
}
