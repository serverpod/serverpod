import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import 'email_idp_config.dart';
import 'email_idp_server_exceptions.dart';
import 'utils/email_idp_account_creation_util.dart';
import 'utils/email_idp_account_utils.dart';
import 'utils/email_idp_authentication_util.dart';
import 'utils/email_idp_password_reset_util.dart';
import 'utils/email_idp_passwordless_login_util.dart';

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
/// - [passwordlessLogin] - Utilities for logging in with a code sent by email
///
/// The utilities of a login method that is disabled in the [EmailIdpConfig]
/// throw a [StateError] when accessed, see [passwordLoginEnabled] and
/// [passwordlessLoginEnabled].
///
/// For most standard use cases, the methods exposed by [EmailIdp] and
/// [EmailIdpAdmin] should be sufficient.
class EmailIdpUtils {
  /// General hash util for the email identity provider.
  ///
  /// Follows OWASP recommended parameters for storing passwords.
  final Argon2HashUtil hashUtil;

  EmailIdpAccountCreationUtil? _accountCreation;
  EmailIdpPasswordResetUtil? _passwordReset;
  EmailIdpAuthenticationUtil? _authentication;
  EmailIdpPasswordlessLoginUtil? _passwordlessLogin;

  /// Whether the password login is enabled, see [EmailIdpConfig.password].
  bool get passwordLoginEnabled => _authentication != null;

  /// Whether the passwordless login is enabled, see
  /// [EmailIdpConfig.passwordless].
  bool get passwordlessLoginEnabled => _passwordlessLogin != null;

  /// {@macro email_idp_account_creation_util}
  EmailIdpAccountCreationUtil get accountCreation =>
      _accountCreation ?? (throw _passwordLoginDisabled());

  /// {@macro email_idp_password_reset_util}
  EmailIdpPasswordResetUtil get passwordReset =>
      _passwordReset ?? (throw _passwordLoginDisabled());

  /// {@macro email_idp_authentication_utils}
  EmailIdpAuthenticationUtil get authentication =>
      _authentication ?? (throw _passwordLoginDisabled());

  /// {@macro email_idp_passwordless_login_util}
  EmailIdpPasswordlessLoginUtil get passwordlessLogin =>
      _passwordlessLogin ??
      (throw StateError(
        'The passwordless login of the email IdP is disabled.',
      ));

  static StateError _passwordLoginDisabled() =>
      StateError('The password login of the email IdP is disabled.');

  /// {@macro email_idp_account_utils}
  final EmailIdpAccountUtils account;

  /// Creates a new instance of [EmailIdpUtils].
  EmailIdpUtils({
    required final EmailIdpConfig config,
    final AuthUsers authUsers = const AuthUsers(),
  }) : hashUtil = Argon2HashUtil(
         hashPepper: config.secretHashPepper,
         fallbackHashPeppers: config.fallbackSecretHashPeppers,
         hashSaltLength: config.secretHashSaltLength,
         // Cost as recommended by OWASP: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
         parameters: Argon2HashParameters(
           memory: 19456,
           iterations: 2,
           lanes: 1,
         ),
       ),
       account = EmailIdpAccountUtils() {
    // Verification codes expire and allow few attempts, so they use the
    // default Argon2 cost and not the password one.
    final verificationCodeHash = Argon2HashUtil(
      hashPepper: config.secretHashPepper,
      fallbackHashPeppers: config.fallbackSecretHashPeppers,
      hashSaltLength: config.secretHashSaltLength,
    );
    final completionTokenHash = Argon2HashUtil.forRandomSecrets(
      hashPepper: config.secretHashPepper,
      fallbackHashPeppers: config.fallbackSecretHashPeppers,
      hashSaltLength: config.secretHashSaltLength,
    );
    final password = config.effectivePassword;
    if (password != null) {
      _accountCreation = EmailIdpAccountCreationUtil(
        config: EmailIdpAccountCreationUtilsConfig.fromEmailIdpConfig(config),
        passwordHashUtils: hashUtil,
        authUsers: authUsers,
        verificationCodeHash: verificationCodeHash,
        completionTokenHash: completionTokenHash,
      );
      _passwordReset = EmailIdpPasswordResetUtil(
        config: EmailIdpPasswordResetUtilsConfig.fromEmailIdpConfig(config),
        passwordHashUtils: hashUtil,
        verificationCodeHash: verificationCodeHash,
        completionTokenHash: completionTokenHash,
      );
      _authentication = EmailIdpAuthenticationUtil(
        hashUtil: hashUtil,
        failedLoginRateLimit: password.failedLoginRateLimit,
      );
    }
    if (config.passwordless != null) {
      _passwordlessLogin = EmailIdpPasswordlessLoginUtil(
        config: EmailIdpPasswordlessLoginUtilConfig.fromEmailIdpConfig(config),
        verificationCodeHash: verificationCodeHash,
      );
    }
  }

  /// Returns the possible [EmailAccount] associated with a session.
  Future<EmailAccount?> getAccount(final Session session) {
    return switch (session.authenticated) {
      null => Future.value(null),
      _ => EmailAccount.db.findFirstRow(
        session,
        where: (final t) => t.authUserId.equals(
          session.authenticated!.authUserId,
        ),
      ),
    };
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
        case EmailPasswordlessLoginServerException():
          throw EmailPasswordlessLoginException(reason: e.reason);
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

extension on EmailPasswordlessLoginServerException {
  EmailPasswordlessLoginExceptionReason get reason {
    switch (this) {
      // It is important that these are grouped together, so that we don't leak
      // information about the existence of the request or the account.
      case EmailPasswordlessLoginRequestNotFoundException():
      case EmailPasswordlessInvalidVerificationCodeException():
      case EmailPasswordlessSignUpNotAllowedException():
        return EmailPasswordlessLoginExceptionReason.invalid;
      case EmailPasswordlessInvalidEmailException():
        return EmailPasswordlessLoginExceptionReason.invalidEmail;
      case EmailPasswordlessTooManyVerificationAttemptsException():
        return EmailPasswordlessLoginExceptionReason.tooManyAttempts;
      case EmailPasswordlessLoginRequestRateLimitedException():
        return EmailPasswordlessLoginExceptionReason.rateLimited;
      case EmailPasswordlessResendCooldownException():
        return EmailPasswordlessLoginExceptionReason.resendCooldown;
      case EmailPasswordlessLoginRequestExpiredException():
        return EmailPasswordlessLoginExceptionReason.expired;
    }
  }
}
