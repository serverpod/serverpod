import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'fake_token_manager.dart';
import 'fake_token_storage.dart';

class FakeTokenManagerFactory extends TokenManagerFactory<FakeTokenManager> {
  FakeTokenManagerFactory({
    required this.tokenStorage,
  });

  final FakeTokenStorage tokenStorage;

  @override
  FakeTokenManager construct({required final AuthUsers authUsers}) {
    return FakeTokenManager(
      tokenStorage,
      authUsers: authUsers,
    );
  }
}
