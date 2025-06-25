import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/business/email_account_secret_hash.dart';
import 'package:serverpod_auth_email_account_server/src/business/email_accounts_admin.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:serverpod_auth_email_account_server/src/util/byte_data_extension.dart';
import 'package:serverpod_auth_email_account_server/src/util/uint8list_extension.dart';

/// Email account management functions.
abstract final class EmailAccounts {
  /// The currently active email accounts configuration.
  static EmailAccountConfig config = EmailAccountConfig();

  /// Collection of admin-related functions.
  static final admin = EmailAccountsAdmin();

  /// Returns the [AuthUser]'s ID upon successful login.
  ///
  /// Throws [EmailAccountLoginException] for expected error cases.
  ///
  /// In case of invalid credentials, the failed login attempt will be logged to
  /// the database outside of the [transaction] and can not be rolled back.
  static Future<UuidValue> login(
    final Session session, {
    required String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        email = email.trim().toLowerCase();

        if (await _hasTooManyFailedSignIns(
          session,
          email,
          transaction: transaction,
        )) {
          throw EmailAccountLoginException(
            reason: EmailAccountLoginFailureReason.tooManyAttempts,
          );
        }

        final account = await EmailAccount.db.findFirstRow(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        );

        if (account == null ||
            !await EmailAccountSecretHash.validateHash(
              value: password,
              hash: account.passwordHash.asUint8List,
              salt: account.passwordSalt.asUint8List,
            )) {
          await _logFailedSignIn(session, email);

          throw EmailAccountLoginException(
            reason: EmailAccountLoginFailureReason.invalidCredentials,
          );
        }

        return account.authUserId;
      },
    );
  }

  /// Returns the result of the operation and a process ID for the account
  /// request.
  ///
  /// An account request is only created if the `result` is
  /// [EmailAccountRequestResult.accountRequestCreated].
  /// In all other cases `accountRequestId` will be `null`.
  ///
  /// The caller should ensure that the actual result does not leak to the
  /// outside client.
  /// Instead clients generally should always see a message like "If this email
  /// was not registered already, a new account has been created and a
  /// verification email has been sent".
  /// This prevents the endpoint from being misused to scan for registered/valid
  /// email addresses.
  ///
  /// The caller might decide to initiate a password reset (via email, not in
  /// the client response), to help users which try to register but already have
  /// an account.
  ///
  /// In the success case of [EmailAccountRequestResult.accountRequestCreated],
  /// the caller may store additional information attached to the
  /// `accountRequestId`, which will be returned from [verifyAccountCreation]
  /// later on.
  static Future<
      ({
        EmailAccountRequestResult result,
        UuidValue? accountRequestId,
      })> startAccountCreation(
    final Session session, {
    required String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    if (!EmailAccounts.config.passwordValidationFunction(password)) {
      throw EmailAccountPasswordPolicyViolationException();
    }

    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        email = email.trim().toLowerCase();

        final existingAccountCount = await EmailAccount.db.count(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        );
        if (existingAccountCount > 0) {
          return (
            result: EmailAccountRequestResult.emailAlreadyRegistered,
            accountRequestId: null,
          );
        }

        final verificationCode =
            EmailAccounts.config.registrationVerificationCodeGenerator();

        final pendingAccountRequest = await EmailAccountRequest.db.findFirstRow(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        );
        if (pendingAccountRequest != null) {
          if (pendingAccountRequest.created.isBefore(clock.now().subtract(
                EmailAccounts.config.registrationVerificationCodeLifetime,
              ))) {
            await EmailAccountRequest.db.deleteRow(
              session,
              pendingAccountRequest,
              transaction: transaction,
            );
          } else {
            return (
              result: EmailAccountRequestResult.emailAlreadyRequested,
              accountRequestId: null,
            );
          }
        }

        final passwordHash = await EmailAccountSecretHash.createHash(
          value: password,
        );
        final verificationCodeHash = await EmailAccountSecretHash.createHash(
          value: verificationCode,
        );

        final emailAccountRequest = await EmailAccountRequest.db.insertRow(
          session,
          EmailAccountRequest(
            email: email,
            passwordHash: passwordHash.hash.asByteData,
            passwordSalt: passwordHash.salt.asByteData,
            verificationCodeHash: verificationCodeHash.hash.asByteData,
            verificationCodeSalt: verificationCodeHash.salt.asByteData,
          ),
          transaction: transaction,
        );

        EmailAccounts.config.sendRegistrationVerificationCode?.call(
          session,
          email: email,
          accountRequestId: emailAccountRequest.id!,
          verificationCode: verificationCode,
          transaction: transaction,
        );

        return (
          result: EmailAccountRequestResult.accountRequestCreated,
          accountRequestId: emailAccountRequest.id!,
        );
      },
    );
  }

  /// Checks whether the verification code matches the pending account creation
  /// request.
  ///
  /// If this returns successfully, this means `createAccount` can be called.
  ///
  /// Throws an [EmailAccountRequestNotFoundException] in case the
  /// [accountRequestId] does not point to an existing request.
  /// Throws an [EmailAccountRequestExpiredException] in case the request's
  /// validation window has elapsed.
  /// Throws [EmailAccountRequestUnauthorizedException] in case the
  /// [verificationCode] is not valid.
  ///
  /// In case of an invalid [verificationCode], the failed attempt will be
  /// logged to the database outside of the [transaction] and can not be rolled
  /// back.
  static Future<({UuidValue emailAccountRequestId, String email})>
      verifyAccountCreation(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
    final Transaction? transaction,
  }) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
      transaction: transaction,
    );

    if (request == null) {
      throw EmailAccountRequestNotFoundException();
    }

    if (request.isExpired) {
      await EmailAccountRequest.db.deleteRow(
        session,
        request,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailAccountRequestExpiredException();
    }

    if (await _hasTooManyEmailAccountCompletionAttempts(
      session,
      emailAccountRequestId: request.id!,
    )) {
      await EmailAccountRequest.db.deleteRow(
        session,
        request,
        // passing no transaction, so this will not be rolled back
      );

      throw EmailAccountRequestTooManyAttemptsException();
    }

    if (!await EmailAccountSecretHash.validateHash(
      value: verificationCode,
      hash: request.verificationCodeHash.asUint8List,
      salt: request.verificationCodeSalt.asUint8List,
    )) {
      throw EmailAccountRequestUnauthorizedException();
    }

    await EmailAccountRequest.db.updateRow(
      session,
      request.copyWith(verifiedAt: clock.now()),
      transaction: transaction,
    );

    return (emailAccountRequestId: request.id!, email: request.email);
  }

  /// Finalize the email authentication creation.
  ///
  /// Returns the `ID` of the new email authentication, and the email address
  /// used during registration.
  ///
  /// Throws an [EmailAccountRequestNotFoundException] in case the
  /// [accountRequestId] does not point to an existing request.
  /// Throws an [EmailAccountRequestNotVerifiedException] in case the request
  /// has not been verified via [verifyAccountCreation].
  static Future<({UuidValue emailAccountId, String email})>
      completeAccountCreation(
    final Session session, {
    required final UuidValue accountRequestId,

    /// Authentication user ID this account should be linked up with
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final request = await EmailAccountRequest.db.findById(
          session,
          accountRequestId,
          transaction: transaction,
        );

        if (request == null) {
          throw EmailAccountRequestNotFoundException();
        }

        if (request.verifiedAt == null) {
          throw EmailAccountRequestNotVerifiedException();
        }

        await EmailAccountRequest.db.deleteRow(
          session,
          request,
          transaction: transaction,
        );

        final account = await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            authUserId: authUserId,
            email: request.email,
            passwordHash: request.passwordHash,
            passwordSalt: request.passwordSalt,
          ),
          transaction: transaction,
        );

        return (emailAccountId: account.id!, email: request.email);
      },
    );
  }

  /// Sends out a password reset email for the given account, if it exists.
  ///
  /// The caller may check the returned [PasswordResetResult], but this
  /// should not be exposed to the client, so that this method can not be
  /// misused to check which emails are registered.
  ///
  /// Each reset request will be logged to the database outside of the
  /// [transaction] and can not be rolled back, so the throttling will always be
  /// enforced.
  static Future<PasswordResetResult> startPasswordReset(
    final Session session, {
    required String email,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        email = email.trim().toLowerCase();

        if (await _hasTooManyPasswordResetRequestAttempts(
          session,
          email: email,
        )) {
          throw EmailAccountPasswordResetRequestTooManyAttemptsException();
        }

        final account = await EmailAccount.db.findFirstRow(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        );

        if (account == null) {
          return PasswordResetResult.emailDoesNotExist;
        }

        final verificationCode =
            EmailAccounts.config.passwordResetVerificationCodeGenerator();

        final verificationCodeHash = await EmailAccountSecretHash.createHash(
          value: verificationCode,
        );

        final resetRequest =
            await EmailAccountPasswordResetRequest.db.insertRow(
          session,
          EmailAccountPasswordResetRequest(
            emailAccountId: account.id!,
            verificationCodeHash: verificationCodeHash.hash.asByteData,
            verificationCodeSalt: verificationCodeHash.salt.asByteData,
          ),
          transaction: transaction,
        );

        EmailAccounts.config.sendPasswordResetVerificationCode?.call(
          session,
          email: email,
          passwordResetRequestId: resetRequest.id!,
          verificationCode: verificationCode,
          transaction: transaction,
        );

        return PasswordResetResult.passwordResetSent;
      },
    );
  }

  /// Returns the auth user ID for the successfully changed password
  ///
  /// Throws [EmailAccountPasswordResetRequestNotFoundException] in case no
  /// reset request could be found for [passwordResetRequestId].
  /// Throws [EmailAccountPasswordResetRequestExpiredException] in case the
  /// reset request has expired.
  /// Throws [EmailAccountPasswordResetRequestUnauthorizedException] in case the
  /// [verificationCode] is not valid.
  ///
  /// In case of an invalid [verificationCode], the failed password reset
  /// completion will be logged to the database outside of the [transaction] and
  /// can not be rolled back.
  static Future<UuidValue> completePasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final String newPassword,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) async {
        final resetRequest = await EmailAccountPasswordResetRequest.db.findById(
          session,
          passwordResetRequestId,
          transaction: transaction,
        );

        if (resetRequest == null) {
          throw EmailAccountPasswordResetRequestNotFoundException();
        }

        if (resetRequest.isExpired) {
          await EmailAccountPasswordResetRequest.db.deleteRow(
            session,
            resetRequest,
            // passing no transaction, so this will not be rolled back
          );

          throw EmailAccountPasswordResetRequestExpiredException();
        }

        if (!EmailAccounts.config.passwordValidationFunction(newPassword)) {
          throw EmailAccountPasswordPolicyViolationException();
        }

        if (await _hasTooManyPasswordResetAttempts(
          session,
          passwordResetRequestId: resetRequest.id!,
        )) {
          await EmailAccountPasswordResetRequest.db.deleteRow(
            session,
            resetRequest,
            // passing no transaction, so this will not be rolled back
          );

          throw EmailAccountPasswordResetTooManyAttemptsException();
        }

        if (!await EmailAccountSecretHash.validateHash(
          value: verificationCode,
          hash: resetRequest.verificationCodeHash.asUint8List,
          salt: resetRequest.verificationCodeSalt.asUint8List,
        )) {
          throw EmailAccountPasswordResetRequestUnauthorizedException();
        }

        await EmailAccountPasswordResetRequest.db.deleteRow(
          session,
          resetRequest,
          transaction: transaction,
        );

        final account = (await EmailAccount.db.findById(
          session,
          resetRequest.emailAccountId,
          transaction: transaction,
        ))!;

        final newPasswordHash = await EmailAccountSecretHash.createHash(
          value: newPassword,
        );

        await EmailAccount.db.updateRow(
          session,
          account.copyWith(
            passwordHash: ByteData.sublistView(newPasswordHash.hash),
            passwordSalt: ByteData.sublistView(newPasswordHash.salt),
          ),
          transaction: transaction,
        );

        return account.authUserId;
      },
    );
  }

  static Future<bool> _hasTooManyFailedSignIns(
    final Session session,
    final String email, {
    final Transaction? transaction,
  }) async {
    final oldestRelevantAttempt = clock
        .now()
        .subtract(EmailAccounts.config.failedLoginRateLimit.timeframe);

    final failedLoginAttemptCount =
        await EmailAccountFailedLoginAttempt.db.count(
      session,
      where: (final t) =>
          (t.email.equals(email) |
              t.ipAddress.equals(session.remoteIpAddress)) &
          (t.attemptedAt > oldestRelevantAttempt),
      transaction: transaction,
    );

    return failedLoginAttemptCount >=
        EmailAccounts.config.failedLoginRateLimit.maxAttempts;
  }

  static Future<void> _logFailedSignIn(
    final Session session,
    final String email,
  ) async {
    // NOTE: The failed attempt logging runs in a separate transaction, so that
    // it is never rolled back with the parent transaction.
    await session.db.transaction((final transaction) async {
      await EmailAccountFailedLoginAttempt.db.insertRow(
        session,
        EmailAccountFailedLoginAttempt(
          email: email,
          ipAddress: session.remoteIpAddress,
        ),
        transaction: transaction,
      );
    });
  }

  static Future<bool> _hasTooManyPasswordResetRequestAttempts(
    final Session session, {
    required final String email,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    return session.db.transaction((final transaction) async {
      await EmailAccountPasswordResetRequestAttempt.db.insertRow(
        session,
        EmailAccountPasswordResetRequestAttempt(
          email: email,
          ipAddress: session.remoteIpAddress,
        ),
        transaction: transaction,
      );

      final oldestRelevantAttemptTimestamp = clock.now().subtract(
            EmailAccounts.config.maxPasswordResetAttempts.timeframe,
          );

      final recentRequests =
          await EmailAccountPasswordResetRequestAttempt.db.count(
        session,
        where: (final t) =>
            (t.email.equals(email) |
                t.ipAddress.equals(session.remoteIpAddress)) &
            (t.attemptedAt > oldestRelevantAttemptTimestamp),
        transaction: transaction,
      );

      return recentRequests >
          EmailAccounts.config.maxPasswordResetAttempts.maxAttempts;
    });
  }

  static Future<bool> _hasTooManyPasswordResetAttempts(
    final Session session, {
    required final UuidValue passwordResetRequestId,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is never rolled back with the parent transaction.
    return session.db.transaction(
      (final transaction) async {
        await EmailAccountPasswordResetAttempt.db.insertRow(
          session,
          EmailAccountPasswordResetAttempt(
            ipAddress: session.remoteIpAddress,
            passwordResetRequestId: passwordResetRequestId,
          ),
          transaction: transaction,
        );

        final recentAttempts = await EmailAccountPasswordResetAttempt.db.count(
          session,
          where: (final t) =>
              t.passwordResetRequestId.equals(passwordResetRequestId),
          transaction: transaction,
        );

        return recentAttempts >
            EmailAccounts.config.passwordResetVerificationCodeAllowedAttempts;
      },
    );
  }

  static Future<bool> _hasTooManyEmailAccountCompletionAttempts(
    final Session session, {
    required final UuidValue emailAccountRequestId,
  }) async {
    // NOTE: The attempt counting runs in a separate transaction, so that it is
    // never rolled back with the parent transaction.
    return session.db.transaction((final transaction) async {
      await EmailAccountRequestCompletionAttempt.db.insertRow(
        session,
        EmailAccountRequestCompletionAttempt(
          ipAddress: session.remoteIpAddress,
          emailAccountRequestId: emailAccountRequestId,
        ),
        transaction: transaction,
      );

      final recentRequests =
          await EmailAccountRequestCompletionAttempt.db.count(
        session,
        where: (final t) =>
            t.emailAccountRequestId.equals(emailAccountRequestId),
        transaction: transaction,
      );

      return recentRequests >
          EmailAccounts.config.registrationVerificationCodeAllowedAttempts;
    });
  }
}

extension on Session {
  /// Returns the client's IP address, or empty string in case it could not be
  /// determined.
  String get remoteIpAddress {
    final session = this;

    return session is MethodCallSession
        ? session.httpRequest.remoteIpAddress
        : '';
  }
}

/// The result of the [EmailAccounts.completeAccountCreation] operation.
///
/// This describes the detailed status of the operation to the caller.
///
/// In the general case the caller should take care not to leak this to clients,
/// such that outside clients can not use this result to determine wheter or not
/// a specific acccount is registered on the server.
enum EmailAccountRequestResult {
  /// An account request has been created.
  accountRequestCreated,

  /// There is a pending account request for this email already.
  ///
  /// No account request has been created.
  emailAlreadyRequested,

  /// There an account for this email already.
  ///
  /// No account request has been created.
  emailAlreadyRegistered,
}

/// Describes the result of a password reset operation.
enum PasswordResetResult {
  /// A password reset email has been sent.
  passwordResetSent,

  /// No account exists for the given email.
  emailDoesNotExist,
}

extension on EmailAccountRequest {
  bool get isExpired {
    final requestExpiresAt = created.add(
      EmailAccounts.config.registrationVerificationCodeLifetime,
    );

    return requestExpiresAt.isBefore(clock.now());
  }
}

extension on EmailAccountPasswordResetRequest {
  bool get isExpired {
    final resetExpiresAt = created.add(
      EmailAccounts.config.passwordResetVerificationCodeLifetime,
    );

    return resetExpiresAt.isBefore(clock.now());
  }
}
