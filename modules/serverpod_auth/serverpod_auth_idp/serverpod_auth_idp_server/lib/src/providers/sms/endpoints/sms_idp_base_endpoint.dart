import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import '../business/sms_idp.dart';

/// Base endpoint for SMS-based accounts.
///
/// Subclass this in your own application to expose an endpoint including all
/// methods.
///
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
///
/// Alternatively you can build up your own endpoint on top of the same business
/// logic by using [SmsIdp].
abstract class SmsIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured SMS Idp instance.
  ///
  /// By default this uses the global instance configured in [AuthServices].
  /// If you want to use a different instance, override this getter.
  SmsIdp get smsIdp => AuthServices.instance.smsIdp;

  /// {@template sms_idp_base_endpoint.start_registration}
  /// Starts the registration process for a new SMS account.
  ///
  /// Returns the account request ID, which should be provided along with the
  /// verification code sent via SMS to [verifyRegistrationCode].
  /// {@endtemplate}
  Future<UuidValue> startRegistration(
    final Session session, {
    required final String phone,
  }) async {
    return smsIdp.startRegistration(session, phone: phone);
  }

  /// {@template sms_idp_base_endpoint.verify_registration_code}
  /// Verifies the registration code sent via SMS.
  ///
  /// Returns a completion token to be used with [finishRegistration].
  /// {@endtemplate}
  Future<String> verifyRegistrationCode(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
  }) async {
    return smsIdp.verifyRegistrationCode(
      session,
      accountRequestId: accountRequestId,
      verificationCode: verificationCode,
    );
  }

  /// {@template sms_idp_base_endpoint.finish_registration}
  /// Finishes the registration process and creates the account.
  ///
  /// Returns an [AuthSuccess] with the authentication tokens.
  /// {@endtemplate}
  Future<AuthSuccess> finishRegistration(
    final Session session, {
    required final String registrationToken,
    required final String phone,
    required final String password,
  }) async {
    return smsIdp.finishRegistration(
      session,
      registrationToken: registrationToken,
      phone: phone,
      password: password,
    );
  }

  /// {@template sms_idp_base_endpoint.start_login}
  /// Starts the login process.
  ///
  /// Returns the login request ID, which should be provided along with the
  /// verification code sent via SMS to [verifyLoginCode].
  /// {@endtemplate}
  Future<UuidValue> startLogin(
    final Session session, {
    required final String phone,
  }) async {
    return smsIdp.startLogin(session, phone: phone);
  }

  /// {@template sms_idp_base_endpoint.verify_login_code}
  /// Verifies the login code sent via SMS.
  ///
  /// Returns a [SmsVerifyLoginResult] with:
  /// - `token`: completion token to be used with [finishLogin]
  /// - `needsPassword`: whether a password is required for new user registration
  /// {@endtemplate}
  Future<SmsVerifyLoginResult> verifyLoginCode(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    return smsIdp.verifyLoginCode(
      session,
      loginRequestId: loginRequestId,
      verificationCode: verificationCode,
    );
  }

  /// {@template sms_idp_base_endpoint.finish_login}
  /// Finishes the login process.
  ///
  /// If the phone is not registered and `requirePasswordOnUnregisteredLogin` is
  /// enabled, a password must be provided to create a new account.
  ///
  /// Returns an [AuthSuccess] with the authentication tokens.
  /// {@endtemplate}
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final String loginToken,
    required final String phone,
    final String? password,
  }) async {
    return smsIdp.finishLogin(
      session,
      loginToken: loginToken,
      phone: phone,
      password: password,
    );
  }

  /// {@template sms_idp_base_endpoint.start_bind_phone}
  /// Starts the phone binding process for an authenticated user.
  ///
  /// Returns the bind request ID, which should be provided along with the
  /// verification code sent via SMS to [verifyBindCode].
  /// {@endtemplate}
  Future<UuidValue> startBindPhone(
    final Session session, {
    required final String phone,
  }) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.unauthenticated,
      );
    }
    return smsIdp.startBindPhone(
      session,
      authUserId: authUserId,
      phone: phone,
    );
  }

  /// {@template sms_idp_base_endpoint.verify_bind_code}
  /// Verifies the bind code sent via SMS.
  ///
  /// Returns a completion token to be used with [finishBindPhone].
  /// {@endtemplate}
  Future<String> verifyBindCode(
    final Session session, {
    required final UuidValue bindRequestId,
    required final String verificationCode,
  }) async {
    return smsIdp.verifyBindCode(
      session,
      bindRequestId: bindRequestId,
      verificationCode: verificationCode,
    );
  }

  /// {@template sms_idp_base_endpoint.finish_bind_phone}
  /// Finishes the phone binding process.
  /// {@endtemplate}
  Future<void> finishBindPhone(
    final Session session, {
    required final String bindToken,
    required final String phone,
  }) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.unauthenticated,
      );
    }
    return smsIdp.finishBindPhone(
      session,
      authUserId: authUserId,
      bindToken: bindToken,
      phone: phone,
    );
  }

  /// {@template sms_idp_base_endpoint.is_phone_bound}
  /// Returns true if the authenticated user has a phone number bound.
  /// {@endtemplate}
  Future<bool> isPhoneBound(final Session session) async {
    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw NotAuthorizedException(
        reason: AuthenticationFailureReason.unauthenticated,
      );
    }
    return smsIdp.isPhoneBound(session, authUserId: authUserId);
  }
}
