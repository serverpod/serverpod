import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import 'google_idp_utils.dart';

/// Collection of Google-account admin methods.
class GoogleIdpAdmin {
  /// Utility functions for the Google identity provider.
  final GoogleIdpUtils utils;

  /// Creates a new instance of [GoogleIdpAdmin].
  GoogleIdpAdmin({required this.utils});

  /// Returns the account details for the given [idToken] and [accessToken].
  Future<GoogleAccountDetails> fetchAccountDetails(
    Session session, {
    required String idToken,
    required String? accessToken,
  }) async {
    return utils.fetchAccountDetails(
      session,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Adds a Google authentication to the given [authUserId].
  ///
  /// Returns the newly created Google account.
  Future<GoogleAccount> linkGoogleAuthentication(
    Session session, {
    required UuidValue authUserId,
    required GoogleAccountDetails accountDetails,
    Transaction? transaction,
  }) async {
    return utils.linkGoogleAuthentication(
      session,
      authUserId: authUserId,
      accountDetails: accountDetails,
      transaction: transaction,
    );
  }

  /// Return the `AuthUser` id for the Google user id, if any.
  static Future<UuidValue?> findUserByGoogleUserId(
    Session session, {
    required String userIdentifier,
    Transaction? transaction,
  }) async {
    final account = await GoogleAccount.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return account?.authUserId;
  }
}
