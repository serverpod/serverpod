import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:serverpod_auth_server/src/business/firebase_auth.dart';

const _authMethod = 'firebase';

/// Endpoint for handling Sign in with Firebase.
class FirebaseEndpoint extends Endpoint {
  /// Authenticate a user with a Firebase id token.
  Future<AuthenticationResponse> authenticate(
    Session session,
    String idToken,
  ) async {
    Auth auth;
    session.log('Firebase authenticate', level: LogLevel.debug);
    try {
      auth = FirebaseAuth.app.auth();
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
      var token = await auth.verifyIdToken(idToken, true);
      session.log('Verified idToken', level: LogLevel.debug);
      var claims = token.claims;

      // Verify that we at a minimum got the email address.
      if (claims.email == null) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.invalidCredentials,
        );
      }

      var email = claims.email!.toLowerCase();
      var userIdentifier = token.claims.subject;
      var userName = token.claims.nickname ?? email.split('@')[0];
      var fullName = token.claims.name;

      session.log('Got email: $email', level: LogLevel.debug);
      session.log('Got userIdentifier: $email', level: LogLevel.debug);

      UserInfo? userInfo;
      userInfo = await Users.findUserByEmail(session, email);
      userInfo ??= await Users.findUserByIdentifier(session, userIdentifier);
      if (userInfo == null) {
        userInfo = UserInfo(
          userIdentifier: userIdentifier,
          userName: userName,
          fullName: fullName,
          email: email,
          created: DateTime.now().toUtc(),
          scopeNames: [],
          banned: false,
        );
        userInfo = await Users.createUser(session, userInfo, _authMethod);
      }

      if (userInfo == null) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.userCreationDenied,
        );
      } else if (userInfo.banned) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.banned,
        );
      }

      var authKey = await session.auth.signInUser(userInfo.id!, _authMethod);

      return AuthenticationResponse(
        success: true,
        keyId: authKey.id,
        key: authKey.key,
        userInfo: userInfo,
      );
    } catch (e) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }
  }
}
