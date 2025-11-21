import 'dart:typed_data';

import 'package:serverpod_auth_core_server/util.dart';

export 'package:serverpod_auth_core_server/util.dart' show HashResult;

/// {@template secret_hash_util}
/// Class for handling secret hashing.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class SecretHashUtil {
  final Argon2idHashUtil _hashUtil;

  /// Creates a new instance of [SecretHashUtil].
  SecretHashUtil({
    required final String hashPepper,
    required final int hashSaltLength,
  }) : _hashUtil = Argon2idHashUtil(
         hashPepper: hashPepper,
         hashSaltLength: hashSaltLength,
       );

  /// Create the hash for the given [value].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later.
  Future<HashResult> createHash({
    required final String value,
    final Uint8List? salt,
  }) {
    return _hashUtil.createHashFromString(value: value, salt: salt);
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given [value].
  Future<bool> validateHash({
    required final String value,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    return _hashUtil.validateHashFromString(
      value: value,
      hash: hash,
      salt: salt,
    );
  }
}
