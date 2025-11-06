import '../../../generated/protocol.dart';
import '../../../utils/secret_hash_util.dart';
import 'email_idp_config.dart';
import 'email_idp_server_exceptions.dart';
import 'utils/email_idp_account_creation_util.dart';
import 'utils/email_idp_authentication_util.dart';
import 'utils/email_idp_password_reset_util.dart';

/// Email account management functions.
///
/// This class provides atomic building blocks for composing custom authentication
/// and administration flows. The building blocks are accessible through properties
/// divided up into related groups.
///
/// - [hashUtil] - Utilities for hashing passwords and verification codes
/// - [authentication] - Utilities for authenticating users
/// - [accountCreation] - Utilities for creating and verifying email accounts
/// - [passwordReset] - Utilities for resetting passwords
///
/// For most standard use cases, the methods exposed by [EmailIDP] and
/// [EmailIDPAdmin] should be sufficient.
class EmailIDPUtils {
  /// {@macro email_idp_hash_util}
  final SecretHashUtil hashUtil;

  /// {@macro email_idp_account_creation_util}
  late final EmailIDPAccountCreationUtil accountCreation;

  /// {@macro email_idp_password_reset_util}
  late final EmailIDPPasswordResetUtil passwordReset;

  /// {@macro email_idp_authentication_utils}
  late final EmailIDPAuthenticationUtil authentication;

  /// Creates a new instance of [EmailIDPUtils].
  EmailIDPUtils({required final EmailIDPConfig config})
    : hashUtil = SecretHashUtil(
        hashPepper: config.secretHashPepper,
        hashSaltLength: config.secretHashSaltLength,
      ) {
    accountCreation = EmailIDPAccountCreationUtil(
      config: EmailIDPAccountCreationUtilsConfig.fromEmailIDPConfig(config),
      passwordHashUtils: hashUtil,
    );
    passwordReset = EmailIDPPasswordResetUtil(
      config: EmailIDPPasswordResetUtilsConfig.fromEmailIDPConfig(config),
      passwordHashUtils: hashUtil,
    );
    authentication = EmailIDPAuthenticationUtil(
      hashUtil: hashUtil,
      failedLoginRateLimit: config.failedLoginRateLimit,
    );
  }

  /// Replaces server-side exceptions by client-side exceptions, hiding details
  /// that could leak account information.
  static Future<T> withReplacedServerEmailException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on EmailServerException catch (e) {
      switch (e) {
        case EmailLoginServerException():
          throw EmailAccountLoginException(reason: e.reason);
        case EmailAccountRequestServerException():
          throw EmailAccountRequestException(reason: e.reason);
        case EmailPasswordResetServerException():
          throw EmailAccountPasswordResetException(reason: e.reason);
      }
    }
  }
}

extension on EmailLoginServerException {
  EmailAccountLoginExceptionReason get reason {
    switch (this) {
      case EmailAccountNotFoundException():
      case EmailAuthenticationInvalidCredentialsException():
        return EmailAccountLoginExceptionReason.invalidCredentials;
      case EmailAuthenticationTooManyAttemptsException():
        return EmailAccountLoginExceptionReason.tooManyAttempts;
    }
  }
}

extension on EmailAccountRequestServerException {
  EmailAccountRequestExceptionReason get reason {
    switch (this) {
      case EmailAccountRequestInvalidVerificationCodeException():
      case EmailAccountRequestNotFoundException():
      case EmailAccountRequestNotVerifiedException():
      case EmailAccountRequestVerificationTooManyAttemptsException():
        return EmailAccountRequestExceptionReason.invalid;
      case EmailPasswordPolicyViolationException():
        return EmailAccountRequestExceptionReason.policyViolation;
      case EmailAccountRequestVerificationExpiredException():
        return EmailAccountRequestExceptionReason.expired;
    }
  }
}

extension on EmailPasswordResetServerException {
  EmailAccountPasswordResetExceptionReason get reason {
    switch (this) {
      case EmailPasswordResetAccountNotFoundException():
      case EmailPasswordResetInvalidVerificationCodeException():
      case EmailPasswordResetRequestNotFoundException():
      case EmailPasswordResetTooManyAttemptsException():
      case EmailPasswordResetTooManyVerificationAttemptsException():
      case EmailPasswordResetEmailNotFoundException():
        return EmailAccountPasswordResetExceptionReason.invalid;
      case EmailPasswordResetPasswordPolicyViolationException():
        return EmailAccountPasswordResetExceptionReason.policyViolation;
      case EmailPasswordResetRequestExpiredException():
        return EmailAccountPasswordResetExceptionReason.expired;
    }
  }
}
