class PasskeyAuthenticationRepository {
  // In this version it would not need to depend on either the user or session info
  // (At least not directly, as it would never create the user, leaving that to the caller,
  // but in the database each active credential would be linked to a user.)
  PasskeyAuthenticationRepository();

  // final Serverpod serverpod;

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

  /// Stores the credential in the database if the challenge was successful (and the credential ID not used already), else throws
  void storeKeyIfValid({
    required String clientPublicKey,
    required String signedChallenge,
    required String credentialId,
  }) {
    if (userKeysByCredentialId.containsKey(credentialId)) {
      throw Exception('credential id already in use');
    }

    if (!_ensureIsSigned(signedChallenge, clientPublicKey)) {
      throw Exception('not properly signed');
    }

    userKeysByCredentialId[credentialId] = clientPublicKey;
  }

  void linkCredential(String credentialId, int userId) {
    if (userIdsByCredentialId.containsKey(credentialId)) {
      throw 'already linked';
    }

    userIdsByCredentialId[credentialId] = userId;
  }

  // Checks the signed challenge, returns the user ID linked to the credential ID
  int verifyCredential(
      {required String signedChallenge, required String credentialId}) {
    final clientPublicKey = userKeysByCredentialId[credentialId]!;
    if (!_ensureIsSigned(signedChallenge, clientPublicKey)) {
      throw Exception('not properly signed');
    }

    return userIdsByCredentialId[credentialId]!;
  }

  bool _ensureIsSigned(String _, String __) {
    // TODO: Check that the signature is correct,
    // and that the challenge is actually from our server
    return true;
  }
}
