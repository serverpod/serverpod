import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../business/auth_sessions_config.dart';

@internal
final class AuthSessionKeyHash {
  final int _sessionKeyHashSaltLength;
  final String _sessionKeyHashPepper;
  AuthSessionKeyHash({
    required final int sessionKeyHashSaltLength,
    required final String sessionKeyHashPepper,
  }) : _sessionKeyHashSaltLength = sessionKeyHashSaltLength,
       _sessionKeyHashPepper = sessionKeyHashPepper;

  /// Uses SHA512 to create a hash for a string using the specified pepper.
  ({Uint8List hash, Uint8List salt}) createSessionKeyHash({
    required final Uint8List secret,
    @protected Uint8List? salt,
  }) {
    final pepper = utf8.encode(_sessionKeyHashPepper);

    salt ??= generateRandomBytes(_sessionKeyHashSaltLength);

    final hash = Uint8List.fromList(sha512.convert(secret + pepper).bytes);

    return (hash: hash, salt: salt);
  }

  /// Validates the session key hash
  bool validateSessionKeyHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    return uint8ListAreEqual(
      hash,
      createSessionKeyHash(secret: secret, salt: salt).hash,
    );
  }

  factory AuthSessionKeyHash.fromConfig(final AuthSessionsConfig config) {
    return AuthSessionKeyHash(
      sessionKeyHashSaltLength: config.sessionKeyHashSaltLength,
      sessionKeyHashPepper: config.sessionKeyHashPepper,
    );
  }
}
