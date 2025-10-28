import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// {@template email_idp_password_hash_util}
/// Class for handling password and verification code hashing in the email
/// account module.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
/// {@endtemplate}
final class EmailIDPPasswordHashUtil {
  final String _passwordHashPepper;
  final int _passwordHashSaltLength;

  /// Creates a new instance of [EmailIDPPasswordHashUtil].
  EmailIDPPasswordHashUtil({
    required final String passwordHashPepper,
    required final int passwordHashSaltLength,
  })  : _passwordHashPepper = passwordHashPepper,
        _passwordHashSaltLength = passwordHashSaltLength;

  /// Create the hash for the given [value].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later.
  Future<PasswordHash> createHash({
    required final String value,
    Uint8List? salt,
  }) {
    salt ??= generateRandomBytes(_passwordHashSaltLength);

    final pepper = utf8.encode(_passwordHashPepper);

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

  Future<PasswordHash> _createHash({
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

      return PasswordHash._(hash: hashBytes, salt: salt);
    });
  }
}

/// A class for representing a password hash and its salt.
class PasswordHash {
  /// The hash of the password.
  final Uint8List hash;

  /// The salt of the password.
  final Uint8List salt;

  /// Creates a new [PasswordHash].
  PasswordHash._({
    required this.hash,
    required this.salt,
  });

  /// Creates an empty [PasswordHash].
  factory PasswordHash.empty() {
    return PasswordHash._(
      hash: Uint8List.fromList([]),
      salt: Uint8List.fromList([]),
    );
  }
}
