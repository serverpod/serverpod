import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'fake_identity_provider.dart';

/// A fake implementation of [IdentityProviderFactory] for testing purposes.
class FakeIdentityProviderFactory
    extends IdentityProviderFactory<FakeIdentityProvider> {
  @override
  FakeIdentityProvider construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return FakeIdentityProvider(
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}
