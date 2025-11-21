import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../common/util/argon2id_hash_util.dart';

/// Class for hashing and verifying a refresh token's rotating secret.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
final class RefreshTokenSecretHash {
  final Argon2idHashUtil _hashUtil;

  /// Creates a new instance of [RefreshTokenSecretHash].
  RefreshTokenSecretHash({
    required final int refreshTokenRotatingSecretSaltLength,
    required final String refreshTokenHashPepper,
  }) : _hashUtil = Argon2idHashUtil(
         hashPepper: refreshTokenHashPepper,
         hashSaltLength: refreshTokenRotatingSecretSaltLength,
       );

  /// Create the hash for the given refresh token secret.
  Future<({Uint8List hash, Uint8List salt})> createHash({
    required final Uint8List secret,
    @protected final Uint8List? salt,
  }) async {
    final result = await _hashUtil.createHashFromBytes(
      secret: secret,
      salt: salt,
    );
    return (hash: result.hash, salt: result.salt);
  }

  /// Verify whether the [secret] can be used to compute the given [hash] with the [salt] applied.
  Future<bool> validateHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    return _hashUtil.validateHashFromBytes(
      secret: secret,
      hash: hash,
      salt: salt,
    );
  }
}
