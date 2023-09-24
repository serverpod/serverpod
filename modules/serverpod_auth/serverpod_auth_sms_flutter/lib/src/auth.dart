import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Controller for SMS authentication.
class SMSAuthController {
  /// A reference to the [AuthModule] as retrieved from the client object.
  final Caller caller;

  /// Creates a new [SMSAuthController].
  SMSAuthController(this.caller);

  /// Attempts to sign in a user with SMS authentication. If successful, a
  /// [UserInfo] is returned. If the user doesn't exist, a new user is created
  /// and returned. If the attempt fails, null is returned.
  Future<SmsOtpResponse> sendSMS({
    required String phoneNumber,
  }) async {
    return await caller.sms.startAuthentication(phoneNumber);
  }

  /// Attempts to sign in a user with SMS authentication. If successful, a
  /// [UserInfo] is returned. If the user doesn't exist, a new user is created
  /// and returned. If the attempt fails, null is returned.
  Future<AuthenticationResponse> validateSMS({
    required String phoneNumber,
    required String otp,
    required String storedHash,
  }) async {
    var serverResponse = await caller.sms.verifyAuthentication(
      phoneNumber,
      otp,
      storedHash,
    );
    if (!serverResponse.success ||
        serverResponse.userInfo == null ||
        serverResponse.keyId == null ||
        serverResponse.key == null) {
      return serverResponse;
    }

    // Authentication was successful, store the key.
    var sessionManager = await SessionManager.instance;

    sessionManager.registerSignedInUser(
      serverResponse.userInfo!,
      serverResponse.keyId!,
      serverResponse.key!,
    );
    return serverResponse;
  }
}
