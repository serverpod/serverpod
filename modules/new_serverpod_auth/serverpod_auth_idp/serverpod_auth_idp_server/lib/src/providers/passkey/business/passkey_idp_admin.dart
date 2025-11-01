import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/passkey.dart';
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart';

/// Collection of Passkey account admin methods.
final class PasskeyIDPAdmin {
  /// Removes all challenges from the database which are older than the
  /// challenge lifetime.
  Future<void> deleteExpiredChallenges(final Session session) async {
    await PasskeyChallenge.db.deleteWhere(
      session,
      where: (final t) =>
          t.createdAt <
          clock.now().subtract(PasskeyIDP.config.challengeLifetime),
    );
  }
}
