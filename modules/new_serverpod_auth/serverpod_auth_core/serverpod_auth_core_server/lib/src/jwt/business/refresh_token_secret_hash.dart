import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:serverpod_auth_core_server/common.dart';

/// Class for hashing and verifying a refresh token's rotating secret.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
final class RefreshTokenSecretHash {
  final Argon2HashUtil _hashUtil;

  /// Creates a new instance of [RefreshTokenSecretHash].
  RefreshTokenSecretHash({
    required final int refreshTokenRotatingSecretSaltLength,
    required final String refreshTokenHashPepper,
    required final List<String> fallbackRefreshTokenHashPeppers,
  }) : _hashUtil = Argon2HashUtil(
          hashPepper: refreshTokenHashPepper,
          fallbackHashPeppers: fallbackRefreshTokenHashPeppers,
          hashSaltLength: refreshTokenRotatingSecretSaltLength,
        );

  /// Create the hash for the given refresh token secret.
  Future<({Uint8List hash, Uint8List salt})> createHash({
    required final Uint8List secret,
    @protected Uint8List? salt,
  }) {
    return _hashUtil.createHashFromBytes(secret: secret, salt: salt);
  }

  /// Verify whether the [secret] can be used to compute the given [hash] with the [salt] applied.
  Future<bool> validateHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    return _hashUtil.validateHashFromBytes(
      secret: secret,
      hash: hash,
      salt: salt,
    );
  }
}
