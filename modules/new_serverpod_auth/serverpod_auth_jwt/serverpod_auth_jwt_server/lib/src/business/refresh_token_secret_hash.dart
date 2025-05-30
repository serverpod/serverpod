import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_auth_jwt_server/src/util/equal_uint8list.dart';
import 'package:serverpod_auth_jwt_server/src/util/random_bytes.dart';

/// Class for hashing and verifying refresh token's rotating secret.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
@internal
abstract final class RefreshTokenSecretHash {
  /// Create the hash for the given refresh token secret.
  static ({Uint8List hash, Uint8List salt}) createHash({
    required final Uint8List secret,
    @protected Uint8List? salt,
  }) {
    salt ??= generateRandomBytes(
      AuthenticationTokens.config.refreshTokenRotatingSecretSaltLength,
    );
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      salt,
      desiredKeyLength: 256,
      secret: utf8.encode(AuthenticationTokenSecrets.refreshTokenHashPepper),
    );

    final generator = Argon2BytesGenerator()..init(parameters);

    final hashBytes = generator.process(secret);

    return (hash: hashBytes, salt: salt);
  }

  /// Verify whether the [secret] can be used to compute the given [hash] with the [salt] applied.
  static bool validateHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    return uint8ListAreEqual(hash, createHash(secret: secret, salt: salt).hash);
  }
}
