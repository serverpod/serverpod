import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_api_tokens_server/serverpod_auth_api_tokens_server.dart';
import 'package:test/test.dart';

import '../test_utils.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given two API tokens for a user,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late String apiToken1;
    late String apiToken2;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      apiToken1 = await ApiTokens.createApiToken(
        session,
        authUserId: authUserId,
        scopes: {},
      );
      apiToken2 = await ApiTokens.createApiToken(
        session,
        authUserId: authUserId,
        scopes: {},
      );
    });

    test(
      'when calling `deleteApiToken` for one token, then this gets invalid while the other continues to work.',
      () async {
        final apiToken1Id =
            UuidValue.fromByteList(base64Decode(apiToken1.split(':')[1]));
        await ApiTokens.deleteApiToken(
          session,
          id: apiToken1Id,
        );

        final authInfo1 = await ApiTokens.authenticationHandler(
          session,
          apiToken1,
        );

        expect(
          authInfo1,
          isNull,
        );

        final authInfo2 = await ApiTokens.authenticationHandler(
          session,
          apiToken2,
        );

        expect(
          authInfo2,
          isNotNull,
        );
      },
    );

    test(
      'when calling `deleteApiTokensForUser`, then all their API tokens become invalid.',
      () async {
        await ApiTokens.deleteApiTokensForUser(
          session,
          authUserId: authUserId,
        );

        final authInfo1 = await ApiTokens.authenticationHandler(
          session,
          apiToken1,
        );

        expect(
          authInfo1,
          isNull,
        );

        final authInfo2 = await ApiTokens.authenticationHandler(
          session,
          apiToken2,
        );

        expect(
          authInfo2,
          isNull,
        );
      },
    );
  });
}
