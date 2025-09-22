import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/uint8list_extension.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a session for an existing `AuthUser` without authentication,',
    (final sessionBuilder, final _) {
      late AuthUserModel user;
      late Session session;

      final challengeId = const Uuid().v4obj();

      setUp(() async {
        user = await AuthUsers.create(sessionBuilder.build());

        session = sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                user.id.uuid,
                {},
              ),
            )
            .build();

        await PasskeyChallenge.db.insertRow(
          session,
          PasskeyChallenge(
            id: challengeId,
            challenge: _registrationChallenge,
          ),
        );

        PasskeyAccounts.config = PasskeyAccountConfig(
          hostname: 'localhost',
        );
      });

      test(
          "when calling `PasskeyAccounts.registerPasskey`, then the passkey is registered for the session's user.",
          () async {
        await PasskeyAccounts.registerPasskey(
          session,
          request: PasskeyRegistrationRequest(
            challengeId: challengeId,
            keyId: _keyId,
            clientDataJSON: _registrationClientDataJSON,
            attestationObject: _attestationObject,
          ),
        );

        final passkeyAccount = (await PasskeyAccount.db.find(session)).single;

        expect(passkeyAccount.authUserId, user.id);
      });
    },
  );

  withServerpod(
    'Given an `AuthUser` with a registered passkey,',
    (final sessionBuilder, final _) {
      late AuthUserModel user;
      late Session session;

      final loginChallengeId = const Uuid().v4obj();

      setUp(() async {
        session = sessionBuilder.build();
        user = await AuthUsers.create(session);

        PasskeyAccounts.config = PasskeyAccountConfig(
          hostname: 'localhost',
        );

        {
          final registrationChallengeId = const Uuid().v4obj();
          await PasskeyChallenge.db.insertRow(
            session,
            PasskeyChallenge(
              id: registrationChallengeId,
              challenge: _registrationChallenge,
            ),
          );

          await PasskeyAccounts.registerPasskey(
            sessionBuilder
                .copyWith(
                  authentication: AuthenticationOverride.authenticationInfo(
                    user.id.uuid,
                    {},
                  ),
                )
                .build(),
            request: PasskeyRegistrationRequest(
              challengeId: registrationChallengeId,
              keyId: _keyId,
              clientDataJSON: _registrationClientDataJSON,
              attestationObject: _attestationObject,
            ),
          );
        }

        await PasskeyChallenge.db.insertRow(
          session,
          PasskeyChallenge(
            id: loginChallengeId,
            challenge: _loginChallenge,
          ),
        );
      });

      test(
          "when calling `PasskeyAccounts.authenticate`, then the user's ID is returned.",
          () async {
        final authenticatedUser = await PasskeyAccounts.authenticate(
          session,
          request: PasskeyLoginRequest(
            challengeId: loginChallengeId,
            keyId: _keyId,
            authenticatorData: _loginAuthenticatorData,
            clientDataJSON: _loginClientDataJSON,
            signature: _signature,
          ),
        );

        expect(authenticatedUser, user.id);
      });
    },
  );
}

final _registrationChallenge = base64Decode(
  '28GIVuuCS/5DG0LA1tNr+01+qWzMf8PfyBZNQPttXqY=',
).asByteData;
final _keyId = base64Decode('smRGEPLBiguLVdDctsYGBQ==').asByteData;
final _registrationClientDataJSON = base64Decode(
  'eyJ0eXBlIjoid2ViYXV0aG4uY3JlYXRlIiwiY2hhbGxlbmdlIjoiMjhHSVZ1dUNTXzVERzBMQTF0TnItMDEtcVd6TWY4UGZ5QlpOUVB0dFhxWSIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCIsImNyb3NzT3JpZ2luIjpmYWxzZX0=',
).asByteData;
final _attestationObject = base64Decode(
  'o2NmbXRkbm9uZWdhdHRTdG10oGhhdXRoRGF0YViUSZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2NdAAAAAOqbjWZNAR0hPOS2tIy1ddQAELJkRhDywYoLi1XQ3LbGBgWlAQIDJiABIVggkoCYhdhCvJfNoqD1pscWeiXJQF5G2RSeqDTE85g8nDsiWCD4rRfcgnxffuLLktXBqPm1Yx9X961Z74FLCwZ_oCuFMg==',
).asByteData;
final _loginChallenge = base64Decode(
  'tzDU2jDhlLCF3/hJSEFLZIi3M/xPf06twHtArTYQ5f8=',
).asByteData;
final _loginAuthenticatorData = base64Decode(
  'SZYN5YgOjGh0NBcPZHZgW4_krrmihjLHmVzzuoMdl2MdAAAAAA==',
).asByteData;
final _loginClientDataJSON = base64Decode(
  'eyJ0eXBlIjoid2ViYXV0aG4uZ2V0IiwiY2hhbGxlbmdlIjoidHpEVTJqRGhsTENGM19oSlNFRkxaSWkzTV94UGYwNnR3SHRBclRZUTVmOCIsIm9yaWdpbiI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MCIsImNyb3NzT3JpZ2luIjpmYWxzZSwib3RoZXJfa2V5c19jYW5fYmVfYWRkZWRfaGVyZSI6ImRvIG5vdCBjb21wYXJlIGNsaWVudERhdGFKU09OIGFnYWluc3QgYSB0ZW1wbGF0ZS4gU2VlIGh0dHBzOi8vZ29vLmdsL3lhYlBleCJ9',
).asByteData;
final _signature = base64Decode(
  'MEUCIQDtgwZM-M-ilKkHwfOouoVb2pMuKwhzpmXFqT2yE6BEEAIgOl_OFgvmSf2fSfVe4NhgG6J2yWSp9eb1MvNt2xcU-CY=',
).asByteData;
