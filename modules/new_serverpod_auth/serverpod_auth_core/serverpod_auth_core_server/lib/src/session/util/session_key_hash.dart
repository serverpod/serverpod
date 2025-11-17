import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../business/server_side_sessions_config.dart';

@internal
final class ServerSideSessionKeyHash {
  final int _sessionKeyHashSaltLength;
  final String _sessionKeyHashPepper;
  final List<String> _fallbackSessionKeyHashPeppers;
  ServerSideSessionKeyHash({
    required final int sessionKeyHashSaltLength,
    required final String sessionKeyHashPepper,
    required final List<String> fallbackSessionKeyHashPeppers,
  }) : _sessionKeyHashSaltLength = sessionKeyHashSaltLength,
       _sessionKeyHashPepper = sessionKeyHashPepper,
       _fallbackSessionKeyHashPeppers = fallbackSessionKeyHashPeppers;

  /// Uses SHA512 to create a hash for a string using the specified pepper.
  ({Uint8List hash, Uint8List salt}) createSessionKeyHash({
    required final Uint8List secret,
    @protected final Uint8List? salt,
  }) {
    return _createSessionKeyHash(
      secret: secret,
      salt: salt,
      pepper: _sessionKeyHashPepper,
    );
  }

  /// Internal method to create a session key hash with a specific pepper.
  ({Uint8List hash, Uint8List salt}) _createSessionKeyHash({
    required final Uint8List secret,
    required final String pepper,
    final Uint8List? salt,
  }) {
    final pepperBytes = utf8.encode(pepper);

    final actualSalt = salt ?? generateRandomBytes(_sessionKeyHashSaltLength);

    final hash = Uint8List.fromList(sha512.convert(secret + pepperBytes).bytes);

    return (hash: hash, salt: actualSalt);
  }

  /// Validates the session key hash
  bool validateSessionKeyHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    // Try the primary pepper first (most common case)
    if (uint8ListAreEqual(
      hash,
      _createSessionKeyHash(
        secret: secret,
        salt: salt,
        pepper: _sessionKeyHashPepper,
      ).hash,
    )) {
      return true;
    }

    // Try fallback peppers if primary didn't match
    for (final fallbackPepper in _fallbackSessionKeyHashPeppers) {
      if (uint8ListAreEqual(
        hash,
        _createSessionKeyHash(
          secret: secret,
          salt: salt,
          pepper: fallbackPepper,
        ).hash,
      )) {
        return true;
      }
    }

    return false;
  }

  factory ServerSideSessionKeyHash.fromConfig(
    final ServerSideSessionsConfig config,
  ) {
    return ServerSideSessionKeyHash(
      sessionKeyHashSaltLength: config.sessionKeyHashSaltLength,
      sessionKeyHashPepper: config.sessionKeyHashPepper,
      fallbackSessionKeyHashPeppers: config.fallbackSessionKeyHashPeppers,
    );
  }
}
