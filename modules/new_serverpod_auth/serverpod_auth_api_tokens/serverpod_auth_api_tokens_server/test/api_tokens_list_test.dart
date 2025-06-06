import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_api_tokens_server/serverpod_auth_api_tokens_server.dart';
import 'package:test/test.dart';

import 'integration/test_tools/serverpod_test_tools.dart';
import 'test_utils.dart';

void main() {
  withServerpod('Given an API token for a user,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      authUserId = await createAuthUser(session);

      await ApiTokens.createApiToken(
        session,
        authUserId: authUserId,
        scopes: {},
        kind: 'test',
      );
    });

    test(
      'when calling `apiTokens`, then it is returned.',
      () async {
        final apiTokens = await ApiTokens.listTokens(session);

        expect(
          apiTokens,
          hasLength(1),
        );
      },
    );

    test(
      'when calling `apiTokens` for the user, then it is returned.',
      () async {
        final apiTokens = await ApiTokens.listTokens(
          session,
          authUserId: authUserId,
        );

        expect(
          apiTokens,
          hasLength(1),
        );
      },
    );

    test(
      'when calling `apiTokens` for another user, then nothing is returned.',
      () async {
        final apiTokens = await ApiTokens.listTokens(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(apiTokens, isEmpty);
      },
    );

    test(
      'when calling `apiTokens` for its `kind`, then it is returned.',
      () async {
        final apiTokens = await ApiTokens.listTokens(session, kind: 'test');

        expect(
          apiTokens,
          hasLength(1),
        );
      },
    );

    test(
      'when calling `apiTokens` for another `kind`, then nothing is returned.',
      () async {
        final apiTokens = await ApiTokens.listTokens(
          session,
          kind: 'something else',
        );

        expect(apiTokens, isEmpty);
      },
    );

    test(
      'when calling `apiTokens` for the user with its `kind`, then it is returned.',
      () async {
        final apiTokens = await ApiTokens.listTokens(
          session,
          authUserId: authUserId,
          kind: 'test',
        );

        expect(
          apiTokens,
          hasLength(1),
        );
      },
    );

    test(
      'when calling `apiTokens` for the user with another kind `kind`, then nothing is returned.',
      () async {
        final apiTokens = await ApiTokens.listTokens(
          session,
          authUserId: authUserId,
          kind: 'some other kind',
        );

        expect(apiTokens, isEmpty);
      },
    );
  });
}
