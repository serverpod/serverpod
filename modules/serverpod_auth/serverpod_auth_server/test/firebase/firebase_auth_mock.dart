import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';

class FirebaseAuthBackendMock {
  final Map<String, dynamic> userJson;

  FirebaseAuthBackendMock({
    required this.userJson,
  });

  /// Returns Firebase Mock Authentication Token
  http.Response _getAuthenticationToken(
    http.Request request,
  ) {
    Map<String, String> body = Uri.splitQueryString(request.body);
    return http.Response(
      jsonEncode({
        'access_token': body['assertion'],
        'expires_in': 3599,
        'token_type': 'Bearer',
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  /// Returns Firebase Mock Users filtering by [localeId]/[uid]
  http.Response _getUsersByLocaleId(
    http.Request request,
  ) {
    Map<String, dynamic> body = jsonDecode(request.body);
    List<String> localeId = List<String>.from(body['localId'] ?? []);

    List<dynamic> users = [];
    if (localeId.contains(userJson['localId'])) {
      users.add(userJson);
    }

    return http.Response(
      jsonEncode({
        'kind': 'identitytoolkit#GetAccountInfoResponse',
        'users': users,
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  Future<http.Response> onHttpCall(
    http.Request request,
  ) async {
    if (request.url.path.endsWith('token')) {
      return _getAuthenticationToken(request);
    }

    return _getUsersByLocaleId(request);
  }
}

class FirebaseOpenIdBackendMock {
  /// Mocks the firebase project OpenId configurations
  Map<String, dynamic> get _getOpenIdConfiguration {
    return {
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
                    'kid': testAccountServiceJson['private_key_id'],
                  }
                ]
              }),
              mimeType: 'application/json')
          .toString(),
      'response_types_supported': ['id_token'],
      'subject_types_supported': ['public'],
      'id_token_signing_alg_values_supported': ['RS256']
    };
  }

  Future<http.Response> onHttpCall(
    http.Request request,
  ) async {
    return http.Response(
      jsonEncode(_getOpenIdConfiguration),
      200,
      headers: {'content-type': 'application/json'},
      request: http.Request(
        request.method,
        request.url,
      ),
    );
  }
}

String generateMockIdToken({
  required String uid,
  Map<String, dynamic>? overrides,
}) {
  overrides ??= {};
  var key = JsonWebKey.fromJson({
    'kty': 'RSA',
    'n':
        'wJENcRev-eXZKvhhWLiV3Lz2MvO-naQRHo59g3vaNQnbgyduN_L4krlrJ5c6FiikXdtJNb_QrsAHSyJWCu8j3T9CruiwbidGAk2W0RuViTVspjHUTsIHExx9euWM0UomGvYkoqXahdhPL_zViVSJt-Rt8bHLsMvpb8RquTIb9iKY3SMV2tCofNmyCSgVbghq_y7lKORtV_IRguWs6R22fbkb0r2MCYoNAbZ9dqnbRIFNZBC7itYtUoTEresRWcyFMh0zfAIJycWOJlVLDLqkY2SmIx8u7fuysCg1wcoSZoStuDq02nZEMw1dx8HGzE0hynpHlloRLByuIuOAfMCCYw',
    'd':
        'MW2KG7tOykA7TBJROmq23OAL-ewiw2f3lPZSNUu3KOIM3E9ktSvCrja10IW6vTFVb1n4IrnHoPNda-W2XDwh4op4XVkQ4FVoXPL5gVcpPPzflJE5w7V-B2PKuZ7uVFJKEaWYpb8Ypj5tpQ2q6gMvDmqt5doTRKAynSO3mS3Ji5XG-EsN5XiibDa7rBqgaSJ-wabyViK-DmXdVHvDYhU69hlO3gG5JhXA4z6qPBpLW-0vuC_RJSOuPzklrrMRFF0WIhMOFnDqey9pyv3_79q630Rov-ShJJvraDl-e1AwTChPiFGeM-cB52aisz1GF12HZMHdkpMFsw3W1STd8nE64Q',
    'p':
        '-z6leSaAcZ3qvwpntcXSpwwJ0SSmzLTH2RJNf-Ld3eBHiSvLTG53dWB7lJtF4R1KcIwf-KGcOFJvsnepzcZBylRvT8RrAAkV0s9OiVm1lXZyaepbLg4GGFJBPi8A6VIAj7zYknToRApdW0s1x_XXChewfJDckqsevTMovdbg8Yk',
    'q':
        'xDYX-3mfvv_opo6HNNY3SfVunM-4vVJL-n8gWZ2w9kz3Q9Ub9YbRmI7iQaiVkO5xNuoG1n9bM-3Mnm84aQ1YeNT01YqeyQsipP5Wi-um0PzYTaBw9RO-8Gh6992OwlJiRtFk5WjalNWOxY4MU0ImnJwIfKQlUODvLmcixm68NYs',
    'alg': 'RS256',
    'kid': testAccountServiceJson['private_key_id'],
  });

  var projectId = testAccountServiceJson['project_id'];

  var builder = JsonWebSignatureBuilder()
    ..jsonContent = {
      'aud': projectId,
      'exp':
          DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
              1000,
      'iss': 'https://securetoken.google.com/$projectId',
      'sub': uid,
      'auth_time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ...overrides,
    }
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

Map<String, dynamic> crateUserRecord({
  required String uuid,
  required DateTime validSince,
}) =>
    {
      'localId': uuid,
      'email': 'user@gmail.com',
      'emailVerified': true,
      'displayName': 'John Doe',
      'phoneNumber': '+11234567890',
      'providerUserInfo': [
        {
          'providerId': 'google.com',
          'displayName': 'John Doe',
          'photoUrl': 'https://lh3.googleusercontent.com/1234567890/photo.jpg',
          'federatedId': '1234567890',
          'email': 'user@gmail.com',
          'rawId': '1234567890',
        },
      ],
      'photoUrl': 'https://lh3.googleusercontent.com/1234567890/photo.jpg',
      'validSince': '${validSince.millisecondsSinceEpoch}',
      'lastLoginAt': '1476235905000',
      'createdAt': '1476136676000',
    };
