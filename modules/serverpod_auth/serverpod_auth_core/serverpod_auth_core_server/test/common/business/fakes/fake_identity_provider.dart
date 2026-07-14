import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

/// A fake identity provider for testing purposes.
class FakeIdentityProvider implements IdentityProvider {
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
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  }) async {}
}
