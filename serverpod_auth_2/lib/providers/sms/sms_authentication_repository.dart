import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/util/sms_service.dart';

/// Showcases an intermediate 2FA step using SMS (e-mail would work differently)
///
/// From the authentication perspective it's just important that the user-session is not yet created until the code has been verified
///
/// The variety of methods could potentially be reduced if we support the logged in and "pending verification" session into a single parameter,
/// where the endpoint can then make the appropriate lookup.
class SMSAuthenticationRepository {
  SMSAuthenticationRepository({
    required this.serverpod,
    required this.smsService,
  });

  final Serverpod serverpod;

  final SmsService smsService;

  // todo: Also store time to get expiration data
  @visibleForTesting
  final pendingRegistrationsByProcessId =
      <String, ({String phoneNumber, String token})>{};

  final _verifiedPhoneNumbersByUserId = <int, String>{};

  @visibleForTesting
  final inProgressLogins = <String, ({String token, int userId})>{};

  static const providerName = 'sms';

  String startEnrollment(String phoneNumber) {
    final processId = DateTime.now().millisecondsSinceEpoch.toString();

    final token = _getToken();

    pendingRegistrationsByProcessId[processId] =
        (phoneNumber: phoneNumber, token: token);

    smsService.sendSms(phoneNumber, token);

    return processId;
  }

  String verifyEnrollment(String smsToken) {
    final pendingRegistration = pendingRegistrationsByProcessId.entries
        .firstWhere((e) => e.value.token == smsToken);

    return pendingRegistration.key;
  }

  void finishEnrollment(String secondFactorRegistrationId, int userId) {
    final pendingRegistration =
        pendingRegistrationsByProcessId.remove(secondFactorRegistrationId)!;

    _verifiedPhoneNumbersByUserId[userId] = pendingRegistration.phoneNumber;
  }

  String startVerification(int userId) {
    final phoneNumber = _verifiedPhoneNumbersByUserId[userId]!;
    final processId = DateTime.now().millisecondsSinceEpoch.toString();

    final token = _getToken();
    smsService.sendSms(phoneNumber, token);

    inProgressLogins[processId] = (token: token, userId: userId);

    return processId;
  }

  // TODO: Should this return the user ID? Else the caller would always have to store the indirection
  //       But then on the other hand they would have to make sure, that the user being verified here is actually the one they want to login in (e.g. userid == "main authentication user id")
  String finishVerification(String smsToken) {
    final entry = inProgressLogins.entries.firstWhere(
      (e) => e.value.token == smsToken,
    );
    inProgressLogins.remove(entry.key);

    return entry.key;
  }

  String _getToken() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
