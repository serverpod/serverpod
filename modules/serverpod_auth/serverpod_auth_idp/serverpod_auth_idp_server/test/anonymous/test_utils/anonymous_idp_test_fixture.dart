import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';

final class AnonymousIdpTestFixture {
  late final AnonymousIdp anonymousIdp;
  late final TokenManager tokenManager;
  final UserProfiles userProfiles = const UserProfiles();
  final AuthUsers authUsers = const AuthUsers();

  AnonymousIdpTestFixture({
    final AnonymousIdpConfig config = const AnonymousIdpConfig(),
    final TokenManager? tokenManager,
  }) {
    this.tokenManager =
        tokenManager ??
        AuthServices(
          authUsers: authUsers,
          userProfiles: userProfiles,
          primaryTokenManagerBuilder: ServerSideSessionsConfig(
            sessionKeyHashPepper: 'test-pepper',
          ),
          identityProviderBuilders: [],
        ).tokenManager;

    anonymousIdp = AnonymousIdp(config, tokenManager: this.tokenManager);
  }
}
