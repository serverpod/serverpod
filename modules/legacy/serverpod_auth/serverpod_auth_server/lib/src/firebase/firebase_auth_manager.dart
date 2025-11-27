// https://github.com/appsup-dart/firebase_admin/blob/master/lib/src/auth.dart Licenced under Apache License.

// Copyright (c) 2020, Rik Bellens.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/auth/auth_account_api.dart';
import 'package:serverpod_auth_server/src/firebase/auth/token_verifier.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';

/// Firebase Auth Manager
class FirebaseAuthManager {
  late final TokenVerifier _tokenVerifier;
  late final AuthRequestApi _accountApi;

  /// Creates a new [FirebaseAuthManager] object with the given configs
  FirebaseAuthManager(
    Map<String, dynamic> firebaseServiceAccountJson, {
    http.Client? authClient,
    http.Client? openIdClient,
  }) {
    if (firebaseServiceAccountJson.isEmpty) {
      throw FirebaseInitException('Invalid Firebase Account Service Json');
    }

    var projectId = firebaseServiceAccountJson['project_id'] as String?;
    if (projectId == null || projectId.isEmpty) {
      throw FirebaseInitException('Invalid Firebase Project ID');
    }

    try {
      _accountApi = AuthRequestApi(
        projectId: projectId,
        credentials: ServiceAccountCredentials.fromJson(
          firebaseServiceAccountJson,
        ),
        httClient: authClient,
      );
    } on ArgumentError catch (e) {
      throw FirebaseInitException(
        'Firebase Initialization Argument Error: $e',
      );
    }

    _tokenVerifier = TokenVerifier(
      projectId: projectId,
      httpClient: openIdClient,
    );
  }

  /// Firebase JWT verifier
  Future<IdToken> verifyIdToken(
    String idToken,
  ) async {
    var decodedIdToken = await _tokenVerifier.verifyJwt(idToken);
    return _verifyDecodedJwtNotRevoked(decodedIdToken);
  }

  Future<IdToken> _verifyDecodedJwtNotRevoked(
    IdToken decodedIdToken,
  ) async {
    // Get tokens valid after time for the corresponding user.
    var user = await _accountApi.getUserByUiid(decodedIdToken.claims.subject);

    // If no tokens valid after time available, token is not revoked.
    if (user.validSince == null) return decodedIdToken;

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
    // All checks above passed. Return the decoded token.
    return decodedIdToken;
  }
}
