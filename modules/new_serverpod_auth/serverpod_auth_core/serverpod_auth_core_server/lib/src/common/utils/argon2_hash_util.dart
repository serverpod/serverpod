import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// {@template argon2_hash_util}
/// A consolidated utility for handling Argon2id-based secret hashing.
///
/// This class provides a unified interface for hashing secrets using the
/// Argon2id algorithm, supporting both String and Uint8List inputs.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class Argon2HashUtil {
  final String _hashPepper;
  final List<String> _fallbackHashPeppers;
  final int _hashSaltLength;
  final int _memory;
  final int _lanes;
  final int _desiredKeyLength;

  /// Creates a new instance of [Argon2HashUtil].
  ///
  /// [hashPepper] is the primary pepper to use for hashing.
  /// [fallbackHashPeppers] is an optional list of peppers to try when validating.
  /// [hashSaltLength] is the length of the salt to generate (in bytes).
  /// [memory] is the memory cost parameter in KiB (default: 4096 = 4MiB).
  /// [lanes] is the degree of parallelism (default: number of processors).
  /// [desiredKeyLength] is the output hash length in bytes (default: 32 = 256 bits).
  Argon2HashUtil({
    required final String hashPepper,
    final List<String> fallbackHashPeppers = const [],
    required final int hashSaltLength,
    final int memory = 1 << 12,
    final int? lanes,
    final int desiredKeyLength = 32,
  }) : _hashPepper = hashPepper,
       _fallbackHashPeppers = fallbackHashPeppers,
       _hashSaltLength = hashSaltLength,
       _memory = memory,
       _lanes = lanes ?? Platform.numberOfProcessors,
       _desiredKeyLength = desiredKeyLength;

  /// Create the hash for the given [secret] (String).
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later. If [salt] is provided, it will be used instead of generating a
  /// random one.
  ///
  /// Returns a [HashResult] containing the hash and salt.
  Future<HashResult> createHashFromString({
    required final String secret,
    @protected Uint8List? salt,
  }) {
    salt ??= generateRandomBytes(_hashSaltLength);
    final pepper = utf8.encode(_hashPepper);
    final secretBytes = utf8.encode(secret);

    return _createHash(
      secret: secretBytes,
      salt: salt,
      pepper: pepper,
    );
  }

  /// Create the hash for the given [secret] (Uint8List).
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later. If [salt] is provided, it will be used instead of generating a
  /// random one.
  ///
  /// Returns a record containing the hash and salt.
  Future<({Uint8List hash, Uint8List salt})> createHashFromBytes({
    required final Uint8List secret,
    @protected Uint8List? salt,
  }) async {
    salt ??= generateRandomBytes(_hashSaltLength);
    final pepper = utf8.encode(_hashPepper);

    final result = await _createHash(
      secret: secret,
      salt: salt,
      pepper: pepper,
    );

    return (hash: result.hash, salt: result.salt);
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given [secret] (String).
  ///
  /// Tries the primary pepper first, then falls back to the fallback peppers
  /// if provided.
  Future<bool> validateHashFromString({
    required final String secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    if (hash.isEmpty) {
      // Empty hashes are stored in the database when no password has been set.
      // In this case we can just skip the computation below, as it would never
      // match the fixed-length output of `createHash`.
      return false;
    }

    final secretBytes = utf8.encode(secret);
    return _validateHash(
      secret: secretBytes,
      hash: hash,
      salt: salt,
    );
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given [secret] (Uint8List).
  ///
  /// Tries the primary pepper first, then falls back to the fallback peppers
  /// if provided.
  Future<bool> validateHashFromBytes({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    if (hash.isEmpty) {
      return false;
    }

    return _validateHash(
      secret: secret,
      hash: hash,
      salt: salt,
    );
  }

  Future<bool> _validateHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) async {
    // Combine primary and fallback peppers into a single list
    final allPeppers = [_hashPepper, ..._fallbackHashPeppers];

    // Try each pepper in order
    for (final pepper in allPeppers) {
      final computedHash = (await _createHash(
        secret: secret,
        salt: salt,
        pepper: utf8.encode(pepper),
      )).hash;
      if (uint8ListAreEqual(hash, computedHash)) {
        return true;
      }
    }

    return false;
  }

  Future<HashResult> _createHash({
    required final Uint8List secret,
    required final Uint8List salt,
    required final Uint8List pepper,
  }) {
    // Capture instance variables for use in isolate
    final memory = _memory;
    final lanes = _lanes;
    final desiredKeyLength = _desiredKeyLength;

    return Isolate.run(() {
      final parameters = Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        salt,
        desiredKeyLength: desiredKeyLength,
        lanes: lanes,
        memory: memory,
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
  /// The hash of the secret.
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
