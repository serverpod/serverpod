import 'package:serverpod/serverpod.dart';

import '../../../../generated/protocol.dart';
import '../../util/email_string_extension.dart';

/// {@template email_idp_account_utils}
/// Utility functions for working with email accounts.
/// {@endtemplate}
class EmailIDPAccountUtils {
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
  /// Returns the list of deleted accounts.
  Future<List<EmailAccount>> deleteAccount(
    final Session session, {
    final String? email,
    final UuidValue? authUserId,
    required final Transaction transaction,
  }) async {
    final normalizedEmail = email?.normalizedEmail;

    final deletedAccounts = await EmailAccount.db.deleteWhere(
      session,
      where: (final t) {
        Expression expression = Constant.bool(true);

        if (normalizedEmail != null) {
          expression = expression & t.email.equals(normalizedEmail);
        }

        if (authUserId != null) {
          expression = expression & t.authUserId.equals(authUserId);
        }

        return expression;
      },
      transaction: transaction,
    );

    return deletedAccounts;
  }

  /// Lists email accounts matching the provided filters.
  ///
  /// Both [email] and [authUserId] are optional nullable parameters that act
  /// as filters:
  /// - If [email] is provided, only accounts with that email are listed.
  /// - If [authUserId] is provided, only accounts with that auth user ID are listed.
  /// - If both are provided, accounts matching both criteria are listed.
  /// - If neither is provided, all email accounts are listed.
  ///
  /// Returns the list of email accounts.
  Future<List<EmailAccount>> listAccounts(
    final Session session, {
    final String? email,
    final UuidValue? authUserId,
    required final Transaction transaction,
  }) async {
    final normalizedEmail = email?.normalizedEmail;

    return EmailAccount.db.find(
      session,
      where: (final t) {
        Expression expression = Constant.bool(true);

        if (normalizedEmail != null) {
          expression = expression & t.email.equals(normalizedEmail);
        }

        if (authUserId != null) {
          expression = expression & t.authUserId.equals(authUserId);
        }

        return expression;
      },
      transaction: transaction,
    );
  }
}
