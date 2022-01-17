import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

class EmailAuthController {
  final Caller caller;
  EmailAuthController(this.caller);

  Future<UserInfo?> signIn(String email, String password) async {
    try {
      var serverResponse = await caller.email.authenticate(email, password);
      if (!serverResponse.success) return null;

      // Authentication was successful, store the key.
      var sessionManager = await SessionManager.instance;
      await sessionManager.keyManager.put(
        '${serverResponse.keyId}:${serverResponse.key}',
      );

      // Store the user info in the session manager.
      sessionManager.signedInUser = serverResponse.userInfo;
      return serverResponse.userInfo;
    } catch (e, stackTrace) {
      print('$e');
      print('$stackTrace');
      return null;
    }
  }

  Future<bool> createAccountRequest(
    String userName,
    String email,
    String password,
  ) async {
    try {
      return await caller.email.createAccountRequest(
        userName,
        email,
        password,
      );
    } catch (e) {
      return false;
    }
  }

  Future<UserInfo?> validateAccount(
    String email,
    String verificationCode,
  ) async {
    try {
      return await caller.email.createAccount(email, verificationCode);
    } catch (e) {
      return null;
    }
  }

  Future<bool> initiatePasswordReset(String email) async {
    try {
      return await caller.email.initiatePasswordReset(email);
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(
    String email,
    String verificationCode,
    String password,
  ) async {
    try {
      return await caller.email.resetPassword(
        verificationCode,
        password,
      );
    } catch (e) {
      return false;
    }
  }
}
