import 'package:openid_client/openid_client.dart';

import '../firebase_admin.dart';
import '../app/app_extension.dart';
import 'package:meta/meta.dart';
import '../utils/validator.dart' as validator;

/// Class for verifying general purpose Firebase JWTs.
///
/// This verifies ID tokens and session cookies.
class FirebaseTokenVerifier {
  /// Firebase App
  final App app;

  final String _jwtName = 'ID token';

  /// Creates a [FirebaseTokenVerifier] singletone object
  static FirebaseTokenVerifier Function(App app) factory =
      (app) => FirebaseTokenVerifier(app);

  /// Creates a new [FirebaseTokenVerifier] with an [App]
  FirebaseTokenVerifier(this.app);

  /// Verifies the format and signature of a Firebase Auth JWT token.
  Future<IdToken> verifyJwt(String jwtToken) async {
    var client = await getOpenIdClient();

    var credential = client.createCredential(idToken: jwtToken);

    await for (var e in credential.validateToken()) {
      throw FirebaseAuthError.invalidArgument(
        'Validating $_jwtName failed: $e',
      );
    }

    if (!validator.isUid(credential.idToken.claims.subject)) {
      throw FirebaseAuthError.invalidArgument(
        '$_jwtName has "sub" (subject) claim which is not a valid uid',
      );
    }

    return credential.idToken;
  }

  /// Creates a new openid [Client] object
  @visibleForTesting
  Future<Client> getOpenIdClient() async {
    var issuer = await Issuer.discover(Issuer.firebase(app.projectId));
    return Client(issuer, app.projectId);
  }
}
