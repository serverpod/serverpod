import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/business/password_hash.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';
import 'package:serverpod_auth_email_account_server/src/util/random_string.dart';

/// Email account management functions.
abstract final class EmailAccounts {
  /// Returns the [AuthUser]'s ID upon successful login.
  ///
  /// Throws [EmailAccountLoginException] for expected error cases.
  static Future<UuidValue> login(
    final Session session, {
    required String email,
    required String password,
  }) async {
    email = email.trim().toLowerCase();
    password = password.trim();

    var account = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
    );

    if (await _hasTooManyFailedSignIns(session, email)) {
      throw EmailAccountLoginException(
        reason: EmailAccountLoginFailureReason.tooManyAttempts,
      );
    }

    try {
      account ??=
          await _importExistingUser(session, email: email, password: password);
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
  }

  /// Returns the registration process ID.
  ///
  /// The caller may store additional information attached to this ID,
  /// which will be returned from [verify] later on.
  static Future<UuidValue> requestAccount(
    final Session session, {
    required String email,
    required String password,
  }) async {
    email = email.trim().toLowerCase();
    password = password.trim();

    final existingAccountCount = await EmailAccount.db
        .count(session, where: (final t) => t.email.equals(email));
    if (existingAccountCount > 0) {
      throw Exception('Email already registered');
    }

    final verificationCode = Random.secure().nextString(length: 20);

    final request = await EmailAccountRequest.db.insertRow(
      session,
      EmailAccountRequest(
        email: email,
        passwordHash: password,
        created: DateTime.now(),
        verificationCode: verificationCode,
      ),
    );

    EmailAccountConfig.current.sendRegistrationVerificationMail?.call(
      email: email,
      verificationToken: verificationCode,
    );

    return request.id!;
  }

  /// Returns the account request creation ID if the request is valid.
  ///
  /// If this returns a value, this means `createAccount` will succeed.
  static Future<({UuidValue emailAccountRequestId, String email})?>
      verifyAccountRequest(
    final Session session, {
    required final String verificationCode,
  }) async {
    final request = (await EmailAccountRequest.db.find(session,
            where: (final t) => t.verificationCode.equals(verificationCode)))
        .where((final r) => r.created
            .add(
                EmailAccountConfig.current.registrationVerificationCodeLifetime)
            .isAfter(DateTime.now()))
        .firstOrNull;

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
  }) async {
    final request = (await EmailAccountRequest.db.find(session,
            where: (final t) => t.verificationCode.equals(verificationCode)))
        .where((final r) => r.created
            .add(
                EmailAccountConfig.current.registrationVerificationCodeLifetime)
            .isAfter(DateTime.now()))
        .singleOrNull;

    if (request == null) {
      throw Exception('Email account request not found');
    }

    await EmailAccountRequest.db.deleteRow(session, request);

    final account = await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: authUserId,
        created: DateTime.now(),
        email: request.email,
        passwordHash: PasswordHash.createHash(
          email: request.email,
          password: request.passwordHash,
        ),
      ),
    );

    return (emailAccountId: account.id!, email: request.email);
  }

  /// Sends out a password reset email for the given account.
  static Future<void> requestPasswordReset(
    final Session session, {
    required String email,
  }) async {
    email = email.trim().toLowerCase();

    await _logPasswordResetAttempt(session, email);

    if (await _hasTooManyPasswordResetAttempts(session, email)) {
      throw Exception('Too many password reset requests in the last hour.');
    }

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
    );

    if (account == null) {
      throw Exception('No account found for email.');
    }

    final resetToken = Random.secure().nextString(length: 20);

    await EmailAccountPasswordResetRequest.db.insertRow(
      session,
      EmailAccountPasswordResetRequest(
        authenticationId: account.id!,
        verificationCode: resetToken,
      ),
    );

    EmailAccountConfig.current.sendPasswordResetMail?.call(
      email: email,
      resetToken: resetToken,
    );
  }

  /// Returns the auth user ID for the successfully changed password
  static Future<UuidValue> completePasswordReset(
    final Session session, {
    required final String resetCode,
    required final String newPassword,
  }) async {
    final resetRequest = (await EmailAccountPasswordResetRequest.db.find(
            session,
            where: (final t) => t.verificationCode.equals(resetCode)))
        .where((final r) => r.created
            .add(EmailAccountConfig.current.passwordResetCodeLifetime)
            .isAfter(DateTime.now()))
        .singleOrNull;

    if (resetRequest == null) {
      throw Exception('Password reset request not found.');
    }

    await EmailAccountPasswordResetRequest.db.deleteRow(session, resetRequest);

    final account = (await EmailAccount.db.findById(
      session,
      resetRequest.authenticationId,
    ))!;

    await EmailAccount.db.updateRow(
      session,
      account.copyWith(
        passwordHash: PasswordHash.createHash(
          email: account.email,
          password: newPassword,
        ),
      ),
    );

    return account.authUserId;
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
  }) async {
    final importFunc = EmailAccountConfig.current.existingUserImportFunction;

    if (importFunc == null) {
      return null;
    }

    final userId = await importFunc(
      session,
      email: email,
      password: password,
    );

    if (userId == null) {
      return null;
    }

    return await EmailAccount.db.insertRow(
      session,
      EmailAccount(
        authUserId: userId,
        email: email,
        passwordHash: password,
      ),
    );
  }

  static Future<void> _logPasswordResetAttempt(
      final Session session, final String email) async {
    await EmailAccountPasswordResetAttempt.db.insertRow(
      session,
      EmailAccountPasswordResetAttempt(
        email: email,
        ipAddress: session.remoteIpAddress,
      ),
    );
  }

  static Future<bool> _hasTooManyPasswordResetAttempts(
      final Session session, final String email) async {
    final recentRequests = (await EmailAccountPasswordResetAttempt.db.find(
            session,
            where: (final t) =>
                t.email.equals(email) |
                t.ipAddress.equals(session.remoteIpAddress)))
        .where((final r) => r.attemptedAt
            .isAfter(DateTime.now().subtract(const Duration(hours: 1))))
        .length;

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
