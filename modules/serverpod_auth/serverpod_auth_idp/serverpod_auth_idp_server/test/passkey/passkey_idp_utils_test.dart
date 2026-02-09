import 'dart:typed_data';

import 'package:passkeys_server/passkeys_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  late PasskeyIdpUtils utils;
  late Session session;

  withServerpod(
    'Given an unauthenticated session',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      setUp(() {
        utils = _createUtils();
        session = sessionBuilder.build();
      });

      test(
        'when calling getAccount then it returns null',
        () async {
          final account = await utils.getAccount(session);
          expect(account, isNull);
        },
      );
    },
  );

  withServerpod('Given an authenticated session but no passkey account', (
    final sessionBuilder,
    final endpoints,
  ) {
    setUp(() {
      utils = _createUtils();
      session = sessionBuilder
          .copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              const Uuid().v4obj().toString(),
              {},
            ),
          )
          .build();
    });

    test(
      'when calling getAccount then it returns null',
      () async {
        final account = await utils.getAccount(session);
        expect(account, isNull);
      },
    );
  });

  withServerpod('Given an authenticated session with a passkey account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late PasskeyAccount passkeyAccount;
    late AuthUserModel authUser;

    setUp(() async {
      utils = _createUtils();

      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      passkeyAccount = await PasskeyAccount.db.insertRow(
        setupSession,
        PasskeyAccount(
          authUserId: authUser.id,
          keyId: ByteData(0),
          keyIdBase64: 'base64-${const Uuid().v4()}',
          clientDataJSON: ByteData(0),
          attestationObject: ByteData(0),
          originalChallenge: ByteData(0),
        ),
      );
      session = sessionBuilder
          .copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUser.id.toString(),
              {},
            ),
          )
          .build();
    });

    test(
      'when calling getAccount then it returns the account',
      () async {
        final account = await utils.getAccount(session);
        expect(account, isNotNull);
        expect(account?.id, passkeyAccount.id);
        expect(account?.authUserId, authUser.id);
      },
    );
  });
}

PasskeyIdpUtils _createUtils() {
  return PasskeyIdpUtils(
    challengeLifetime: const Duration(minutes: 5),
    passkeys: Passkeys(
      config: PasskeysConfig(relyingPartyId: 'id'),
    ),
  );
}
