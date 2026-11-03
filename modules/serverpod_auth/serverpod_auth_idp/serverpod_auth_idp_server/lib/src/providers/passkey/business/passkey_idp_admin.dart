import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'passkey_idp_utils.dart';

/// Collection of Passkey account admin methods.
class PasskeyIdpAdmin {
  final Duration _challengeLifetime;
  final PasskeyIdpUtils _utils;

  /// Creates a new instance of [PasskeyIdpAdmin].
  PasskeyIdpAdmin({
    required Duration challengeLifetime,
    required PasskeyIdpUtils utils,
  }) : _challengeLifetime = challengeLifetime,
       _utils = utils;

  /// Removes all challenges from the database which are older than the
  /// challenge lifetime.
  Future<void> deleteExpiredChallenges(Session session) async {
    await PasskeyChallenge.db.deleteWhere(
      session,
      where: (t) => t.createdAt < clock.now().subtract(_challengeLifetime),
    );
  }

  /// Deletes the passkey account with the given ID.
  Future<void> deletePasskeyAccountById(
    Session session, {
    required UuidValue passkeyAccountId,
    Transaction? transaction,
  }) async {
    await _utils.deletePasskeyAccounts(
      session,
      authUserId: null,
      passkeyAccountId: passkeyAccountId,
      transaction: transaction,
    );
  }

  /// Deletes all passkey accounts for the given [authUserId].
  Future<List<DeletedPasskeyAccount>> deletePasskeyAccountsByAuthUserId(
    Session session, {
    required UuidValue authUserId,
    Transaction? transaction,
  }) async {
    return _utils.deletePasskeyAccounts(
      session,
      authUserId: authUserId,
      passkeyAccountId: null,
      transaction: transaction,
    );
  }
}
