// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/protocol.dart';
import '../../module.dart';

// const _configFilePath = 'config/google_client_secret.json';

/// Endpoint for handling Sign in with Google.
class EmailEndpoint extends Endpoint {
  /// Authenticates a user with email and password. Returns an
  /// [AuthenticationResponse] with the users information.
  Future<AuthenticationResponse> authenticate(
    Session session,
    String email,
    String password,
  ) async {
    email = email.toLowerCase();
    password = password.trim();

    session.log('authenticate $email / $password', level: LogLevel.debug);

    // Fetch password entry
    EmailAuth? entry = await session.db.findSingleRow<EmailAuth>(
      where: EmailAuth.t.email.equals(email),
    );
    if (entry == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - found entry ', level: LogLevel.debug);

    // Check that password is correct
    if (entry.hash != Emails.generatePasswordHash(password, email)) {
      session.log(
          ' - ${Emails.generatePasswordHash(password, email)} saved: ${entry.hash}',
          level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - password is correct, userId: ${entry.userId})',
        level: LogLevel.debug);

    UserInfo? userInfo = await Users.findUserByUserId(session, entry.userId);
    if (userInfo == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - user found', level: LogLevel.debug);

    // Sign in user and return user info
    AuthKey auth = await session.auth.signInUser(
      entry.userId,
      'email',
      scopes: userInfo.scopes,
    );

    session.log(' - user signed in', level: LogLevel.debug);

    return AuthenticationResponse(
      success: true,
      userInfo: userInfo,
      key: auth.key,
      keyId: auth.id,
    );
  }

  /// Changes a users password.
  Future<bool> changePassword(
      Session session, String oldPassword, String newPassword) async {
    int? userId = await session.auth.authenticatedUserId;
    if (userId == null) return false;

    return Emails.changePassword(session, userId, oldPassword, newPassword);
  }

  /// Initiates a password reset and sends an email with the reset code to the
  /// user.
  Future<bool> initiatePasswordReset(Session session, String email) {
    return Emails.initiatePasswordReset(session, email);
  }

  /// Verifies a password reset code, if successful returns an
  /// [EmailPasswordReset] object, otherwise returns null.
  Future<EmailPasswordReset?> verifyEmailPasswordReset(
    Session session,
    String verificationCode,
  ) {
    return Emails.verifyEmailPasswordReset(session, verificationCode);
  }

  /// Resets a users password using the reset code.
  Future<bool> resetPassword(
      Session session, String verificationCode, String password) {
    return Emails.resetPassword(session, verificationCode, password);
  }

  /// Starts the procedure for creating an account by sending an email with
  /// a verification code.
  Future<bool> createAccountRequest(
    Session session,
    String userName,
    String email,
    String password,
  ) async {
    return await Emails.createAccountRequest(
      session,
      userName,
      email,
      password,
    );
  }

  /// Creates a new account using a verification code.
  Future<UserInfo?> createAccount(
    Session session,
    String email,
    String verificationCode,
  ) async {
    EmailCreateAccountRequest? request =
        await Emails.findAccountRequest(session, email);
    if (request == null) {
      return null;
    }
    if (request.verificationCode != verificationCode) {
      return null;
    }

    // Email is verified, create a new user
    return await Emails.createUser(
      session,
      request.userName,
      email,
      null,
      request.hash,
    );
  }
}
