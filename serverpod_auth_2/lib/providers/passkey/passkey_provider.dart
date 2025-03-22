import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';

class PasskeyProvider {
  PasskeyProvider({
    required this.serverpod,
  });

  final Serverpod serverpod;

  // ignore: unused_field
  final String _privateKey = 'asdf1234';

  // ignore: unused_field
  final String _publicKey = 'qwerty5678';

  final userKeysByCredentialId = <String, String>{};
  final userIdsByCredentialId = <String, int>{};

  static const providerName = 'passkey';

  String provideChallenge() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  ActiveUserSession solveChallenge({
    // This is only passed on the first "registration"
    required String? clientPublicKey,
    required String signedChallenge,
    required String credentialId,
    // TODO "username"?
  }) {
    if (clientPublicKey == null) {
      clientPublicKey = userKeysByCredentialId[credentialId]!;
    } else {
      if (userKeysByCredentialId.containsKey(credentialId)) {
        throw Exception('credetial id already in use');
      }

      userKeysByCredentialId[credentialId] = clientPublicKey;
    }

    if (!_ensureIsSigned(signedChallenge, clientPublicKey)) {
      throw Exception('not properly signed');
    }

    final userId = userIdsByCredentialId[credentialId];
    if (userId == null) {
      final newUser = serverpod.userInfoRepository.createUser();

      userIdsByCredentialId[credentialId] = newUser.id!;

      return serverpod.userSessionRepository.createSession(
        newUser.id!,
        authProvider: providerName,
      );
    } else {
      return serverpod.userSessionRepository.createSession(
        userId,
        authProvider: providerName,
      );
    }
  }

  bool _ensureIsSigned(String _, String __) {
    // TODO: Check that the signature is correct,
    // and that the challenge is actually from our server
    return true;
  }

  // TODO: Ability to set up an additional passkey for logged-in user
}
