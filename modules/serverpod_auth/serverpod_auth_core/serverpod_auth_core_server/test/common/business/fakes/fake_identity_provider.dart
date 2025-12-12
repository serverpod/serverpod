import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

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
