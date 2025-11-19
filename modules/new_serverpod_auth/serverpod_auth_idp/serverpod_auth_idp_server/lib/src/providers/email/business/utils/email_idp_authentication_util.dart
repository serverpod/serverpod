import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/email/util/email_string_extension.dart';

import '../../../../generated/protocol.dart';
import '../../../../utils/byte_data_extension.dart';
import '../../../../utils/secret_hash_util.dart';
import '../../util/session_extension.dart';
import '../email_idp_config.dart';
import '../email_idp_server_exceptions.dart';

/// {@template email_idp_authentication_util}
/// Authentication utilities for the email identity provider.
///
/// The main entry point is the [authenticate] method, which can be used to authenticate a user.
///
/// This class also contains utility functions for administration tasks, such as deleting failed login attempts.
/// {@endtemplate}
class EmailIDPAuthenticationUtil {
  final SecretHashUtil _hashUtil;
  final RateLimit _failedLoginRateLimit;

  /// Creates a new instance of [EmailIDPAuthenticationUtil].
  EmailIDPAuthenticationUtil({
    required final SecretHashUtil hashUtil,
    required final RateLimit failedLoginRateLimit,
  }) : _hashUtil = hashUtil,
       _failedLoginRateLimit = failedLoginRateLimit;

  /// Returns the [AuthUser]'s ID upon successful email/password verification.
  ///
  /// Can throw the following [EmailLoginServerException] subclasses:
  /// - [EmailAccountNotFoundException] if the email address is not registered
  ///   in the database.
  /// - [EmailAuthenticationInvalidCredentialsException] if the password is not
  ///   valid for an existing account.
  /// - [EmailAuthenticationTooManyAttemptsException] if the user has made
  ///   too many failed attempts.
  ///
  /// In case of invalid credentials, the failed attempt will be logged to
  /// the database outside of the [transaction] and can not be rolled back.
  Future<UuidValue> authenticate(
    final Session session, {
    required String email,
    required final String password,
    required final Transaction? transaction,
  }) async {
    email = email.normalizedEmail;

    if (await _hasTooManyFailedSignIns(
      session,
      email,
      transaction: transaction,
    )) {
      throw EmailAuthenticationTooManyAttemptsException();
    }

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (final t) => t.email.equals(email),
      transaction: transaction,
    );

    if (account == null) {
      await _logFailedSignIn(session, email);
      throw EmailAccountNotFoundException();
    }

    if (!await _hashUtil.validateHash(
      value: password,
      hash: account.passwordHash.asUint8List,
      salt: account.passwordSalt.asUint8List,
    )) {
      await _logFailedSignIn(session, email);
      throw EmailAuthenticationInvalidCredentialsException();
    }

    return account.authUserId;
  }

  /// {@template email_idp_authentication_utils.delete_failed_login_attempts}
  /// Cleans up the log of failed login attempts older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time
  /// window that is checked upon login, as configured in
  /// [EmailIDPConfig.emailSignInFailureResetTime].
  ///
  /// If [email] is provided, only attempts for the given email will be deleted.
  /// {@endtemplate}
  Future<void> deleteFailedLoginAttempts(
    final Session session, {
    Duration? olderThan,
    final String? email,
    required final Transaction transaction,
  }) async {
    olderThan ??= _failedLoginRateLimit.timeframe;

    final removeBefore = clock.now().subtract(olderThan);

    await EmailAccountFailedLoginAttempt.db.deleteWhere(
      session,
      where: (final t) {
        var expression = t.attemptedAt < removeBefore;
        if (email != null) {
          expression &= t.email.equals(email);
        }

        return expression;
      },
      transaction: transaction,
    );
  }

  Future<bool> _hasTooManyFailedSignIns(
    final Session session,
    final String email, {
    required final Transaction? transaction,
  }) async {
    final oldestRelevantAttempt = clock.now().subtract(
      _failedLoginRateLimit.timeframe,
    );

    final failedLoginAttemptCount = await EmailAccountFailedLoginAttempt.db
        .count(
          session,
          where: (final t) =>
              t.email.equals(email) & (t.attemptedAt > oldestRelevantAttempt),
          transaction: transaction,
        );

    return failedLoginAttemptCount >= _failedLoginRateLimit.maxAttempts;
  }

  Future<void> _logFailedSignIn(
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
}
