import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Controller for phone authentication.
class PhoneAuthController {
  /// A reference to the auth module as retrieved from the client object.
  final Caller caller;

  /// Creates a new phone authentication controller.
  PhoneAuthController(this.caller);

  /// Attempts to sign in with phone number and password. If successful, a [UserInfo]
  /// is returned. If the attempt is not a success, null is returned.
  Future<UserInfo?> signIn(String phoneNumber, String password) async {
    try {
      var serverResponse =
          await caller.phone.authenticate(phoneNumber, password);
      if (!serverResponse.success ||
          serverResponse.userInfo == null ||
          serverResponse.keyId == null ||
          serverResponse.key == null) {
        if (kDebugMode) {
          print(
            'serverpod_auth_phone: Failed to authenticate with '
            'Serverpod backend: '
            '${serverResponse.failReason ?? 'reason unknown'}'
            '. Aborting.',
          );
        }
        return null;
      }

      // Authentication was successful, store the key.
      var sessionManager = await SessionManager.instance;
      sessionManager.registerSignedInUser(
        serverResponse.userInfo!,
        serverResponse.keyId!,
        serverResponse.key!,
      );
      return serverResponse.userInfo;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('$e');
        print('$stackTrace');
      }
      return null;
    }
  }

  /// Attempts to create a new account request with the given phone number and
  /// password. If successful, true is returned. If the attempt is not a
  /// success, false is returned.
  Future<bool> createAccountRequest(
    String userName,
    String phoneNumber,
    String password,
  ) async {
    try {
      return await caller.phone.createAccountRequest(
        userName,
        phoneNumber,
        password,
      );
    } catch (e) {
      return false;
    }
  }

  /// Attempts to validate the account with the given phone number and verification
  /// code. If successful, a [UserInfo] is returned. If the attempt is not a
  /// success, null is returned.
  Future<UserInfo?> validateAccount(
    String phoneNumber,
    String verificationCode,
  ) async {
    try {
      return await caller.phone.createAccount(phoneNumber, verificationCode);
    } catch (e) {
      return null;
    }
  }

  /// Attempts to initiate a password reset for the given phone number. If successful,
  /// true is returned. If the attempt is not a success, false is returned.
  Future<bool> initiatePasswordReset(String phoneNumber) async {
    try {
      return await caller.phone.initiatePasswordReset(phoneNumber);
    } catch (e) {
      return false;
    }
  }

  /// Attempts to reset the password for the given phone number with the given
  /// verification code and new password. If successful, true is returned. If
  /// the attempt is not a success, false is returned.
  Future<bool> resetPassword(
    String phoneNumber,
    String verificationCode,
    String password,
  ) async {
    try {
      return await caller.phone.resetPassword(
        verificationCode,
        password,
      );
    } catch (e) {
      return false;
    }
  }
}
