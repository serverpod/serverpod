import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/business/email_account_secrets.dart';

/// Class for handling password and verification code hashing in the email account module.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
abstract final class EmailAccountSecretHash {
  /// Create the hash for the given [value].
  ///
  /// Applies a random salt, which must be stored with the hash to validate it later.
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
    return uint8ListAreEqual(
      hash,
      (await createHash(value: value, salt: salt)).hash,
    );
  }
}

// TODO: These 2 utils should be shared across the auth packages, maybe even through `serverpod_shared` (to migrate off of the base64-encoded, reduced randomness)

final Random _random = Random.secure();

/// Generates a list of secure random bytes of the specified length.
Uint8List generateRandomBytes(final int length) {
  return Uint8List.fromList(
    List<int>.generate(length, (final int i) => _random.nextInt(256)),
  );
}

/// Checks whethere the 2 given lists contain the same data.
bool uint8ListAreEqual(final Uint8List a, final Uint8List b) {
  if (a.length != b.length) {
    return false;
  }

  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}
