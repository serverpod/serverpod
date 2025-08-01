import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_google_account_server/serverpod_auth_google_account_server.dart';

/// Collection of Google-account admin methods.
final class GoogleAccountsAdmin {
  /// Return the `AuthUser` id for the Google user id, if any.
  Future<UuidValue?> findUserByGoogleUserId(
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

  /// Returns the account details for the given [idToken].
  Future<GoogleAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String idToken,
  }) async {
    final clientSecret = GoogleAccounts.secrets;
    if (clientSecret == null) {
      throw StateError('The server side Google client secret is not loaded.');
    }

    final String clientId = clientSecret.clientId;

    // Verify the ID token with Google's servers.
    final response = await http.get(
      Uri.https(
        'www.googleapis.com',
        '/oauth2/v3/tokeninfo',
        {'id_token': idToken},
      ),
    );

    if (response.statusCode != 200) {
      session.log(
        'Invalid token response status: ${response.statusCode}',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      session.log(
        'Invalid token response, content was not a Map.',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    final issuer = data['iss'] as String?;
    if (issuer != 'accounts.google.com' &&
        issuer != 'https://accounts.google.com') {
      session.log(
        'Invalid token response, unexpected issuer "$issuer"',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    if (data['aud'] != clientId) {
      session.log(
        'Invalid token response, client ID does not match',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    final userId = data['sub'] as String?;
    final email = data['email'] as String?;
    final verifiedEmail = data['verified_email'] as bool? ??
        ((data['email_verified'] as String?) == 'true');
    final fullName = data['name'] as String?;
    final image = data['picture'] as String?;
    final name = data['given_name'] as String?;

    if (userId == null ||
        email == null ||
        verifiedEmail != true ||
        fullName == null ||
        image == null ||
        name == null) {
      session.log(
        'Invalid token response, missing required data: $data',
        level: LogLevel.debug,
      );

      throw GoogleIdTokenVerificationException();
    }

    return (
      userIdentifier: userId,
      email: email,
      name: name,
      fullName: fullName,
      image: image,
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
    return await GoogleAccount.db.insertRow(
      session,
      GoogleAccount(
        userIdentifier: accountDetails.userIdentifier,
        email: accountDetails.email.toLowerCase(),
        authUserId: authUserId,
      ),
      transaction: transaction,
    );
  }
}

/// Details of the Google Account.
typedef GoogleAccountDetails = ({
  /// Google's user identifier for this account.
  String userIdentifier,

  /// The verified email received from Google.
  String email,
  String name,
  String fullName,
  String image
});
