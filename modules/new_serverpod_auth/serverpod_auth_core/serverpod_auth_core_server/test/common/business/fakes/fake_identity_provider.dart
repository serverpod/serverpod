import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';

/// A fake identity provider for testing purposes.
class FakeIdentityProvider implements IdentityProvider {
  final TokenManager tokenManager;

  FakeIdentityProvider({required this.tokenManager});
}
