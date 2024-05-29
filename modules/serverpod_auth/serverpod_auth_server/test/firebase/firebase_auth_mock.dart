import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import 'package:mockito/mockito.dart';
import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/auth/auth_http_client.dart';
import 'package:rsa_pkcs/rsa_pkcs.dart';

class MockAuthBaseClient extends Mock implements AuthBaseClient {
  @override
  Future<http.StreamedResponse> send(
    http.BaseRequest baseRequest,
  ) async {
    var bodyBytes = await baseRequest.finalize().toBytes();
    var request = http.Request(baseRequest.method, baseRequest.url)
      ..persistentConnection = baseRequest.persistentConnection
      ..followRedirects = baseRequest.followRedirects
      ..maxRedirects = baseRequest.maxRedirects
      ..headers.addAll(baseRequest.headers)
      ..bodyBytes = bodyBytes
      ..finalize();

    if (request.url.path.endsWith('token')) {
      Map<String, String> body = Uri.splitQueryString(request.body);
      return http.StreamedResponse(
        http.ByteStream.fromBytes(
          jsonEncode(
            {
              'access_token': body['assertion'],
              'expires_in': 3599,
              'token_type': 'Bearer',
            },
          ).runes.toList(),
        ),
        200,
        headers: {'content-type': 'application/json'},
      );
    }

    Map<String, dynamic> body = jsonDecode(request.body);
    List<String> localeId = List<String>.from(body['localeId'] ?? []);
    if (localeId.contains('abcdefghijklmnopqrstuvwxyz')) {
      return http.StreamedResponse(
        http.ByteStream.fromBytes(
          jsonEncode({
            'kind': 'identitytoolkit#GetAccountInfoResponse',
            'users': []
          }).runes.toList(),
        ),
        200,
        headers: {'content-type': 'application/json'},
      );
    }

    return http.StreamedResponse(
      http.ByteStream.fromBytes(
        jsonEncode(
          {
            'kind': 'identitytoolkit#GetAccountInfoResponse',
            'users': [
              {
                'localId': 'abcdefghijklmnopqrstuvwxyz',
                'email': 'user@gmail.com',
                'emailVerified': true,
                'displayName': 'John Doe',
                'phoneNumber': '+11234567890',
                'providerUserInfo': [
                  {
                    'providerId': 'google.com',
                    'displayName': 'John Doe',
                    'photoUrl':
                        'https://lh3.googleusercontent.com/1234567890/photo.jpg',
                    'federatedId': '1234567890',
                    'email': 'user@gmail.com',
                    'rawId': '1234567890',
                  },
                  {
                    'providerId': 'facebook.com',
                    'displayName': 'John Smith',
                    'photoUrl': 'https://facebook.com/0987654321/photo.jpg',
                    'federatedId': '0987654321',
                    'email': 'user@facebook.com',
                    'rawId': '0987654321',
                  },
                  {
                    'providerId': 'phone',
                    'phoneNumber': '+11234567890',
                    'rawId': '+11234567890',
                  },
                ],
                'photoUrl':
                    'https://lh3.googleusercontent.com/1234567890/photo.jpg',
                'validSince': '1476136676',
                'lastLoginAt': '1476235905000',
                'createdAt': '1476136676000',
              }
            ],
          },
        ).runes.toList(),
      ),
      200,
      headers: {'content-type': 'application/json'},
    );
  }
}

class MockTokenClient extends Mock implements Client {
  final Issuer _mIssuer;
  final String _projectId;

  @override
  Issuer get issuer => _mIssuer;

  @override
  String get clientId => _projectId;

  MockTokenClient({
    required Issuer issuer,
    required String projectId,
  })  : _mIssuer = issuer,
        _projectId = projectId;

  @override
  Credential createCredential({
    String? accessToken,
    String? tokenType,
    String? refreshToken,
    Duration? expiresIn,
    DateTime? expiresAt,
    String? idToken,
  }) {
    return Credential.fromJson({
      'client_id': clientId,
      'issuer': issuer.metadata.toJson(),
      'token': TokenResponse.fromJson(
        {
          'access_token': accessToken,
          'token_type': tokenType,
          'refresh_token': refreshToken,
          'id_token': idToken,
          if (expiresIn != null) 'expires_in': expiresIn.inSeconds,
          if (expiresAt != null)
            'expires_at': expiresAt.millisecondsSinceEpoch ~/ 1000
        },
      ).toJson(),
    });
  }
}

String generateMockIdToken({
  required String projectId,
  required String uid,
  Map<String, dynamic>? overrides,
}) {
  overrides ??= {};

  var claims = {
    'aud': projectId,
    'exp': clock.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
        1000,
    'iss': 'https://securetoken.google.com/$projectId',
    'sub': uid,
    'auth_time': clock.now().millisecondsSinceEpoch ~/ 1000,
    ...overrides,
  };

  var key = getTestJsonWebKey();

  var builder = JsonWebSignatureBuilder()
    ..jsonContent = claims
    ..setProtectedHeader('kid', key.keyId)
    ..addRecipient(
      key,
      algorithm: 'RS256',
    );
  return builder.build().toCompactSerialization();
}

Map<String, dynamic> testAccountServiceJson = {
  'type': 'service_account',
  'project_id': 'project_id',
  'private_key_id': 'aaaaaaaaaabbbbbbbbbbccccccccccdddddddddd',
  'private_key':
      '-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAwJENcRev+eXZKvhhWLiV3Lz2MvO+naQRHo59g3vaNQnbgyduN/L4krlr\nJ5c6FiikXdtJNb/QrsAHSyJWCu8j3T9CruiwbidGAk2W0RuViTVspjHUTsIHExx9euWM0Uom\nGvYkoqXahdhPL/zViVSJt+Rt8bHLsMvpb8RquTIb9iKY3SMV2tCofNmyCSgVbghq/y7lKORt\nV/IRguWs6R22fbkb0r2MCYoNAbZ9dqnbRIFNZBC7itYtUoTEresRWcyFMh0zfAIJycWOJlVL\nDLqkY2SmIx8u7fuysCg1wcoSZoStuDq02nZEMw1dx8HGzE0hynpHlloRLByuIuOAfMCCYwID\nAQABAoIBADFtihu7TspAO0wSUTpqttzgC/nsIsNn95T2UjVLtyjiDNxPZLUrwq42tdCFur0x\nVW9Z+CK5x6DzXWvltlw8IeKKeF1ZEOBVaFzy+YFXKTz835SROcO1fgdjyrme7lRSShGlmKW/\nGKY+baUNquoDLw5qreXaE0SgMp0jt5ktyYuVxvhLDeV4omw2u6waoGkifsGm8lYivg5l3VR7\nw2IVOvYZTt4BuSYVwOM+qjwaS1vtL7gv0SUjrj85Ja6zERRdFiITDhZw6nsvacr9/+/aut9E\naL/koSSb62g5fntQMEwoT4hRnjPnAedmorM9Rhddh2TB3ZKTBbMN1tUk3fJxOuECgYEA+z6l\neSaAcZ3qvwpntcXSpwwJ0SSmzLTH2RJNf+Ld3eBHiSvLTG53dWB7lJtF4R1KcIwf+KGcOFJv\nsnepzcZBylRvT8RrAAkV0s9OiVm1lXZyaepbLg4GGFJBPi8A6VIAj7zYknToRApdW0s1x/XX\nChewfJDckqsevTMovdbg8YkCgYEAxDYX+3mfvv/opo6HNNY3SfVunM+4vVJL+n8gWZ2w9kz3\nQ9Ub9YbRmI7iQaiVkO5xNuoG1n9bM+3Mnm84aQ1YeNT01YqeyQsipP5Wi+um0PzYTaBw9RO+\n8Gh6992OwlJiRtFk5WjalNWOxY4MU0ImnJwIfKQlUODvLmcixm68NYsCgYEAuAqI3jkk55Vd\nKvotREsX5wP7gPePM+7NYiZ1HNQL4Ab1f/bTojZdTV8Sx6YCR0fUiqMqnE+OBvfkGGBtw22S\nLesx6sWf99Ov58+x4Q0U5dpxL0Lb7d2Z+2Dtp+Z4jXFjNeeI4ae/qG/LOR/b0pE0J5F415ap\n7Mpq5v89vepUtrkCgYAjMXytu4v+q1Ikhc4UmRPDrUUQ1WVSd+9u19yKlnFGTFnRjej86hiw\nH3jPxBhHra0a53EgiilmsBGSnWpl1WH4EmJz5vBCKUAmjgQiBrueIqv9iHiaTNdjsanUyaWw\njyxXfXl2eI80QPXh02+8g1H/pzESgjK7Rg1AqnkfVH9nrwKBgQDJVxKBPTw9pigYMVt9iHrR\niCl9zQVjRMbWiPOc0J56+/5FZYm/AOGl9rfhQ9vGxXZYZiOP5FsNkwt05Y1UoAAH4B4VQwbL\nqod71qOcI0ywgZiIR87CYw40gzRfjWnN+YEEW1qfyoNLilEwJB8iB/T+ZePHGmJ4MmQ/cTn9\nxpdLXA==\n-----END RSA PRIVATE KEY-----\n',
  'client_email': 'foo@project_id.iam.gserviceaccount.com',
  'client_id': 'client_id'
};

JsonWebKey getTestJsonWebKey() {
  RSAPKCSParser parser = RSAPKCSParser();
  RSAKeyPair pair = parser.parsePEM(testAccountServiceJson['private_key']);
  RSAPrivateKey? pKey = pair.private;

  return JsonWebKey.fromJson({
    'kty': 'RSA',
    'n': intToBase64(pKey!.modulus),
    'd': intToBase64(pKey.privateExponent),
    'p': intToBase64(pKey.prime1),
    'q': intToBase64(pKey.prime2),
    'alg': 'RS256',
    'kid': testAccountServiceJson['private_key_id']
  });
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

String bytesToBase64(List<int> bytes) {
  return base64Url.encode(bytes).replaceAll('=', '');
}

Issuer getTestIssuer() {
  var config = <String, dynamic>{
    'issuer': 'https://securetoken.google.com/project_id',
    'jwks_uri': Uri.dataFromString(
            json.encode({
              'keys': [
                {
                  'kty': 'RSA',
                  'n':
                      'wJENcRev-eXZKvhhWLiV3Lz2MvO-naQRHo59g3vaNQnbgyduN_L4krlrJ5c6FiikXdtJNb_QrsAHSyJWCu8j3T9CruiwbidGAk2W0RuViTVspjHUTsIHExx9euWM0UomGvYkoqXahdhPL_zViVSJt-Rt8bHLsMvpb8RquTIb9iKY3SMV2tCofNmyCSgVbghq_y7lKORtV_IRguWs6R22fbkb0r2MCYoNAbZ9dqnbRIFNZBC7itYtUoTEresRWcyFMh0zfAIJycWOJlVLDLqkY2SmIx8u7fuysCg1wcoSZoStuDq02nZEMw1dx8HGzE0hynpHlloRLByuIuOAfMCCYw',
                  'e': 'AQAB',
                  'alg': 'RS256',
                  'kid': 'aaaaaaaaaabbbbbbbbbbccccccccccdddddddddd'
                }
              ]
            }),
            mimeType: 'application/json')
        .toString(),
    'response_types_supported': ['id_token'],
    'subject_types_supported': ['public'],
    'id_token_signing_alg_values_supported': ['RS256']
  };

  return Issuer(OpenIdProviderMetadata.fromJson(config));
}
