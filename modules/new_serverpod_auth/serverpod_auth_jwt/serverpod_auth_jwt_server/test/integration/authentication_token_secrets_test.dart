import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:test/test.dart';

void main() {
  const baseConfiguration = {
    AuthenticationTokenSecrets.refreshTokenHashPepperConfigurationKey:
        'some pepper',
  };

// #region HS512

  test(
    'Given no configuration, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(getPassword: (final _) => null),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given just a secret key, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(
          getPassword: (final key) => {
            ...baseConfiguration,
            AuthenticationTokenSecrets.secretKeyConfigurationKey:
                'some secret key',
          }[key],
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given just the HS512 algorithm, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(
          getPassword: (final key) => {
            ...baseConfiguration,
            AuthenticationTokenSecrets.algorithmConfigurationKey: 'HS512',
          }[key],
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given the HS512 algorithm and a secret key, when a `AuthenticationTokenSecrets` instance is created, then it uses HS512 for the given key.',
    () {
      final algorithm = AuthenticationTokenSecrets(
        getPassword: (final key) => {
          ...baseConfiguration,
          AuthenticationTokenSecrets.algorithmConfigurationKey: 'HS512',
          AuthenticationTokenSecrets.secretKeyConfigurationKey:
              'secret-key-for-jwt',
        }[key],
      ).algorithm;

      expect(
        algorithm,
        isA<HmacSha512AuthenticationTokenAlgorithmConfiguration>().having(
          (final a) => a.key.key,
          'key',
          'secret-key-for-jwt',
        ),
      );
    },
  );

  test(
    'Given the HS512 algorithm and a secret key as the fallback algorithm, when a `AuthenticationTokenSecrets` instance is created, then it uses HS512 for the given key as the fallback.',
    () {
      final algorithm = AuthenticationTokenSecrets(
        getPassword: (final key) => {
          ...baseConfiguration,
          AuthenticationTokenSecrets.algorithmConfigurationKey: 'ES512',
          AuthenticationTokenSecrets.privateKeyConfigurationKey:
              _testPrivateKey,
          AuthenticationTokenSecrets.publicKeyConfigurationKey: _testPublicKey,
          AuthenticationTokenSecrets.fallbackAlgorithmConfigurationKey: 'HS512',
          AuthenticationTokenSecrets.fallbackSecretKeyConfigurationKey:
              'secret-key-for-jwt',
        }[key],
      ).fallbackVerificationAlgorithm;

      expect(
        algorithm,
        isA<HmacSha512FallbackAuthenticationTokenAlgorithmConfiguration>()
            .having(
          (final a) => a.key.key,
          'key',
          'secret-key-for-jwt',
        ),
      );
    },
  );

// #endregion

// #region ES512

  test(
    'Given just a private key, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(
          getPassword: (final key) => {
            ...baseConfiguration,
            AuthenticationTokenSecrets.privateKeyConfigurationKey:
                _testPrivateKey
          }[key],
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given just a public key, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(
          getPassword: (final key) => {
            ...baseConfiguration,
            AuthenticationTokenSecrets.publicKeyConfigurationKey: _testPublicKey
          }[key],
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given just the ES512 algorithm, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(
          getPassword: (final key) => {
            ...baseConfiguration,
            AuthenticationTokenSecrets.algorithmConfigurationKey: 'ES512',
          }[key],
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given just the ES512 algorithm and a private key, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(
          getPassword: (final key) => {
            ...baseConfiguration,
            AuthenticationTokenSecrets.algorithmConfigurationKey: 'ES512',
            AuthenticationTokenSecrets.privateKeyConfigurationKey:
                _testPrivateKey
          }[key],
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given just the ES512 algorithm and a public key, when a `AuthenticationTokenSecrets` instance is created, then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenSecrets(
          getPassword: (final key) => {
            ...baseConfiguration,
            AuthenticationTokenSecrets.algorithmConfigurationKey: 'ES512',
            AuthenticationTokenSecrets.publicKeyConfigurationKey: _testPublicKey
          }[key],
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given the ES512 algorithm and both a private and public key, when a `AuthenticationTokenSecrets` instance is created, then it is available as the primary algorithm.',
    () {
      final algorithm = AuthenticationTokenSecrets(
        getPassword: (final key) => {
          ...baseConfiguration,
          AuthenticationTokenSecrets.algorithmConfigurationKey: 'ES512',
          AuthenticationTokenSecrets.privateKeyConfigurationKey:
              _testPrivateKey,
          AuthenticationTokenSecrets.publicKeyConfigurationKey: _testPublicKey
        }[key],
      ).algorithm;

      expect(
        algorithm,
        isA<EcdsaSha512AuthenticationTokenAlgorithmConfiguration>(),
      );
    },
  );

  test(
    'Given the ES512 algorithm and a public key as fallback, when a `AuthenticationTokenSecrets` instance is created, then it is available as the fallback algorithm',
    () {
      final algorithm = AuthenticationTokenSecrets(
        getPassword: (final key) => {
          ...baseConfiguration,
          AuthenticationTokenSecrets.algorithmConfigurationKey: 'HS512',
          AuthenticationTokenSecrets.secretKeyConfigurationKey:
              'secret-key-for-jwt',
          AuthenticationTokenSecrets.fallbackAlgorithmConfigurationKey: 'ES512',
          AuthenticationTokenSecrets.fallbackPublicKeyConfigurationKey:
              _testPublicKey
        }[key],
      ).fallbackVerificationAlgorithm;

      expect(
        algorithm,
        isA<EcdsaSha512FallbackAuthenticationTokenAlgorithmConfiguration>(),
      );
    },
  );

// #endregion
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
