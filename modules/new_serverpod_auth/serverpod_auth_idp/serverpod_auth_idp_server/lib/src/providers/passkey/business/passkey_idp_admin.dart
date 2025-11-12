import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart';

import 'passkey_idp_utils.dart';

/// Collection of Passkey account admin methods.
final class PasskeyIDPAdmin {
  final Duration _challengeLifetime;
  final PasskeyIDPUtils _utils;

  /// Creates a new instance of [PasskeyIDPAdmin].
  PasskeyIDPAdmin({
    required final Duration challengeLifetime,
    required final PasskeyIDPUtils utils,
  }) : _challengeLifetime = challengeLifetime,
       _utils = utils;

  /// Removes all challenges from the database which are older than the
  /// challenge lifetime.
  Future<void> deleteExpiredChallenges(final Session session) async {
    await PasskeyChallenge.db.deleteWhere(
      session,
      where: (final t) =>
          t.createdAt < clock.now().subtract(_challengeLifetime),
    );
  }

  /// Deletes the passkey account with the given ID.
  Future<void> deletePasskeyAccountById(
    final Session session, {
    required final UuidValue passkeyAccountId,
    final Transaction? transaction,
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
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    return _utils.deletePasskeyAccounts(
      session,
      authUserId: authUserId,
      passkeyAccountId: null,
      transaction: transaction,
    );
  }
}
