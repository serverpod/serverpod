import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import 'microsoft_idp_utils.dart';

/// Collection of Microsoft-account admin methods.
class MicrosoftIdpAdmin {
  /// Utility functions for the Microsoft identity provider.
  final MicrosoftIdpUtils utils;

  /// Creates a new instance of [MicrosoftIdpAdmin].
  const MicrosoftIdpAdmin({required this.utils});

  /// Returns the account details for the given [accessToken].
  Future<MicrosoftAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String accessToken,
  }) async {
    return utils.fetchAccountDetails(
      session,
      accessToken: accessToken,
    );
  }

  /// Adds a Microsoft authentication to the given [authUserId].
  ///
  /// Returns the newly created Microsoft account.
  Future<MicrosoftAccount> linkMicrosoftAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final MicrosoftAccountDetails accountDetails,
    final Transaction? transaction,
  }) async {
    return utils.linkMicrosoftAuthentication(
      session,
      authUserId: authUserId,
      accountDetails: accountDetails,
      transaction: transaction,
    );
  }

  /// Return the `AuthUser` id for the Microsoft user id, if any.
  static Future<UuidValue?> findUserByMicrosoftUserId(
    final Session session, {
    required final String userIdentifier,
    final Transaction? transaction,
  }) async {
    final account = await MicrosoftAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return account?.authUserId;
  }
}
