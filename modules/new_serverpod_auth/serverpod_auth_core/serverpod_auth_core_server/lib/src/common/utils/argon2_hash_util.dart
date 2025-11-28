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
/// Output follows the PHC format: `$argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}${base64Hash}`
/// Sample output: `$argon2id$v=19$m=65536,t=2,p=1$gZiV/M1gPc22ElAH/Jh1Hw$CWOrkoo7oJBQ/iyh7uJ0LO2aLEfrHwTWllSAxT0zRno`
///
/// Hashes validated by the class need to follow the PHC format.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class Argon2HashUtil {
  final String _hashPepper;
  final List<String> _fallbackHashPeppers;
  final int _hashSaltLength;
  final Argon2HashParameters _parameters;

  /// Creates a new instance of [Argon2HashUtil].
  ///
  /// The class creates hashes in the PHC format: `$argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}${base64Hash}`
  ///
  /// [hashPepper] is the primary pepper to use for hashing.
  /// [fallbackHashPeppers] is an optional list of peppers to try when validating.
  /// [hashSaltLength] is the length of the salt to generate (in bytes).
  /// [parameters] is the hash parameters used when creating new hashes,
  Argon2HashUtil({
    required final String hashPepper,
    final List<String> fallbackHashPeppers = const [],
    required final int hashSaltLength,
    final Argon2HashParameters? parameters,
  }) : _hashPepper = hashPepper,
       _fallbackHashPeppers = fallbackHashPeppers,
       _hashSaltLength = hashSaltLength,
       _parameters = parameters ?? Argon2HashParameters();

  /// Create the hash for the given [secret] (String).
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later. If [salt] is provided, it will be used instead of generating a
  /// random one.
  ///
  /// Returns a PHC-formatted string: `$argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}`
  Future<String> createHashFromString({
    required final String secret,
    @protected Uint8List? salt,
  }) async {
    salt ??= generateRandomBytes(_hashSaltLength);
    final pepper = utf8.encode(_hashPepper);
    final secretBytes = utf8.encode(secret);

    final result = await _createHash(
      secret: secretBytes,
      salt: salt,
      pepper: pepper,
    );

    return result.toPhcHashString();
  }

  /// Create the hash for the given [secret] (Uint8List).
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later. If [salt] is provided, it will be used instead of generating a
  /// random one.
  ///
  /// Returns a PHC-formatted string: `$argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}${base64Hash}`
  Future<String> createHashFromBytes({
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

    return result.toPhcHashString();
  }

  /// Verify whether the [hashString] is valid for the given [secret] (String).
  ///
  /// [hashString] should be a PHC-formatted string: `$argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}${base64Hash}`
  ///
  /// Tries the primary pepper first, then falls back to the fallback peppers
  /// if provided.
  Future<bool> validateHashFromString({
    required final String secret,
    required final String hashString,
  }) async {
    final secretBytes = utf8.encode(secret);
    return _validateHashFromHashedString(
      secret: secretBytes,
      hashString: hashString,
    );
  }

  /// Verify whether the [hashString] is valid for the given [secret] (Uint8List).
  ///
  /// [hashString] should be a PHC-formatted string: `$argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}`
  ///
  /// Tries the primary pepper first, then falls back to the fallback peppers
  /// if provided.
  Future<bool> validateHashFromBytes({
    required final Uint8List secret,
    required final String hashString,
  }) async {
    return _validateHashFromHashedString(
      secret: secret,
      hashString: hashString,
    );
  }

  Future<bool> _validateHashFromHashedString({
    required final Uint8List secret,
    required final String hashString,
  }) async {
    final _HashResult parsed;
    try {
      parsed = _HashResult.fromPhcHashString(hashString);
    } catch (e) {
      return false;
    }

    final allPeppers = [_hashPepper, ..._fallbackHashPeppers];

    for (final pepper in allPeppers) {
      final computedHash = (await _createHashWithParameters(
        secret: secret,
        salt: parsed.salt,
        pepper: utf8.encode(pepper),
        memory: parsed.memory,
        iterations: parsed.iterations,
        lanes: parsed.lanes,
        desiredKeyLength: parsed.hash.length,
      )).hash;
      if (uint8ListAreEqual(parsed.hash, computedHash)) {
        return true;
      }
    }

    return false;
  }

  Future<_HashResult> _createHash({
    required final Uint8List secret,
    required final Uint8List salt,
    required final Uint8List pepper,
  }) {
    return _createHashWithParameters(
      secret: secret,
      salt: salt,
      pepper: pepper,
      memory: _parameters.memory,
      iterations: _parameters.iterations,
      lanes: _parameters.lanes,
      desiredKeyLength: _parameters.desiredKeyLength,
    );
  }

  static Future<_HashResult> _createHashWithParameters({
    required final Uint8List secret,
    required final Uint8List salt,
    required final Uint8List pepper,
    required final int memory,
    required final int iterations,
    required final int lanes,
    required final int desiredKeyLength,
  }) {
    // Capture variables for use in isolate
    return Isolate.run(() {
      final parameters = Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        salt,
        desiredKeyLength: desiredKeyLength,
        lanes: lanes,
        memory: memory,
        iterations: iterations,
        secret: pepper,
      );

      final generator = Argon2BytesGenerator()..init(parameters);
      final hashBytes = generator.process(secret);

      return _HashResult.fromArgon2Parameters(
        parameters,
        hash: hashBytes,
        salt: salt,
      );
    });
  }
}

/// Class containing the result from hashing a value.
///
/// Contains the computed hash, the salt used to compute it, and the Argon2
/// parameters that were used during hashing.
class _HashResult {
  /// The hash of the secret.
  final Uint8List hash;

  /// The salt used to compute the hash.
  final Uint8List salt;

  /// The memory cost parameter in KiB that was used to compute the hash.
  final int memory;

  /// The time cost parameter (iterations) that was used to compute the hash.
  final int iterations;

  /// The degree of parallelism (lanes) that was used to compute the hash.
  final int lanes;

  /// The version of the Argon2 algorithm that was used to compute the hash.
  final int version;

  /// Creates a new [_HashResult].
  _HashResult._({
    required this.hash,
    required this.salt,
    required this.memory,
    required this.iterations,
    required this.lanes,
    required this.version,
  });

  /// Formats a hash result into a PHC-formatted string.
  ///
  /// Format: `$argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}${base64Hash}`
  String toPhcHashString() {
    final base64Salt = base64Encode(salt);
    final base64Hash = base64Encode(hash);

    return '\$argon2id\$v=$version\$m=$memory,t=$iterations,p=$lanes\$$base64Salt\$$base64Hash';
  }

  /// Creates a new [_HashResult] from the given [parameters].
  factory _HashResult.fromArgon2Parameters(
    final Argon2Parameters parameters, {
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    return _HashResult._(
      hash: hash,
      salt: salt,
      memory: parameters.memory,
      iterations: parameters.iterations,
      lanes: parameters.lanes,
      version: parameters.version,
    );
  }

  /// Parses a PHC-formatted hash string into a [_HashResult].
  ///
  /// Throws [ArgumentError] if the string format is invalid.
  factory _HashResult.fromPhcHashString(final String hashString) {
    final argumentError = ArgumentError.value(
      hashString,
      'hashString',
      'Invalid PHC hash string',
    );
    final parts = hashString.split('\$');
    if (parts.length != 6 || parts[0] != '' || parts[1] != 'argon2id') {
      throw argumentError;
    }

    final version = parts[2].startsWith('v=')
        ? int.tryParse(parts[2].substring(2))
        : null;
    if (version == null) {
      throw argumentError;
    }

    // Parse version: v=19
    if (version != Argon2Parameters.ARGON2_VERSION_13 &&
        version != Argon2Parameters.ARGON2_VERSION_10) {
      throw ArgumentError('Unsupported Argon2 version: $version');
    }

    // Parse parameters: m={memory},t={iterations},p={lanes}
    final params = parts[3].split(',');
    final memory = params[0].startsWith('m=')
        ? int.tryParse(params[0].substring(2))
        : null;
    final iterations = params[1].startsWith('t=')
        ? int.tryParse(params[1].substring(2))
        : null;
    final lanes = params[2].startsWith('p=')
        ? int.tryParse(params[2].substring(2))
        : null;

    if (memory == null || iterations == null || lanes == null) {
      throw argumentError;
    }

    // Parse salt and hash (base64 encoded)
    final Uint8List salt;
    final Uint8List hash;
    try {
      salt = Uint8List.fromList(base64Decode(parts[4]));
      hash = Uint8List.fromList(base64Decode(parts[5]));
    } catch (e) {
      throw argumentError;
    }

    return _HashResult._(
      hash: hash,
      salt: salt,
      memory: memory,
      iterations: iterations,
      lanes: lanes,
      version: 19,
    );
  }
}

/// Parameters for hashing a secret using the Argon2id algorithm.
final class Argon2HashParameters {
  /// The memory cost parameter in KiB (default: 4096 = 4MiB).
  final int memory;

  /// The time cost parameter (default: 3, standard Argon2 value).
  final int iterations;

  /// The degree of parallelism (default: number of processors).
  final int lanes;

  /// The output hash length in bytes (default: 32 = 256 bits).
  final int desiredKeyLength;

  /// [memory] is the memory cost parameter in KiB (default: 4096 = 4MiB).
  /// [lanes] is the degree of parallelism (default: number of processors).
  /// [iterations] is the time cost parameter (default: 3, standard Argon2 value).
  /// [desiredKeyLength] is the output hash length in bytes (default: 32 = 256 bits).
  Argon2HashParameters({
    this.memory = 1 << 12,
    final int? lanes,
    this.iterations = 3,
    this.desiredKeyLength = 32,
  }) : lanes = lanes ?? Platform.numberOfProcessors;
}
