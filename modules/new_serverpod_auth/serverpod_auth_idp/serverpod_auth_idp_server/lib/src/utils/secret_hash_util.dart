import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// {@template secret_hash_util}
/// Class for handling secret hashing.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class SecretHashUtil {
  final String _hashPepper;
  final int _hashSaltLength;

  /// Creates a new instance of [SecretHashUtil].
  SecretHashUtil({
    required final String hashPepper,
    required final int hashSaltLength,
  }) : _hashPepper = hashPepper,
       _hashSaltLength = hashSaltLength;

  /// Create the hash for the given [value].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later.
  Future<HashResult> createHash({
    required final String value,
    Uint8List? salt,
  }) {
    salt ??= generateRandomBytes(_hashSaltLength);

    final pepper = utf8.encode(_hashPepper);

    return _createHash(
      secret: value,
      salt: salt,
      pepper: pepper,
    );
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given [value].
  Future<bool> validateHash({
    required final String value,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    if (hash.isEmpty) {
      // Empty hashes are stored in the database when no password has been set.
      // In this case we can just skip the computation below, as it would never
      // match the fixed-length output of `createHash`.
      return false;
    }

    return uint8ListAreEqual(
      hash,
      (await createHash(value: value, salt: salt)).hash,
    );
  }

  Future<HashResult> _createHash({
    required final String secret,
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

      final hashBytes = generator.process(utf8.encode(secret));

      return HashResult._(hash: hashBytes, salt: salt);
    });
  }
}

/// Class containing the result from hashing a value.
///
/// Contains the computed hash and the salt used to compute it.
class HashResult {
  /// The hash of the password.
  final Uint8List hash;

  /// The salt of the password.
  final Uint8List salt;

  /// Creates a new [HashResult].
  HashResult._({
    required this.hash,
    required this.salt,
  });

  /// Creates an empty [HashResult].
  factory HashResult.empty() {
    return HashResult._(
      hash: Uint8List.fromList([]),
      salt: Uint8List.fromList([]),
    );
  }
}
