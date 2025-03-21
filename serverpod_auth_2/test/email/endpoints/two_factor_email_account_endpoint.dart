import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/providers/2fa/sms/sms.dart';
import 'package:serverpod_auth_2/providers/email/email_account_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';

class TwoFactorEmailRegistrationEndpoint {
  TwoFactorEmailRegistrationEndpoint({
    required this.sessionRepository,
    required this.userInfoRepository,
    required this.emailAuthenticationRepository,
    required this.sms2faRepository,
  });

  final SessionRepository sessionRepository;

  final UserInfoRepository userInfoRepository;

  final EmailAuthenticationRepository emailAuthenticationRepository;

  final SMS2FARepository sms2faRepository;

// #region Registration

  /// Registration token (from this endpoint) -> email account repository verification ID
  @visibleForTesting
  var pendingAccountCreations =
      <String, ({String emailVerificationId, String? sms2FAId})>{};

  var secondFactorIdByEmail = <String, String>{};

  /// Upon successful call, user will need to open the verification link from the email
  void register(String email, String password) {
    emailAuthenticationRepository.startVerificationFlow(
      email: email,
      password: password,
    );
  }

  /// Returns a token with which to register the second factor
  String verifyEmail(String verificationToken) {
    final verificationId = emailAuthenticationRepository.verifyEmailWithToken(
      verificationToken,
    );

    var registrationKey = DateTime.now().microsecondsSinceEpoch.toString();

    pendingAccountCreations[registrationKey] =
        (emailVerificationId: verificationId, sms2FAId: null);

    return registrationKey;
  }

  void setupSMS2FA(String registrationKey, String phoneNumber) {
    final pendingAccountCreation = pendingAccountCreations[registrationKey];
    if (pendingAccountCreation == null) {
      throw 'Registration key unknown';
    }

    final registrationId = sms2faRepository.startEnrollment(phoneNumber);

    pendingAccountCreations[registrationKey] = (
      emailVerificationId: pendingAccountCreation.emailVerificationId,
      sms2FAId: registrationId,
    );
  }

  /// Returns the user session
  String verify2FA(String smsToken) {
    final secondFactorRegistraionId =
        sms2faRepository.verifyEnrollment(smsToken);

    final pendingCreation = pendingAccountCreations.entries
        .firstWhere((e) => e.value.sms2FAId == secondFactorRegistraionId);
    pendingAccountCreations.remove(pendingCreation.key);

    final user = userInfoRepository.createUser(null, null);

    emailAuthenticationRepository.createVerifiedAccount(
        pendingCreation.value.emailVerificationId, user.id!);
    sms2faRepository.finishEnrollment(secondFactorRegistraionId, user.id!);

    return sessionRepository.createSession(
      user.id!,
      authProvider: 'email',
      additionalData: null,
    );
  }

// #endregion

// #region Login

  /// Challenge ID -> User ID
  var _inProgressLoginsBySMSChallengeId = <String, int>{};

  /// Checks email and password and will send out the SMS 2FA
  // TODO: Maybe this should round-trip a long token, so [verifyLogin] does not only depend on the (short) SMS token?
  void login(String email, String password) {
    final userId = emailAuthenticationRepository.login(email, password);

    final smsVerificationId = sms2faRepository.startVerification(userId);

    _inProgressLoginsBySMSChallengeId[smsVerificationId] = userId;
  }

  /// Returns the session
  String verifyLogin(String smsToken) {
    final smsVerificationId = sms2faRepository.finishVerification(smsToken);

    final userId = _inProgressLoginsBySMSChallengeId.remove(smsVerificationId)!;

    return sessionRepository.createSession(
      userId,
      authProvider: 'email',
      additionalData: null,
    );
  }

// #endregion
}
