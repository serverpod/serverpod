import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'fake_identity_provider.dart';

/// A fake implementation of [IdentityProviderBuilder] for testing purposes.
class FakeConfig extends IdentityProviderBuilder<FakeIdentityProvider> {
  const FakeConfig();

  @override
  FakeIdentityProvider build({
    required TokenManager tokenManager,
    required AuthUsers authUsers,
    required UserProfiles userProfiles,
  }) {
    return FakeIdentityProvider(
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}
