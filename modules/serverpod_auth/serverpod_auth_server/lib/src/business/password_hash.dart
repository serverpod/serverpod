import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod_auth_server/module.dart';

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

  factory _PasswordHashType.fromPasswordHash(String passwordHash) {
    var passwordHashParts = passwordHash.split('\$');
    if (passwordHashParts.length < 2) {
      return _PasswordHashType.legacy;
    }

    var type = passwordHashParts[1];
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
    String passwordHash, {
    required String legacySalt,
    String? legacyEmail,
    String? pepper,
  }) {
    _type = _PasswordHashType.fromPasswordHash(passwordHash);
    var passwordHashParts = passwordHash.split('\$');

    switch (_type) {
      case _LegacyPasswordHashGenerator.type:
        _hash = passwordHash;
        _hashGenerator = _LegacyPasswordHashGenerator(
          salt: legacySalt,
          email: legacyEmail,
        );
        break;
      case _Argon2idPasswordHashGenerator.type:
        var [_, _, salt, hash] = passwordHashParts;
        _hash = hash;
        _hashGenerator = _Argon2idPasswordHashGenerator(
          salt: salt,
          pepper: pepper,
        );
        break;
      case _LegacyToArgon2idPasswordHash.type:
        var [_, _, salt, hash] = passwordHashParts;
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
    String password, {
    void Function(String hash, String passwordHash)? onValidationFailure,
  }) async {
    var passwordHash =
        await Isolate.run(() => _hashGenerator.generateHash(password));

    if (_hash != passwordHash) {
      onValidationFailure?.call(passwordHash, _hash);
      return false;
    }

    return true;
  }

  /// Creates a new password hash using the legacy algorithm.
  ///
  /// If the [email] parameter is provided, the email will be used as an
  /// additional salt for the password hash.
  static Future<String> legacyHash(
    String password,
    String salt, {
    String? email,
  }) async =>
      Isolate.run(() => _LegacyPasswordHashGenerator(salt: salt, email: email)
          .generatePasswordHash(password));

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
    String legacyHash, {
    required String legacySalt,
    String? salt,
    String? pepper,
    bool allowUnsecureRandom = false,
  }) async =>
      Isolate.run(() {
        var encodedSalt = _generateSalt(
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
    String password, {
    String? salt,
    String? pepper,
    bool allowUnsecureRandom = false,
  }) async =>
      Isolate.run(() {
        var encodedSalt = _generateSalt(
          salt: salt,
          allowUnsecureRandom: allowUnsecureRandom,
        );

        return _Argon2idPasswordHashGenerator(
          salt: encodedSalt,
          pepper: pepper,
        ).generatePasswordHash(password);
      });

  static String _generateSalt({
    required bool allowUnsecureRandom,
    String? salt,
  }) {
    if (salt != null) {
      return const Base64Encoder().convert(salt.codeUnits);
    }

    try {
      return Random.secure().nextString(
        length: _saltLength,
      );
    } on UnsupportedError {
      if (!allowUnsecureRandom) {
        rethrow;
      }
    }

    return Random().nextString(
      length: _saltLength,
    );
  }
}

/// Interface for password hash generators.
abstract interface class _PasswordHashGenerator {
  /// Generates a hash from a password.
  String generateHash(String password);
}

/// A password hash generator for legacy password hashes.
class _LegacyPasswordHashGenerator implements _PasswordHashGenerator {
  /// Creates a new legacy password hash generator from a hash string.
  final String _salt;
  final String? _email;

  _LegacyPasswordHashGenerator({required String salt, String? email})
      : _salt = salt,
        _email = email;

  String generatePasswordHash(String password) {
    return generateHash(password);
  }

  @override
  String generateHash(String password) {
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

  _Argon2idPasswordHashGenerator({required String salt, String? pepper})
      : _salt = salt,
        _pepper = pepper;

  String generatePasswordHash(String password) {
    var hash = generateHash(password);
    return '\$${type.name}\$$_salt\$$hash';
  }

  @override
  String generateHash(String password) {
    var parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      utf8.encode(_salt) as Uint8List,
      desiredKeyLength: 256,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      secret: _pepper != null ? utf8.encode(_pepper!) as Uint8List : null,
    );

    var generator = Argon2BytesGenerator()..init(parameters);
    // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
    // ignore: unnecessary_cast
    var hashBytes = generator.process(utf8.encode(password) as Uint8List);

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
    required String legacySalt,
    required String salt,
    String? email,
    String? pepper,
  })  : _legacySalt = legacySalt,
        _salt = salt,
        _email = email,
        _pepper = pepper;

  String generatePasswordHash(String legacyHash) {
    var hash = _Argon2idPasswordHashGenerator(
      salt: _salt,
      pepper: _pepper,
    ).generateHash(legacyHash);
    return '\$${type.name}\$$_salt\$$hash';
  }

  @override
  String generateHash(String password) {
    var legacyHash =
        _LegacyPasswordHashGenerator(salt: _legacySalt, email: _email)
            .generateHash(password);
    return _Argon2idPasswordHashGenerator(
      salt: _salt,
      pepper: _pepper,
    ).generateHash(legacyHash);
  }

  static const _PasswordHashType type = _PasswordHashType.migratedLegacy;
}
