import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_auth_email_account_server/src/business/email_account_secrets.dart';

/// Class for handling password hashing.
///
/// Uses the Argon2id algorithm.
/// See: https://en.wikipedia.org/wiki/Argon2
abstract final class PasswordHash {
  /// Prefix for Argon2 Hash with lower-case email as the `salt`, and a configured `pepper`
  static const _prefix = 'argon2:';

  /// Create the password hash for the given [email] / [password] pair.
  static String createHash({
    required final String email,
    required final String password,
  }) {
    if (email != email.toLowerCase()) {
      throw ArgumentError.value(
        email,
        'email',
        'Email is not given in lower-case.',
      );
    }

    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      utf8.encode(email) as Uint8List,
      desiredKeyLength: 256,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      secret: utf8.encode(EmailAccountSecrets.passwordHashPepper) as Uint8List,
    );

    final generator = Argon2BytesGenerator()..init(parameters);
    // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
    // ignore: unnecessary_cast
    final hashBytes = generator.process(utf8.encode(password) as Uint8List);

    final hash = const Base64Encoder().convert(hashBytes);

    return '$_prefix$hash';
  }

  /// Verify whether the [hash] is valid for the given [email] / [password] pair.
  static bool validateHash({
    required final String email,
    required final String password,
    required final String hash,
  }) {
    if (email != email.toLowerCase()) {
      throw ArgumentError.value(
        email,
        'email',
        'Email is not given in lower-case.',
      );
    }

    if (!hash.startsWith(_prefix)) {
      throw ArgumentError.value(
        hash,
        'hash',
        'Hash is not of the supported kind.',
      );
    }

    return hash == createHash(email: email, password: password);
  }
}
