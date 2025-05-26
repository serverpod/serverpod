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
      'when the current `algorithm` is read, then it uses HS512.',
      () {
        final algorithm = AuthenticationTokenSecrets.algorithm;

        expect(algorithm, isA<HmacSha512AuthenticationTokenAlgorithm>());
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

  withServerpod('Given just a private key when using ES512,',
      (final sessionBuilder, final endpoints) {
    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'private key value';
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmES512;
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

  withServerpod('Given just both a private and public key for ES512,',
      (final sessionBuilder, final endpoints) {
    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'private key value';
      AuthenticationTokenSecrets.publicKeyTestOverride = 'public key value';
      AuthenticationTokenSecrets.algorithmTestOverride =
          AuthenticationTokenSecrets.algorithmES512;
    });

    test(
      'when the current `algorithm` is read, then a configuration for asymmetric crypto is returned.',
      () {
        final algorithm = AuthenticationTokenSecrets.algorithm;

        expect(
          algorithm,
          isA<EcdsaSha512AuthenticationTokenAlgorithm>()
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
