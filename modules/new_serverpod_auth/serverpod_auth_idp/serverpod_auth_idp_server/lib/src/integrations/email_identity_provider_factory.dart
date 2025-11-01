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
  });

  @override
  EmailIDP construct({required final TokenManager tokenManager}) {
    return EmailIDP(config: config, tokenManager: tokenManager);
  }
}
