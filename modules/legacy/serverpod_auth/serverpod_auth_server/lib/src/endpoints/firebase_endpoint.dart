import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_server/src/business/firebase_auth.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_auth_manager.dart';

const _authMethod = 'firebase';

/// Endpoint for handling Sign in with Firebase.
class FirebaseEndpoint extends Endpoint {
  /// Authenticate a user with a Firebase id token.
  Future<AuthenticationResponse> authenticate(
    Session session,
    String idToken,
  ) async {
    FirebaseAuthManager authManager;
    session.log('Firebase authenticate', level: LogLevel.debug);
    try {
      authManager = await FirebaseAuth.authManager;
    } catch (e, stackTrace) {
      session.log(
        'Failed to create Firebase app. Have you correctly configured the service account key?',
        level: LogLevel.error,
        stackTrace: stackTrace,
        exception: e,
      );

      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.internalError,
      );
    }

    session.log('Created Auth object', level: LogLevel.debug);

    try {
      var token = await authManager.verifyIdToken(idToken);
      session.log('Verified idToken', level: LogLevel.debug);
      var claims = token.claims;

      // An unverified address identifies nobody, so treat it as no address.
      // Read the claims raw, since openid_client's getters cast them
      // unchecked, and accept the string form the Apple path also accepts.
      var claimedEmail = claims['email'];
      var claimedVerified = claims['email_verified'];
      var verified = claimedVerified == true || claimedVerified == 'true';
      var email = verified && claimedEmail is String
          ? claimedEmail.toLowerCase()
          : null;
      if (email == null && claimedEmail != null) {
        session.log(
          'Ignoring unverified Firebase email claim',
          level: LogLevel.debug,
        );
      }
      var userIdentifier = token.claims.subject;
      var fullName = token.claims.name;
      var userName = token.claims.nickname ?? email?.split('@').firstOrNull;
      userName ??= fullName ?? '';

      session.log('Got email: $email', level: LogLevel.debug);
      session.log('Got userIdentifier: $userIdentifier', level: LogLevel.debug);

      UserInfo? userInfo;
      if (email != null) {
        userInfo = await Users.findUserByEmail(session, email);
      }
      userInfo ??= await Users.findUserByIdentifier(session, userIdentifier);
      if (userInfo == null) {
        userInfo = UserInfo(
          userIdentifier: userIdentifier,
          userName: userName,
          fullName: fullName,
          email: email,
          created: DateTime.now().toUtc(),
          scopeNames: [],
          blocked: false,
        );
        userInfo = await Users.createUser(session, userInfo, _authMethod);
      }

      if (userInfo == null) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.userCreationDenied,
        );
      } else if (userInfo.blocked) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.blocked,
        );
      }

      var authKey = await UserAuthentication.signInUser(
        session,
        userInfo.id!,
        _authMethod,
        scopes: userInfo.scopes,
      );

      return AuthenticationResponse(
        success: true,
        keyId: authKey.id,
        key: authKey.key,
        userInfo: userInfo,
      );
    } catch (e) {
      session.log(
        'Authentication failed with exception.',
        exception: e,
        level: LogLevel.error,
      );
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }
  }
}
