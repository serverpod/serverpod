import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'anonymous_idp.dart';

/// Configuration options for the anonymous identity provider.
class AnonymousIdpConfig extends IdentityProviderBuilder<AnonymousIdp> {
  /// Creates a new [AnonymousIdpConfig] instance.
  const AnonymousIdpConfig();

  @override
  AnonymousIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return AnonymousIdp(
      authUsers: authUsers,
      tokenManager: tokenManager,
    );
  }
}
