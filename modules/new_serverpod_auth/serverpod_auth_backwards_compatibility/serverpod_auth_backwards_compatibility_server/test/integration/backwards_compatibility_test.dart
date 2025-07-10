import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/serverpod_auth_backwards_compatibility_server.dart';
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no legacy passwords,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() {
        session = sessionBuilder.build();
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
    },
  );
}
