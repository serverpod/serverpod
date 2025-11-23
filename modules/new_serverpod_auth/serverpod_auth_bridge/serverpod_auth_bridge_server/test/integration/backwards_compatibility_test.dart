import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerFactory = ServerSideSessionsTokenManagerFactory(
    ServerSideSessionsConfig(
      sessionKeyHashPepper: 'test-pepper',
    ),
  );

  const newEmailIdpConfig = EmailIdpConfig(secretHashPepper: 'test');

  withServerpod('Given no legacy passwords,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() {
      session = sessionBuilder.build();
      AuthServices.set(
        identityProviders: [
          EmailIdentityProviderFactory(newEmailIdpConfig),
        ],
        primaryTokenManager: tokenManagerFactory,
      );
    });

    tearDown(() {
      AuthServices.set(
        identityProviders: [],
        primaryTokenManager: tokenManagerFactory,
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
