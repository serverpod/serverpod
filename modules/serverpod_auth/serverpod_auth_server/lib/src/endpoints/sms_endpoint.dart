// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/sms_auth.dart';

/// Endpoint for handling Sign in with SMS.
class SmsEndpoint extends Endpoint {
  /// Start a Authentication with SMS. Returns a String containing a hash that
  /// should be sent back to the server with the OTP. To verify.
  Future<SmsOtpResponse> startAuthentication(
    Session session,
    String phoneNumber,
  ) async {
    if (await _hasTooManyFailedSignIns(session, phoneNumber)) {
      session.log('Too many failed sign in attempts', level: LogLevel.warning);
      return SmsOtpResponse(
        success: false,
        failReason: AuthenticationFailReason.tooManyFailedAttempts,
      );
    }
    var hash = await SMSs.getOTPRequest(phoneNumber: phoneNumber);
    return SmsOtpResponse(
      success: true,
      hash: hash,
    );
  }

  /// Verifies that the OTP is correct and that the hash hasn't been tampered
  /// with. If the OTP is correct, the user is logged in and a session is
  /// returned.
  Future<AuthenticationResponse> verifyAuthentication(
    Session session,
    String phoneNumber,
    String otp,
    String storedHash,
  ) async {
    session.log('authenticate $phoneNumber / XXXXXXXX', level: LogLevel.debug);

    if (await _hasTooManyFailedSignIns(session, phoneNumber)) {
      return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.tooManyFailedAttempts);
    }

    var verification = await SMSs.verifyOTPRequest(
      phoneNumber: phoneNumber,
      otp: otp,
      storedHash: storedHash,
    );
    if (!verification) {
      session.log(' - invalid credentials', level: LogLevel.debug);
      await _logFailedSignIn(session, phoneNumber);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log(' - OTP verified', level: LogLevel.debug);

    var entry = await session.db.findSingleRow<SmsAuth>(
      where: SmsAuth.t.phoneNumber.equals(phoneNumber),
    );

    if (entry == null) {
      session.log(' - no entry found', level: LogLevel.debug);
      entry = await SMSs.createUser(session, phoneNumber);
      if (entry == null) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.invalidCredentials,
        );
      }
    }

    session.log(' - user found', level: LogLevel.debug);

    var userInfo = await Users.findUserByUserId(session, entry.userId);
    // Check if user exists

    // Create user if it doesn't exist and return it
    if (userInfo == null) {
      session.log('- user not fount', level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var auth = await session.auth.signInUser(
      entry.userId,
      'sms',
      scopes: userInfo.scopes,
    );

    session.log(' - user signed in', level: LogLevel.debug);

    return AuthenticationResponse(
        success: true, userInfo: userInfo, key: auth.key, keyId: auth.id);
  }

  /// Stores failed authentication attempts in the database.
  Future<void> _logFailedSignIn(Session session, String phoneNumber) async {
    session as MethodCallSession;
    var failedSignIn = SmsFailedSignIn(
        phoneNumber: phoneNumber,
        time: DateTime.now(),
        ipAddress: session.httpRequest.remoteIpAddress);
    await SmsFailedSignIn.insert(session, failedSignIn);
  }

  /// Checks if the user has made too many failed sign in attempts.
  Future<bool> _hasTooManyFailedSignIns(
      Session session, String phoneNumber) async {
    var numFailedSingIns = await SmsFailedSignIn.count(
      session,
      where: (t) =>
          t.phoneNumber.equals(phoneNumber) &
          (t.time >
              DateTime.now()
                  .toUtc()
                  .subtract(AuthConfig.current.smsSignInFailureResetTime)),
    );
    return numFailedSingIns >= AuthConfig.current.maxAllowedSmsSignInAttempts;
  }
}
