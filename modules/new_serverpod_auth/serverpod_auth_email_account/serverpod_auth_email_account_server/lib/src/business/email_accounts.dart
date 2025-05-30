import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/business/password_hash.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';

/// Email account management functions.
abstract final class EmailAccounts {
  /// Returns the [AuthUser]'s ID upon successful login.
  ///
  /// Throws [EmailAccountLoginException] for expected error cases.
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

        var account = await EmailAccount.db.findFirstRow(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        );

        if (await _hasTooManyFailedSignIns(session, email)) {
          throw EmailAccountLoginException(
            reason: EmailAccountLoginFailureReason.tooManyAttempts,
          );
        }

        try {
          account ??= await _importExistingUser(
            session,
            email: email,
            password: password,
            transaction: transaction,
          );
        } catch (_) {
          await _logFailedSignIn(session, email);

          rethrow;
        }

        if (account == null) {
          throw EmailAccountLoginException(
            reason: EmailAccountLoginFailureReason.invalidCredentials,
          );
        }

        if (!PasswordHash.validateHash(
          password: password,
          hash: Uint8List.sublistView(account.passwordHash),
          salt: Uint8List.sublistView(account.passwordSalt),
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

  /// Returns the result of the operation and a process ID for the account request.
  ///
  /// An account request is only created if the `result` is [EmailAccountRequestResult.accountRequestCreated].
  /// In all other cases `accountRequestId` will be `null`
  ///
  /// The caller should ensure that the actual result does not leak to the outside / client.
  /// Instead clients generally should always see a message like "If this email was not registered already,
  /// a new account has been created and a verification email has been sent".
  /// This prevents the endpoint being misused to scan for registered/valid email addresses.
  ///
  /// The caller might decide to initiate a password reset (per email, not in the client response), to help users which try
  /// to register but already have a valid account.
  ///
  /// In the success case of [EmailAccountRequestResult.accountRequestCreated], the caller may store additional information
  /// attached to the `accountRequestId`, which will be returned from [verifyAccountCreation] later on.
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
    if (!EmailAccountConfig.current.passwordValidationFunction(password)) {
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
            EmailAccountConfig.current.registrationVerificationCodeGenerator();

        final pendingAccountRequest = await EmailAccountRequest.db.findFirstRow(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        );
        if (pendingAccountRequest != null) {
          if (pendingAccountRequest.created.isBefore(DateTime.now().subtract(
            EmailAccountConfig.current.registrationVerificationCodeLifetime,
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

        final passwordHash = PasswordHash.createHash(password: password);

        final emailAccountRequest = await EmailAccountRequest.db.insertRow(
          session,
          EmailAccountRequest(
            email: email,
            passwordHash: ByteData.sublistView(passwordHash.hash),
            passwordSalt: ByteData.sublistView(passwordHash.salt),
            verificationCode: verificationCode,
          ),
          transaction: transaction,
        );

        EmailAccountConfig.current.sendRegistrationVerificationMail?.call(
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

  /// Returns the account request creation ID if the request is valid.
  ///
  /// If this returns a value, this means `createAccount` will succeed.
  static Future<({UuidValue emailAccountRequestId, String email})?>
      verifyAccountCreation(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
  }) async {
    final request = await EmailAccountRequest.db.findById(
      session,
      accountRequestId,
    );

    if (request == null ||
        request.isExpired ||
        request.verificationCode != verificationCode) {
      return null;
    }

    return (emailAccountRequestId: request.id!, email: request.email);
  }

  /// Finalize the email authentication creation.
  ///
  /// Returns the `ID` of the new email authentication, and the email address used during registration.
  ///
  /// Throws an [EmailAccountRequestNotFoundException] in case the [accountRequestId] does not point to an existing request.
  /// Throws an [EmailAccountRequestExpiredException] in case the request's validation window has elapsed.
  /// /// Throws [EmailAccountRequestUnauthorizedException] in case the [verificationCode] is not valid.
  static Future<({UuidValue emailAccountId, String email})>
      completeAccountCreation(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,

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

        if (request.isExpired) {
          throw EmailAccountRequestExpiredException();
        }

        if (request.verificationCode != verificationCode) {
          throw EmailAccountRequestUnauthorizedException();
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

        await _logPasswordResetRequestAttempt(
          session,
          email,
          transaction: transaction,
        );

        if (await _hasTooManyPasswordResetRequestAttempts(
          session,
          email,
          transaction: transaction,
        )) {
          throw Exception('Too many password reset requests in the last hour.');
        }

        final account = await EmailAccount.db.findFirstRow(
          session,
          where: (final t) => t.email.equals(email),
          transaction: transaction,
        );

        if (account == null) {
          return PasswordResetResult.emailDoesNotExist;
        }

        final resetToken =
            EmailAccountConfig.current.passwordResetVerificationCodeGenerator();

        final resetRequest =
            await EmailAccountPasswordResetRequest.db.insertRow(
          session,
          EmailAccountPasswordResetRequest(
            emailAccountId: account.id!,
            verificationCode: resetToken,
          ),
          transaction: transaction,
        );

        EmailAccountConfig.current.sendPasswordResetMail?.call(
          session,
          email: email,
          passwordResetRequestId: resetRequest.id!,
          verificationCode: resetToken,
          transaction: transaction,
        );

        return PasswordResetResult.passwordResetSent;
      },
    );
  }

  /// Returns whether the password reset request is still valid.
  ///
  /// If this returns a value, this means `completePasswordReset` will succeed.
  static Future<bool> verifyPasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
  }) async {
    final request = await EmailAccountPasswordResetRequest.db.findById(
      session,
      passwordResetRequestId,
    );

    if (request == null ||
        request.isExpired ||
        request.verificationCode != verificationCode) {
      return false;
    }

    return true;
  }

  /// Returns the auth user ID for the successfully changed password
  ///
  /// Throws [EmailAccountPasswordResetRequestNotFoundException] in case no reset request could be found for [passwordResetRequestId].
  /// Throws [EmailAccountPasswordResetRequestExpiredException] in case the reset request has expired.
  /// Throws [EmailAccountPasswordResetRequestUnauthorizedException] in case the [verificationCode] is not valid.
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
          throw EmailAccountPasswordResetRequestExpiredException();
        }

        if (!EmailAccountConfig.current
            .passwordValidationFunction(newPassword)) {
          throw EmailAccountPasswordPolicyViolationException();
        }

        await _logPasswordResetAttempt(
          session,
          passwordResetRequestId: resetRequest.id!,
          transaction: transaction,
        );

        if (await _hasTooManyPasswordResetAttempts(session,
            passwordResetRequestId: resetRequest.id!,
            transaction: transaction)) {
          throw 'Too many attempts'; // TODO: Custom exception with max count config exposed
        }

        if (resetRequest.verificationCode != verificationCode) {
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

        final newPasswordHash = PasswordHash.createHash(
          password: newPassword,
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
    final String email,
  ) async {
    final failedLoginAttemptCount =
        await EmailAccountFailedLoginAttempt.db.count(
      session,
      where: (final t) =>
          (t.email.equals(email) |
              t.ipAddress.equals(session.remoteIpAddress)) &
          (t.attemptedAt >
              DateTime.now().subtract(
                  EmailAccountConfig.current.emailSignInFailureResetTime)),
    );

    return failedLoginAttemptCount >=
        EmailAccountConfig.current.maxAllowedEmailSignInAttempts;
  }

  static Future<void> _logFailedSignIn(
    final Session session,
    final String email,
  ) async {
    await EmailAccountFailedLoginAttempt.db.insertRow(
      session,
      EmailAccountFailedLoginAttempt(
        email: email,
        ipAddress: session.remoteIpAddress,
      ),
    );
  }

  static Future<EmailAccount?> _importExistingUser(
    final Session session, {
    required final String email,
    required final String password,
    required final Transaction transaction,
  }) async {
    final importFunc = EmailAccountConfig.current.existingUserImportFunction;

    if (importFunc == null) {
      return null;
    }

    final userId = await importFunc(
      session,
      email: email,
      password: password,
      transaction: transaction,
    );

    if (userId == null) {
      return null;
    }

    final passwordHash = PasswordHash.createHash(
      password: password,
    );

    return await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: userId,
        email: email,
        passwordHash: ByteData.sublistView(passwordHash.hash),
        passwordSalt: ByteData.sublistView(passwordHash.salt),
      ),
      transaction: transaction,
    );
  }

  /// Cleans up the log of failed login attempts older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time window that
  /// is checked upon login, as configured in [EmailAccountConfig.emailSignInFailureResetTime].
  static Future<void> deleteFailedLoginAttempts(
    final Session session, {
    Duration? olderThan,
  }) async {
    olderThan ??= EmailAccountConfig.current.emailSignInFailureResetTime;

    final removeBefore = DateTime.now().subtract(olderThan);

    await EmailAccountFailedLoginAttempt.db.deleteWhere(
      session,
      where: (final t) => t.attemptedAt < removeBefore,
    );
  }

  /// Cleans up the log of failed password reset attempts older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time window that
  /// is checked upon password reset requets, as configured in [EmailAccountConfig.maxPasswordResetAttempts].
  static Future<void> deletePasswordResetAttempts(
    final Session session, {
    Duration? olderThan,
  }) async {
    olderThan ??= EmailAccountConfig.current.maxPasswordResetAttempts.timeframe;

    final removeBefore = DateTime.now().subtract(olderThan);

    await EmailAccountPasswordResetAttempt.db.deleteWhere(
      session,
      where: (final t) => t.attemptedAt < removeBefore,
    );
  }

  /// Cleans up expired password reset attempts.
  static Future<void> deleteExpiredPasswordResetRequests(
    final Session session,
  ) async {
    final lastValidDateTime = DateTime.now().subtract(
      EmailAccountConfig.current.passwordResetCodeLifetime,
    );

    await EmailAccountPasswordResetRequest.db.deleteWhere(
      session,
      where: (final t) => t.created < lastValidDateTime,
    );
  }

  /// Cleans up expired account creation requests.
  static Future<void> deleteExpiredAccountCreations(
    final Session session,
  ) async {
    final lastValidDateTime = DateTime.now().subtract(
      EmailAccountConfig.current.registrationVerificationCodeLifetime,
    );

    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final t) => t.created < lastValidDateTime,
    );
  }

  static Future<void> _logPasswordResetRequestAttempt(
    final Session session,
    final String email, {
    required final Transaction transaction,
  }) async {
    await EmailAccountPasswordResetRequestAttempt.db.insertRow(
      session,
      EmailAccountPasswordResetRequestAttempt(
        email: email,
        ipAddress: session.remoteIpAddress,
      ),
      transaction: transaction,
    );
  }

  static Future<bool> _hasTooManyPasswordResetRequestAttempts(
    final Session session,
    final String email, {
    required final Transaction transaction,
  }) async {
    final oldestRelevantAttemptTimestamp = DateTime.now().subtract(
      EmailAccountConfig.current.maxPasswordResetAttempts.timeframe,
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
        EmailAccountConfig.current.maxPasswordResetAttempts.maxAttempts;
  }

  static Future<void> _logPasswordResetAttempt(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final Transaction transaction,
  }) async {
    await EmailAccountPasswordResetAttempt.db.insertRow(
      session,
      EmailAccountPasswordResetAttempt(
        ipAddress: session.remoteIpAddress,
        passwordResetRequestId: passwordResetRequestId,
      ),
      transaction: transaction,
    );
  }

  static Future<bool> _hasTooManyPasswordResetAttempts(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final Transaction transaction,
  }) async {
    final recentRequests = await EmailAccountPasswordResetAttempt.db.count(
      session,
      where: (final t) =>
          t.passwordResetRequestId.equals(passwordResetRequestId),
      transaction: transaction,
    );

    return recentRequests >
        EmailAccountConfig.current.passwordResetCodeAllowedAttempts;
  }
}

extension on Session {
  /// Returns the requester's IP address, or empty string in case it could not be determined
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
/// such that outside clients can not use this result to determine wheter or not a specific
/// acccount is registered on the server.
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
    final oldestValidRegistrationTime = DateTime.now().subtract(
      EmailAccountConfig.current.registrationVerificationCodeLifetime,
    );

    return created.isBefore(oldestValidRegistrationTime);
  }
}

extension on EmailAccountPasswordResetRequest {
  bool get isExpired {
    final oldestValidResetDate = DateTime.now().subtract(
      EmailAccountConfig.current.passwordResetCodeLifetime,
    );

    return created.isBefore(oldestValidResetDate);
  }
}
