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
  final String? _fallbackSessionKeyHashPepper;
  AuthSessionKeyHash({
    required final int sessionKeyHashSaltLength,
    required final String sessionKeyHashPepper,
    final String? fallbackSessionKeyHashPepper,
  }) : _sessionKeyHashSaltLength = sessionKeyHashSaltLength,
       _sessionKeyHashPepper = sessionKeyHashPepper,
       _fallbackSessionKeyHashPepper = fallbackSessionKeyHashPepper;

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
  ///
  /// If validation with the primary pepper fails and a fallback pepper is
  /// configured, the validation will be retried with the fallback pepper.
  bool validateSessionKeyHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    // Try primary pepper first
    if (uint8ListAreEqual(
      hash,
      createSessionKeyHash(secret: secret, salt: salt).hash,
    )) {
      return true;
    }

    // If primary fails and fallback exists, try fallback
    if (_fallbackSessionKeyHashPepper != null) {
      final fallbackPepper = utf8.encode(_fallbackSessionKeyHashPepper);
      final fallbackHash = Uint8List.fromList(
        sha512.convert(secret + fallbackPepper).bytes,
      );

      if (uint8ListAreEqual(hash, fallbackHash)) {
        return true;
      }
    }

    return false;
  }

  factory AuthSessionKeyHash.fromConfig(final AuthSessionsConfig config) {
    return AuthSessionKeyHash(
      sessionKeyHashSaltLength: config.sessionKeyHashSaltLength,
      sessionKeyHashPepper: config.sessionKeyHashPepper,
      fallbackSessionKeyHashPepper: config.fallbackSessionKeyHashPepper,
    );
  }
}
