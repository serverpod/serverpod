import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';

/// Legacy password validation closely mirroring the behavior of `serverpod_auth`
//
// Copied from `modules/serverpod_auth/serverpod_auth_server/lib/src/business/email_auth.dart`
@internal
Future<bool> legacyEmailPasswordValidator(
  final Session session, {
  required final String email,
  required final String password,
  required final String passwordHash,
}) async {
  try {
    return await PasswordHash(
      passwordHash,
      legacySalt: _LegacyEmailSecrets.legacySalt,
      legacyEmail: AuthBackwardsCompatibility.config.extraSaltyHash
          ? email
          : null,
      pepper: _LegacyEmailSecrets.pepper,
    ).validate(password);
  } catch (e, stackTrace) {
    session.log(
      'Failed to check password against legacy system',
      exception: e,
      stackTrace: stackTrace,
      level: LogLevel.error,
    );

    return false;
  }
}

/// Password hash types.
enum _PasswordHashType {
  /// A legacy password hash.
  legacy,

  /// A password hash generated using the Argon2id algorithm.
  /// See: https://en.wikipedia.org/wiki/Argon2
  argon2id,

  /// A password hash generated using the Argon2id algorithm, but expecting the
  /// passed in password hash to be a legacy password hash.
  ///
  /// This is used to migrate legacy password hashes to safer Argon2id
  /// password hashes without forcing users to change their passwords.
  migratedLegacy;

  factory _PasswordHashType.fromPasswordHash(final String passwordHash) {
    final passwordHashParts = passwordHash.split('\$');
    if (passwordHashParts.length < 2) {
      return _PasswordHashType.legacy;
    }

    final type = passwordHashParts[1];
    if (type == _PasswordHashType.argon2id.name) {
      return _PasswordHashType.argon2id;
    } else if (type == _PasswordHashType.migratedLegacy.name) {
      return _PasswordHashType.migratedLegacy;
    }

    throw ArgumentError('Unknown password hash type: $type', 'passwordHash');
  }
}

/// A class for handling password hashes.
class PasswordHash {
  // Recommended salt length by ietf.
  // https://www.ietf.org/archive/id/draft-ietf-kitten-password-storage-04.html#name-storage-2
  static const int _saltLength = 16;
  late final _PasswordHashType _type;

  late final _PasswordHashGenerator _hashGenerator;
  late final String _hash;

  /// Creates a new [PasswordHash] from a password hash string used to validate
  /// passwords using the same hashing algorithm.
  ///
  /// Throws an [ArgumentError] if the password hash is not recognized.
  PasswordHash(
    final String passwordHash, {
    required final String legacySalt,
    final String? legacyEmail,
    final String? pepper,
  }) {
    _type = _PasswordHashType.fromPasswordHash(passwordHash);
    final passwordHashParts = passwordHash.split('\$');

    switch (_type) {
      case _LegacyPasswordHashGenerator.type:
        _hash = passwordHash;
        _hashGenerator = _LegacyPasswordHashGenerator(
          salt: legacySalt,
          email: legacyEmail,
        );
        break;
      case _Argon2idPasswordHashGenerator.type:
        final [_, _, salt, hash] = passwordHashParts;
        _hash = hash;
        _hashGenerator = _Argon2idPasswordHashGenerator(
          salt: salt,
          pepper: pepper,
        );
        break;
      case _LegacyToArgon2idPasswordHash.type:
        final [_, _, salt, hash] = passwordHashParts;
        _hash = hash;
        _hashGenerator = _LegacyToArgon2idPasswordHash(
          legacySalt: legacySalt,
          salt: salt,
          email: legacyEmail,
          pepper: pepper,
        );
        break;
    }
  }

  /// Returns true if the hash was generated using an outdated algorithm.
  bool shouldUpdateHash() {
    return [
      _LegacyPasswordHashGenerator.type,
      _LegacyToArgon2idPasswordHash.type,
    ].contains(_type);
  }

  /// Returns true if the hash was generated using the legacy algorithm.
  bool isLegacyHash() {
    return _type == _LegacyPasswordHashGenerator.type;
  }

  /// Checks if a password matches the hash.
  ///
  /// If the password does not match the hash, the [onValidationFailure] function
  /// will be called with the hash and the password hash as arguments.
  Future<bool> validate(
    final String password, {
    final void Function({
      required String storedHash,
      required String passwordHash,
    })?
    onValidationFailure,
  }) async {
    final passwordHash = await Isolate.run(
      () => _hashGenerator.generateHash(password),
    );

    if (_hash != passwordHash) {
      onValidationFailure?.call(storedHash: _hash, passwordHash: passwordHash);
      return false;
    }

    return true;
  }

  /// Creates a new password hash using the legacy algorithm.
  ///
  /// If the [email] parameter is provided, the email will be used as an
  /// additional salt for the password hash.
  static Future<String> legacyHash(
    final String password,
    final String salt, {
    final String? email,
  }) async => Isolate.run(
    () => _LegacyPasswordHashGenerator(
      salt: salt,
      email: email,
    ).generatePasswordHash(password),
  );

  /// Creates an Argon2id password hash expecting the passed in password hash to
  /// be a legacy password hash.
  ///
  /// This is used to migrate legacy password hashes to Argon2id password
  /// hashes.
  ///
  /// The [legacySalt] parameter is the salt used in the legacy password hash.
  ///
  /// The [salt] parameter should only be used in testing and development.
  /// If omitted a random salt will be generated which is the recommended way
  /// to use this function in production.
  ///
  /// The [allowUnsecureRandom] parameter can be used to allow unsecure random
  /// number generation. If set to false (default value), an error will be thrown
  /// if the platform does not support secure random number generation.
  static Future<String> migratedLegacyToArgon2idHash(
    final String legacyHash, {
    required final String legacySalt,
    final String? salt,
    final String? pepper,
    final bool allowUnsecureRandom = false,
  }) async => Isolate.run(() {
    final encodedSalt = _generateSalt(
      salt: salt,
      allowUnsecureRandom: allowUnsecureRandom,
    );

    return _LegacyToArgon2idPasswordHash(
      legacySalt: legacySalt,
      salt: encodedSalt,
      pepper: pepper,
    ).generatePasswordHash(legacyHash);
  });

  /// Creates a new password hash using the Argon2id algorithm.
  ///
  /// The [salt] parameter should only be used in testing and development.
  /// If omitted a random salt will be generated which is the recommended way
  /// to use this function in production.
  ///
  /// The [allowUnsecureRandom] parameter can be used to allow unsecure random
  /// number generation. If set to false (default value), an error will be thrown
  /// if the platform does not support secure random number generation.
  static Future<String> argon2id(
    final String password, {
    final String? salt,
    final String? pepper,
    final bool allowUnsecureRandom = false,
  }) async => Isolate.run(() {
    final encodedSalt = _generateSalt(
      salt: salt,
      allowUnsecureRandom: allowUnsecureRandom,
    );

    return _Argon2idPasswordHashGenerator(
      salt: encodedSalt,
      pepper: pepper,
    ).generatePasswordHash(password);
  });

  static String _generateSalt({
    required final bool allowUnsecureRandom,
    final String? salt,
  }) {
    if (salt != null) {
      return const Base64Encoder().convert(salt.codeUnits);
    }

    try {
      return Random.secure().nextString(length: _saltLength);
    } on UnsupportedError {
      if (!allowUnsecureRandom) {
        rethrow;
      }
    }

    return Random().nextString(length: _saltLength);
  }
}

/// Interface for password hash generators.
abstract interface class _PasswordHashGenerator {
  /// Generates a hash from a password.
  String generateHash(final String password);
}

/// A password hash generator for legacy password hashes.
class _LegacyPasswordHashGenerator implements _PasswordHashGenerator {
  /// Creates a new legacy password hash generator from a hash string.
  final String _salt;
  final String? _email;

  _LegacyPasswordHashGenerator({
    required final String salt,
    final String? email,
  }) : _salt = salt,
       _email = email;

  String generatePasswordHash(final String password) {
    return generateHash(password);
  }

  @override
  String generateHash(final String password) {
    var salt = _salt;
    if (_email != null) {
      salt += ':$_email';
    }

    return sha256.convert(utf8.encode(password + salt)).toString();
  }

  static const _PasswordHashType type = _PasswordHashType.legacy;
}

/// A password hash generator for Argon2id password hashes.
class _Argon2idPasswordHashGenerator implements _PasswordHashGenerator {
  final String _salt;
  final String? _pepper;

  _Argon2idPasswordHashGenerator({
    required final String salt,
    final String? pepper,
  }) : _salt = salt,
       _pepper = pepper;

  String generatePasswordHash(final String password) {
    final hash = generateHash(password);
    return '\$${type.name}\$$_salt\$$hash';
  }

  @override
  String generateHash(final String password) {
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      utf8.encode(_salt) as Uint8List,
      desiredKeyLength: 256,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      secret: _pepper != null ? utf8.encode(_pepper) as Uint8List : null,
    );

    final generator = Argon2BytesGenerator()..init(parameters);
    // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
    // ignore: unnecessary_cast
    final hashBytes = generator.process(utf8.encode(password) as Uint8List);

    return const Base64Encoder().convert(hashBytes);
  }

  static const _PasswordHashType type = _PasswordHashType.argon2id;
}

class _LegacyToArgon2idPasswordHash implements _PasswordHashGenerator {
  final String _legacySalt;
  final String _salt;
  final String? _email;
  final String? _pepper;

  _LegacyToArgon2idPasswordHash({
    required final String legacySalt,
    required final String salt,
    final String? email,
    final String? pepper,
  }) : _legacySalt = legacySalt,
       _salt = salt,
       _email = email,
       _pepper = pepper;

  String generatePasswordHash(final String legacyHash) {
    final hash = _Argon2idPasswordHashGenerator(
      salt: _salt,
      pepper: _pepper,
    ).generateHash(legacyHash);
    return '\$${type.name}\$$_salt\$$hash';
  }

  @override
  String generateHash(final String password) {
    final legacyHash = _LegacyPasswordHashGenerator(
      salt: _legacySalt,
      email: _email,
    ).generateHash(password);
    return _Argon2idPasswordHashGenerator(
      salt: _salt,
      pepper: _pepper,
    ).generateHash(legacyHash);
  }

  static const _PasswordHashType type = _PasswordHashType.migratedLegacy;
}

/// An extension for generating random strings.
extension on Random {
  /// Returns a random [String] consisting of letters and numbers, by default
  /// the [length] of the string will be 16 characters.
  String nextString({
    final int length = 16,
    final String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890',
  }) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (final _) => chars.codeUnitAt(nextInt(chars.length)),
      ),
    );
  }
}

/// Secrets used for email authentication.
abstract class _LegacyEmailSecrets {
  /// The salt used for hashing legacy passwords.
  static String get legacySalt =>
      Serverpod.instance.getPassword('email_password_salt') ??
      'serverpod password salt';

  /// The pepper used for hashing passwords.
  static String? get pepper =>
      Serverpod.instance.getPassword('emailPasswordPepper');
}
