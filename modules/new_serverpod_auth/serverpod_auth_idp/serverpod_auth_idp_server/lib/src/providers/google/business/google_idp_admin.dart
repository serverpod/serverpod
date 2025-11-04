import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import 'google_idp_utils.dart';

/// Collection of Google-account admin methods.
final class GoogleIDPAdmin {
  /// Utility functions for the Google identity provider.
  final GoogleIDPUtils utils;

  /// Creates a new instance of [GoogleIDPAdmin].
  GoogleIDPAdmin({required this.utils});

  /// Returns the account details for the given [idToken] and [accessToken].
  Future<GoogleAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String idToken,
    required final String accessToken,
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
    final Session session, {
    required final UuidValue authUserId,
    required final GoogleAccountDetails accountDetails,
    final Transaction? transaction,
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
    final Session session, {
    required final String userIdentifier,
    final Transaction? transaction,
  }) async {
    final account = await GoogleAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(userIdentifier),
      transaction: transaction,
    );

    return account?.authUserId;
  }
}
