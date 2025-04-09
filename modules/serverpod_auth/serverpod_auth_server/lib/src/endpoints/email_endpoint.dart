// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

// const _configFilePath = 'config/google_client_secret.json';

/// Endpoint for handling Sign in with Google.
// `abstract` ensures that this endpoint is not generated in the module's server/client code
abstract class EmailEndpoint extends Endpoint {
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
    return await Emails.tryCreateAccount(
      session,
      email: email,
      verificationCode: verificationCode,
    );
  }
}

// This is then defined in the developers app
class MyProjectsEmailEndpoint extends EmailEndpoint {
  @override
  Future<bool> createAccountRequest(
    Session session,
    String userName,
    String email,
    String password,
  ) {
    if (!email.endsWith('@serverpod.dev')) {
      throw ArgumentError.value('email');
    }

    return super.createAccountRequest(session, userName, email, password);
  }

  // For a while the old `authenticate` method is still being supported, but the developer plans to require 2FA via OTP
  // Eventually they would use a Serverpod provided `@obsolete` annotation (or similar), which would instruct code gen (which
  // already happens in the app's namespace) to omit this method.
  // Per convention we could ensure that an `@obsolete` method's implementation is always `throw UnimplementedError()`,
  // to mimick the error the client would get when calling a non-existent method.
  @Deprecated('Use authenticateWithOTP instead')
  @override
  Future<AuthenticationResponse> authenticate(
    Session session,
    String email,
    String password,
  ) {
    return super.authenticate(session, email, password);
  }

  // The developer's new login method
  Future<AuthenticationResponse> authenticateWithOtp(
    Session session, {
    required String email,
    required String password,
    required String otp,
  }) {
    if (otp != '123456') {
      throw ArgumentError.value('otp');
    }

    return super.authenticate(session, email, password);
  }
}
