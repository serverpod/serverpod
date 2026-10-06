import 'package:serverpod/serverpod.dart';

import '../../../../core.dart';
import '../../email/business/utils/email_idp_account_utils.dart';
import '../../email/util/email_string_extension.dart';
import 'email_passwordless_idp_config.dart';
import 'email_passwordless_idp_server_exceptions.dart';
import 'utils/email_passwordless_idp_login_util.dart';

/// Passwordless email account management functions.
///
/// This class provides atomic building blocks for composing custom
/// authentication and administration flows. The building blocks are accessible
/// through properties divided up into related groups.
///
/// - [hashUtil] - Utility for hashing verification codes
/// - [login] - Utilities for creating and verifying login requests
/// - [account] - Utilities for working with the email accounts
///
/// For most standard use cases, the methods exposed by [EmailPasswordlessIdp]
/// and [EmailPasswordlessIdpAdmin] should be sufficient.
class EmailPasswordlessIdpUtils {
  /// Hash util for the verification codes of the passwordless email identity
  /// provider.
  ///
  /// Codes expire and allow few attempts, so this uses the default Argon2 cost
  /// and not the one for passwords.
  final Argon2HashUtil hashUtil;

  /// {@macro email_passwordless_idp_login_util}
  late final EmailPasswordlessIdpLoginUtil login;

  /// {@macro email_idp_account_utils}
  final EmailIdpAccountUtils account;

  /// Creates a new instance of [EmailPasswordlessIdpUtils].
  EmailPasswordlessIdpUtils({
    required final EmailPasswordlessIdpConfig config,
  }) : hashUtil = Argon2HashUtil(
         hashPepper: config.secretHashPepper,
         fallbackHashPeppers: config.fallbackSecretHashPeppers,
         hashSaltLength: config.secretHashSaltLength,
       ),
       account = EmailIdpAccountUtils() {
    login = EmailPasswordlessIdpLoginUtil(
      config:
          EmailPasswordlessIdpLoginUtilConfig.fromEmailPasswordlessIdpConfig(
            config,
          ),
      verificationCodeHash: hashUtil,
      completionTokenHash: Argon2HashUtil.forRandomSecrets(
        hashPepper: config.secretHashPepper,
        fallbackHashPeppers: config.fallbackSecretHashPeppers,
        hashSaltLength: config.secretHashSaltLength,
      ),
    );
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

  /// Creates an [EmailAccount] without a password for [authUserId].
  ///
  /// The [email] is treated as verified right away, so the caller must ensure
  /// that it comes from a trusted source. It is normalized before it is stored.
  ///
  /// Returns the created account.
  Future<EmailAccount> createAccount(
    final Session session, {
    required final UuidValue authUserId,
    required final String email,
    required final Transaction transaction,
  }) {
    return EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        email: email.normalizedEmail,
        passwordHash: '',
      ),
      transaction: transaction,
    );
  }

  /// Replaces server-side exceptions by client-side exceptions, hiding details
  /// that could leak account information.
  static Future<T> withReplacedServerException<T>(
    final Future<T> Function() fn,
  ) async {
    try {
      return await fn();
    } on EmailPasswordlessLoginServerException catch (e) {
      throw EmailPasswordlessLoginException(reason: e.reason);
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
      case EmailPasswordlessLoginRequestExpiredException():
        return EmailPasswordlessLoginExceptionReason.expired;
    }
  }
}
