import 'dart:typed_data';

import 'package:passkeys_server/passkeys_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:test/test.dart';

import '../test_tags.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given PasskeyIdpUtils',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      late PasskeyIdpUtils utils;

      setUp(() {
        utils = PasskeyIdpUtils(
          challengeLifetime: const Duration(minutes: 5),
          passkeys: Passkeys(
            config: PasskeysConfig(relyingPartyId: 'id'),
          ),
        );
      });

      test(
        'when calling getAccount with unauthenticated session then it returns null',
        () async {
          final session = sessionBuilder.build();
          final account = await utils.getAccount(session);
          expect(account, isNull);
        },
      );

      test(
        'when calling getAccount with authenticated session but no passkey account then it returns null',
        () async {
          final session = sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  const Uuid().v4obj().toString(),
                  {},
                ),
              )
              .build();

          final account = await utils.getAccount(session);
          expect(account, isNull);
        },
      );

      test(
        'when calling getAccount with authenticated session and existing passkey account then it returns the account',
        () async {
          final setupSession = sessionBuilder.build();
          final authUser = await const AuthUsers().create(setupSession);
          final passkeyAccount = await PasskeyAccount.db.insertRow(
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

          final session = sessionBuilder
              .copyWith(
                authentication: AuthenticationOverride.authenticationInfo(
                  authUser.id.toString(),
                  {},
                ),
              )
              .build();

          final account = await utils.getAccount(session);
          expect(account, isNotNull);
          expect(account?.id, passkeyAccount.id);
          expect(account?.authUserId, authUser.id);
        },
      );
    },
  );
}
