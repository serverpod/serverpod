import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/anonymous_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given login request with default rate limiting',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in under rate limits, it is allowed',
        () async {
          final result = await fixture.anonymousIdp.login(session);
          expect(result, isA<AuthSuccess>());
        },
      );

      test(
        'when logging in over rate limits, it is blocked',
        () async {
          for (int i = 0; i < 100; i++) {
            final result = await fixture.anonymousIdp.login(session);
            expect(result, isA<AuthSuccess>());
          }
          await expectLater(
            () => fixture.anonymousIdp.login(session),
            throwsA(isA<AnonymousAccountBlockedException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given login request within specific rate limiting allowance',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in under rate limits, it is allowed',
        () async {
          final rateLimitedFixture = AnonymousIdpTestFixture(
            config: AnonymousIdpConfig(
              perIpAddressRateLimitConfig: AnonymousIdpLoginRateLimitingConfig(
                // Limit of 2, but only inserting 1 record
                maxAttempts: 2,
                timeframe: const Duration(minutes: 1),
              ),
            ),
          );

          final result = await fixture.anonymousIdp.login(session);
          expect(result, isA<AuthSuccess>());

          final result2 = await rateLimitedFixture.anonymousIdp.login(session);
          expect(result2, isA<AuthSuccess>());
        },
      );

      test(
        'when logging in over rate limits, it is blocked',
        () async {
          final rateLimitedFixture = AnonymousIdpTestFixture(
            config: AnonymousIdpConfig(
              perIpAddressRateLimitConfig: AnonymousIdpLoginRateLimitingConfig(
                maxAttempts: 1,
                timeframe: const Duration(minutes: 1),
              ),
            ),
          );
          final result = await fixture.anonymousIdp.login(session);
          expect(result, isA<AuthSuccess>());

          await expectLater(
            () => rateLimitedFixture.anonymousIdp.login(session),
            throwsA(isA<AnonymousAccountBlockedException>()),
          );
        },
      );

      test(
        'when logging in over rate limits but from different IP addresses, '
        'it is allowed',
        () async {
          final rateLimitedFixture = AnonymousIdpTestFixture(
            config: AnonymousIdpConfig(
              perIpAddressRateLimitConfig: AnonymousIdpLoginRateLimitingConfig(
                maxAttempts: 1,
                timeframe: const Duration(minutes: 1),
              ),
            ),
          );

          // Manually insert a row instead of calling `login`, as this is the
          // only feasible way to create the same side effects of `login`, but
          // with a different IP address.
          final attemptedAt = DateTime.now();
          await RateLimitedRequestAttempt.db.insertRow(
            session,
            RateLimitedRequestAttempt(
              domain: 'anonymous-idp-login',
              source: 'account-creation',
              nonce: 'different-ip-address',
              // The IP address column is not used, so this value is irrelevant.
              // We check on IP addresses by reusing its value as the `nonce`.
              ipAddress: 'does-not-matter',
              attemptedAt: attemptedAt,
            ),
          );

          final result = rateLimitedFixture.anonymousIdp.login(session);
          await expectLater(result, completion(isA<AuthSuccess>()));
        },
      );
    },
  );

  withServerpod(
    'Given login request with onBeforeAnonymousAccountCreated',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in without onBeforeAnonymousAccountCreated approval, '
        'it is blocked',
        () async {
          final cannotCreateFixture = AnonymousIdpTestFixture(
            config: AnonymousIdpConfig(
              onBeforeAnonymousAccountCreated:
                  (
                    final Session session, {
                    final String? token,
                    final Transaction? transaction,
                  }) async {
                    await Future.delayed(Duration.zero);
                    throw Exception('Test exception');
                  },
            ),
          );
          await expectLater(
            () => cannotCreateFixture.anonymousIdp.login(session),
            throwsA(isA<AnonymousAccountBlockedException>()),
          );
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );

      test(
        'when logging in with onBeforeAnonymousAccountCreated approval, '
        'it is allowed',
        () async {
          final canCreateFixture = AnonymousIdpTestFixture(
            config: AnonymousIdpConfig(
              onBeforeAnonymousAccountCreated:
                  (
                    final Session session, {
                    final String? token,
                    final Transaction? transaction,
                  }) async {
                    await Future.delayed(Duration.zero);
                  },
            ),
          );
          final result = canCreateFixture.anonymousIdp.login(session);
          await expectLater(result, completion(isA<AuthSuccess>()));
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );
    },
  );
}
