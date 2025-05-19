import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/business/password_hash.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Email account management functions.
abstract final class EmailAccounts {
  /// Returns the [AuthUser]'s ID upon successful login.
  ///
  /// Throws [EmailAccountLoginException] for expected error cases.
  static Future<UuidValue> login(
    final Session session, {
    required String email,
    required String password,
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      email = email.trim().toLowerCase();
      password = password.trim();

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
        email: email,
        password: password,
        hash: account.passwordHash,
      )) {
        await _logFailedSignIn(session, email);

        throw EmailAccountLoginException(
          reason: EmailAccountLoginFailureReason.invalidCredentials,
        );
      }

      return account.authUserId;
    }, transaction: transaction);
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
  /// attached to the `accountRequestId`, which will be returned from [verifyAccountRequest] later on.
  static Future<
      ({
        EmailAccountRequestResult result,
        UuidValue? accountRequestId,
      })> requestAccount(
    final Session session, {
    required String email,
    required final String password,
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
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

      final verificationCode = generateRandomString(20);

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

      final emailAccountRequest = await EmailAccountRequest.db.insertRow(
        session,
        EmailAccountRequest(
          email: email,
          passwordHash: PasswordHash.createHash(
            email: email,
            password: password,
          ),
          verificationCode: verificationCode,
        ),
        transaction: transaction,
      );

      EmailAccountConfig.current.sendRegistrationVerificationMail?.call(
        session,
        email: email,
        verificationToken: verificationCode,
        transaction: transaction,
      );

      return (
        result: EmailAccountRequestResult.accountRequestCreated,
        accountRequestId: emailAccountRequest.id!,
      );
    }, transaction: transaction);
  }

  /// Returns the account request creation ID if the request is valid.
  ///
  /// If this returns a value, this means `createAccount` will succeed.
  static Future<({UuidValue emailAccountRequestId, String email})?>
      verifyAccountRequest(
    final Session session, {
    required final String verificationCode,
  }) async {
    final oldestValidRegistrationTime = DateTime.now().subtract(
      EmailAccountConfig.current.registrationVerificationCodeLifetime,
    );

    final request = await EmailAccountRequest.db.findFirstRow(
      session,
      where: (final t) =>
          t.verificationCode.equals(verificationCode) &
          (t.created > oldestValidRegistrationTime),
    );

    if (request == null) {
      return null;
    }

    return (emailAccountRequestId: request.id!, email: request.email);
  }

  /// Finalize the email authentication creation.
  ///
  /// Returns the `ID` of the new email authentication, and the email address used during registration.
  static Future<({UuidValue emailAccountId, String email})> createAccount(
    final Session session, {
    required final String verificationCode,

    /// Authentication user ID this account should be linked up with
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      final oldestValidRegistrationTime = DateTime.now().subtract(
        EmailAccountConfig.current.registrationVerificationCodeLifetime,
      );

      final request = await EmailAccountRequest.db.findFirstRow(
        session,
        where: (final t) =>
            t.verificationCode.equals(verificationCode) &
            (t.created > oldestValidRegistrationTime),
        transaction: transaction,
      );

      if (request == null) {
        throw Exception('Email account request not found');
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
          created: DateTime.now(),
          email: request.email,
          passwordHash: request.passwordHash,
        ),
        transaction: transaction,
      );

      return (emailAccountId: account.id!, email: request.email);
    }, transaction: transaction);
  }

  /// Sends out a password reset email for the given account, if it exists.
  ///
  /// The caller may check the returned [PasswordResetResult], but this
  /// should not be exposed to the client, so that this method can not be
  /// misused to check which emails are registered.
  static Future<PasswordResetResult> requestPasswordReset(
    final Session session, {
    required String email,
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      email = email.trim().toLowerCase();

      await _logPasswordResetAttempt(
        session,
        email,
        transaction: transaction,
      );

      if (await _hasTooManyPasswordResetAttempts(
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

      final resetToken = generateRandomString(20);

      await EmailAccountPasswordResetRequest.db.insertRow(
        session,
        EmailAccountPasswordResetRequest(
          authenticationId: account.id!,
          verificationCode: resetToken,
        ),
        transaction: transaction,
      );

      EmailAccountConfig.current.sendPasswordResetMail?.call(
        session,
        email: email,
        resetToken: resetToken,
        transaction: transaction,
      );

      return PasswordResetResult.passwordResetSent;
    }, transaction: transaction);
  }

  /// Returns the auth user ID for the successfully changed password
  static Future<UuidValue> completePasswordReset(
    final Session session, {
    required final String resetCode,
    required final String newPassword,
    final Transaction? transaction,
  }) async {
    return session.transactionOrSavepoint((final transaction) async {
      final oldestValidResetDate = DateTime.now().subtract(
        EmailAccountConfig.current.passwordResetCodeLifetime,
      );

      final resetRequest =
          await EmailAccountPasswordResetRequest.db.findFirstRow(
        session,
        where: (final t) =>
            t.verificationCode.equals(resetCode) &
            (t.created > oldestValidResetDate),
        transaction: transaction,
      );

      if (resetRequest == null) {
        throw Exception('Password reset request not found.');
      }

      await EmailAccountPasswordResetRequest.db.deleteRow(
        session,
        resetRequest,
        transaction: transaction,
      );

      final account = (await EmailAccount.db.findById(
        session,
        resetRequest.authenticationId,
        transaction: transaction,
      ))!;

      await EmailAccount.db.updateRow(
        session,
        account.copyWith(
          passwordHash: PasswordHash.createHash(
            email: account.email,
            password: newPassword,
          ),
        ),
        transaction: transaction,
      );

      return account.authUserId;
    }, transaction: transaction);
  }

  static Future<bool> _hasTooManyFailedSignIns(
    final Session session,
    final String email,
  ) async {
    final failedLoginAttemptCount =
        await EmailAccountFailedLoginAttempt.db.count(
      session,
      where: (final t) =>
          t.email.equals(email) &
          (t.attemptedAt >
              DateTime.now().toUtc().subtract(
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

    return await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: userId,
        email: email,
        passwordHash: PasswordHash.createHash(
          email: email,
          password: password,
        ),
      ),
      transaction: transaction,
    );
  }

  /// Cleans up the log of failed login attempts older than [olderThan].
  static Future<void> deleteFailedLoginAttempts(
    final Session session, {
    required final Duration olderThan,
  }) async {
    final removeBefore = DateTime.now().subtract(olderThan);

    await EmailAccountFailedLoginAttempt.db.deleteWhere(
      session,
      where: (final t) => t.attemptedAt < removeBefore,
    );
  }

  /// Cleans up the log of failed password reset attempts older than [olderThan].
  static Future<void> deletePasswordResetAttempts(
    final Session session, {
    required final Duration olderThan,
  }) async {
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
    final lastValidDateTime = DateTime.now()
        .subtract(EmailAccountConfig.current.passwordResetCodeLifetime);

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
        EmailAccountConfig.current.registrationVerificationCodeLifetime);

    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final t) => t.created < lastValidDateTime,
    );
  }

  static Future<void> _logPasswordResetAttempt(
    final Session session,
    final String email, {
    required final Transaction transaction,
  }) async {
    await EmailAccountPasswordResetAttempt.db.insertRow(
      session,
      EmailAccountPasswordResetAttempt(
        email: email,
        ipAddress: session.remoteIpAddress,
      ),
      transaction: transaction,
    );
  }

  static Future<bool> _hasTooManyPasswordResetAttempts(
    final Session session,
    final String email, {
    required final Transaction transaction,
  }) async {
    final recentRequests = await EmailAccountPasswordResetAttempt.db.count(
      session,
      where: (final t) =>
          (t.email.equals(email) |
              t.ipAddress.equals(session.remoteIpAddress)) &
          (t.attemptedAt > DateTime.now().subtract(const Duration(hours: 1))),
      transaction: transaction,
    );

    return (recentRequests >= 3);
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

/// The result of the [EmailAccounts.createAccount] operation.
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

extension on Session {
  /// Runs the closure [f] in isolation, inside the parent [Transaction] (if any).
  ///
  /// Either creates a new transaction for [f],
  /// or creates a savepoint inside the given transaction,
  /// and would discard any modifications if [f] fails.
  Future<R> transactionOrSavepoint<R>(
    final TransactionFunction<R> f, {
    required Transaction? transaction,
  }) async {
    // Use the implicit transaction from tests
    // ignore: invalid_use_of_visible_for_testing_member
    transaction ??= this.transaction;

    if (transaction == null) {
      return db.transaction(f);
    }

    Savepoint? savepoint;
    try {
      savepoint = await transaction.createSavepoint();

      final result = await f(transaction);

      await savepoint.release();

      return result;
    } catch (_) {
      try {
        await savepoint?.rollback();
      } catch (e, stackTrace) {
        log(
          'Failed to roll back to savepoint.',
          exception: e,
          stackTrace: stackTrace,
        );
      }

      rethrow;
    }
  }
}
