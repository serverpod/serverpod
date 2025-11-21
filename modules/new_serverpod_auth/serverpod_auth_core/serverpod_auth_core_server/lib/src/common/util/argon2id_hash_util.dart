import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// {@template argon2id_hash_util}
/// Consolidated utility for Argon2id-based hashing operations.
///
/// This utility provides a flexible API for hashing secrets using the Argon2id
/// algorithm, supporting both String and Uint8List inputs.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class Argon2idHashUtil {
  final String _hashPepper;
  final int _hashSaltLength;

  /// Creates a new instance of [Argon2idHashUtil].
  ///
  /// The [hashPepper] is used as a secret parameter in the Argon2id algorithm.
  /// The [hashSaltLength] determines the length of randomly generated salts.
  Argon2idHashUtil({
    required final String hashPepper,
    required final int hashSaltLength,
  }) : _hashPepper = hashPepper,
       _hashSaltLength = hashSaltLength;

  /// Create a hash for the given String [value].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later. If [salt] is provided, it will be used instead of generating a
  /// random salt.
  Future<HashResult> createHashFromString({
    required final String value,
    final Uint8List? salt,
  }) {
    final actualSalt = salt ?? generateRandomBytes(_hashSaltLength);

    final pepper = utf8.encode(_hashPepper);
    final secret = utf8.encode(value);

    return _createHash(
      secret: secret,
      salt: actualSalt,
      pepper: pepper,
    );
  }

  /// Create a hash for the given Uint8List [secret].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later. If [salt] is provided, it will be used instead of generating a
  /// random salt.
  Future<HashResult> createHashFromBytes({
    required final Uint8List secret,
    final Uint8List? salt,
  }) {
    final actualSalt = salt ?? generateRandomBytes(_hashSaltLength);

    final pepper = utf8.encode(_hashPepper);

    return _createHash(
      secret: secret,
      salt: actualSalt,
      pepper: pepper,
    );
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given String [value].
  Future<bool> validateHashFromString({
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
      (await createHashFromString(value: value, salt: salt)).hash,
    );
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given Uint8List [secret].
  Future<bool> validateHashFromBytes({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    if (hash.isEmpty) {
      return false;
    }

    return uint8ListAreEqual(
      hash,
      (await createHashFromBytes(secret: secret, salt: salt)).hash,
    );
  }

  Future<HashResult> _createHash({
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

      return HashResult._(hash: hashBytes, salt: salt);
    });
  }
}

/// Class containing the result from hashing a value.
///
/// Contains the computed hash and the salt used to compute it.
class HashResult {
  /// The hash of the value.
  final Uint8List hash;

  /// The salt used to compute the hash.
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
