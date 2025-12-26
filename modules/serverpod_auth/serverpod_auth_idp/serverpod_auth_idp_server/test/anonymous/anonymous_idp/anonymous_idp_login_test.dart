import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart' show RateLimit;
import 'package:serverpod_auth_idp_server/src/utils/session_extension.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/anonymous_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given no account',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture();
      });

      test('when logging in anonymously then a new account is created', () async {
        final result = fixture.anonymousIdp.login(session);
        await expectLater(result, completion(isA<AuthSuccess>()));
      });

      test('is not blocked by acceptable amount of attempts', () async {
        final rateLimitedFixture = AnonymousIdpTestFixture(
          config: const AnonymousIdpConfig(
            perIpAddressRateLimit: RateLimit(
              // Limit of 2, but only inserting 1 record
              maxAttempts: 2,
              timeframe: Duration(minutes: 1),
            ),
          ),
        );
        final attemptedAt = DateTime.now();
        await RateLimitedRequestAttempt.db.insertRow(
          session,
          RateLimitedRequestAttempt(
            domain: 'anonymous',
            source: 'account_creation',
            nonce: session.remoteIpAddress.toString(),
            ipAddress: session.remoteIpAddress.toString(),
            attemptedAt: attemptedAt,
          ),
        );
        final result = rateLimitedFixture.anonymousIdp.login(session);
        await expectLater(result, completion(isA<AuthSuccess>()));
      });

      test('is blocked by too many attempts', () async {
        final rateLimitedFixture = AnonymousIdpTestFixture(
          config: const AnonymousIdpConfig(
            perIpAddressRateLimit: RateLimit(
              // Limit of 1, and inserting 1 record
              maxAttempts: 1,
              timeframe: Duration(minutes: 1),
            ),
          ),
        );
        final attemptedAt = DateTime.now();
        await RateLimitedRequestAttempt.db.insertRow(
          session,
          RateLimitedRequestAttempt(
            domain: 'anonymous',
            source: 'account_creation',
            nonce: session.remoteIpAddress.toString(),
            ipAddress: session.remoteIpAddress.toString(),
            attemptedAt: attemptedAt,
          ),
        );
        await expectLater(
          () => rateLimitedFixture.anonymousIdp.login(session),
          throwsA(isA<AnonymousAccountBlockedException>()),
        );
      });

      test(
        'is not blocked by too many attempts but from different IP addresses',
        () async {
          final rateLimitedFixture = AnonymousIdpTestFixture(
            config: const AnonymousIdpConfig(
              perIpAddressRateLimit: RateLimit(
                // Limit of 1, and inserting 1 record
                maxAttempts: 1,
                timeframe: Duration(minutes: 1),
              ),
            ),
          );
          final attemptedAt = DateTime.now();
          await RateLimitedRequestAttempt.db.insertRow(
            session,
            RateLimitedRequestAttempt(
              domain: 'anonymous',
              source: 'account_creation',
              nonce: 'different-ip-address',
              // The IP address column is not used, so this value is irrelevant.
              // We check on IP addresses by reusing its value as the `nonce`.
              ipAddress: 'does-not-matter',
              attemptedAt: attemptedAt,
            ),
          );
          await expectLater(
            () => rateLimitedFixture.anonymousIdp.login(session),
            throwsA(isA<AnonymousAccountBlockedException>()),
          );
        },
      );

      test('is blocked by beforeAnonymousAccountCreated', () async {
        final cannotCreateFixture = AnonymousIdpTestFixture(
          config: AnonymousIdpConfig(
            beforeAnonymousAccountCreated:
                (
                  final Session session, {
                  final Transaction? transaction,
                }) => Future.value(false),
          ),
        );
        await expectLater(
          () => cannotCreateFixture.anonymousIdp.login(session),
          throwsA(isA<AnonymousAccountBlockedException>()),
        );
      });

      test('is blocked by synchronous beforeAnonymousAccountCreated', () async {
        final cannotCreateFixture = AnonymousIdpTestFixture(
          config: AnonymousIdpConfig(
            beforeAnonymousAccountCreated:
                (
                  final Session session, {
                  final Transaction? transaction,
                }) => false,
          ),
        );
        await expectLater(
          () => cannotCreateFixture.anonymousIdp.login(session),
          throwsA(isA<AnonymousAccountBlockedException>()),
        );
      });
    },
  );
}
