import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given no configuration,',
      (final sessionBuilder, final endpoints) {
    test(
      'when the current `algorithm` is read, then an error is thrown.',
      () {
        expect(
          () => AuthenticationTokenSecrets.algorithm,
          throwsArgumentError,
        );
      },
    );
  });

  withServerpod('Given just a private key,',
      (final sessionBuilder, final endpoints) {
    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'secret-key-for-jwt';
    });

    test(
      'when the current `algorithm` is read, then it uses HS512 for the given key.',
      () {
        final algorithm = AuthenticationTokenSecrets.algorithm;

        expect(
          algorithm,
          isA<HmacSha512AuthenticationTokenAlgorithmConfiguration>()
              .having((final a) => a.key, 'key', 'secret-key-for-jwt'),
        );
      },
    );
  });

  withServerpod('Given just a private key and an invalid algorithm config,',
      (final sessionBuilder, final endpoints) {
    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'secret-key-for-jwt';
      AuthenticationTokenSecrets.algorithmTestOverride = '🤷🏻‍♂️';
    });

    test(
      'when the current `algorithm` is read, then an error is thrown.',
      () {
        expect(
          () => AuthenticationTokenSecrets.algorithm,
          throwsArgumentError,
        );
      },
    );
  });

  withServerpod('Given a private key and the algorithm set to HS512,',
      (final sessionBuilder, final endpoints) {
    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'secret-key-for-jwt';
      AuthenticationTokenSecrets.algorithmTestOverride = 'HS512';
    });

    test(
      'when the current `algorithm` is read, then it uses HS512 for the given key.',
      () {
        final algorithm = AuthenticationTokenSecrets.algorithm;

        expect(
          algorithm,
          isA<HmacSha512AuthenticationTokenAlgorithmConfiguration>()
              .having((final a) => a.key, 'key', 'secret-key-for-jwt'),
        );
      },
    );
  });

  withServerpod('Given just a private key when using ES512,',
      (final sessionBuilder, final endpoints) {
    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'private key value';
      AuthenticationTokenSecrets.algorithmTestOverride = 'ES512';
    });

    test(
      'when the current `algorithm` is read, then an error is thrown.',
      () {
        expect(
          () => AuthenticationTokenSecrets.algorithm,
          throwsArgumentError,
        );
      },
    );
  });

  withServerpod('Given both a private and public key for ES512,',
      (final sessionBuilder, final endpoints) {
    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'private key value';
      AuthenticationTokenSecrets.publicKeyTestOverride = 'public key value';
      AuthenticationTokenSecrets.algorithmTestOverride = 'ES512';
    });

    test(
      'when the current `algorithm` is read, then a configuration for asymmetric crypto is returned.',
      () {
        final algorithm = AuthenticationTokenSecrets.algorithm;

        expect(
          algorithm,
          isA<EcdsaSha512AuthenticationTokenAlgorithmConfiguration>()
              .having(
                (final a) => a.privateKey,
                'privateKey',
                'private key value',
              )
              .having(
                (final a) => a.publicKey,
                'publicKey',
                'public key value',
              ),
        );
      },
    );
  });
}
