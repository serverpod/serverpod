import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import './test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: 'test-pepper',
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
        identityProviderBuilders: [
          newEmailIdpConfig,
        ],
        tokenManagerBuilders: [tokenManagerConfig],
      );
    });

    tearDown(() {
      AuthServices.set(
        identityProviderBuilders: [],
        tokenManagerBuilders: [tokenManagerConfig],
      );
    });

    test(
      'when attempting to run `importLegacyPasswordIfNeeded` for a non-existent account, '
      'then it completes without error.',
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

  withServerpod(
    'Given a migrated account whose password only exists in the legacy system,',
    rollbackDatabase: RollbackDatabase.disabled,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue emailAccountId;

      const email = 'migrated@serverpod.dev';
      const password = 'Foobar123!';
      const failedLoginRateLimit = RateLimit(
        maxAttempts: 2,
        timeframe: Duration(hours: 1),
      );

      setUp(() async {
        session = sessionBuilder.build();
        AuthServices.set(
          identityProviderBuilders: [
            const EmailIdpConfig(
              secretHashPepper: 'test',
              failedLoginRateLimit: failedLoginRateLimit,
            ),
          ],
          tokenManagerBuilders: [tokenManagerConfig],
        );

        final authUser = await const AuthUsers().create(session);
        emailAccountId = await AuthServices.instance.emailIdp.admin
            .createEmailAuthentication(
              session,
              authUserId: authUser.id,
              email: email,
              password: null,
            );

        await AuthBackwardsCompatibility.storeLegacyPassword(
          session,
          emailAccountId: emailAccountId,
          passwordHash: _legacyPasswordHash(password: password, email: email),
        );
      });

      tearDown(() async {
        AuthServices.set(
          identityProviderBuilders: [],
          tokenManagerBuilders: [tokenManagerConfig],
        );

        // Rollbacks are disabled here, so each test has to leave the database
        // as it found it. Deleting the user cascades to its email account, and
        // that in turn to the legacy password hanging off it.
        await AuthUser.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
        );
        await RateLimitedRequestAttempt.db.deleteWhere(
          session,
          where: (final _) => Constant.bool(true),
        );
      });

      group('when the failed login rate limit is already exhausted,', () {
        late LegacyAuthenticationResponse response;

        setUp(() async {
          for (
            var attempt = 0;
            attempt <= failedLoginRateLimit.maxAttempts;
            attempt++
          ) {
            await endpoints.legacyEmail.authenticate(
              sessionBuilder,
              email,
              'wrong-password-$attempt',
            );
          }

          response = await endpoints.legacyEmail.authenticate(
            sessionBuilder,
            email,
            password,
          );
        });

        test('then a correct password is refused as a locked out guess.', () {
          expect(
            response.failReason,
            LegacyAuthenticationFailReason.tooManyFailedAttempts,
          );
        });

        test(
          'then a correct password is not verified against the legacy hash.',
          () async {
            // A correct guess consumes the legacy row: the import verifies it,
            // installs the password on the `EmailAccount` and deletes it.
            // Finding the row gone is therefore proof that the hash was
            // verified while the account was locked out - which is the guess
            // the rate limit was supposed to refuse.
            final legacyPassword = await LegacyEmailPassword.db.findFirstRow(
              session,
              where: (final t) => t.emailAccountId.equals(emailAccountId),
            );

            expect(
              legacyPassword,
              isNotNull,
              reason:
                  'The legacy password was verified and imported even though '
                  'the account was rate limited, so the limit does not bound '
                  'how many guesses an attacker gets.',
            );
          },
        );
      });
    },
  );
}

/// Builds a `serverpod_auth` era password hash, as
/// `LegacyEmailPassword.hash` would hold for an account migrated from it.
///
/// Mirrors the plain `legacy` hash type: `sha256(password + salt)`, with the
/// email appended to the salt because `extraSaltyHash` defaults to true.
String _legacyPasswordHash({
  required final String password,
  required final String email,
}) {
  const legacySalt = 'serverpod password salt';

  return sha256.convert(utf8.encode('$password$legacySalt:$email')).toString();
}
