import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';

/// A fake identity provider for testing purposes.
class FakeIdentityProvider {
  final TokenIssuer tokenIssuer;

  FakeIdentityProvider({required this.tokenIssuer});
}
