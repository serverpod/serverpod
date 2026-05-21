import 'package:serverpod/serverpod.dart';

import 'utils/passwordless_idp_login_util.dart';

/// Collection of passwordless admin methods.
class PasswordlessIdpAdmin {
  final PasswordlessIdpLoginUtil _loginUtil;

  /// Creates a new instance of [PasswordlessIdpAdmin].
  PasswordlessIdpAdmin({
    required final PasswordlessIdpLoginUtil loginUtil,
  }) : _loginUtil = loginUtil;

  /// {@macro passwordless_idp_login_util.delete_incomplete_login_attempts}
  Future<void> deleteIncompleteLoginAttempts(
    final Session session, {
    final Duration? olderThan,
    final Transaction? transaction,
  }) async {
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (final transaction) => _loginUtil.deleteIncompleteLoginAttempts(
        session,
        olderThan: olderThan,
        transaction: transaction,
      ),
    );
  }
}
