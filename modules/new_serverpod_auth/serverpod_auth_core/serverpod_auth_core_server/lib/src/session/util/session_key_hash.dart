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
  final List<String> _fallbackSessionKeyHashPeppers;
  AuthSessionKeyHash({
    required final int sessionKeyHashSaltLength,
    required final String sessionKeyHashPepper,
    required final List<String> fallbackSessionKeyHashPeppers,
  }) : _sessionKeyHashSaltLength = sessionKeyHashSaltLength,
       _sessionKeyHashPepper = sessionKeyHashPepper,
       _fallbackSessionKeyHashPeppers = fallbackSessionKeyHashPeppers;

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
    // Try the primary pepper first (most common case)
    if (_validateWithPepper(
      secret: secret,
      hash: hash,
      salt: salt,
      pepper: _sessionKeyHashPepper,
    )) {
      return true;
    }

    // Try fallback peppers if primary didn't match
    for (final fallbackPepper in _fallbackSessionKeyHashPeppers) {
      if (_validateWithPepper(
        secret: secret,
        hash: hash,
        salt: salt,
        pepper: fallbackPepper,
      )) {
        return true;
      }
    }

    return false;
  }

  /// Internal helper to validate hash with a specific pepper
  bool _validateWithPepper({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
    required final String pepper,
  }) {
    final pepperBytes = utf8.encode(pepper);
    final computedHash = Uint8List.fromList(
      sha512.convert(secret + pepperBytes).bytes,
    );
    return uint8ListAreEqual(hash, computedHash);
  }

  factory AuthSessionKeyHash.fromConfig(final AuthSessionsConfig config) {
    return AuthSessionKeyHash(
      sessionKeyHashSaltLength: config.sessionKeyHashSaltLength,
      sessionKeyHashPepper: config.sessionKeyHashPepper,
      fallbackSessionKeyHashPeppers: config.fallbackSessionKeyHashPeppers,
    );
  }
}
