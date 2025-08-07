import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';

import '../../../generated/protocol.dart';
import 'google_accounts_admin.dart';
import 'google_auth.dart';

/// Management functions to work with Google-backed accounts.
abstract final class GoogleAccounts {
  /// Admin operations to work with Google-backed accounts.
  static final admin = GoogleAccountsAdmin();

  /// The secrets used for the Google sign-in.
  static GoogleClientSecret? secrets = GoogleAuth.clientSecret;

  /// Authenticates a user using an ID token.
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  static Future<GoogleAuthSuccess> authenticate(
    final Session session, {
    required final String idToken,
    final Transaction? transaction,
  }) async {
    final accountDetails = await admin.fetchAccountDetails(
      session,
      idToken: idToken,
    );

    var googleAccount = await GoogleAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        accountDetails.userIdentifier,
      ),
      transaction: transaction,
    );
    final authUserNewlyCreated = googleAccount == null;

    if (googleAccount == null) {
      await DatabaseUtil.runInTransactionOrSavepoint(
        session.db,
        transaction,
        (final transaction) async {
          final authUser = await AuthUsers.create(
            session,
            transaction: transaction,
          );

          googleAccount = await admin.linkGoogleAuthentication(
            session,
            authUserId: authUser.id,
            accountDetails: accountDetails,
            transaction: transaction,
          );
        },
      );
    }

    return (
      googleAccountId: googleAccount!.id!,
      authUserId: googleAccount!.authUserId,
      details: accountDetails,
      authUserNewlyCreated: authUserNewlyCreated,
    );
  }
}

/// Details of a successful Google-based authentication.
typedef GoogleAuthSuccess = ({
  /// The ID of the `GoogleAccount` database entity.
  UuidValue googleAccountId,
  UuidValue authUserId,
  GoogleAccountDetails details,
  bool authUserNewlyCreated,
});
