import 'package:serverpod_auth_core_server/auth_user.dart';

import '../../../generated/protocol.dart';
import '../../../utils/secret_hash_util.dart';
import 'email_idp_config.dart';
import 'email_idp_server_exceptions.dart';
import 'utils/email_idp_account_creation_util.dart';
import 'utils/email_idp_account_utils.dart';
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
/// For most standard use cases, the methods exposed by [EmailIdp] and
/// [EmailIdpAdmin] should be sufficient.
class EmailIdpUtils {
  /// {@macro email_idp_hash_util}
  final SecretHashUtil hashUtil;

  /// {@macro email_idp_account_creation_util}
  late final EmailIdpAccountCreationUtil accountCreation;

  /// {@macro email_idp_password_reset_util}
  late final EmailIdpPasswordResetUtil passwordReset;

  /// {@macro email_idp_authentication_utils}
  late final EmailIdpAuthenticationUtil authentication;

  /// {@macro email_idp_account_utils}
  final EmailIdpAccountUtils account;

  /// Creates a new instance of [EmailIdpUtils].
  EmailIdpUtils({
    required final EmailIdpConfig config,
    final AuthUsers authUsers = const AuthUsers(),
  }) : hashUtil = SecretHashUtil(
         hashPepper: config.secretHashPepper,
         fallbackHashPeppers: config.fallbackSecretHashPeppers,
         hashSaltLength: config.secretHashSaltLength,
       ),
       account = EmailIdpAccountUtils() {
    accountCreation = EmailIdpAccountCreationUtil(
      config: EmailIdpAccountCreationUtilsConfig.fromEmailIdpConfig(config),
      passwordHashUtils: hashUtil,
      authUsers: authUsers,
    );
    passwordReset = EmailIdpPasswordResetUtil(
      config: EmailIdpPasswordResetUtilsConfig.fromEmailIdpConfig(config),
      passwordHashUtils: hashUtil,
    );
    authentication = EmailIdpAuthenticationUtil(
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
      // It is important that NotVerified and NotFound are grouped together
      // so that we don't leak information about the existence of the request.
      case EmailAccountRequestNotFoundException():
      case EmailAccountRequestNotVerifiedException():
      case EmailAccountAlreadyRegisteredException():
      case EmailAccountRequestAlreadyExistsException():
      case EmailAccountRequestVerificationCodeAlreadyUsedException():
        return EmailAccountRequestExceptionReason.invalid;
      case EmailAccountRequestVerificationTooManyAttemptsException():
        return EmailAccountRequestExceptionReason.tooManyAttempts;
      case EmailPasswordPolicyViolationException():
      case EmailAccountRequestInvalidEmailException():
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
      case EmailPasswordResetVerificationCodeAlreadyUsedException():
      case EmailPasswordResetEmailNotFoundException():
      case EmailPasswordResetNotVerifiedException():
        return EmailAccountPasswordResetExceptionReason.invalid;
      case EmailPasswordResetTooManyAttemptsException():
      case EmailPasswordResetTooManyVerificationAttemptsException():
        return EmailAccountPasswordResetExceptionReason.tooManyAttempts;
      case EmailPasswordResetPasswordPolicyViolationException():
        return EmailAccountPasswordResetExceptionReason.policyViolation;
      case EmailPasswordResetRequestExpiredException():
        return EmailAccountPasswordResetExceptionReason.expired;
    }
  }
}
