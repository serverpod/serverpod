import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Callback type for rehashing a value when fallback pepper validates.
///
/// This is called when a hash is validated successfully using the fallback
/// pepper, allowing the value to be rehashed with the primary pepper.
typedef RehashCallback = Future<void> Function(HashResult newHash);

/// {@template secret_hash_util}
/// Class for handling secret hashing.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class SecretHashUtil {
  final String _hashPepper;
  final String? _fallbackHashPepper;
  final int _hashSaltLength;

  /// Creates a new instance of [SecretHashUtil].
  SecretHashUtil({
    required final String hashPepper,
    final String? fallbackHashPepper,
    required final int hashSaltLength,
  }) : _hashPepper = hashPepper,
       _fallbackHashPepper = fallbackHashPepper,
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
  ///
  /// If validation with the primary pepper fails and a fallback pepper is
  /// configured, the validation will be retried with the fallback pepper.
  ///
  /// If the [onFallbackValidated] callback is provided and the hash is
  /// validated using the fallback pepper, the callback will be invoked with
  /// a new hash created using the primary pepper. This allows automatic
  /// migration from the old pepper to the new one.
  Future<bool> validateHash({
    required final String value,
    required final Uint8List hash,
    required final Uint8List salt,
    final RehashCallback? onFallbackValidated,
  }) async {
    if (hash.isEmpty) {
      // Empty hashes are stored in the database when no password has been set.
      // In this case we can just skip the computation below, as it would never
      // match the fixed-length output of `createHash`.
      return false;
    }

    // Try primary pepper first
    final primaryHash = (await createHash(value: value, salt: salt)).hash;
    if (uint8ListAreEqual(hash, primaryHash)) {
      return true;
    }

    // If primary fails and fallback exists, try fallback
    if (_fallbackHashPepper != null) {
      final fallbackPepper = utf8.encode(_fallbackHashPepper!);
      final fallbackHash = await _createHash(
        secret: value,
        salt: salt,
        pepper: fallbackPepper,
      );

      if (uint8ListAreEqual(hash, fallbackHash.hash)) {
        // If callback is provided, rehash with primary pepper
        if (onFallbackValidated != null) {
          final newHash = await createHash(value: value);
          await onFallbackValidated(newHash);
        }
        return true;
      }
    }

    return false;
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
