import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';

class GoogleAccountRepository {
  GoogleAccountRepository({
    required this.serverpod,
  }) {
    /// e.g. https://developers.google.com/identity/protocols/oauth2/web-server#cross-account-protection
    serverpod.relic.registerEndpoint('/account-disabled', () {
      final disabledGoogleUserId = 'revoked_account_id_passed_as_parameter';

      for (final account
          in accounts.where((a) => a.googleUserId == disabledGoogleUserId)) {
        // TODO: If we wanted, we could further filter on "provider" to only revoke the Google login for the affected user
        serverpod.userSessionRepository
            .revokeAllSessionsForUser(account.userId);
      }

      return '';
    });

    // TODO: Similary set up a future call to periodically pull the current Google-backed accounts and updater their info or revoke them it needed
  }

  final Serverpod serverpod;

  static const providerName = 'google';

  @visibleForTesting
  final accounts = <GoogleUserAccount>[];

  // static const callbackPath = 'google-login/succes';

  /// Returns the sign-in entry URL to be opened in a web view
  ///
  /// At the end of the flow, this will redirect back to the app via a configured callback URL
  ///
  /// (in desktop web scenarios this might be opened in a pop-up; for native apps this might use a native API instead)
  Uri getSignInEntryUri() {
    return Uri();
  }

  /// The client calls this with the token it has received
  // TODO: This should probably also support adding the Google login as a second method to the account
  // TODO: Maybe support nonces or similar to verify that we're actually waiting for this token
  String createSessionFromToken(String googleToken) {
    // in practice we'd have to call Google's API to look up the user with the token
    final googleUserId = googleToken;

    final existingAccounts =
        accounts.where((a) => a.googleUserId == googleUserId);
    if (existingAccounts.isNotEmpty) {
      return serverpod.userSessionRepository.createSession(
        existingAccounts.single.userId,
        authProvider: providerName,
        additionalData: null,
      );
    }

    final newUser = serverpod.userInfoRepository.createUser(
      null,
      null,
    );

    final account = GoogleUserAccount(
      googleUserId: googleUserId,
      userId: newUser.id!,
      email: null,
      displayName: null,
    );

    accounts.add(account);

    return serverpod.userSessionRepository.createSession(
      newUser.id!,
      authProvider: providerName,
      additionalData: null,
    );
  }
}

class GoogleUserAccount {
  GoogleUserAccount({
    required this.googleUserId,
    required this.userId,
    required this.displayName,
    required this.email,
  });

  final String refreshToken = '';

  final String accessToken = '';

  final String googleUserId;

  /// Serverpod user
  final int userId;

  // TODO: Only available based on scope?
  final String? displayName;

  final String? email;
}
