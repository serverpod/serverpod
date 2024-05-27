import 'package:openid_client/openid_client.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';
import 'package:serverpod_auth_server/src/firebase/auth/token_verifier.dart';

import 'auth/auth_api_request.dart';
import 'service.dart';

export 'auth/user_record.dart';

/// The Firebase Auth service interface.
class Auth implements FirebaseService {
  @override
  final App app;

  final AuthRequestHandler _authRequestHandler;
  final FirebaseTokenVerifier _tokenVerifier;

  /// Do not call this constructor directly. Instead, use app().auth.
  Auth(this.app)
      : _authRequestHandler = AuthRequestHandler(app),
        _tokenVerifier = FirebaseTokenVerifier.factory(app);

  /// Gets the user data for the user corresponding to a given [uid].
  Future<UserRecord> getUser(String uid) async {
    return await _authRequestHandler.getAccountInfoByUid(uid);
  }

  /// Verifies a Firebase ID token (JWT).
  ///
  /// If the token is valid, the returned [Future] is completed with an instance
  /// of [IdToken]; otherwise, the future is completed with an error.
  /// An optional flag can be passed to additionally check whether the ID token
  /// was revoked.
  Future<IdToken> verifyIdToken(String idToken,
      [bool checkRevoked = false]) async {
    var decodedIdToken = await _tokenVerifier.verifyJwt(idToken);
    // Whether to check if the token was revoked.
    if (!checkRevoked) {
      return decodedIdToken;
    }
    return _verifyDecodedJwtNotRevoked(decodedIdToken);
  }

  /// Verifies the decoded Firebase issued JWT is not revoked. Returns a future
  /// that resolves with the decoded claims on success. Rejects the future with
  /// revocation error if revoked.
  Future<IdToken> _verifyDecodedJwtNotRevoked(IdToken decodedIdToken) async {
    // Get tokens valid after time for the corresponding user.
    var user = await getUser(decodedIdToken.claims.subject);
    // If no tokens valid after time available, token is not revoked.
    if (user.tokensValidAfterTime != null) {
      // Get the ID token authentication time.
      var authTimeUtc = decodedIdToken.claims.authTime!;
      // Get user tokens valid after time.
      var validSinceUtc = user.tokensValidAfterTime!;
      // Check if authentication time is older than valid since time.
      if (authTimeUtc.isBefore(validSinceUtc)) {
        throw FirebaseAuthError.idTokenRevoked();
      }
    }
    // All checks above passed. Return the decoded token.
    return decodedIdToken;
  }
}
