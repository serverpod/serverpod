import 'package:serverpod_auth_core_server/src/common/integrations/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';

/// A fake identity provider for testing purposes.
class FakeIdentityProvider implements IdentityProvider {
  @override
  final TokenIssuer tokenIssuer;

  FakeIdentityProvider({required this.tokenIssuer});
}
