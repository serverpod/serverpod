// https://github.com/appsup-dart/firebase_admin/blob/master/lib/src/auth/token_verifier.dart Licenced under Apache License.

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

import 'package:openid_client/openid_client_io.dart';
import 'package:serverpod_auth_server/src/firebase/exceptions/firebase_exception.dart';
import 'package:http/http.dart' as http;

/// JWT verifier
class TokenVerifier {
  final String _projectId;
  final http.Client? _httpClient;
  Client? _openIdClient;

  /// Creates a new [TokenVerifier] object with a [projectId] and [Client]
  TokenVerifier({
    required String projectId,
    http.Client? httpClient,
  })  : _projectId = projectId,
        _httpClient = httpClient;

  /// Verifies the format and signature of a Firebase Auth JWT token.
  Future<IdToken> verifyJwt(String jwtToken) async {
    var client = await _getOpenIdClient();

    var credential = client.createCredential(idToken: jwtToken);

    try {
      await for (var e in credential.validateToken()) {
        throw FirebaseJWTException(
          'Validating ID token failed: $e',
        );
      }
    } on ArgumentError catch (e) {
      throw FirebaseJWTFormatException(
        'JWT Argument Error: $e',
      );
    } on FormatException catch (e) {
      throw FirebaseJWTFormatException(
        'JWT Format Exception: $e',
      );
    }

    if (!_isUid(credential.idToken.claims.subject)) {
      throw FirebaseJWTException(
        'ID token has "sub" (subject) claim which is not a valid uid',
      );
    }

    return credential.idToken;
  }

  /// Creates a new openid [Client] object
  Future<Client> _getOpenIdClient() async {
    var client = _openIdClient;
    if (client != null) return client;

    var issuer = await Issuer.discover(
      Issuer.firebase(_projectId),
      httpClient: _httpClient,
    );
    client = Client(
      issuer,
      _projectId,
      httpClient: _httpClient,
    );

    _openIdClient = client;
    return client;
  }

  /// Validates that a string is a valid Firebase Auth uid.
  bool _isUid(String? uid) {
    return uid != null && uid.isNotEmpty && uid.length <= 128;
  }
}
