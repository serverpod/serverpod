import 'package:openid_client/openid_client.dart';

import 'package:meta/meta.dart';
import 'package:serverpod_auth_server/src/firebase/app.dart';

/// Class for verifying general purpose Firebase JWTs.
///
/// This verifies ID tokens and session cookies.
class FirebaseTokenVerifier {
  final App app;

  final String _jwtName = 'ID token';

  static FirebaseTokenVerifier Function(App app) factory =
      (app) => FirebaseTokenVerifier(app);

  FirebaseTokenVerifier(this.app);

  /// Validates that a string is a valid Firebase Auth uid.
  bool _isUid(String? uid) {
    return uid != null && uid.isNotEmpty && uid.length <= 128;
  }

  /// Verifies the format and signature of a Firebase Auth JWT token.
  Future<IdToken> verifyJwt(String jwtToken) async {
    var client = await getOpenIdClient();

    var credential = client.createCredential(idToken: jwtToken);

    await for (var e in credential.validateToken()) {
      throw Exception(
        'Validating $_jwtName failed: $e',
      );
    }

    if (!_isUid(credential.idToken.claims.subject)) {
      throw Exception(
        '$_jwtName has "sub" (subject) claim which is not a valid uid',
      );
    }

    return credential.idToken;
  }

  @visibleForTesting
  Future<Client> getOpenIdClient() async {
    var issuer = await Issuer.discover(Issuer.firebase(app.options.projectId));
    return Client(issuer, app.options.projectId);
  }
}
