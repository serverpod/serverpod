import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/auth/account_api.dart';
import 'package:serverpod_auth_server/src/firebase/auth/token_verifier.dart';

class Auth {
  static Auth instance = Auth._init();

  TokenVerifier? _tokenVerifier;
  AccountApi? _accountApi;

  Auth._init();

  Future<void> init(
    String firebaseServiceAccountKeyJson, {
    AuthClient? authClient,
    Client? tokenClient,
  }) async {
    Map<String, dynamic> json = jsonDecode(
      await File(firebaseServiceAccountKeyJson).readAsString(),
    );

    var projectId = json['project_id'];
    if (projectId == null) {
      throw Exception('Invalid Project ID');
    }

    var accountClient = authClient ??
        await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(json),
          [
            'https://www.googleapis.com/auth/cloud-platform',
            'https://www.googleapis.com/auth/identitytoolkit',
            'https://www.googleapis.com/auth/userinfo.email',
          ],
        );

    _tokenVerifier = TokenVerifier(
      projectId,
      client: tokenClient,
    );
    _accountApi = AccountApi(
      projectId,
      accountClient,
    );
  }

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
