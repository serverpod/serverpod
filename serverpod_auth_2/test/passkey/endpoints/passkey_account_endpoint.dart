import 'package:serverpod_auth_2/providers/passkey/passkey_provider.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';

class PasskeyAccountEndpoint {
  PasskeyAccountEndpoint({
    required this.sessionRepository,
    required this.userInfoRepository,
    required this.passkeyAuthenticationRepository,
  });

  final SessionRepository sessionRepository;

  final UserInfoRepository userInfoRepository;

  final PasskeyAuthenticationRepository passkeyAuthenticationRepository;

  /// Returns the challenge to sign
  String provideChallenge() {
    return passkeyAuthenticationRepository.provideChallenge();
  }

  /// Creates a new user for the new passkey
  ///
  /// Returns a session key
  String register({
    // TODO: Challenge probably needs to roundtrip here and in login, so we can verify it, right?
    required String clientPublicKey,
    required String signedChallenge,
    required String credentialId,
  }) {
    passkeyAuthenticationRepository.storeKeyIfValid(
      clientPublicKey: clientPublicKey,
      signedChallenge: signedChallenge,
      credentialId: credentialId,
    );

    final user = userInfoRepository.createUser(null, null);

    passkeyAuthenticationRepository.linkCredential(credentialId, user.id!);

    return sessionRepository.createSession(
      user.id!,
      authProvider: 'passkey',
      additionalData: null,
    );
  }

  String login({
    required String signedChallenge,
    required String credentialId,
  }) {
    final userId = passkeyAuthenticationRepository.verifyCredential(
      signedChallenge: signedChallenge,
      credentialId: credentialId,
    );

    return sessionRepository.createSession(
      userId,
      authProvider: 'passkey',
      additionalData: null,
    );
  }
}
