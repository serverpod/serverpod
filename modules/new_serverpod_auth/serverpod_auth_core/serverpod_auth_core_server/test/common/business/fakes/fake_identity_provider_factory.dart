import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';

import 'fake_identity_provider.dart';

/// A fake implementation of [IdentityProviderFactory] for testing purposes.
class FakeIdentityProviderFactory
    implements IdentityProviderFactory<FakeIdentityProvider> {
  @override
  Type get type => FakeIdentityProvider;

  @override
  FakeIdentityProvider construct({
    required final TokenIssuer defaultTokenIssuer,
  }) {
    return FakeIdentityProvider(tokenIssuer: defaultTokenIssuer);
  }
}
