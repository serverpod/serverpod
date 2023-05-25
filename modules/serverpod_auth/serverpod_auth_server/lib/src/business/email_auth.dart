import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/user_images.dart';

/// Collection of utility methods when working with email authentication.
class Emails {
  /// Generates a password hash from a users password and email. This value
  /// can safely be stored in the database without the risk of exposing
  /// passwords.
  static String generatePasswordHash(String password, String email) {
    var salt = Serverpod.instance!.getPassword('email_password_salt') ??
        'serverpod password salt';
    if (AuthConfig.current.extraSaltyHash) {
      salt += ':$email';
    }
    return sha256.convert(utf8.encode(password + salt)).toString();
  }

  /// Creates a new user. Either password or hash needs to be provided.
  static Future<UserInfo?> createUser(
    Session session,
    String userName,
    String email,
    String? password, [
    String? hash,
  ]) async {
    assert(password != null || hash != null,
        'Either password or hash needs to be provided');
    var userInfo = await Users.findUserByEmail(session, email);

    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: email,
        email: email,
        userName: userName,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );

      session.log('creating user', level: LogLevel.debug);
      userInfo = await Users.createUser(session, userInfo, 'email');
      if (userInfo == null) return null;
    }

    // Check if there is email authentication in place already
    var oldAuth = await session.db.findSingleRow<EmailAuth>(
      where: EmailAuth.t.userId.equals(userInfo.id!),
    );
    if (oldAuth != null) {
      return userInfo;
    }

    session.log('creating email auth', level: LogLevel.debug);
    hash = hash ?? generatePasswordHash(password!, email);
    var auth = EmailAuth(
      userId: userInfo.id!,
      email: email,
      hash: hash,
    );
    await session.db.insert(auth);

    await UserImages.setDefaultUserImage(session, userInfo.id!);
    await Users.invalidateCacheForUser(session, userInfo.id!);
    userInfo = await Users.findUserByUserId(session, userInfo.id!);

    session.log('returning created user', level: LogLevel.debug);
    return userInfo;
  }

  /// Updates the password of a user.
  static Future<bool> changePassword(
    Session session,
    int userId,
    String oldPassword,
    String newPassword,
  ) async {
    var auth = await session.db.findSingleRow<EmailAuth>(
      where: EmailAuth.t.userId.equals(userId),
    );
    if (auth == null) {
      return false;
    }

    // Check old password
    if (auth.hash != generatePasswordHash(oldPassword, auth.email)) {
      return false;
    }

    // Update password
    auth.hash = generatePasswordHash(newPassword, auth.email);
    await session.db.update(auth);

    return true;
  }

  /// Initiates the password reset procedure. Will send an email to the provided
  /// address with a reset code.
  static Future<bool> initiatePasswordReset(
    Session session,
    String email,
  ) async {
    assert(
      AuthConfig.current.sendPasswordResetEmail != null,
      'ResetPasswordEmail is not configured, cannot send email.',
    );

    email = email.trim().toLowerCase();

    var userInfo = await Users.findUserByEmail(session, email);
    if (userInfo == null) return false;

    var verificationCode = _generateVerificationCode();
    var emailReset = EmailReset(
      userId: userInfo.id!,
      verificationCode: verificationCode,
      expiration: DateTime.now().add(
        AuthConfig.current.passwordResetExpirationTime,
      ),
    );
    await session.db.insert(emailReset);

    return AuthConfig.current.sendPasswordResetEmail!(
      session,
      userInfo,
      verificationCode,
    );
  }

  /// Verifies a password reset code, returns a [EmailPasswordReset] object if
  /// successful, null otherwise.
  static Future<EmailPasswordReset?> verifyEmailPasswordReset(
    Session session,
    String verificationCode,
  ) async {
    session.log('verificationCode: $verificationCode', level: LogLevel.debug);
    var passwordReset = await session.db.findSingleRow<EmailReset>(
      where: EmailReset.t.verificationCode.equals(verificationCode) &
          (EmailReset.t.expiration > DateTime.now().toUtc()),
    );

    if (passwordReset == null) return null;

    var userInfo = await Users.findUserByUserId(session, passwordReset.userId);
    if (userInfo == null) return null;

    if (userInfo.email == null) return null;

    return EmailPasswordReset(
      userName: userInfo.userName,
      email: userInfo.email!,
    );
  }

  /// Resets a users password using a password reset verification code.
  static Future<bool> resetPassword(
    Session session,
    String verificationCode,
    String password,
  ) async {
    var passwordReset = await session.db.findSingleRow<EmailReset>(
      where: EmailReset.t.verificationCode.equals(verificationCode) &
          (EmailReset.t.expiration > DateTime.now().toUtc()),
    );

    if (passwordReset == null) return false;

    var emailAuth = await session.db.findSingleRow<EmailAuth>(
      where: EmailAuth.t.userId.equals(passwordReset.userId),
    );

    if (emailAuth == null) return false;

    emailAuth.hash = generatePasswordHash(password, emailAuth.email);
    await session.db.update(emailAuth);

    return true;
  }

  /// Creates a request for creating an account associated with the specified
  /// email address. An email with a validation code will be sent.
  static Future<bool> createAccountRequest(
    Session session,
    String userName,
    String email,
    String password,
  ) async {
    assert(
      AuthConfig.current.sendValidationEmail != null,
      'The sendValidationEmail property needs to be set in AuthConfig.',
    );

    try {
      // Check if user already has an account
      var userInfo = await Users.findUserByEmail(session, email);
      if (userInfo != null) {
        return false;
      }

      email = email.trim().toLowerCase();
      if (!EmailValidator.validate(email)) {
        return false;
      }

      userName = userName.trim();
      if (userName.isEmpty) {
        return false;
      }

      if (password.length < AuthConfig.current.minPasswordLength ||
          password.length > AuthConfig.current.maxPasswordLength) {
        return false;
      }

      var accountRequest = await findAccountRequest(session, email);
      if (accountRequest == null) {
        accountRequest = EmailCreateAccountRequest(
          userName: userName,
          email: email,
          hash: generatePasswordHash(password, email),
          verificationCode: _generateVerificationCode(),
        );
        await session.db.insert(accountRequest);
      } else {
        accountRequest.userName = userName;
        accountRequest.verificationCode = _generateVerificationCode();
        await EmailCreateAccountRequest.update(session, accountRequest);
      }

      return await AuthConfig.current.sendValidationEmail!(
        session,
        email,
        accountRequest.verificationCode,
      );
    } catch (e) {
      return false;
    }
  }

  /// Returns an [EmailCreateAccountRequest] if one exists for the provided
  /// email, null otherwise.
  static Future<EmailCreateAccountRequest?> findAccountRequest(
    Session session,
    String email,
  ) async {
    return await EmailCreateAccountRequest.findSingleRow(
      session,
      where: (t) => t.email.equals(email),
    );
  }

  static String _generateVerificationCode() {
    return Random().nextString(
      length: 8,
      chars: '0123456789',
    );
  }
}
