import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../providers/google/google.dart';

/// AuthServices factory for creating [GoogleIDP] instances.
class GoogleIdentityProviderFactory extends IdentityProviderFactory<GoogleIDP> {
  /// The configuration that will be used to create the [GoogleIDP].
  final GoogleIDPConfig config;

  /// Creates a new [GoogleIdentityProviderFactory].
  GoogleIdentityProviderFactory(
    this.config, {
    super.tokenManagerOverride,
  });

  @override
  GoogleIDP construct({required final TokenManager tokenManager}) {
    return GoogleIDP(config: config, tokenIssuer: tokenManager);
  }
}
