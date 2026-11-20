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
    Session session, {
    required String accessToken,
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
    Session session, {
    required UuidValue authUserId,
    required MicrosoftAccountDetails accountDetails,
    Transaction? transaction,
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
    Session session, {
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    final account = await MicrosoftAccount.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return account?.authUserId;
  }
}
