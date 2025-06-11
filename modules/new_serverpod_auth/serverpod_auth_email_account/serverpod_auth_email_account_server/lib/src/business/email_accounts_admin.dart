import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart';
import 'package:serverpod_auth_email_account_server/src/generated/protocol.dart';

@internal
final class EmailAccountsAdmin {
  /// Cleans up the log of failed password reset attempts older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time window that
  /// is checked upon password reset requets, as configured in [EmailAccountConfig.maxPasswordResetAttempts].
  Future<void> deletePasswordResetAttempts(
    final Session session, {
    Duration? olderThan,
    final Transaction? transaction,
  }) async {
    olderThan ??= EmailAccounts.config.maxPasswordResetAttempts.timeframe;

    final removeBefore = clock.now().subtract(olderThan);

    await EmailAccountPasswordResetAttempt.db.deleteWhere(
      session,
      where: (final t) => t.attemptedAt < removeBefore,
      transaction: transaction,
    );
  }

  /// Cleans up expired password reset attempts.
  Future<void> deleteExpiredPasswordResetRequests(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final lastValidDateTime = clock.now().subtract(
          EmailAccounts.config.passwordResetVerificationCodeLifetime,
        );

    await EmailAccountPasswordResetRequest.db.deleteWhere(
      session,
      where: (final t) => t.created < lastValidDateTime,
      transaction: transaction,
    );
  }

  /// Cleans up expired account creation requests.
  Future<void> deleteExpiredAccountCreations(
    final Session session, {
    final Transaction? transaction,
  }) async {
    final lastValidDateTime = clock.now().subtract(
          EmailAccounts.config.registrationVerificationCodeLifetime,
        );

    await EmailAccountRequest.db.deleteWhere(
      session,
      where: (final t) => t.created < lastValidDateTime,
      transaction: transaction,
    );
  }

  /// Cleans up the log of failed login attempts older than [olderThan].
  ///
  /// If [olderThan] is `null`, this will remove all attempts outside the time window that
  /// is checked upon login, as configured in [EmailAccountConfig.emailSignInFailureResetTime].
  Future<void> deleteFailedLoginAttempts(
    final Session session, {
    Duration? olderThan,
    final Transaction? transaction,
  }) async {
    olderThan ??= EmailAccounts.config.failedLoginRateLimit.timeframe;

    final removeBefore = clock.now().subtract(olderThan);

    await EmailAccountFailedLoginAttempt.db.deleteWhere(
      session,
      where: (final t) => t.attemptedAt < removeBefore,
      transaction: transaction,
    );
  }
}
