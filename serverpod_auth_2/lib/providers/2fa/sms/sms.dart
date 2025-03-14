import 'package:serverpod_auth_2/serverpod/serverpod.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session.dart';
import 'package:serverpod_auth_2/util/sms_service.dart';

/// Showcases an intermediate 2FA step using SMS (e-mail would work differently)
///
/// From the authentication perspective it's just important that the user-session is not yet created until the code has been verified
///
/// The variety of methods could potentially be reduced if we support the logged in and "pending verification" session into a single parameter,
/// where the endpoint can then make the appropriate lookup.
class SMS2FAProvider {
  SMS2FAProvider({
    required this.serverpod,
    required this.smsService,
  });

  final Serverpod serverpod;

  final SmsService smsService;

  // todo: Also store time to get expiration data
  final pendingTokensBySessionId = <String, String>{};

  String _getToken() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // in this case there is not yet a user object, as the registration is not complete
  void setupDuringRegistration({
    required String pendingSessionId,
    required String phoneNumber,
  }) {
    // todo: verify pending session exists

    final token = _getToken();

    pendingTokensBySessionId[pendingSessionId] = token;

    smsService.sendSms(phoneNumber, token);
  }

  void setupWhenLoggedIn({
    required String sessionId,
    required String phoneNumber,
  }) {
    throw UnimplementedError();
  }

  void requestTokenWhenLoggingIn({
    required String pendingSessionId,
  }) {
    throw UnimplementedError();
  }

  ActiveUserSession verifyTokenWhenLoggingIn({
    required String pendingSessionId,
    required String token,
  }) {
    if (pendingTokensBySessionId[pendingSessionId] != token) {
      throw Exception('invalid token');
    }

    return serverpod.userSessionRepository
        .verifyPendingSession(pendingSessionId);
  }

  void requestTokenWhenLoggedIn({
    required String sessionId,
  }) {
    throw UnimplementedError();
  }

  void verifyTokenWhenLoggedIn({
    required String sessionId,
    required String token,
  }) {
    throw UnimplementedError();
  }
}
