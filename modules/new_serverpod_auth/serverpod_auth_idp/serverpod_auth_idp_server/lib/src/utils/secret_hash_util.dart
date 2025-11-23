import 'dart:typed_data';

import 'package:serverpod_auth_core_server/common.dart';

export 'package:serverpod_auth_core_server/common.dart' show HashResult;

/// {@template secret_hash_util}
/// Class for handling secret hashing.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class SecretHashUtil {
  final Argon2HashUtil _hashUtil;

  /// Creates a new instance of [SecretHashUtil].
  SecretHashUtil({
    required final String hashPepper,
    final List<String> fallbackHashPeppers = const [],
    required final int hashSaltLength,
  }) : _hashUtil = Argon2HashUtil(
          hashPepper: hashPepper,
          fallbackHashPeppers: fallbackHashPeppers,
          hashSaltLength: hashSaltLength,
        );

  /// Create the hash for the given [value].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later.
  Future<HashResult> createHash({
    required final String value,
    Uint8List? salt,
  }) {
    return _hashUtil.createHashFromString(secret: value, salt: salt);
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given [value].
  Future<bool> validateHash({
    required final String value,
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    return _hashUtil.validateHashFromString(
      secret: value,
      hash: hash,
      salt: salt,
    );
  }
}
