import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:x509/x509.dart';
import '../utils/error.dart';
import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import '../credential.dart';
import 'package:clock/clock.dart';
import 'package:openid_client/openid_client.dart' as openid;

/// Contains the properties necessary to use service-account JSON credentials.
class Certificate {
  final String? projectId;
  final JsonWebKey privateKey;
  final String clientEmail;

  Certificate(
      {this.projectId, required this.privateKey, required this.clientEmail});

  factory Certificate.fromPath(String filePath) {
    try {
      return Certificate.fromJson(
          json.decode(File(filePath).readAsStringSync()));
    } on FirebaseException {
      rethrow;
    } catch (error) {
      // Throw a nicely formed error message if the file contents cannot be parsed
      throw FirebaseAppError.invalidCredential(
        'Failed to parse certificate key file: $error',
      );
    }
  }

  factory Certificate.fromJson(Map<String, dynamic> json) {
    var privateKey = json['private_key'];
    if (privateKey is! String) privateKey = null;
    var clientEmail = json['client_email'];
    if (clientEmail is! String) clientEmail = null;

    var v = parsePem(privateKey).first;
    var keyPair = (v is PrivateKeyInfo) ? v.keyPair : (v as KeyPair?)!;
    var pKey = keyPair.privateKey as RsaPrivateKey;

    String bytesToBase64(List<int> bytes) {
      return base64Url.encode(bytes).replaceAll('=', '');
    }

    String intToBase64(BigInt v) {
      return bytesToBase64(v
          .toRadixString(16)
          .replaceAllMapped(RegExp('[0-9a-f]{2}'), (m) => '${m.group(0)},')
          .split(',')
          .where((v) => v.isNotEmpty)
          .map((v) => int.parse(v, radix: 16))
          .toList());
    }

    var k = JsonWebKey.fromJson({
      'kty': 'RSA',
      'n': intToBase64(pKey.modulus),
      'd': intToBase64(pKey.privateExponent),
      'p': intToBase64(pKey.firstPrimeFactor),
      'q': intToBase64(pKey.secondPrimeFactor),
      'alg': 'RS256',
      'kid': json['private_key_id']
    });

    return Certificate(
        projectId: json['project_id'], privateKey: k, clientEmail: clientEmail);
  }
}

/// Implementation of Credential that uses a service account certificate.
class ServiceAccountCredential extends _OpenIdCredential
    implements FirebaseCredential {
  @override
  final Certificate certificate;

  ServiceAccountCredential.fromJson(Map<String, dynamic> json)
      : certificate = Certificate.fromJson(json),
        super(json['client_id']!, null);

  factory ServiceAccountCredential(serviceAccountPathOrObject) {
    {
      if (serviceAccountPathOrObject is Map) {
        return ServiceAccountCredential.fromJson(
            serviceAccountPathOrObject.cast());
      }
      try {
        return ServiceAccountCredential.fromJson(
            json.decode(File(serviceAccountPathOrObject).readAsStringSync()));
      } on FirebaseException {
        rethrow;
      } catch (error) {
        // Throw a nicely formed error message if the file contents cannot be parsed
        throw FirebaseAppError.invalidCredential(
          'Failed to parse certificate key file: $error',
        );
      }
    }
  }

  String _createAuthJwt() {
    final claims = {
      'scope': [
        'https://www.googleapis.com/auth/cloud-platform',
        'https://www.googleapis.com/auth/firebase.database',
        'https://www.googleapis.com/auth/firebase.messaging',
        'https://www.googleapis.com/auth/identitytoolkit',
        'https://www.googleapis.com/auth/userinfo.email',
      ].join(' '),
      'aud': 'https://accounts.google.com/o/oauth2/token',
      'iss': certificate.clientEmail,
      'iat': clock.now().millisecondsSinceEpoch ~/ 1000,
      'exp': clock.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000
    };

    var builder = JsonWebSignatureBuilder()
      ..jsonContent = claims
      ..addRecipient(certificate.privateKey, algorithm: 'RS256');

    return builder.build().toCompactSerialization();
  }

  @override
  Future<openid.Credential> createCredential(openid.Client client) async {
    var flow = openid.Flow.jwtBearer(client);
    return await flow.callback({'jwt': _createAuthJwt(), 'state': flow.state});
  }
}

abstract class _OpenIdCredential implements Credential {
  final String clientId;
  final String? clientSecret;

  _OpenIdCredential(this.clientId, this.clientSecret);

  Future<openid.Credential> createCredential(openid.Client client);

  @override
  Future<AccessToken> getAccessToken() async {
    var issuer = await openid.Issuer.discover(openid.Issuer.google);
    var client = openid.Client(issuer, clientId, clientSecret: clientSecret);
    var response = await (await createCredential(client)).getTokenResponse();
    return _OpenIdAccessToken(openid.TokenResponse.fromJson({
      ...response.toJson(),
      'access_token': response.accessToken?.replaceAll(RegExp(r'\.*$'), '')
    }));
  }
}

class _OpenIdAccessToken implements AccessToken {
  final openid.TokenResponse _token;

  _OpenIdAccessToken(this._token);

  @override
  String get accessToken => _token.accessToken!;

  @override
  DateTime get expirationTime => _token.expiresAt!;
}

/// Internal interface for credentials that can both generate access tokens and
/// may have a Certificate associated with them.
abstract class FirebaseCredential implements Credential {
  Certificate get certificate;
}

/// Implementation of Credential that gets access tokens from refresh tokens.
class RefreshTokenCredential extends _OpenIdCredential {
  final String refreshToken;
  final http.Client httpClient = http.Client();

  RefreshTokenCredential(Map<String, dynamic> json)
      : refreshToken = json['refresh_token'],
        super(json['client_id'], json['client_secret']);

  @override
  Future<openid.Credential> createCredential(openid.Client client) async {
    return client.createCredential(refreshToken: refreshToken);
  }
}
