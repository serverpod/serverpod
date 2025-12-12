import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'fake_token_manager.dart';
import 'fake_token_storage.dart';

class FakeTokenManagerBuilder implements TokenManagerBuilder<FakeTokenManager> {
  const FakeTokenManagerBuilder({
    required this.tokenStorage,
  });

  final FakeTokenStorage tokenStorage;

  @override
  FakeTokenManager build({required final AuthUsers authUsers}) {
    return FakeTokenManager(
      tokenStorage,
      authUsers: authUsers,
    );
  }
}
