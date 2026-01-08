import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;
import 'package:http/http.dart' as http;

import 'id_token_verifier_config.dart';

/// Generic utility class for verifying ID tokens from various providers.
///
/// This implementation supports multiple identity providers through the
/// [IdTokenVerifierConfig] interface. Each provider type maintains its own
/// certificate cache.
class IdTokenVerifier {
  /// How long before the cache should be updated again.
  static const _cacheExpirationInterval = Duration(hours: 1);

  /// Interval between failed cache update attempts.
  static const _cacheUpdateFailedInterval = Duration(minutes: 10);

  /// Maximum number of failed attempts to update the cache before giving up.
  static const _cacheUpdateMaxFailedAttempts = 5;

  /// Cached key sets per config type.
  static final Map<Type, _CachedKeySet> _cacheRegistry = {};

  /// Ongoing cache updates per config type (mutex).
  static final Map<Type, Future<void>?> _ongoingUpdates = {};

  /// Verifies an ID token using the provided configuration.
  ///
  /// 1. Decodes and verifies the JWT signature
  /// 2. Validates standard claims (exp, iat, sub)
  /// 3. Validates provider-specific claims via the config
  ///
  /// The [audience] parameter is passed to the config for audience validation.
  /// Its interpretation depends on the provider (e.g., projectId for Firebase,
  /// clientId for Google).
  ///
  /// Throws an exception created by the config in case of any validation
  /// failures.
  static Future<Map<String, dynamic>> verifyOAuth2Token(
    final String idToken, {
    required final IdTokenVerifierConfig config,
    final String? audience,
  }) async {
    final keys = await _getKeys(config);

    dart_jsonwebtoken.JWT? verifiedJwt;
    dart_jsonwebtoken.JWTException? lastException;

    for (final key in keys) {
      try {
        verifiedJwt = dart_jsonwebtoken.JWT.verify(idToken, key);
        break;
      } on dart_jsonwebtoken.JWTException catch (e) {
        lastException = e;
        continue;
      }
    }

    if (verifiedJwt == null) {
      throw config.createException(
        'Failed to verify token signature: ${lastException?.message ?? "No keys available"}',
      );
    }

    final payload = verifiedJwt.payload as Map<String, dynamic>;
    _validateClaims(payload, config: config, audience: audience);
    return payload;
  }

  /// Fetches public certificates for JWT verification.
  ///
  /// Certificates are cached for 1 hour to reduce network requests. If the
  /// request fails, the cache update is postponed for 10 minutes up to 5 times.
  static Future<Iterable<dart_jsonwebtoken.JWTKey>> _getKeys(
    final IdTokenVerifierConfig config,
  ) async {
    final configType = config.runtimeType;
    final cachedKeySet = _cacheRegistry[configType];

    if (cachedKeySet != null && !cachedKeySet.shouldUpdate) {
      return cachedKeySet.keys;
    }

    final ongoingUpdate = _ongoingUpdates[configType];
    if (ongoingUpdate != null) {
      await ongoingUpdate;
      return _cacheRegistry[configType]!.keys;
    }

    _ongoingUpdates[configType] = _updateCachedKeySet(config);
    try {
      await _ongoingUpdates[configType];
    } finally {
      _ongoingUpdates[configType] = null;
    }
    return _cacheRegistry[configType]!.keys;
  }

  static Future<void> _updateCachedKeySet(
    final IdTokenVerifierConfig config,
  ) async {
    final configType = config.runtimeType;
    final response = await http.get(Uri.parse(config.certsUrl));

    if (response.statusCode != 200) {
      final existingCache = _cacheRegistry[configType];
      if (existingCache != null && existingCache.postponeExpiration()) {
        return;
      }
      throw config.createException('Failed to fetch certificates');
    }

    final keys = config.parseKeys(response.body).toList();

    if (keys.isEmpty) {
      throw config.createException(
        'No valid keys could be parsed from certificates',
      );
    }

    _cacheRegistry[configType] = _CachedKeySet(keys);
  }

  static void _validateClaims(
    final Map<String, dynamic> claims, {
    required final IdTokenVerifierConfig config,
    required final String? audience,
  }) {
    final now = const Clock().now();

    final exp = claims['exp'] as int?;
    if (exp == null) {
      throw config.createException('Missing expiry claim');
    }
    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    if (expiry.isBefore(now)) {
      throw config.createException('Token expired');
    }

    final iat = claims['iat'] as int?;
    if (iat == null) {
      throw config.createException('Missing issued at claim');
    }
    final issuedAt = DateTime.fromMillisecondsSinceEpoch(
      iat * 1000,
      isUtc: true,
    );
    if (issuedAt.isAfter(now)) {
      throw config.createException('Invalid issued at time');
    }

    final sub = claims['sub'] as String?;
    if (sub == null || sub.isEmpty) {
      throw config.createException('Missing subject');
    }

    config.validateAudience(claims, audience);
    config.validateIssuer(claims);
    config.validateExtraClaims(claims, now);
  }
}

/// Cached key set for ID tokens.
///
/// Controls the logic for updating the cache, checking if it should be updated,
/// and providing the keys for verification.
class _CachedKeySet {
  final List<dart_jsonwebtoken.JWTKey> _keys;
  DateTime expiry;
  int failedAttempts = 0;

  _CachedKeySet(this._keys) : expiry = _newExpiry();

  static DateTime _newExpiry({final bool postpone = false}) {
    final interval = postpone
        ? IdTokenVerifier._cacheUpdateFailedInterval
        : IdTokenVerifier._cacheExpirationInterval;
    return DateTime.now().add(interval);
  }

  bool get shouldUpdate => _keys.isEmpty || expiry.isBefore(DateTime.now());

  bool postponeExpiration() {
    if (failedAttempts >= IdTokenVerifier._cacheUpdateMaxFailedAttempts) {
      return false;
    }
    expiry = _newExpiry(postpone: true);
    failedAttempts++;
    return true;
  }

  List<dart_jsonwebtoken.JWTKey> get keys {
    if (_keys.isEmpty) {
      throw StateError('No keys available');
    }
    return _keys;
  }
}
