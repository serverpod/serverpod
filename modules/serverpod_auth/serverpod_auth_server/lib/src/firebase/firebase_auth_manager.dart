import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/auth/auth_account_api.dart';
import 'package:serverpod_auth_server/src/firebase/auth/token_verifier.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';

/// Firebase Auth Manager
class FirebaseAuthManager {
  TokenVerifier? _tokenVerifier;
  AuthRequestApi? _accountApi;

  /// Firebase Auth initialization with firebaseServiceAccountKeyJson
  Future<void> init(
    Map<String, dynamic> json, {
    http.Client? authClient,
    http.Client? openIdClient,
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
      baseClient: authClient,
    );

    _tokenVerifier = TokenVerifier(
      projectId: projectId,
      httpClient: openIdClient,
    );

    _accountApi = AuthRequestApi(
      projectId: projectId,
      client: client,
    );
  }

  /// Firebase JWT verifier
  Future<IdToken> verifyIdToken(
    String idToken,
  ) async {
    if (_accountApi == null || _tokenVerifier == null) {
      throw FirebasInitException('FirebaseAdmin not initialized!');
    }
    var decodedIdToken = await _tokenVerifier!.verifyJwt(idToken);
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
      var validSinceUtc = DateTime.fromMillisecondsSinceEpoch(
        num.parse(user.validSince!).toInt(),
      );
      // Check if authentication time is older than valid since time.
      if (authTimeUtc.isBefore(validSinceUtc)) {
        throw FirebaseJWTException('The Firebase ID token has been revoked.');
      }
    }
    // All checks above passed. Return the decoded token.
    return decodedIdToken;
  }
}
