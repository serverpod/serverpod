import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../business/exceptions.dart';

/// Mints Google OAuth access tokens from a service account, with single-flight
/// refresh so concurrent sends share one token request.
class FcmOauthTokenSource {
  /// Firebase service-account credentials used to sign the JWT.
  final FirebaseServiceAccountCredentials credentials;

  final http.Client _httpClient;
  final Duration _refreshSkew;

  Future<String>? _inFlight;
  String? _accessToken;
  DateTime? _expiresAt;

  /// OAuth scope required by FCM HTTP v1.
  static const scope = 'https://www.googleapis.com/auth/firebase.messaging';

  /// Creates a token source.
  FcmOauthTokenSource({
    required this.credentials,
    required final http.Client httpClient,
    final Duration refreshSkew = const Duration(minutes: 1),
  }) : _httpClient = httpClient,
       _refreshSkew = refreshSkew;

  /// Returns a valid access token, refreshing if needed.
  Future<String> accessToken() {
    final token = _accessToken;
    final expiresAt = _expiresAt;
    if (token != null &&
        expiresAt != null &&
        clock.now().toUtc().isBefore(expiresAt.subtract(_refreshSkew))) {
      return Future.value(token);
    }

    return _inFlight ??= _refresh().whenComplete(() {
      _inFlight = null;
    });
  }

  Future<String> _refresh() async {
    if (!credentials.canSign) {
      throw const PushMissingCredentialsException(
        'fcm',
        'client_email and private_key are required to mint an FCM access token.',
      );
    }

    final assertion = JWT(
      {
        'scope': scope,
        'aud': credentials.tokenUri,
      },
      issuer: credentials.clientEmail,
    ).sign(
      RSAPrivateKey(credentials.privateKey!),
      algorithm: JWTAlgorithm.RS256,
      expiresIn: const Duration(hours: 1),
    );

    final response = await _httpClient.post(
      Uri.parse(credentials.tokenUri),
      headers: const {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': assertion,
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PushMissingCredentialsException(
        'fcm',
        'OAuth token endpoint returned HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const PushMissingCredentialsException(
        'fcm',
        'OAuth token endpoint returned a non-object body.',
      );
    }
    final accessToken = body['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw const PushMissingCredentialsException(
        'fcm',
        'OAuth token endpoint did not return access_token.',
      );
    }

    final expiresIn = body['expires_in'];
    final lifetime = expiresIn is int
        ? Duration(seconds: expiresIn)
        : const Duration(hours: 1);

    _accessToken = accessToken;
    _expiresAt = clock.now().toUtc().add(lifetime);
    return accessToken;
  }
}
