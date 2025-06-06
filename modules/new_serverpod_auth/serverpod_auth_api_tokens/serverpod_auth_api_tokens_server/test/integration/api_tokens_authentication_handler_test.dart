import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_api_tokens_server/serverpod_auth_api_tokens_server.dart';
import 'package:serverpod_auth_api_tokens_server/src/business/api_token_secrets.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no API keys,',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });

      test(
          'when calling `authenticationHandler` with an unrelated string, then it returns `null`.',
          () async {
        expect(
          await ApiTokens.authenticationHandler(session, 'some string'),
          isNull,
        );
      });

      test(
          'when calling `authenticationHandler` with an invalid string fitting the pattern, then it returns `null`.',
          () async {
        expect(
          await ApiTokens.authenticationHandler(
            session,
            'sat:noguid64:nosecret64',
          ),
          isNull,
        );
      });
    },
  );

  withServerpod('Given an API token,', (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String apiToken;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      apiToken = await ApiTokens.createApiToken(
        session,
        authUserId: authUserId,
        scopes: {},
      );
    });

    test(
      'when calling `authenticationHandler`, then it returns an `AuthenticationInfo` for the user.',
      () async {
        final authInfo = await ApiTokens.authenticationHandler(
          session,
          apiToken,
        );

        expect(
          authInfo?.userUuid,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` with the wrong secret, then it returns `null`.',
      () async {
        final apiTokenParts = apiToken.split(':');
        apiTokenParts[2] = base64Encode(utf8.encode('some other secret'));
        final apiTokenWithInvalidSecret = apiTokenParts.join(':');

        final authInfo = await ApiTokens.authenticationHandler(
          session,
          apiTokenWithInvalidSecret,
        );

        expect(
          authInfo,
          isNull,
        );
      },
    );
  });

  withServerpod('Given an API token with custom scopes,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late String apiToken;

    setUp(() async {
      session = sessionBuilder.build();

      final authUserId = await createAuthUser(session);

      apiToken = await ApiTokens.createApiToken(
        session,
        authUserId: authUserId,
        scopes: {const Scope('test')},
      );
    });

    test(
      'when calling `authenticationHandler`, then it returns an `AuthenticationInfo` with the correct scopes.',
      () async {
        final authInfo = await ApiTokens.authenticationHandler(
          session,
          apiToken,
        );

        expect(
          authInfo?.scopes,
          {const Scope('test')},
        );
      },
    );
  });

  withServerpod(
    'Given an API token with an expiration date,',
    (final sessionBuilder, final endpoints) {
      final expiresAt = DateTime.now().add(const Duration(days: 1));
      late Session session;
      late UuidValue authUserId;
      late String apiToken;

      setUp(() async {
        session = sessionBuilder.build();

        authUserId = await createAuthUser(session);

        apiToken = await ApiTokens.createApiToken(
          session,
          authUserId: authUserId,
          scopes: {},
          expiresAt: expiresAt,
        );
      });

      tearDown(() {
        ApiTokens.secretsTestOverride = null;
      });

      test(
        'when calling `authenticationHandler` right away, then it returns an `AuthenticationInfo` for the user.',
        () async {
          final authInfo = await ApiTokens.authenticationHandler(
            session,
            apiToken,
          );

          expect(
            authInfo?.userUuid,
            authUserId,
          );
        },
      );

      test(
        'when calling `authenticationHandler` after the expiration date, then it returns `null`.',
        () async {
          final authInfo = await withClock(
            Clock.fixed(expiresAt.add(const Duration(seconds: 1))),
            () => ApiTokens.authenticationHandler(
              session,
              apiToken,
            ),
          );

          expect(
            authInfo,
            isNull,
          );
        },
      );

      test(
        'when calling `authenticationHandler` after the pepper has been changed, then it returns `null`.',
        () async {
          ApiTokens.secretsTestOverride = ApiTokenSecrets(
            apiTokenHashPepper: 'another pepper',
          );

          final authInfo = await ApiTokens.authenticationHandler(
            session,
            apiToken,
          );

          expect(
            authInfo,
            isNull,
          );
        },
      );
    },
  );

  withServerpod('Given an API token which will expire when unused,',
      (final sessionBuilder, final endpoints) {
    const expireAfterUnusedFor = Duration(minutes: 10);
    late Session session;
    late UuidValue authUserId;
    late String apiToken;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      apiToken = await ApiTokens.createApiToken(
        session,
        authUserId: authUserId,
        scopes: {},
        expireAfterUnusedFor: expireAfterUnusedFor,
      );
    });

    test(
      'when calling `authenticationHandler` right away, then it returns an `AuthenticationInfo` for the user.',
      () async {
        final authInfo = await ApiTokens.authenticationHandler(
          session,
          apiToken,
        );

        expect(
          authInfo?.userUuid,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` within the time limit and then afterwards, then it returns an `AuthenticationInfo` for the user (as the lifetime was extended).',
      () async {
        final firstUseTime = DateTime.now()
            .add(expireAfterUnusedFor - const Duration(minutes: 1));
        final authInfoBeforeInitialExpiration = await withClock(
          Clock.fixed(firstUseTime),
          () => ApiTokens.authenticationHandler(
            session,
            apiToken,
          ),
        );

        expect(
          authInfoBeforeInitialExpiration?.userUuid,
          authUserId,
        );

        final secondUseTime =
            firstUseTime.add(expireAfterUnusedFor - const Duration(minutes: 1));
        final authInfoAfterExtension = await withClock(
          Clock.fixed(secondUseTime),
          () => ApiTokens.authenticationHandler(
            session,
            apiToken,
          ),
        );

        expect(
          authInfoAfterExtension?.userUuid,
          authUserId,
        );
      },
    );

    test(
      'when calling `authenticationHandler` after the inactivity time limit, then it returns `null`',
      () async {
        final authInfo = await withClock(
          Clock.fixed(DateTime.now()
              .add(expireAfterUnusedFor + const Duration(minutes: 1))),
          () => ApiTokens.authenticationHandler(
            session,
            apiToken,
          ),
        );

        expect(
          authInfo,
          isNull,
        );
      },
    );
  });
}
