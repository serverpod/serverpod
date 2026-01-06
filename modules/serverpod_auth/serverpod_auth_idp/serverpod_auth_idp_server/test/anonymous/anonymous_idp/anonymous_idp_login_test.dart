import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:test/test.dart';

import '../../test_tags.dart';
import '../../test_tools/serverpod_test_tools.dart';
import '../test_utils/anonymous_idp_test_fixture.dart';

void main() {
  withServerpod(
    'Given login request with no previous attempts',
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
        'when logging in, then it is allowed',
        () async {
          final result = await fixture.anonymousIdp.login(session);
          expect(result, isA<AuthSuccess>());
        },
      );
    },
  );

  withServerpod(
    'Given login request within configured rate limit with existing request attempt',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() async {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture(
          config: AnonymousIdpConfig(
            perIpAddressRateLimitConfig: AnonymousIdpLoginRateLimitingConfig(
              maxAttempts: 2,
              timeframe: const Duration(minutes: 1),
            ),
          ),
        );

        // Create one existing attempt to simulate a previous login
        await fixture.anonymousIdp.login(session);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in, then it is allowed',
        () async {
          final result = await fixture.anonymousIdp.login(session);
          expect(result, isA<AuthSuccess>());
        },
      );
    },
  );

  withServerpod(
    'Given login request exceeding configured rate limit',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() async {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture(
          config: AnonymousIdpConfig(
            perIpAddressRateLimitConfig: AnonymousIdpLoginRateLimitingConfig(
              maxAttempts: 1,
              timeframe: const Duration(minutes: 1),
            ),
          ),
        );

        // Create one existing attempt to reach the rate limit
        await fixture.anonymousIdp.login(session);
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in, then it is blocked with too many attempts exception',
        () async {
          await expectLater(
            () => fixture.anonymousIdp.login(session),
            throwsA(isA<AnonymousAccountBlockedException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given rate limit of 1 and an existing request attempt with a different IP address',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() async {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture(
          config: AnonymousIdpConfig(
            perIpAddressRateLimitConfig: AnonymousIdpLoginRateLimitingConfig(
              maxAttempts: 1,
              timeframe: const Duration(minutes: 1),
            ),
          ),
        );

        await fixture.anonymousIdp.login(session);

        // NOTE: This test is coupled to the implementation of the rate limiting
        // due to the impossibility of mocking the IP address.
        await session.db.transaction((final transaction) async {
          final loggedAttempt = await RateLimitedRequestAttempt.db.findFirstRow(
            session,
            transaction: transaction,
          );

          // This check ensures that any change to the implementation of the
          // rate limiting will break the test, so we can be sure that the test
          // is actually testing the rate limiting.
          expect(loggedAttempt, isNotNull);

          // Change the stored login attempt to simulate a different IP address.
          await RateLimitedRequestAttempt.db.updateRow(
            session,
            loggedAttempt!.copyWith(nonce: 'different-ip-address'),
            transaction: transaction,
          );
        });
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in from different IP address, then it is allowed',
        () async {
          final result = fixture.anonymousIdp.login(session);
          await expectLater(result, completion(isA<AuthSuccess>()));
        },
      );
    },
  );

  withServerpod(
    'Given onBeforeAnonymousAccountCreated callback configured to receive the token',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      String? receivedToken;
      setUp(() {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture(
          config: AnonymousIdpConfig(
            onBeforeAnonymousAccountCreated:
                (
                  final Session session, {
                  final String? token,
                  final Transaction? transaction,
                }) async {
                  receivedToken = token;
                },
          ),
        );
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in with a token, then it is received by the callback.',
        () async {
          const token = 'test-token';
          await fixture.anonymousIdp.login(session, token: token);

          expect(receivedToken, isNotNull);
          expect(receivedToken, equals(token));
        },
      );
    },
  );

  withServerpod(
    'Given onBeforeAnonymousAccountCreated configured to block login attempts',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AnonymousIdpTestFixture fixture;
      setUp(() {
        session = sessionBuilder.build();
        fixture = AnonymousIdpTestFixture(
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
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      test(
        'when logging in, then it is blocked with AnonymousAccountBlockedException exception',
        () async {
          await expectLater(
            () => fixture.anonymousIdp.login(session),
            throwsA(isA<AnonymousAccountBlockedException>()),
          );
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );
    },
  );
}
