import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';

import 'fake_identity_provider.dart';

/// A fake implementation of [IdentityProviderFactory] for testing purposes.
class FakeIdentityProviderFactory
    extends IdentityProviderFactory<FakeIdentityProvider> {
  @override
  FakeIdentityProvider construct({
    required final TokenManager tokenManager,
  }) {
    return FakeIdentityProvider(tokenIssuer: tokenManager);
  }
}
