import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import 'facebook_idp_utils.dart';

/// Collection of Facebook-account admin methods.
class FacebookIdpAdmin {
  /// Utility functions for the Facebook identity provider.
  final FacebookIdpUtils utils;

  /// Creates a new instance of [FacebookIdpAdmin].
  const FacebookIdpAdmin({required this.utils});

  /// Returns the account details for the given [accessToken].
  ///
  /// This method verifies the token and fetches the user's profile information
  /// from Facebook's Graph API.
  Future<FacebookAccountDetails> fetchAccountDetails(
    Session session, {
    required String accessToken,
  }) async {
    return utils.fetchAccountDetails(
      session,
      accessToken: accessToken,
    );
  }

  /// Adds a Facebook authentication to the given [authUserId].
  ///
  /// Returns the newly created Facebook account.
  Future<FacebookAccount> linkFacebookAuthentication(
    Session session, {
    required UuidValue authUserId,
    required FacebookAccountDetails accountDetails,
    Transaction? transaction,
  }) async {
    return utils.linkFacebookAuthentication(
      session,
      authUserId: authUserId,
      accountDetails: accountDetails,
      transaction: transaction,
    );
  }

  /// Return the `AuthUser` id for the Facebook user id, if any.
  static Future<UuidValue?> findUserByFacebookUserId(
    Session session, {
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    final account = await FacebookAccount.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return account?.authUserId;
  }
}
