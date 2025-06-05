import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';

class AuthenticationTokenSecretsMock implements AuthenticationTokenSecrets {
  @override
  late AuthenticationTokenAlgorithmConfiguration algorithm;

  @override
  FallbackAuthenticationTokenAlgorithmConfiguration?
      fallbackVerificationAlgorithm;

  @override
  late String refreshTokenHashPepper;

  void setHs512Algorithm({final String? secretKeyOverride}) {
    algorithm = HmacSha512AuthenticationTokenAlgorithmConfiguration(
      key: SecretKey(secretKeyOverride ?? 'test-private-key-for-HS512'),
    );
  }

  void setEs512Algorithm() {
    algorithm = EcdsaSha512AuthenticationTokenAlgorithmConfiguration(
      privateKey: ECPrivateKey(_testPrivateKey),
      publicKey: ECPublicKey(_testPublicKey),
    );
  }
}

const _testPrivateKey = '''-----BEGIN EC PRIVATE KEY-----
MHQCAQEEINCRiJnNDnzfo2So2tWY4AIuzeC2ZBp/hmMDcZz3Fh45oAcGBSuBBAAK
oUQDQgAE0aELkvG/Xeo5y6o0WXRAjlediLptGz7Q8zjDmpGFXkKBYZ6IiL7JJ2Tk
cHzd83bmeUeGX33RGTYFPXs5t/VBnw==
-----END EC PRIVATE KEY-----''';

const _testPublicKey = '''-----BEGIN PUBLIC KEY-----
MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAE0aELkvG/Xeo5y6o0WXRAjlediLptGz7Q
8zjDmpGFXkKBYZ6IiL7JJ2TkcHzd83bmeUeGX33RGTYFPXs5t/VBnw==
-----END PUBLIC KEY-----''';
