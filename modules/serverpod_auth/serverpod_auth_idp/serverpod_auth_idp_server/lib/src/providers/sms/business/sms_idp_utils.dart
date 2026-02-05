import '../../../../core.dart';
import 'sms_idp_config.dart';
import 'sms_idp_server_exceptions.dart';
import 'utils/sms_idp_account_creation_util.dart';
import 'utils/sms_idp_bind_util.dart';
import 'utils/sms_idp_login_util.dart';

/// SMS account management utilities.
///
/// This class provides atomic building blocks for composing custom authentication
/// and administration flows.
///
/// - [hashUtil] - Utilities for hashing passwords and verification codes
/// - [accountCreation] - Utilities for creating and verifying SMS accounts
/// - [login] - Utilities for logging in users
/// - [bind] - Utilities for binding phones to existing users
class SmsIdpUtils {
  /// General hash util for the SMS identity provider.
  final Argon2HashUtil hashUtil;

  /// {@macro sms_idp_account_creation_util}
  late final SmsIdpAccountCreationUtil accountCreation;

  /// {@macro sms_idp_login_util}
  late final SmsIdpLoginUtil login;

  /// {@macro sms_idp_bind_util}
  late final SmsIdpBindUtil bind;

  /// Creates a new instance of [SmsIdpUtils].
  SmsIdpUtils({
    required SmsIdpConfig config,
    required AuthUsers authUsers,
  }) : hashUtil = Argon2HashUtil(
         hashPepper: config.secretHashPepper,
         fallbackHashPeppers: config.fallbackSecretHashPeppers,
         hashSaltLength: config.secretHashSaltLength,
         parameters: Argon2HashParameters(memory: 19456),
       ) {
    accountCreation = SmsIdpAccountCreationUtil(
      config: config,
      authUsers: authUsers,
      hashUtil: hashUtil,
    );
    login = SmsIdpLoginUtil(config: config, hashUtil: hashUtil);
    bind = SmsIdpBindUtil(config: config, hashUtil: hashUtil);
  }

  /// Wraps a function to convert challenge exceptions to account request exceptions.
  static Future<T> withReplacedAccountRequestException<T>(
    Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on ChallengeExpiredException {
      throw SmsAccountRequestVerificationExpiredException();
    } on ChallengeRateLimitExceededException {
      throw SmsAccountRequestVerificationTooManyAttemptsException();
    } on ChallengeInvalidCompletionTokenException catch (_) {
      throw SmsAccountRequestNotFoundException();
    } on ChallengeInvalidVerificationCodeException catch (_) {
      throw SmsAccountRequestInvalidVerificationCodeException();
    } on ChallengeNotVerifiedException {
      throw SmsAccountRequestNotVerifiedException();
    } on ChallengeRequestNotFoundException {
      throw SmsAccountRequestNotFoundException();
    } on ChallengeAlreadyUsedException {
      throw SmsAccountRequestVerificationCodeAlreadyUsedException();
    }
  }

  /// Wraps a function to convert challenge exceptions to login exceptions.
  static Future<T> withReplacedLoginException<T>(
    Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on ChallengeExpiredException {
      throw SmsLoginExpiredException();
    } on ChallengeRateLimitExceededException {
      throw SmsLoginTooManyAttemptsException();
    } on ChallengeInvalidCompletionTokenException catch (_) {
      throw SmsLoginNotFoundException();
    } on ChallengeInvalidVerificationCodeException catch (_) {
      throw SmsLoginInvalidCredentialsException();
    } on ChallengeNotVerifiedException {
      throw SmsLoginNotFoundException();
    } on ChallengeRequestNotFoundException {
      throw SmsLoginNotFoundException();
    } on ChallengeAlreadyUsedException {
      throw SmsLoginNotFoundException();
    }
  }

  /// Wraps a function to convert challenge exceptions to phone bind exceptions.
  static Future<T> withReplacedBindException<T>(
    Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on ChallengeExpiredException {
      throw SmsPhoneBindExpiredException();
    } on ChallengeRateLimitExceededException {
      throw SmsPhoneBindTooManyAttemptsException();
    } on ChallengeInvalidCompletionTokenException catch (_) {
      throw SmsPhoneBindInvalidException();
    } on ChallengeInvalidVerificationCodeException catch (_) {
      throw SmsPhoneBindInvalidException();
    } on ChallengeNotVerifiedException {
      throw SmsPhoneBindInvalidException();
    } on ChallengeRequestNotFoundException {
      throw SmsPhoneBindInvalidException();
    } on ChallengeAlreadyUsedException {
      throw SmsPhoneBindInvalidException();
    }
  }

  /// Wraps a function to convert server-side SMS exceptions to client-serializable exceptions.
  ///
  /// This converts internal [SmsServerException] types to the serializable
  /// exception types defined in the protocol (e.g., [SmsAccountRequestException],
  /// [SmsLoginException], [SmsPhoneBindException]).
  static Future<T> withReplacedServerSmsException<T>(
    Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on SmsServerException catch (e) {
      switch (e) {
        case SmsAccountRequestServerException():
          throw SmsAccountRequestException(reason: e.reason);
        case SmsLoginServerException():
          throw SmsLoginException(reason: e.reason);
        case SmsPhoneBindServerException():
          throw SmsPhoneBindException(reason: e.reason);
      }
    }
  }
}

/// Extension to map [SmsAccountRequestServerException] to [SmsAccountRequestExceptionReason].
extension on SmsAccountRequestServerException {
  SmsAccountRequestExceptionReason get reason {
    switch (this) {
      case SmsAccountAlreadyRegisteredException():
      case SmsAccountRequestInvalidVerificationCodeException():
      case SmsAccountRequestNotFoundException():
      case SmsAccountRequestVerificationCodeAlreadyUsedException():
      case SmsAccountRequestNotVerifiedException():
        return SmsAccountRequestExceptionReason.invalid;
      case SmsAccountRequestVerificationExpiredException():
        return SmsAccountRequestExceptionReason.expired;
      case SmsAccountRequestVerificationTooManyAttemptsException():
        return SmsAccountRequestExceptionReason.tooManyAttempts;
      case SmsPasswordPolicyViolationException():
        return SmsAccountRequestExceptionReason.policyViolation;
    }
  }
}

/// Extension to map [SmsLoginServerException] to [SmsLoginExceptionReason].
extension on SmsLoginServerException {
  SmsLoginExceptionReason get reason {
    switch (this) {
      case SmsLoginInvalidCredentialsException():
      case SmsLoginNotFoundException():
        return SmsLoginExceptionReason.invalid;
      case SmsLoginTooManyAttemptsException():
        return SmsLoginExceptionReason.tooManyAttempts;
      case SmsLoginExpiredException():
        return SmsLoginExceptionReason.expired;
      case SmsLoginPasswordRequiredException():
        return SmsLoginExceptionReason.passwordRequired;
      case SmsLoginPasswordPolicyViolationException():
        return SmsLoginExceptionReason.policyViolation;
    }
  }
}

/// Extension to map [SmsPhoneBindServerException] to [SmsPhoneBindExceptionReason].
extension on SmsPhoneBindServerException {
  SmsPhoneBindExceptionReason get reason {
    switch (this) {
      case SmsPhoneBindInvalidException():
        return SmsPhoneBindExceptionReason.invalid;
      case SmsPhoneBindTooManyAttemptsException():
        return SmsPhoneBindExceptionReason.tooManyAttempts;
      case SmsPhoneBindExpiredException():
        return SmsPhoneBindExceptionReason.expired;
      case SmsPhoneAlreadyBoundException():
        return SmsPhoneBindExceptionReason.phoneAlreadyBound;
    }
  }
}
