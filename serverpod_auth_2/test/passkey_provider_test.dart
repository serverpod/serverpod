import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/providers/passkey/passkey_provider.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';

void main() {
  test('Register via passkey; then log in again', () {
    final serverpod = Serverpod();

    final passkeyProvider = PasskeyProvider(
      serverpod: serverpod,
    );

    // register
    final challenge = passkeyProvider.provideChallenge();

    final session = passkeyProvider.solveChallenge(
      clientPublicKey: 'client_pub_key',
      signedChallenge: challenge,
      credentialId: 'client_credential_0001',
    );

    expect(session, isA<ActiveUserSession>());
    expect(serverpod.userInfoRepository.users, hasLength(1));
    expect(serverpod.userSessionRepository.activeSessions, hasLength(1));

    // login
    final loginChallenge = passkeyProvider.provideChallenge();

    final loginSession = passkeyProvider.solveChallenge(
      clientPublicKey: null, // server verifies against stored key
      signedChallenge: loginChallenge,
      credentialId: 'client_credential_0001',
    );

    expect(loginSession, isA<ActiveUserSession>());
    expect(serverpod.userInfoRepository.users, hasLength(1));
    expect(serverpod.userSessionRepository.activeSessions, hasLength(2));
  });
}
