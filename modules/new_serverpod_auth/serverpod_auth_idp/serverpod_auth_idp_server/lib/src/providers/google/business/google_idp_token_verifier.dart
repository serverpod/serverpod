import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

/// Utility class for verifying Google ID tokens.
///
/// This implementation follows the pattern from Google's official
/// google-auth-library-python, specifically the `verify_oauth2_token` method.
/// For reference, see:
/// https://github.com/googleapis/google-auth-library-python/blob/main/google/oauth2/id_token.py
class GoogleIdTokenVerifier {
  /// The URL that provides public certificates for verifying ID tokens issued
  /// by Google's OAuth 2.0 authorization server.
  static const String _certsUrl = 'https://www.googleapis.com/oauth2/v3/certs';

  /// Valid Google issuers for OAuth 2.0 tokens.
  static const List<String> _googleIssuers = [
    'accounts.google.com',
    'https://accounts.google.com',
  ];

  /// How long before the cache should be updated again.
  static const _cacheExpirationInterval = Duration(hours: 1);

  /// Interval between failed cache update attempts.
  static const _cacheUpdateFailedInterval = Duration(minutes: 10);

  /// Maximum number of failed attempts to update the cache before giving up.
  static const _cacheUpdateMaxFailedAttempts = 5;

  /// Cached key set for Google ID tokens.
  static _CachedKeySet _cachedKeySet = _CachedKeySet([]);

  /// Mutex lock to prevent concurrent cache updates.
  static Future<void>? _ongoingCacheUpdate;

  /// Verifies an ID Token issued by Google's OAuth 2.0 authorization server.
  ///
  /// 1. Decodes and verifies the JWT signature
  /// 2. Validates standard claims (exp, iat, aud, sub)
  /// 3. Validates the issuer is from Google
  ///
  /// The [audience] parameter represent the client ID of the application that
  /// the ID token is intended for. If null then the audience is not verified.
  /// Can throw [GoogleIdTokenValidationServerException] in case of any validation
  /// failures.
  static Future<Map<String, dynamic>> verifyOAuth2Token(
    final String idToken, {
    final String? audience,
  }) async {
    final idInfo = await _verifyToken(
      idToken,
      audience: audience,
    );

    final issuer = idInfo['iss'] as String?;
    if (issuer == null || !_googleIssuers.contains(issuer)) {
      throw GoogleIdTokenValidationServerException('Invalid issuer');
    }

    return idInfo;
  }

  /// Internal method to verify token signature and basic claims.
  static Future<Map<String, dynamic>> _verifyToken(
    final String idToken, {
    final String? audience,
  }) async {
    final keys = await _getKeys();

    JWT? verifiedJwt;
    JWTException? lastException;

    for (final key in keys) {
      try {
        verifiedJwt = JWT.verify(idToken, key);
        break;
      } on JWTException catch (e) {
        lastException = e;
        continue;
      }
    }

    if (verifiedJwt == null) {
      throw GoogleIdTokenValidationServerException(
        'Failed to verify token signature: ${lastException?.message ?? "No keys available"}',
      );
    }

    final payload = verifiedJwt.payload as Map<String, dynamic>;
    _validateClaims(payload, audience: audience);
    return payload;
  }

  /// Fetches Google's public certificates for JWT verification.
  ///
  /// Certificates are cached for 1 hour to reduce network requests. If the
  /// request fails, the cache update is postponed for 10 minutes up to 5 times.
  /// If the request fails 5 times, throws [GoogleIdTokenValidationServerException].
  static Future<List<JWTKey>> _getKeys() async {
    if (!_cachedKeySet.shouldUpdate) {
      return _cachedKeySet.keys;
    }

    final ongoingCacheUpdate = _ongoingCacheUpdate;
    if (ongoingCacheUpdate != null) {
      await ongoingCacheUpdate;
      return _cachedKeySet.keys;
    }

    _ongoingCacheUpdate = _updateCachedKeySet();
    try {
      await _ongoingCacheUpdate;
    } finally {
      _ongoingCacheUpdate = null;
    }
    return _cachedKeySet.keys;
  }

  static Future<void> _updateCachedKeySet() async {
    final response = await http.get(Uri.parse(_certsUrl));
    if (response.statusCode != 200) {
      if (_cachedKeySet.postponeExpiration()) return;
      throw GoogleIdTokenValidationServerException(
        'Failed to fetch certificates',
      );
    }

    final jwksJson = jsonDecode(response.body) as Map<String, dynamic>;
    final jwksList = (jwksJson['keys'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    final keys = <JWTKey>[];
    for (final jwk in jwksList) {
      try {
        final key = JWTKey.fromJWK(jwk);
        keys.add(key);
      } catch (e) {
        // Skip invalid keys
        continue;
      }
    }

    if (keys.isEmpty) {
      throw GoogleIdTokenValidationServerException(
        'No valid keys could be parsed from JWKs',
      );
    }

    _cachedKeySet = _CachedKeySet(keys);
  }

  static void _validateClaims(
    final Map<String, dynamic> claims, {
    final String? audience,
  }) {
    final now = const Clock().now();

    final exp = claims['exp'] as int?;
    if (exp == null) {
      throw GoogleIdTokenValidationServerException('Missing expiry claim');
    }
    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    if (expiry.isBefore(now)) {
      throw GoogleIdTokenValidationServerException('Token expired');
    }

    final iat = claims['iat'] as int?;
    if (iat == null) {
      throw GoogleIdTokenValidationServerException('Missing issued at claim');
    }
    final issuedAt = DateTime.fromMillisecondsSinceEpoch(
      iat * 1000,
      isUtc: true,
    );
    if (issuedAt.isAfter(now)) {
      throw GoogleIdTokenValidationServerException('Invalid issued at time');
    }

    if (audience != null) {
      final aud = claims['aud'];
      final audienceMatches = aud is String
          ? aud == audience
          : aud is List && aud.contains(audience);
      if (!audienceMatches) {
        throw GoogleIdTokenValidationServerException('Audience does not match');
      }
    }

    final sub = claims['sub'] as String?;
    if (sub == null || sub.isEmpty) {
      throw GoogleIdTokenValidationServerException('Missing subject');
    }
  }
}

/// Cached key set for Google ID tokens.
///
/// Controls the logic for updating the cache, checking if it should be updated,
/// and providing a list of [JWTKey] for verification.
class _CachedKeySet {
  final List<JWTKey> _keys;
  DateTime expiry;
  int failedAttempts = 0;

  _CachedKeySet(this._keys) : expiry = _newExpiry();

  static DateTime _newExpiry({final bool postpone = false}) {
    final interval = postpone
        ? GoogleIdTokenVerifier._cacheUpdateFailedInterval
        : GoogleIdTokenVerifier._cacheExpirationInterval;
    return DateTime.now().add(interval);
  }

  bool get shouldUpdate => _keys.isEmpty || expiry.isBefore(DateTime.now());

  bool postponeExpiration() {
    if (failedAttempts >= GoogleIdTokenVerifier._cacheUpdateMaxFailedAttempts) {
      return false;
    }
    expiry = _newExpiry(postpone: true);
    failedAttempts++;
    return true;
  }

  List<JWTKey> get keys {
    if (_keys.isEmpty) {
      throw StateError('No keys available');
    }
    return _keys;
  }
}

/// Exception thrown when the Google ID token validation fails.
class GoogleIdTokenValidationServerException implements Exception {
  /// The exception message that was thrown.
  final String message;

  /// Creates a new instance.
  GoogleIdTokenValidationServerException(this.message);
}
