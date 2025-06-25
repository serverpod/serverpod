import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/business/email_account_secrets.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Class for handling password and verification code hashing in the email
/// account module.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
abstract final class EmailAccountSecretHash {
  /// Create the hash for the given [value].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it
  /// later.
  static Future<({Uint8List hash, Uint8List salt})> createHash({
    required final String value,
    @protected Uint8List? salt,
  }) {
    salt ??= generateRandomBytes(
      EmailAccounts.config.passwordHashSaltLength,
    );

    final pepper = utf8.encode(EmailAccountSecrets.passwordHashPepper);

    return _createHash(
      secret: value,
      salt: salt,
      pepper: pepper,
    );
  }

  static Future<({Uint8List hash, Uint8List salt})> _createHash({
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

      return (hash: hashBytes, salt: salt);
    });
  }

  /// Verify whether the [hash] / [salt] pair is valid for the given [value].
  static Future<bool> validateHash({
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
}
