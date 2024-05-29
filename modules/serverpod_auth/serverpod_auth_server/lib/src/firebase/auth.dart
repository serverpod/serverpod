import 'package:googleapis_auth/auth_io.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/auth/auth_account_api.dart';
import 'package:serverpod_auth_server/src/firebase/auth/auth_http_client.dart';
import 'package:serverpod_auth_server/src/firebase/auth/token_verifier.dart';

// void main() async {
//   var jsonPath =
//       '/Users/kkucaj/Desktop/my-atelier-prod-firebase-adminsdk-969n0-5e54519c4d.json';

//   var idToken =
//       'eyJhbGciOiJSUzI1NiIsImtpZCI6IjVkNjE3N2E5Mjg2ZDI1Njg0NTI2OWEzMTM2ZDNmNjY0MjZhNGQ2NDIiLCJ0eXAiOiJKV1QifQ.eyJyZXZlbnVlQ2F0RW50aXRsZW1lbnRzIjpbXSwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL215LWF0ZWxpZXItcHJvZCIsImF1ZCI6Im15LWF0ZWxpZXItcHJvZCIsImF1dGhfdGltZSI6MTcxNDU4MTExNSwidXNlcl9pZCI6Ik9sNko0MmRnSzNaRDlhUFpqQ3RSRHJBM1d0cjEiLCJzdWIiOiJPbDZKNDJkZ0szWkQ5YVBaakN0UkRyQTNXdHIxIiwiaWF0IjoxNzE2OTg5NjM5LCJleHAiOjE3MTY5OTMyMzksImVtYWlsIjoia2t1Y2FqLmNvbnRhY3RAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsia2t1Y2FqLmNvbnRhY3RAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.FYMWvemm90NWenaHGSGM_d_e2rxszpGD1GiRZNUBi6oinBKO7h4Efwu2mCSM_OGdlqJo18u1vjILFAOmhmetoyjsWXya-vfy3uoVu8XKJ0nl5yyrFbfU2Qv7gYef_-rcDRnREmKXKGEh_66d2FJiW_mIdlXI3UJ-snCOVBJ4XpPmGTmYrAglJXNw787dlu9C-AsvVugSYReuHTRK6ZSthrGIqDGC4dt5_rLO981nGRCtVL9EH9KS9KatdLTotYUtuWV0mcLZ9xqo_zli_aClXeVlsaUR_RjIg9b0GlBZZuV7tEtiSxw-xIaROp5ct5cXuCeaKRGFiiaZX9iPjnejMQ';
//   await Auth.instance.init(jsonPath);

//   var token = await Auth.instance.verifyIdToken(idToken);
//   print(token.toCompactSerialization());
// }

/// Firebase Auth Manager
class Auth {
  TokenVerifier? _tokenVerifier;
  AuthRequestApi? _accountApi;

  /// Firebase Auth initialization with firebaseServiceAccountKeyJson
  Future<void> init(
    Map<String, dynamic> json, {
    AuthBaseClient? authBaseClient,
    Client? openIdClient,
  }) async {
    var projectId = json['project_id'];
    if (projectId == null) {
      throw Exception('Invalid Project ID');
    }

    var client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(json),
      [
        'https://www.googleapis.com/auth/cloud-platform',
        'https://www.googleapis.com/auth/identitytoolkit',
        'https://www.googleapis.com/auth/userinfo.email',
      ],
      baseClient: authBaseClient ?? AuthBaseClient(),
    );

    _tokenVerifier = TokenVerifier(
      projectId: projectId,
      client: openIdClient,
    );

    _accountApi = AuthRequestApi(
      projectId: projectId,
      client: client,
    );
  }

  /// Firebase JWT verifier
  Future<IdToken> verifyIdToken(
    String idToken, [
    bool checkRevoked = false,
  ]) async {
    if (_accountApi == null || _tokenVerifier == null) {
      throw Exception('FirebaseAdmin not initialized!');
    }
    var decodedIdToken = await _tokenVerifier!.verifyJwt(idToken);
    // Whether to check if the token was revoked.
    if (!checkRevoked) {
      return decodedIdToken;
    }
    return _verifyDecodedJwtNotRevoked(decodedIdToken);
  }

  Future<IdToken> _verifyDecodedJwtNotRevoked(
    IdToken decodedIdToken,
  ) async {
    // Get tokens valid after time for the corresponding user.
    var user = await _accountApi!.getUserByUiid(decodedIdToken.claims.subject);
    // If no tokens valid after time available, token is not revoked.
    if (user.validSince != null) {
      // Get the ID token authentication time.
      var authTimeUtc = decodedIdToken.claims.authTime!;
      // Get user tokens valid after time.
      var validSinceUtc = DateTime.fromMicrosecondsSinceEpoch(
        (num.parse(user.validSince!) * 1000).toInt(),
      );
      // Check if authentication time is older than valid since time.
      if (authTimeUtc.isBefore(validSinceUtc)) {
        throw Exception('The Firebase ID token has been revoked.');
      }
    }
    // All checks above passed. Return the decoded token.
    return decodedIdToken;
  }
}
