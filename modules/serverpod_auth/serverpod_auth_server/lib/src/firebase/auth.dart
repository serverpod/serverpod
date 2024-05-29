import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/auth/auth_account_api.dart';
import 'package:serverpod_auth_server/src/firebase/auth/auth_http_client.dart';
import 'package:serverpod_auth_server/src/firebase/auth/token_verifier.dart';

void main() async {
  var jsonPath =
      '/Users/kkucaj/Desktop/my-atelier-prod-firebase-adminsdk-969n0-5e54519c4d.json';

  var idToken =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IjVkNjE3N2E5Mjg2ZDI1Njg0NTI2OWEzMTM2ZDNmNjY0MjZhNGQ2NDIiLCJ0eXAiOiJKV1QifQ.eyJyZXZlbnVlQ2F0RW50aXRsZW1lbnRzIjpbXSwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL215LWF0ZWxpZXItcHJvZCIsImF1ZCI6Im15LWF0ZWxpZXItcHJvZCIsImF1dGhfdGltZSI6MTcxNDU4MTExNSwidXNlcl9pZCI6Ik9sNko0MmRnSzNaRDlhUFpqQ3RSRHJBM1d0cjEiLCJzdWIiOiJPbDZKNDJkZ0szWkQ5YVBaakN0UkRyQTNXdHIxIiwiaWF0IjoxNzE2OTgyMzAzLCJleHAiOjE3MTY5ODU5MDMsImVtYWlsIjoia2t1Y2FqLmNvbnRhY3RAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsia2t1Y2FqLmNvbnRhY3RAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.te6R4P0way7EHT5XZvVnCjPVbU8UWPISFcMY4DHTByww_k4PpGh7esAvxcKok0jd3xK3uIJ-njAlI5TzYKlp7rFZKklm6ocrHndEJxYga3spQmi0E5xwh3L_9aTw2CFCutFl6zO4d8Mm5gyMFwH1ACFCGt1bYn4kmwJExEwJ_DBKeK4SjO6aou6xafNYW7zVky3h4m7NyP-PxiQ53QspHPYMHfuCmSCrCZJPzKvIT662LLoA0a1g4ZGxNx2VJGKQrT0WOB6zfv5H1KjR6ViDwcqAqF-2xNgnm41Rl8LKzkhZWkMtrEBxvOo3ILLTrrfchr2XqwElYt8kWkQZOQSFlA';
  await Auth.instance.init(jsonPath);

  var token = await Auth.instance.verifyIdToken(idToken);
  print(token.toCompactSerialization());
}

/// Firebase Auth Manager
class Auth {
  /// Firebase Singletone Auth
  static Auth instance = Auth._init();

  TokenVerifier? _tokenVerifier;
  AuthRequestApi? _accountApi;

  Auth._init();

  /// Firebase Auth initialization with firebaseServiceAccountKeyJson
  Future<void> init(
    String firebaseServiceAccountKeyJson, {
    AuthBaseClient? authBaseClient,
    Client? openIdClient,
  }) async {
    Map<String, dynamic> json = jsonDecode(
      await File(firebaseServiceAccountKeyJson).readAsString(),
    );

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
