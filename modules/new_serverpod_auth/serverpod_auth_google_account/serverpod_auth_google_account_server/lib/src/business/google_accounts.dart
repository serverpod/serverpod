import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_google_account_server/serverpod_auth_google_account_server.dart';
import 'package:serverpod_auth_google_account_server/src/business/google_auth.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';

/// Management functions to work with Google-backed accounts.
abstract final class GoogleAccounts {
  /// Authenticates a user using an ID token.
  ///
  /// If the external user ID is not yet known in the system, a new `AuthUser`
  /// is created for it.
  static Future<GoogleAuthSuccess> authenticate(
    final Session session, {
    required final String idToken,
    final Transaction? transaction,
  }) async {
    final accountDetails = await _getAccount(session, idToken: idToken);

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

          googleAccount = await GoogleAccount.db.insertRow(
            session,
            GoogleAccount(
              userIdentifier: accountDetails.userIdentifier,
              email: accountDetails.email,
              authUserId: authUser.id,
            ),
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

  static Future<GoogleAccountDetails> _getAccount(
    final Session session, {
    required final String idToken,
  }) async {
    final clientSecret = GoogleAuth.clientSecret;
    if (clientSecret == null) {
      throw StateError('The server side Google client secret is not loaded.');
    }

    final clientId = clientSecret.clientId;

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
        !verifiedEmail ||
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
}

/// Details of a successful Google-based authentication.
typedef GoogleAuthSuccess = ({
  /// The ID of the `GoogleAccount` database entity.
  UuidValue googleAccountId,
  UuidValue authUserId,
  GoogleAccountDetails details,
  bool authUserNewlyCreated,
});

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
