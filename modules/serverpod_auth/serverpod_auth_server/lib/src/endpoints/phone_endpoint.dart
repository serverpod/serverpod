// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

/// Endpoint for handling Sign in with phone number.
class PhoneEndpoint extends Endpoint {
  /// Authenticates a user with phone number and password. Returns an
  /// [AuthenticationResponse] with the users information.
  Future<AuthenticationResponse> authenticate(
    Session session,
    String phoneNumber,
    String password,
  ) async {
    return Phones.authenticate(session, phoneNumber, password);
  }

  /// Changes a users password.
  Future<bool> changePassword(
      Session session, String oldPassword, String newPassword) async {
    var userId = (await session.authenticated)?.userId;
    if (userId == null) return false;

    return Phones.changePassword(session, userId, oldPassword, newPassword);
  }

  /// Initiates a password reset and sends an sms with the reset code to the
  /// user.
  Future<bool> initiatePasswordReset(Session session, String phoneNumber) {
    return Phones.initiatePasswordReset(session, phoneNumber);
  }

  /// Resets a users password using the reset code.
  Future<bool> resetPassword(
      Session session, String verificationCode, String password) {
    return Phones.resetPassword(session, verificationCode, password);
  }

  /// Starts the procedure for creating an account by sending an sms with
  /// a verification code.
  Future<bool> createAccountRequest(
    Session session,
    String userName,
    String phoneNumber,
    String password,
  ) async {
    return await Phones.createAccountRequest(
      session,
      userName,
      phoneNumber,
      password,
    );
  }

  /// Creates a new account using a verification code.
  Future<UserInfo?> createAccount(
    Session session,
    String phoneNumber,
    String verificationCode,
  ) async {
    var request = await Phones.findAccountRequest(session, phoneNumber);
    if (request == null) {
      return null;
    }
    if (request.verificationCode != verificationCode) {
      return null;
    }

    // Phone number is verified, create a new user
    return await Phones.createUser(
      session,
      request.userName,
      phoneNumber,
      null,
      request.hash,
    );
  }
}
