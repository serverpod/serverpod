import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/business/apple_auth.dart';
import 'package:serverpod_auth_server/src/business/user_authentication.dart';

import '../business/users.dart';
import '../generated/protocol.dart';

const _authMethod = 'apple';

/// Endpoint for handling Sign in with Apple.
class AppleEndpoint extends Endpoint {
  /// Authenticates a user with Apple.
  Future<AuthenticationResponse> authenticate(
    Session session,
    AppleAuthInfo authInfo,
  ) async {
    AppleIdentityToken identityToken;
    try {
      identityToken = await AppleAuth.verifyIdentityToken(
        authInfo.identityToken,
      );
    } on AppleAuthUnavailableException catch (e) {
      // Our failure, not the caller's, so it must not log at debug.
      session.log(e.message, level: LogLevel.error);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.internalError,
      );
    } on AppleIdentityTokenException catch (e) {
      session.log(
        'Sign in with Apple rejected: ${e.message}',
        level: LogLevel.debug,
      );
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var userIdentifier = authInfo.userIdentifier;
    if (userIdentifier != identityToken.subject) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var email = authInfo.email?.toLowerCase();
    if (email != null && email != identityToken.email) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    // An unverified address identifies nobody, so treat it as no address.
    if (email != null && !identityToken.isEmailVerified) {
      session.log(
        'Ignoring unverified Apple email claim',
        level: LogLevel.debug,
      );
      email = null;
    }

    var fullName = authInfo.fullName;
    var name = authInfo.nickname;

    UserInfo? userInfo;
    if (email != null) userInfo = await Users.findUserByEmail(session, email);
    userInfo ??= await Users.findUserByIdentifier(session, userIdentifier);
    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: userIdentifier,
        userName: name,
        fullName: fullName,
        email: email,
        blocked: false,
        created: DateTime.now().toUtc(),
        scopeNames: [],
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
  }
}
