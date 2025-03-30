import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/passkey/passkey_authentication_repository.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';

import 'endpoints/passkey_account_endpoint.dart';

void main() {
  test('Register via passkey; then log in again', () {
    final serverpod = Serverpod();

    final passkeyAccountEndpoint = PasskeyAccountEndpoint(
      sessionRepository: serverpod.userSessionRepository,
      userInfoRepository: serverpod.userInfoRepository,
      passkeyAuthenticationRepository: PasskeyAuthenticationRepository(),
    );

    // register
    {
      final challenge = passkeyAccountEndpoint.provideChallenge();

      final sessionKey = passkeyAccountEndpoint.register(
        clientPublicKey: 'client_pub_key',
        signedChallenge: challenge,
        credentialId: 'client_credential_0001',
      );

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
      expect(serverpod.userInfoRepository.users, hasLength(1));
    }

    // login
    {
      final loginChallenge = passkeyAccountEndpoint.provideChallenge();

      final sessionKey = passkeyAccountEndpoint.login(
        signedChallenge: loginChallenge,
        credentialId: 'client_credential_0001',
      );

      expect(
        serverpod.userSessionRepository.resolveSessionToUserId(sessionKey),
        isNotNull,
      );
      expect(serverpod.userInfoRepository.users, hasLength(1));
    }
  });
}
