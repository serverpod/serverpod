import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

/// A fake identity provider for testing purposes.
class FakeIdentityProvider implements IdentityProvider {
  @override
  String get method => 'fake';

  final TokenIssuer tokenIssuer;
  final AuthUsers authUsers;
  final UserProfiles userProfiles;

  FakeIdentityProvider({
    required this.tokenIssuer,
    required this.authUsers,
    required this.userProfiles,
  });

  @override
  Future<void> mergeAuthUsers(
    Session session, {
    required UuidValue userToKeepId,
    required UuidValue userToRemoveId,
    required Transaction transaction,
  }) async {}
}
