import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/config.dart';
import 'package:serverpod_auth_server/src/business/user_images.dart';

import '../generated/protocol.dart';
import '../util/random_string.dart';
import 'users.dart';

class Emails {
  static String generatePasswordHash(String password) {
    var salt = Serverpod.instance!.getPassword('email_password_salt') ??
        'serverpod password salt';
    return sha256.convert(utf8.encode(password + salt)).toString();
  }

  static Future<UserInfo?> createUser(
      Session session, String userName, String email, String password) async {
    var userInfo = await Users.findUserByEmail(session, email);

    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: email,
        email: email,
        userName: userName,
        created: DateTime.now(),
        scopeNames: [],
        active: true,
        blocked: false,
      );

      print('creating user');
      userInfo = await Users.createUser(session, userInfo);
      if (userInfo == null) return null;
    }

    // Check if there is email authentication in place already
    var oldAuth = await session.db.findSingleRow<EmailAuth>(
      where: tEmailAuth.userId.equals(userInfo.id!),
    );
    if (oldAuth != null) {
      return userInfo;
    }

    print('creating email auth');
    var auth = EmailAuth(
      userId: userInfo.id!,
      email: email,
      hash: generatePasswordHash(password),
    );
    await session.db.insert(auth);

    await UserImages.setDefaultUserImage(session, userInfo.id!);
    await Users.invalidateCacheForUser(session, userInfo.id!);
    userInfo = await Users.findUserByUserId(session, userInfo.id!);

    print('returning created user');
    return userInfo;
  }

  static Future<bool> changePassword(Session session, int userId,
      String oldPassword, String newPassword) async {
    var auth = await session.db.findSingleRow<EmailAuth>(
      where: EmailAuth.t.userId.equals(userId),
    );
    if (auth == null) {
      return false;
    }

    // Check old password
    if (auth.hash != generatePasswordHash(oldPassword)) {
      return false;
    }

    // Update password
    auth.hash = generatePasswordHash(newPassword);
    await session.db.update(auth);

    return true;
  }

  static Future<bool> initiatePasswordReset(
      Session session, String email) async {
    if (AuthConfig.current.sendPasswordResetEmail == null) {
      // TODO: User proper logging instead
      print('ResetPasswordEmail is not configured, cannot send email.');
      return false;
    }

    email = email.trim().toLowerCase();

    var userInfo = await Users.findUserByEmail(session, email);
    if (userInfo == null) return false;

    var verificationCode = Random().nextString();
    var emailReset = EmailReset(
      userId: userInfo.id!,
      verificationCode: verificationCode,
      expiration:
          DateTime.now().add(AuthConfig.current.passwordResetExpirationTime),
    );
    await session.db.insert(emailReset);

    var config = session.server.serverpod.config;
    var resetLink = Uri(
      scheme: config.publicScheme,
      host: config.publicHost,
      path: '/password-reset/$verificationCode',
    );

    return AuthConfig.current.sendPasswordResetEmail!(
        session, userInfo, resetLink.toString());
  }

  static Future<EmailPasswordReset?> verifyEmailPasswordReset(
      Session session, String verificationCode) async {
    print('verificationCode: $verificationCode');
    var passwordReset = await session.db.findSingleRow<EmailReset>(
      where: EmailReset.t.verificationCode.equals(verificationCode) &
          (EmailReset.t.expiration > DateTime.now().toUtc()),
    );

    print(' - found reset');

    if (passwordReset == null) return null;

    var userInfo = await Users.findUserByUserId(session, passwordReset.userId);
    if (userInfo == null) return null;

    if (userInfo.email == null) return null;

    return EmailPasswordReset(
      userName: userInfo.userName,
      email: userInfo.email!,
    );
  }

  static Future<bool> resetPassword(
      Session session, String verificationCode, String password) async {
    var passwordReset = await session.db.findSingleRow<EmailReset>(
      where: EmailReset.t.verificationCode.equals(verificationCode) &
          (EmailReset.t.expiration > DateTime.now().toUtc()),
    );

    if (passwordReset == null) return false;

    var emailAuth = await session.db.findSingleRow<EmailAuth>(
      where: EmailAuth.t.userId.equals(passwordReset.userId),
    );

    if (emailAuth == null) return false;

    emailAuth.hash = generatePasswordHash(password);
    await session.db.update(emailAuth);

    return true;
  }
}
