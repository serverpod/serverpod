import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;
import 'package:http/http.dart' as http;
import 'package:synchronized/synchronized.dart';

/// Utility class for verifying Firebase ID tokens.
///
/// This implementation follows the pattern from Google's ID token verification,
/// fetching public keys from Firebase's certificate endpoint and validating
/// JWT claims.
class FirebaseIdTokenVerifier {
  /// The URL that provides public certificates for verifying ID tokens issued
  /// by Firebase Authentication.
  static const String _certsUrl =
      'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com';

  /// How long before the cache should be updated again.
  static const _cacheExpirationInterval = Duration(hours: 1);

  /// Interval between failed cache update attempts.
  static const _cacheUpdateFailedInterval = Duration(minutes: 10);

  /// Maximum number of failed attempts to update the cache before giving up.
  static const _cacheUpdateMaxFailedAttempts = 5;

  /// Cached key set for Firebase ID tokens.
  static _CachedKeySet _cachedKeySet = _CachedKeySet({});

  /// Lock to prevent concurrent cache updates.
  static final _lock = Lock();

  /// Verifies an ID Token issued by Firebase Authentication.
  ///
  /// 1. Decodes and verifies the JWT signature
  /// 2. Validates standard claims (exp, iat, aud, sub)
  /// 3. Validates the issuer is from Firebase for the given project
  ///
  /// The [projectId] parameter is used to validate both the audience and issuer
  /// claims of the token.
  ///
  /// Can throw [FirebaseIdTokenValidationServerException] in case of any
  /// validation failures.
  static Future<Map<String, dynamic>> verifyIdToken(
    final String idToken, {
    required final String projectId,
  }) async {
    final idInfo = await _verifyToken(
      idToken,
      audience: projectId,
    );

    final expectedIssuer = 'https://securetoken.google.com/$projectId';
    final issuer = idInfo['iss'] as String?;
    if (issuer == null || issuer != expectedIssuer) {
      throw FirebaseIdTokenValidationServerException(
        'Invalid issuer: expected $expectedIssuer',
      );
    }

    return idInfo;
  }

  /// Internal method to verify token signature and basic claims.
  static Future<Map<String, dynamic>> _verifyToken(
    final String idToken, {
    required final String audience,
  }) async {
    final keys = await _getKeys();

    dart_jsonwebtoken.JWT? verifiedJwt;
    dart_jsonwebtoken.JWTException? lastException;

    for (final key in keys.values) {
      try {
        verifiedJwt = dart_jsonwebtoken.JWT.verify(idToken, key);
        break;
      } on dart_jsonwebtoken.JWTException catch (e) {
        lastException = e;
        continue;
      }
    }

    if (verifiedJwt == null) {
      throw FirebaseIdTokenValidationServerException(
        'Failed to verify token signature: ${lastException?.message ?? "No keys available"}',
      );
    }

    final payload = verifiedJwt.payload as Map<String, dynamic>;
    _validateClaims(payload, audience: audience);
    return payload;
  }

  /// Fetches Firebase's public certificates for JWT verification.
  ///
  /// Certificates are cached for 1 hour to reduce network requests. If the
  /// request fails, the cache update is postponed for 10 minutes up to 5 times.
  /// If the request fails 5 times, throws
  /// [FirebaseIdTokenValidationServerException].
  static Future<Map<String, dart_jsonwebtoken.JWTKey>> _getKeys() async {
    if (!_cachedKeySet.shouldUpdate) {
      return _cachedKeySet.keys;
    }

    await _lock.synchronized(() async {
      if (!_cachedKeySet.shouldUpdate) return;
      await _updateCachedKeySet();
    });

    return _cachedKeySet.keys;
  }

  static Future<void> _updateCachedKeySet() async {
    final response = await http.get(Uri.parse(_certsUrl));
    if (response.statusCode != 200) {
      if (_cachedKeySet.postponeExpiration()) return;
      throw FirebaseIdTokenValidationServerException(
        'Failed to fetch certificates',
      );
    }

    // Firebase returns a map of kid -> PEM certificate
    final certsJson = jsonDecode(response.body) as Map<String, dynamic>;

    final keys = <String, dart_jsonwebtoken.JWTKey>{};
    for (final entry in certsJson.entries) {
      try {
        final pem = entry.value as String;
        final key = dart_jsonwebtoken.RSAPublicKey.cert(pem);
        keys[entry.key] = key;
      } catch (e) {
        // Skip invalid keys
        continue;
      }
    }

    if (keys.isEmpty) {
      throw FirebaseIdTokenValidationServerException(
        'No valid keys could be parsed from certificates',
      );
    }

    _cachedKeySet = _CachedKeySet(keys);
  }

  static void _validateClaims(
    final Map<String, dynamic> claims, {
    required final String audience,
  }) {
    final now = const Clock().now();

    final exp = claims['exp'] as int?;
    if (exp == null) {
      throw FirebaseIdTokenValidationServerException('Missing expiry claim');
    }
    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    if (expiry.isBefore(now)) {
      throw FirebaseIdTokenValidationServerException('Token expired');
    }

    final iat = claims['iat'] as int?;
    if (iat == null) {
      throw FirebaseIdTokenValidationServerException('Missing issued at claim');
    }
    final issuedAt = DateTime.fromMillisecondsSinceEpoch(
      iat * 1000,
      isUtc: true,
    );
    if (issuedAt.isAfter(now)) {
      throw FirebaseIdTokenValidationServerException('Invalid issued at time');
    }

    final aud = claims['aud'];
    final audienceMatches = aud is String
        ? aud == audience
        : aud is List && aud.contains(audience);
    if (!audienceMatches) {
      throw FirebaseIdTokenValidationServerException('Audience does not match');
    }

    final sub = claims['sub'] as String?;
    if (sub == null || sub.isEmpty) {
      throw FirebaseIdTokenValidationServerException('Missing subject');
    }

    // Firebase-specific: subject must be 128 characters or less
    if (sub.length > 128) {
      throw FirebaseIdTokenValidationServerException('Invalid subject length');
    }

    // Firebase-specific: auth_time must be present and in the past
    final authTime = claims['auth_time'] as int?;
    if (authTime == null) {
      throw FirebaseIdTokenValidationServerException(
        'Missing auth_time claim',
      );
    }
    final authDateTime = DateTime.fromMillisecondsSinceEpoch(
      authTime * 1000,
      isUtc: true,
    );
    if (authDateTime.isAfter(now)) {
      throw FirebaseIdTokenValidationServerException('Invalid auth_time');
    }
  }
}

/// Cached key set for Firebase ID tokens.
///
/// Controls the logic for updating the cache, checking if it should be updated,
/// and providing a map of key IDs to [JWTKey] for verification.
class _CachedKeySet {
  final Map<String, dart_jsonwebtoken.JWTKey> _keys;
  DateTime expiry;
  int failedAttempts = 0;

  _CachedKeySet(this._keys) : expiry = _newExpiry();

  static DateTime _newExpiry({final bool postpone = false}) {
    final interval = postpone
        ? FirebaseIdTokenVerifier._cacheUpdateFailedInterval
        : FirebaseIdTokenVerifier._cacheExpirationInterval;
    return DateTime.now().add(interval);
  }

  bool get shouldUpdate => _keys.isEmpty || expiry.isBefore(DateTime.now());

  bool postponeExpiration() {
    if (failedAttempts >=
        FirebaseIdTokenVerifier._cacheUpdateMaxFailedAttempts) {
      return false;
    }
    expiry = _newExpiry(postpone: true);
    failedAttempts++;
    return true;
  }

  Map<String, dart_jsonwebtoken.JWTKey> get keys {
    if (_keys.isEmpty) {
      throw StateError('No keys available');
    }
    return _keys;
  }
}

/// Exception thrown when the Firebase ID token validation fails.
class FirebaseIdTokenValidationServerException implements Exception {
  /// The exception message that was thrown.
  final String message;

  /// Creates a new instance.
  FirebaseIdTokenValidationServerException(this.message);
}
