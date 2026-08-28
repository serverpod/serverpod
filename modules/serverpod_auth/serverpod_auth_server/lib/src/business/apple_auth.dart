import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import 'package:meta/meta.dart';

import 'config.dart';

/// The issuer Apple stamps on every Sign in with Apple identity token.
const _appleIssuer = 'https://appleid.apple.com';

/// Where Apple publishes the public keys its identity tokens are signed with.
final _appleKeysUrl = Uri.parse('https://appleid.apple.com/auth/keys');

/// How long to wait for Apple's key endpoint before giving up.
const _keyFetchTimeout = Duration(seconds: 10);

/// How long a fetched key set is served from cache before being refreshed.
const _keyCacheLifetime = Duration(hours: 24);

/// How long to wait before fetching again after a failed fetch.
const _keyRefetchBackoff = Duration(minutes: 1);

/// The default for [AppleAuth.minRefetchInterval].
const _defaultMinRefetchInterval = Duration(minutes: 5);

/// The verified claims of a Sign in with Apple identity token.
class AppleIdentityToken {
  /// Apple's stable identifier for the user. Unique per developer team, so it
  /// only identifies the user within the apps of a single team.
  final String subject;

  /// The email address the token carries, if any. Lower-cased.
  ///
  /// This is either the user's real address or a per-app private relay
  /// address, depending on what the user shared at authorization time.
  final String? email;

  /// Whether Apple vouches for [email] being verified.
  final bool isEmailVerified;

  /// Creates verified identity token claims.
  AppleIdentityToken({
    required this.subject,
    required this.email,
    required this.isEmailVerified,
  });
}

/// Thrown when a Sign in with Apple identity token cannot be verified.
class AppleIdentityTokenException implements Exception {
  /// Description of why verification failed.
  final String message;

  /// Creates a verification failure with the given [message].
  AppleIdentityTokenException(this.message);

  @override
  String toString() => 'AppleIdentityTokenException: $message';
}

/// Thrown when Sign in with Apple cannot be attempted at all.
///
/// A missing configuration or an unreachable key endpoint, rather than a bad
/// token, so callers should report it as their own failure.
class AppleAuthUnavailableException extends AppleIdentityTokenException {
  /// Creates an unavailability failure with the given [message].
  AppleAuthUnavailableException(super.message);
}

/// Convenience methods for handling authentication with Apple.
class AppleAuth {
  static _AppleKeySet? _publicKeys;
  static ({DateTime at, AppleIdentityTokenException error})? _lastFetchFailure;
  static Future<_AppleKeySet>? _inFlightFetch;

  /// The shortest interval between two fetches of Apple's key set.
  ///
  /// An unknown key id triggers a refresh, and the key id comes out of the
  /// token, so without a floor a stream of tokens naming nonexistent keys
  /// would reach Apple once each.
  @visibleForTesting
  static Duration minRefetchInterval = _defaultMinRefetchInterval;

  /// Verifies a Sign in with Apple identity token and returns its claims.
  ///
  /// Checks the signature against Apple's published keys and validates the
  /// `iss`, `aud` and `exp`/`iat` claims. Apple signs every developer team's
  /// tokens with the same keys, so only the `aud` check against
  /// [AuthConfig.appleClientIds] proves the token was minted for this
  /// application.
  ///
  /// Throws an [AppleIdentityTokenException] if the token cannot be verified,
  /// or an [AppleAuthUnavailableException] if the sign in cannot be attempted
  /// at all.
  static Future<AppleIdentityToken> verifyIdentityToken(
    String identityToken,
  ) async {
    var clientIds = AuthConfig.current.appleClientIds;
    if (clientIds.isEmpty) {
      throw AppleAuthUnavailableException(
        'Sign in with Apple is not configured. Set `appleClientIds` on '
        '`AuthConfig` to the client identifiers (app bundle ids and services '
        'ids) this server accepts identity tokens for. Without it an identity '
        'token minted for any other Apple developer team would be accepted.',
      );
    }

    JsonWebSignature jws;
    String? keyId;
    try {
      jws = JsonWebSignature.fromCompactSerialization(identityToken);

      // The header is the caller's, so a non-string `kid` is malformed input.
      keyId = jws.commonHeader.keyId;
    } catch (e) {
      throw AppleIdentityTokenException('Malformed identity token: $e');
    }

    if (!await _verifySignature(jws, keyId)) {
      throw AppleIdentityTokenException('Identity token signature is invalid');
    }

    // The signature over these exact bytes was checked above.
    var claims = jws.unverifiedPayload.jsonContent;
    if (claims is! Map<String, dynamic>) {
      throw AppleIdentityTokenException('Identity token payload is not a map');
    }

    _validateClaims(claims, clientIds);

    var email = (claims['email'] as String?)?.toLowerCase();

    return AppleIdentityToken(
      subject: claims['sub'] as String,
      email: email,
      isEmailVerified: email != null && _isTrueClaim(claims['email_verified']),
    );
  }

  static void _validateClaims(
    Map<String, dynamic> claims,
    Set<String> clientIds,
  ) {
    if (claims['iss'] != _appleIssuer) {
      throw AppleIdentityTokenException(
        'Identity token was issued by "${claims['iss']}", expected '
        '"$_appleIssuer"',
      );
    }

    var audience = claims['aud'];
    var audiences = switch (audience) {
      String() => [audience],
      List() => audience.whereType<String>().toList(),
      _ => const <String>[],
    };
    if (!audiences.any(clientIds.contains)) {
      throw AppleIdentityTokenException(
        'Identity token audience $audiences is not one of the configured '
        'Apple client ids. The token was minted for a different application.',
      );
    }

    var subject = claims['sub'];
    if (subject is! String || subject.isEmpty) {
      throw AppleIdentityTokenException('Identity token has no subject');
    }

    var tolerance = AuthConfig.current.appleIdentityTokenClockSkewTolerance;
    var now = DateTime.now().toUtc();

    var expiresAt = _timestamp(claims['exp']);
    if (expiresAt == null) {
      throw AppleIdentityTokenException('Identity token has no expiry');
    }
    if (now.isAfter(expiresAt.add(tolerance))) {
      throw AppleIdentityTokenException('Identity token expired at $expiresAt');
    }

    var issuedAt = _timestamp(claims['iat']);
    if (issuedAt != null && issuedAt.subtract(tolerance).isAfter(now)) {
      throw AppleIdentityTokenException(
        'Identity token was issued in the future, at $issuedAt',
      );
    }
  }

  /// Verifies [jws] against Apple's published keys.
  ///
  /// Apple rotates its signing keys, so a `kid` the cache does not hold may
  /// mean a stale cache rather than a forgery. Fetches once more before
  /// rejecting.
  static Future<bool> _verifySignature(
    JsonWebSignature jws,
    String? keyId,
  ) async {
    var keys = await _loadPublicKeys();
    if (await jws.verify(keys.keyStore)) return true;

    // A cached key id means a bad signature, not a stale cache.
    if (keyId != null && keys.keyIds.contains(keyId)) return false;
    if (keys.wasFetchedWithin(minRefetchInterval)) return false;

    var refreshed = await _loadPublicKeys(forceRefresh: true);
    if (identical(refreshed, keys)) return false;

    return jws.verify(refreshed.keyStore);
  }

  static Future<_AppleKeySet> _loadPublicKeys({
    bool forceRefresh = false,
  }) async {
    var publicKeys = _publicKeys;
    if (publicKeys != null && !forceRefresh && !publicKeys.isStale) {
      return publicKeys;
    }

    var failure = _lastFetchFailure;
    if (failure != null &&
        DateTime.now().toUtc().difference(failure.at) < _keyRefetchBackoff) {
      // Serve the previous key set rather than amplify an outage at Apple.
      if (publicKeys != null) return publicKeys;
      throw failure.error;
    }

    // Share the fetch, so a burst of unknown key ids reaches Apple once.
    return _inFlightFetch ??= _fetchAndCachePublicKeys();
  }

  static Future<_AppleKeySet> _fetchAndCachePublicKeys() async {
    try {
      var fetched = await _fetchPublicKeys();
      _lastFetchFailure = null;
      return _publicKeys = fetched;
    } on AppleIdentityTokenException catch (e) {
      _lastFetchFailure = (at: DateTime.now().toUtc(), error: e);

      // An outage at Apple must not take sign-in down with it.
      var cached = _publicKeys;
      if (cached != null) return cached;
      rethrow;
    } finally {
      _inFlightFetch = null;
    }
  }

  static Future<_AppleKeySet> _fetchPublicKeys() async {
    http.Response response;
    try {
      response = await http.get(_appleKeysUrl).timeout(_keyFetchTimeout);
    } catch (e) {
      throw AppleAuthUnavailableException(
        'Failed to fetch Apple public keys: $e',
      );
    }

    if (response.statusCode != 200) {
      throw AppleAuthUnavailableException(
        'Failed to fetch Apple public keys: HTTP ${response.statusCode}',
      );
    }

    try {
      var data = jsonDecode(response.body) as Map;
      return _AppleKeySet([
        for (Map key in data['keys'] as List)
          JsonWebKey.fromJson(key.cast<String, dynamic>()),
      ]);
    } catch (e) {
      throw AppleAuthUnavailableException(
        'Failed to parse Apple public keys: $e',
      );
    }
  }

  /// Apple sends the boolean claims of an identity token as either a JSON
  /// boolean or the strings `"true"`/`"false"`, depending on the flow.
  static bool _isTrueClaim(Object? value) => value == true || value == 'true';

  static DateTime? _timestamp(Object? value) {
    var seconds = switch (value) {
      int() => value,
      String() => int.tryParse(value),
      _ => null,
    };

    return seconds == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  }

  /// Drops the cached Apple public keys.
  @visibleForTesting
  static void resetPublicKeyCache() {
    _publicKeys = null;
    _lastFetchFailure = null;
    _inFlightFetch = null;
    minRefetchInterval = _defaultMinRefetchInterval;
  }
}

/// A snapshot of the keys Apple published, and when it was taken.
///
/// The keys are parsed once, when fetched: a snapshot verifies against the
/// same unchanging set for its whole life.
class _AppleKeySet {
  /// The keys, ready to verify a signature against.
  final JsonWebKeyStore keyStore;

  /// The ids of the keys in [keyStore], to tell a stale cache from a bad
  /// signature.
  final Set<String> keyIds;

  final DateTime fetchedAt;

  factory _AppleKeySet(List<JsonWebKey> keys) {
    var keyStore = JsonWebKeyStore();
    for (var key in keys) {
      keyStore.addKey(key);
    }

    return _AppleKeySet._(keyStore, {
      for (var key in keys)
        if (key.keyId case var keyId?) keyId,
    });
  }

  _AppleKeySet._(this.keyStore, this.keyIds)
      : fetchedAt = DateTime.now().toUtc();

  bool get isStale => !wasFetchedWithin(_keyCacheLifetime);

  bool wasFetchedWithin(final Duration duration) =>
      DateTime.now().toUtc().difference(fetchedAt) < duration;
}
