import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';
import 'package:serverpod_auth_core_server/src/profile/profile.dart';

/// A fake identity provider for testing purposes.
class FakeIdentityProvider {
  final TokenIssuer tokenIssuer;
  final AuthUsers authUsers;
  final UserProfiles userProfiles;

  FakeIdentityProvider({
    required this.tokenIssuer,
    required this.authUsers,
    required this.userProfiles,
  });
}
