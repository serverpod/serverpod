import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../business/server_side_sessions_config.dart';

/// Outcome of validating a presented secret against a stored session key hash.
enum SessionKeyHashValidation {
  /// The secret did not match under any supported scheme or pepper.
  invalid,

  /// The secret matched a hash already stored in the current scheme.
  valid,

  /// The secret matched, but the stored hash uses a superseded scheme (the
  /// pre-versioning saltless digest). The caller should re-hash via
  /// [ServerSideSessionKeyHash.rehashSessionKeyHash] and persist it, upgrading
  /// the row in place without dropping the session.
  validButOutdated,
}

@internal
final class ServerSideSessionKeyHash {
  /// Length in bytes of a raw SHA-512 digest.
  static const int _digestLength = 64;

  /// The scheme written today: `[_saltedVersion] + sha512(secret + salt + pepper)`.
  static const int _saltedVersion = 1;

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

  /// Creates a versioned hash for [secret] with a per-session salt and the
  /// configured pepper.
  ///
  /// The stored hash is `[version] + digest`. The leading version byte lets
  /// [validateSessionKeyHash] pick the right digest formula, and lets future
  /// scheme changes be told apart from what is already on disk. The returned
  /// salt has to be stored next to the hash and handed back to
  /// [validateSessionKeyHash], which cannot verify the hash without it.
  ({Uint8List hash, Uint8List salt}) createSessionKeyHash({
    required final Uint8List secret,
    @protected final Uint8List? salt,
  }) {
    final actualSalt = salt ?? generateRandomBytes(_sessionKeyHashSaltLength);
    return (
      hash: rehashSessionKeyHash(secret: secret, salt: actualSalt),
      salt: actualSalt,
    );
  }

  /// Produces the current-scheme hash for [secret], reusing an already-stored
  /// [salt].
  ///
  /// Used to upgrade a row whose hash used a superseded scheme; the salt does
  /// not change, so only the hash column needs to be written.
  Uint8List rehashSessionKeyHash({
    required final Uint8List secret,
    required final Uint8List salt,
  }) {
    final digest = _saltedDigest(
      secret: secret,
      salt: salt,
      pepper: _sessionKeyHashPepper,
    );

    return Uint8List(1 + digest.length)
      ..[0] = _saltedVersion
      ..setRange(1, 1 + digest.length, digest);
  }

  /// Validates [secret] against a stored [hash] and its [salt], across the
  /// primary and fallback peppers.
  ///
  /// Dispatches on the stored scheme: a bare 64-byte value is a pre-versioning
  /// saltless hash and is always superseded; a longer value carries its version
  /// in the first byte. Returns [SessionKeyHashValidation.validButOutdated] when
  /// the match came from a superseded scheme, so the caller can upgrade the row.
  SessionKeyHashValidation validateSessionKeyHash({
    required final Uint8List secret,
    required final Uint8List hash,
    required final Uint8List salt,
  }) {
    // Pre-versioning rows are the released saltless digest, sha512(secret +
    // pepper), stored as a bare 64-byte value. A match is genuine but
    // superseded, so the caller upgrades the row.
    if (hash.length == _digestLength) {
      return _matchesAnyPepper(
            hash,
            (final pepper) =>
                _legacySaltlessDigest(secret: secret, pepper: pepper),
          )
          ? SessionKeyHashValidation.validButOutdated
          : SessionKeyHashValidation.invalid;
    }

    // Anything that is neither a bare digest nor a version byte followed by
    // one is corrupt or truncated. Fail closed rather than indexing into it.
    if (hash.length != 1 + _digestLength) {
      return SessionKeyHashValidation.invalid;
    }

    // Versioned rows carry their scheme in the first byte.
    switch (hash[0]) {
      case _saltedVersion:
        final storedDigest = Uint8List.sublistView(hash, 1);
        return _matchesAnyPepper(
              storedDigest,
              (final pepper) =>
                  _saltedDigest(secret: secret, salt: salt, pepper: pepper),
            )
            ? SessionKeyHashValidation.valid
            : SessionKeyHashValidation.invalid;
      default:
        // A newer scheme written by a build ahead of this one. Fail closed.
        return SessionKeyHashValidation.invalid;
    }
  }

  bool _matchesAnyPepper(
    final Uint8List expectedDigest,
    final Uint8List Function(String pepper) computeDigest,
  ) {
    if (uint8ListAreEqual(
      expectedDigest,
      computeDigest(_sessionKeyHashPepper),
    )) {
      return true;
    }
    for (final fallbackPepper in _fallbackSessionKeyHashPeppers) {
      if (uint8ListAreEqual(expectedDigest, computeDigest(fallbackPepper))) {
        return true;
      }
    }
    return false;
  }

  /// The current digest, with the salt folded in.
  ///
  /// The salt has to be part of the digest, not merely stored beside it.
  /// Without it every session sharing a secret shares a hash, and one
  /// precomputation is good against every row at once. Both lengths are fixed
  /// by configuration, so the concatenation is unambiguous.
  Uint8List _saltedDigest({
    required final Uint8List secret,
    required final Uint8List salt,
    required final String pepper,
  }) {
    return Uint8List.fromList(
      sha512.convert(secret + salt + utf8.encode(pepper)).bytes,
    );
  }

  /// The pre-fix digest that never mixed the salt in.
  ///
  /// Validation-only: a hash is never written with this formula again. It exists
  /// so sessions issued before the fix keep working until they are re-hashed on
  /// next use. It can be removed after a deprecation window, at which point any
  /// remaining pre-fix sessions simply require a fresh sign-in.
  Uint8List _legacySaltlessDigest({
    required final Uint8List secret,
    required final String pepper,
  }) {
    return Uint8List.fromList(
      sha512.convert(secret + utf8.encode(pepper)).bytes,
    );
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
