import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManager = AuthSessionsTokenManager(
    config: AuthSessionsConfig(
      sessionKeyHashPepper: 'test-pepper',
    ),
  );

  const config = EmailIDPConfig(passwordHashPepper: 'test');
  final newEmailIDP = EmailIDP(
    config: config,
    tokenManager: tokenManager,
  );

  withServerpod('Given no legacy passwords,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() {
      session = sessionBuilder.build();
      AuthBackwardsCompatibility.config = AuthBackwardsCompatibilityConfig(
        emailIDP: newEmailIDP,
      );
    });

    test(
      'when attempting to run `importLegacyPasswordIfNeeded` for a non-existent account, then it completes without error.',
      () async {
        await expectLater(
          AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
            session,
            email: '404@serverpod.dev',
            password: 'DoesNotExist123!',
          ),
          completes,
        );
      },
    );
  });
}
