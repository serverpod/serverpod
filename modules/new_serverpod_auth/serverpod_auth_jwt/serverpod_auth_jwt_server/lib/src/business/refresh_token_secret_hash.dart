import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Class for hashing and verifying refresh token secrets.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
@internal
abstract final class RefreshTokenSecretHash {
  /// Create the hash for the given refresh token secret.
  static ({String hash, String salt}) createHash({
    required final String secret,
    @protected String? salt,
  }) {
    salt ??= generateRandomString(16);
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      utf8.encode(salt),
      desiredKeyLength: 256,
      secret: utf8.encode(AuthenticationTokenSecrets.tokenHashPepper),
    );

    final generator = Argon2BytesGenerator()..init(parameters);

    final hashBytes = generator.process(utf8.encode(secret));

    final hash = const Base64Encoder().convert(hashBytes);

    return (hash: hash, salt: salt);
  }

  /// Verify whether the [secret] can be used to compute the given [hash] with the [salt] applied.
  static bool validateHash({
    required final String secret,
    required final String hash,
    required final String salt,
  }) {
    return hash == createHash(secret: secret, salt: salt).hash;
  }
}
