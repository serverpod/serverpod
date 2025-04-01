// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

/// Endpoint for handling authentication via email and password
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
    Session session,
    String oldPassword,
    String newPassword,
  ) async {
    var userId = (await session.authenticated)?.userId;
    if (userId == null) return false;

    return Emails.changePassword(session, userId, oldPassword, newPassword);
  }

  /// Initiates a password reset and sends an email with the reset code to the
  /// user.
  Future<bool> initiatePasswordReset(Session session, String email) {
    return Emails.initiatePasswordReset(session, email);
  }

  /// Resets a users password using the reset code.
  Future<bool> resetPassword(
    Session session,
    String verificationCode,
    String password,
  ) {
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
    return await Emails.tryCreateAccount(
      session,
      email: email,
      verificationCode: verificationCode,
    );
  }
}
