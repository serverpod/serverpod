// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

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
    return Emails.authenticate(session, email, password);
  }

  /// Changes a users password.
  Future<bool> changePassword(
      Session session, String oldPassword, String newPassword) async {
    var userId = await session.auth.authenticatedUserId;
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
    var request = await Emails.findAccountRequest(session, email);
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
