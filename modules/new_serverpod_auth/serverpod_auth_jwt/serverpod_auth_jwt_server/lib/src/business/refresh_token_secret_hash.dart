import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Class for hashing and verifying a refresh token's rotating secret.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
@internal
final class RefreshTokenSecretHash {
  RefreshTokenSecretHash({
    required final AuthenticationTokenSecrets secrets,
  }) : _secrets = secrets;

  final AuthenticationTokenSecrets _secrets;

  /// Create the hash for the given refresh token secret.
  Future<({Uint8List hash, Uint8List salt})> createHash({
    required final Uint8List secret,
    @protected Uint8List? salt,
  }) {
    salt ??= generateRandomBytes(
      AuthenticationTokens.config.refreshTokenRotatingSecretSaltLength,
    );

    final pepper = utf8.encode(_secrets.refreshTokenHashPepper);

    return _createHash(secret: secret, salt: salt, pepper: pepper);
  }

  Future<({Uint8List hash, Uint8List salt})> _createHash({
    required final Uint8List secret,
    required final Uint8List salt,
    required final Uint8List pepper,
  }) {
    return Isolate.run(() {
      final parameters = Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        salt,
        desiredKeyLength: 256,
        secret: pepper,
      );

      final generator = Argon2BytesGenerator()..init(parameters);

      final hashBytes = generator.process(secret);

      return (hash: hashBytes, salt: salt);
    });
  }

  /// Verify whether the [secret] can be used to compute the given [hash] with the [salt] applied.
  Future<bool> validateHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    return uint8ListAreEqual(
      hash,
      (await createHash(secret: secret, salt: salt)).hash,
    );
  }
}
