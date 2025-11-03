import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/email_string_extension.dart';

import '../../../generated/protocol.dart';
import 'email_idp_config.dart';
import 'email_idp_server_exceptions.dart';
import 'utils/email_idp_account_creation_util.dart';
import 'utils/email_idp_authentication_util.dart';
import 'utils/email_idp_password_hash_util.dart';
import 'utils/email_idp_password_reset_util.dart';

/// Email account management functions.
///
/// This class provides atomic building blocks for composing custom authentication
/// and administration flows. The building blocks are accessible through properties
/// divided up into related groups.
///
/// - [passwordHash] - Utilities for hashing passwords and verification codes
/// - [authentication] - Utilities for authenticating users
/// - [accountCreation] - Utilities for creating and verifying email accounts
/// - [passwordReset] - Utilities for resetting passwords
///
/// For most standard use cases, the methods exposed by [EmailIDP] and
/// [EmailIDPAdmin] should be sufficient.
class EmailIDPUtils {
  /// {@macro email_idp_password_hash_util}
  final EmailIDPPasswordHashUtil passwordHash;

  /// {@macro email_idp_account_creation_util}
  late final EmailIDPAccountCreationUtil accountCreation;

  /// {@macro email_idp_password_reset_util}
  late final EmailIDPPasswordResetUtil passwordReset;

  /// {@macro email_idp_authentication_utils}
  late final EmailIDPAuthenticationUtil authentication;

  /// Creates a new instance of [EmailIDPUtils].
  EmailIDPUtils({required final EmailIDPConfig config})
      : passwordHash = EmailIDPPasswordHashUtil(
          passwordHashPepper: config.passwordHashPepper,
          passwordHashSaltLength: config.passwordHashSaltLength,
        ) {
    accountCreation = EmailIDPAccountCreationUtil(
      config: EmailIDPAccountCreationUtilsConfig.fromEmailIDPConfig(config),
      passwordHashUtils: passwordHash,
    );
    passwordReset = EmailIDPPasswordResetUtil(
      config: EmailIDPPasswordResetUtilsConfig.fromEmailIDPConfig(config),
      passwordHashUtils: passwordHash,
    );
    authentication = EmailIDPAuthenticationUtil(
      passwordHashUtil: passwordHash,
      failedLoginRateLimit: config.failedLoginRateLimit,
    );
  }

  /// Deletes email accounts matching the provided filters.
  ///
  /// Both [email] and [authUserId] are optional nullable parameters that act
  /// as filters:
  /// - If [email] is provided, only accounts with that email are deleted.
  /// - If [authUserId] is provided, only accounts with that auth user ID are deleted.
  /// - If both are provided, accounts matching both criteria are deleted.
  /// - If neither is provided, all email accounts are deleted.
  ///
  /// Related data such as password reset requests will be automatically
  /// deleted due to cascade delete constraints.
  ///
  /// Returns the number of accounts deleted.
  Future<int> deleteAccount(
    final Session session, {
    final String? email,
    final UuidValue? authUserId,
    required final Transaction transaction,
  }) async {
    final normalizedEmail = email?.normalizedEmail;

    if (normalizedEmail == null && authUserId == null) {
      final deletedAccounts = await EmailAccount.db.deleteWhere(
        session,
        where: (final _) => Constant.bool(true),
        transaction: transaction,
      );
      return deletedAccounts.length;
    }

    final deletedAccounts = await EmailAccount.db.deleteWhere(
      session,
      where: (final t) {
        if (normalizedEmail != null && authUserId != null) {
          return t.email.equals(normalizedEmail) & t.authUserId.equals(authUserId);
        } else if (normalizedEmail != null) {
          return t.email.equals(normalizedEmail);
        } else {
          return t.authUserId.equals(authUserId!);
        }
      },
      transaction: transaction,
    );

    return deletedAccounts.length;
  }

  /// Replaces server-side exceptions by client-side exceptions, hiding details
  /// that could leak account information.
  static Future<T> withReplacedServerEmailException<T>(
      final Future<T> Function() fn) async {
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
